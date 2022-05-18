package entops

import (
	"context"
	"errors"
	"regexp"
	"strings"
	"time"

	"github.com/vektah/gqlparser/v2/gqlerror"
	"go.uber.org/zap"

	"github.com/kingzbauer/shilingi/app-engine/ent"
	"github.com/kingzbauer/shilingi/app-engine/ent/item"
	"github.com/kingzbauer/shilingi/app-engine/ent/schema/utils"
	"github.com/kingzbauer/shilingi/app-engine/ent/shoppinglist"
	"github.com/kingzbauer/shilingi/app-engine/ent/shoppinglistitem"
	"github.com/kingzbauer/shilingi/app-engine/ent/sublabel"
	"github.com/kingzbauer/shilingi/app-engine/ent/tag"
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

// EditSubLabel ...
func EditSubLabel(ctx context.Context, subLabelID int, input model.SubLabelInput) (*ent.SubLabel, error) {
	cli := ent.FromContext(ctx)
	cleanedName := utils.CleanTagName(input.Name)
	// Make sure the name is not "uncategorized"
	if cleanedName == "uncategorized" {
		return nil, gqlerror.Errorf("'uncategorized' is not a valid label name")
	}

	// Check that the  name is not used by an existing label within the same parent
	label, err := cli.SubLabel.Query().
		Where(sublabel.ID(subLabelID)).
		WithParent().
		Only(ctx)
	if err != nil {
		return nil, err
	}

	exists, err := cli.SubLabel.Query().
		Where(
			sublabel.Name(cleanedName),
			sublabel.Not(
				sublabel.ID(label.ID),
			),
			sublabel.HasParentWith(
				tag.ID(label.Edges.Parent.ID),
			),
		).Exist(ctx)
	if err != nil {
		return nil, err
	}
	if exists {
		return nil, gqlerror.Errorf("another label with a similar name exists in parent label %s", label.Edges.Parent.Name)
	}

	return cli.SubLabel.UpdateOne(label).
		SetName(cleanedName).
		Save(ctx)
}

// CreateShoppingList creates a shopping list with items
func CreateShoppingList(ctx context.Context, input model.ShoppingListInput) (*ent.ShoppingList, error) {
	cli := ent.FromContext(ctx)

	itemIDs := []int{}
	for _, item := range input.Items {
		itemIDs = append(itemIDs, item.Item)
	}
	// Check that the provided item ids are all valid
	count, err := cli.Item.Query().
		Where(
			item.IDIn(itemIDs...),
		).Count(ctx)
	if count != len(input.Items) {
		return nil, gqlerror.Errorf("The provided items are not all valid")
	}

	shoppingList, err := cli.ShoppingList.Create().
		SetName(input.Name).
		Save(ctx)
	if err != nil {
		return nil, err
	}

	shoppingListItemCreate := []*ent.ShoppingListItemCreate{}
	for _, input := range input.Items {
		shoppingListItemCreate = append(shoppingListItemCreate,
			cli.ShoppingListItem.Create().
				SetItemID(input.Item).
				SetShoppingList(shoppingList),
		)
	}

	if _, err := cli.ShoppingListItem.CreateBulk(shoppingListItemCreate...).Save(ctx); err != nil {
		return nil, err
	}

	return shoppingList, nil
}

// DeleteShoppingList checks whether the shopping list is connect to an existing purchase
// If such a connection exists, the delete will not succeed
func DeleteShoppingList(ctx context.Context, id int) (bool, error) {
	cli := ent.FromContext(ctx)
	if exists, err := cli.ShoppingList.Query().Where(
		shoppinglist.ID(id),
		shoppinglist.HasItemsWith(
			shoppinglistitem.HasPurchase(),
		),
	).Exist(ctx); exists || err != nil {
		if err == nil {
			err = gqlerror.Errorf("A shopping list that is already connect to a purchase cannot be deleted")
		}
		return false, err
	}

	if err := cli.ShoppingList.DeleteOneID(id).Exec(ctx); err != nil {
		zap.S().Errorf("unable to delete a shopping list: %w", err)
		return false, gqlerror.Errorf("We were an able perform the requested action at the moment")
	}

	return true, nil
}

// AddToShoppingList adds items to the shopping list. The function does on attempt
// make sure that the provided items aren't already part of the shopping list.
// This for the moment it left as a burden on the client app
func AddToShoppingList(ctx context.Context, id int, items []int) (*ent.ShoppingList, error) {
	cli := ent.FromContext(ctx)
	shoppingList, err := cli.ShoppingList.Get(ctx, id)
	if err != nil {
		return nil, gqlerror.Errorf("Shopping list not found")
	}
	bulkCreate := []*ent.ShoppingListItemCreate{}
	for _, i := range items {
		create := cli.ShoppingListItem.Create().
			SetItemID(i).
			SetShoppingList(shoppingList)
		bulkCreate = append(bulkCreate, create)
	}
	_, err = cli.ShoppingListItem.CreateBulk(bulkCreate...).Save(ctx)
	if err != nil {
		zap.S().Errorf("unable to save list items: %w", err)
		return nil, gqlerror.Errorf("Uable to update shopping list")
	}

	return shoppingList, nil
}

// RemoveFromShoppingList removes a select set of entries from the shopping list
// only if they aren't already linked to an existing purchase
func RemoveFromShoppingList(ctx context.Context, id int, listItems []int) (*ent.ShoppingList, error) {
	cli := ent.FromContext(ctx)
	list, err := cli.ShoppingList.Get(ctx, id)
	if err != nil {
		zap.S().Errorf("error: %s", err)
		return nil, gqlerror.Errorf("Shopping list not found")
	}

	// Check if there are items which are already linked to a purchase
	if exists, err := cli.ShoppingListItem.Query().
		Where(
			shoppinglistitem.IDIn(listItems...),
			shoppinglistitem.HasPurchase(),
		).Exist(ctx); exists || err != nil {
		if exists {
			return nil, gqlerror.Errorf("Some of the items are already purchased")
		}
		zap.S().Errorf("Unable to query the db: %w", err)
		return nil, gqlerror.Errorf("Something went wrong. We have been notified of this")
	}

	count, err := cli.ShoppingListItem.Delete().
		Where(
			shoppinglistitem.IDIn(listItems...),
			shoppinglistitem.HasShoppingListWith(
				shoppinglist.ID(id),
			),
		).Exec(ctx)
	zap.S().Debugf("Delete %d from shopping list: %d", count, id)
	if err != nil {
		zap.S().Errorf("unable to remove items from the shopping list: %w", err)
		return nil, gqlerror.Errorf("Something went wrong. Kindly try again in a few.")
	}

	return list, nil
}

// CreatePurchaseFromShoppingList given a shopping list, it will create the necessary
// Shopping/Purchase from the list
func CreatePurchaseFromShoppingList(ctx context.Context, id int, input *model.CreatePurchaseFromShoppingListInput) (*ent.Shopping, error) {
	cli := ent.FromContext(ctx)
	// Retrieve the shoppinglist
	_, err := cli.ShoppingList.Get(ctx, id)
	if err != nil && ent.IsNotFound(err) {
		return nil, gqlerror.Errorf("Shopping list item not found")
	} else if err != nil {
		zap.S().Errorf("Error while trying to retrieve shopping list: %s", err)
		return nil, gqlerror.Errorf("Something unexpected happened. We are working to fix it.")
	}

	itemIDs := make([]int, len(input.Items))
	for i, item := range input.Items {
		itemIDs[i] = item.Item
	}

	// Validate that all of the items provided exist on the list
	// and that none of the has a purchase linked
	list, err := cli.ShoppingListItem.Query().
		Where(
			shoppinglistitem.HasShoppingListWith(
				shoppinglist.ID(id),
			),
			shoppinglistitem.Not(
				shoppinglistitem.HasPurchase(),
			),
			shoppinglistitem.IDIn(itemIDs...),
		).
		WithItem().All(ctx)
	if err != nil {
		zap.S().Errorf("error while retrieving shopping list items: %s", err)
		return nil, gqlerror.Errorf("Something unexpected happened. We are working to fix it.")
	}
	// Assert length of retrieved list is equal to the list of items provided from client
	if len(list) != len(itemIDs) {
		return nil, gqlerror.Errorf("Some of the provided list entries could not be processed")
	}

	// 1. Create the purchase
	purchase, err := cli.Shopping.Create().
		SetDate(time.Now()).
		SetVendorID(input.Vendor).
		Save(ctx)
	if err != nil {
		zap.S().Errorf("unable to create purchase: %s", err)
		return nil, gqlerror.Errorf("Unable to create a purchase at the moment")
	}

	purchaseItemsCreate := make([]*ent.ShoppingItemCreate, len(list))
	for i, item := range list {
		// retrieve input
		var itemInput *model.PurchaseShoppingListItemInput
		for _, in := range input.Items {
			if in.Item == item.ID {
				itemInput = in
				break
			}
		}

		purchaseItemsCreate[i] = cli.ShoppingItem.Create().
			SetUnits(*itemInput.Units).
			SetPricePerUnit(itemInput.PricePerUnit).
			SetNillableBrand(itemInput.Brand).
			SetNillableQuantity(itemInput.Quantity).
			SetNillableQuantityType(itemInput.QuantityType).
			SetItem(item.Edges.Item).
			SetShopping(purchase).
			AddShoppingList(item)
	}

	_, err = cli.ShoppingItem.CreateBulk(purchaseItemsCreate...).Save(ctx)
	if err != nil {
		tx, _ := cli.Tx(ctx)
		if tx != nil {
			if err := tx.Rollback(); err != nil {
				zap.S().Errorf("unable to rollback Tx: %s", err)
			}
		}
		zap.S().Errorf("unable to create shopping items: %s", err)
		return nil, gqlerror.Errorf(
			"Unable to create purchase. Kindly try again in a few minutes",
		)
	}

	// We need to save the backref from ShoppingListItem

	return purchase, nil
}

// CreateVendor creates a vendor with the specified name, if vendor already exists,
// return that
func CreateVendor(ctx context.Context, input model.VendorInput) (*ent.Vendor, error) {
	cli := ent.FromContext(ctx)
	vendorSlug := Slugify(input.Name)
	v, err := cli.Vendor.Query().
		Where(
			vendor.Slug(vendorSlug),
		).Only(ctx)
	if ent.IsNotFound(err) {
		v, err = cli.Vendor.Create().
			SetName(string(strings.ToUpper(input.Name[:1]) + input.Name[1:])).
			SetSlug(vendorSlug).
			Save(ctx)
	}

	if err != nil {
		return nil, gqlerror.Errorf("Unable to create vendor. Try again later")
	}

	return v, nil
}
