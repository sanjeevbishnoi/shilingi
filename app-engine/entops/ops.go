package entops

import (
	"context"
	"regexp"
	"strings"

	"github.com/kingzbauer/shilingi/app-engine/ent"
	"github.com/kingzbauer/shilingi/app-engine/ent/item"
	"github.com/kingzbauer/shilingi/app-engine/ent/vendor"
	"github.com/kingzbauer/shilingi/app-engine/graph/model"
)

// CreatePurchase verifies and creates a new purchase
func CreatePurchase(ctx context.Context, input model.ShoppingInput) (*ent.Shopping, error) {
	vendorSlug := Slugify(input.Vendor.Name)
	// check if a vendor with the slug exists, if not create a new one
	cli := ent.FromContext(ctx)
	var v *ent.Vendor
	var err error
	if exist, _ := cli.Vendor.Query().
		Where(
			vendor.Slug(vendorSlug),
		).Exist(ctx); !exist {
		if v, err = cli.Vendor.Create().
			SetName(input.Vendor.Name).
			SetSlug(vendorSlug).
			Save(ctx); err != nil {
			return nil, err
		}
	} else {
		if v, err = cli.Vendor.Query().
			Where(vendor.Slug(vendorSlug)).First(ctx); err != nil {
			return nil, err
		}
	}

	// Create a shopping/purchase entry
	s, err := cli.Shopping.Create().
		SetNillableDate(input.Date).
		SetVendor(v).
		Save(ctx)
	if err != nil {
		return nil, err
	}

	// TODO: Validate item id provided
	// update the purchase items
	itemCreate := []*ent.ShoppingItemCreate{}
	for _, item := range input.Items {
		shoppingItem := cli.ShoppingItem.Create().
			SetQuantity(item.Quantity).
			SetQuantityType(item.QuantityType).
			SetNillableUnits(item.Units).
			SetNillableBrand(item.Brand).
			SetPricePerUnit(item.PricePerUnit).
			SetItemID(item.Item).
			SetShopping(s)
		itemCreate = append(itemCreate, shoppingItem)
	}
	if _, err = cli.ShoppingItem.CreateBulk(itemCreate...).Save(ctx); err != nil {
		return nil, err
	}

	return s, nil
}

// Slugify processes the string and returns a slug string
func Slugify(val string) string {
	val = strings.TrimSpace(val)
	val = regexp.MustCompile(`[^\w_\-\s]`).ReplaceAllString(val, "")
	val = regexp.MustCompile(`\s+`).ReplaceAllString(val, "-")
	return strings.ToLower(val)
}

// GetItem retrieves or creates a new item based on it's name
func GetItem(ctx context.Context, name string) (*ent.Item, error) {
	cli := ent.FromContext(ctx)
	nameSlug := Slugify(name)
	i, err := cli.Item.Query().
		Where(
			item.Slug(nameSlug),
		).Only(ctx)
	switch err.(type) {
	case *ent.NotFoundError:
		if i, err = cli.Item.Create().
			SetName(name).
			SetSlug(nameSlug).
			Save(ctx); err != nil {
			return nil, err
		}
	default:
		return nil, err
	}
	return i, nil
}
