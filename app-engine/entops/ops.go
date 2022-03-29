package entops

import (
	"context"
	"errors"
	"regexp"
	"strings"

	"github.com/kingzbauer/shilingi/app-engine/ent"
	"github.com/kingzbauer/shilingi/app-engine/ent/item"
	"github.com/kingzbauer/shilingi/app-engine/ent/schema/utils"
	"github.com/kingzbauer/shilingi/app-engine/ent/sublabel"
	"github.com/kingzbauer/shilingi/app-engine/ent/tag"
	"github.com/kingzbauer/shilingi/app-engine/ent/vendor"
	"github.com/kingzbauer/shilingi/app-engine/graph/model"
	"github.com/vektah/gqlparser/v2/gqlerror"
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

	itemNames := make([]string, len(input.Items))
	for i, name := range input.Items {
		itemNames[i] = name.Item
	}
	items, err := GetOrCreateItemsByName(ctx, itemNames)
	if err != nil {
		return nil, err
	}
	itemMap := map[string]*ent.Item{}
	for _, i := range items {
		itemMap[i.Slug] = i
	}

	// TODO: Validate item id provided
	// update the purchase items
	itemCreate := []*ent.ShoppingItemCreate{}
	for _, item := range input.Items {
		shoppingItem := cli.ShoppingItem.Create().
			SetNillableQuantity(item.Quantity).
			SetNillableQuantityType(item.QuantityType).
			SetNillableUnits(item.Units).
			SetNillableBrand(item.Brand).
			SetPricePerUnit(item.PricePerUnit).
			SetItem(itemMap[Slugify(item.Item)]).
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

	// If exists, return
	if err == nil {
		return i, nil
	}

	switch err.(type) {
	case *ent.NotFoundError:
		if i, err = cli.Item.Create().
			SetName(name).
			SetSlug(nameSlug).
			Save(ctx); err != nil {
			return nil, err
		}
		return i, nil
	default:
		return nil, err
	}
}

// GetOrCreateItemsByName converts the name to slugs and queries the database
func GetOrCreateItemsByName(ctx context.Context, names []string) ([]*ent.Item, error) {
	cli := ent.FromContext(ctx)
	slugs := []string{}
	slugToName := map[string]string{}
	for _, entry := range names {
		slug := Slugify(entry)
		slugs = append(slugs, slug)
		slugToName[slug] = entry
	}

	items, err := cli.Item.Query().
		Where(
			item.SlugIn(slugs...),
		).All(ctx)
	if err != nil {
		return nil, err
	}
	if len(items) == len(names) {
		return items, nil
	}

	for _, i := range items {
		delete(slugToName, i.Slug)
	}

	bulk := []*ent.ItemCreate{}
	for slug, name := range slugToName {
		bulk = append(bulk, cli.Item.Create().
			SetName(name).
			SetSlug(slug))
	}
	createItems, err := cli.Item.CreateBulk(bulk...).Save(ctx)
	if err != nil {
		return nil, err
	}

	items = append(items, createItems...)
	return items, nil
}

// EditItem updates the item attributes as provided by input
func EditItem(ctx context.Context, id int, input model.ItemInput) (*ent.Item, error) {
	cli := ent.FromContext(ctx)
	slug := Slugify(input.Name)
	// check if there exists another item with the same name
	exists, err := cli.Item.Query().
		Where(
			item.Slug(slug),
			item.Not(
				item.ID(id),
			),
		).Exist(ctx)
	if exists || err != nil {
		if err != nil {
			return nil, err
		}
		return nil, errors.New("item with a similar name exists, duplicates are not allowed")
	}

	return cli.Item.UpdateOneID(id).
		SetName(input.Name).
		SetSlug(slug).
		Save(ctx)
}

// CreateSubLabel validates and creates the sublabel
func CreateSubLabel(ctx context.Context, tagID int, input model.SubLabelInput) (*ent.SubLabel, error) {
	cli := ent.FromContext(ctx)

	// Make sure that the tag already exists
	t, err := cli.Tag.Query().Where(tag.ID(tagID)).Only(ctx)
	if err != nil {
		return nil, err
	}

	cleanedName := utils.CleanTagName(input.Name)
	if cleanedName == "uncategorized" {
		return nil, errors.New("'uncategorized' is a reserved label name")
	}

	label, err := cli.SubLabel.Query().Where(
		sublabel.Name(cleanedName),
		sublabel.HasParentWith(
			tag.ID(t.ID),
		),
	).Only(ctx)
	if ent.IsNotFound(err) {
		label, err = cli.SubLabel.Create().
			SetName(cleanedName).
			SetParent(t).
			Save(ctx)
	}

	return label, err
}

// AddItemsToSubLabel adds the provided items under the label provided
func AddItemsToSubLabel(ctx context.Context, subLabelID int, itemIDs []int) (*ent.SubLabel, error) {
	cli := ent.FromContext(ctx)
	// Make sure the items are part of the parent label
	label, err := cli.SubLabel.Query().
		Where(
			sublabel.ID(subLabelID),
		).
		WithParent().
		Only(ctx)
	if err != nil {
		return nil, err
	}

	items, err := cli.Item.Query().
		Where(
			item.IDIn(itemIDs...),
			item.HasTagsWith(
				tag.ID(label.Edges.Parent.ID),
			),
		).
		All(ctx)
	if err != nil {
		return nil, err
	}

	if len(items) != len(itemIDs) {
		return nil, gqlerror.Errorf(
			"At least %d of the items are not part of the parent label %q", len(itemIDs)-len(items), label.Edges.Parent.Name)
	}

	// Check if any of the items have sub-tags already
	items, err = cli.Item.Query().
		Where(
			item.IDIn(itemIDs...),
			item.HasSublabel(),
		).
		All(ctx)
	if err != nil {
		return nil, err
	}

	if len(items) > 0 {
		return nil, gqlerror.Errorf(
			"At least %d of the items have already been labeled", len(items))
	}

	_, err = cli.Item.Update().
		Where(
			item.IDIn(itemIDs...),
		).
		SetSublabelID(subLabelID).
		Save(ctx)

	return label, err
}

// RemoveItemsFromSubLabel ...
//
// NOTE: we do not return an error if any of the items is not labelled with the
// provided label id, but we do validate that only the items with the label
// are unlabeled
func RemoveItemsFromSubLabel(ctx context.Context, subLabelID int, itemIDs []int) (*ent.SubLabel, error) {
	cli := ent.FromContext(ctx)
	label, err := cli.SubLabel.Get(ctx, subLabelID)
	if err != nil {
		return nil, err
	}

	_, err = cli.Item.Update().
		Where(
			item.IDIn(itemIDs...),
			item.HasSublabelWith(
				sublabel.ID(label.ID),
			),
		).
		ClearSublabel().
		Save(ctx)

	return label, err
}
