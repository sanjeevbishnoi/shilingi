package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"
	"errors"
	"time"

	"github.com/kingzbauer/shilingi/app-engine/ent"
	"github.com/kingzbauer/shilingi/app-engine/ent/item"
	"github.com/kingzbauer/shilingi/app-engine/ent/schema/utils"
	"github.com/kingzbauer/shilingi/app-engine/ent/shopping"
	"github.com/kingzbauer/shilingi/app-engine/ent/shoppingitem"
	"github.com/kingzbauer/shilingi/app-engine/ent/tag"
	"github.com/kingzbauer/shilingi/app-engine/ent/vendor"
	"github.com/kingzbauer/shilingi/app-engine/entops"
	"github.com/kingzbauer/shilingi/app-engine/graph/generated"
	"github.com/kingzbauer/shilingi/app-engine/graph/model"
	"github.com/vektah/gqlparser/v2/gqlerror"
)

func (r *mutationResolver) CreateItem(ctx context.Context, input model.ItemInput) (*ent.Item, error) {
	return entops.GetItem(ctx, input.Name)
}

func (r *mutationResolver) CreatePurchase(ctx context.Context, input model.ShoppingInput) (*ent.Shopping, error) {
	return entops.CreatePurchase(ctx, input)
}

func (r *mutationResolver) TagItems(ctx context.Context, itemIDs []int, tagID int) ([]int, error) {
	cli := ent.FromContext(ctx)

	// Check whether the tag exists
	if exists, err := cli.Tag.Query().
		Where(
			tag.ID(tagID),
		).Exist(ctx); !exists || err != nil {
		if err != nil {
			return nil, gqlerror.Errorf("%s", err)
		}
		return nil, gqlerror.Errorf("tag with id %d does not exist", tagID)
	}

	_, err := cli.Item.Update().
		Where(
			item.IDIn(itemIDs...),
			item.Not(
				item.HasTagsWith(
					tag.ID(tagID),
				),
			),
		).
		AddTagIDs(tagID).
		Save(ctx)
	if err != nil {
		return nil, err
	}

	return itemIDs, nil
}

func (r *mutationResolver) UntagItems(ctx context.Context, itemIDs []int, tagID int) (*ent.Tag, error) {
	cli := ent.FromContext(ctx)
	tag, err := cli.Tag.
		UpdateOneID(tagID).
		RemoveItemIDs(itemIDs...).Save(ctx)
	return tag, err
}

func (r *mutationResolver) CreateTag(ctx context.Context, input model.TagInput) (*ent.Tag, error) {
	cli := ent.FromContext(ctx)
	cleanedTagName := utils.CleanTagName(input.Name)

	if cleanedTagName == "uncategorized" {
		return nil, errors.New("'uncategorized' is a reserved label name")
	}

	t, err := cli.Tag.Query().Where(tag.Name(cleanedTagName)).Only(ctx)
	if ent.IsNotFound(err) {
		// Create the tag
		if t, err = cli.Tag.Create().
			SetName(cleanedTagName).
			Save(ctx); err != nil {
			return nil, err
		}
	} else if err != nil {
		return nil, err
	}

	return t, err
}

func (r *mutationResolver) EditTag(ctx context.Context, id int, input model.TagInput) (*ent.Tag, error) {
	cleanedTagName := utils.CleanTagName(input.Name)
	// check whether there is an already existing tag with the same name
	cli := ent.FromContext(ctx)

	t, _ := cli.Tag.Query().
		Where(tag.Name(cleanedTagName)).
		Only(ctx)
	if t != nil && t.ID != id {
		return nil, gqlerror.Errorf("A tag with a similar name exists")
	}

	return cli.Tag.UpdateOneID(id).SetName(cleanedTagName).Save(ctx)
}

func (r *mutationResolver) EditItem(ctx context.Context, id int, input model.ItemInput) (*ent.Item, error) {
	// Check whether the name provided for item is already taken
	return entops.EditItem(ctx, id, input)
}

func (r *mutationResolver) DeleteTag(ctx context.Context, id int) (bool, error) {
	cli := ent.FromContext(ctx)
	if err := cli.Tag.DeleteOneID(id).Exec(ctx); err != nil {
		return false, err
	}
	return true, nil
}

func (r *mutationResolver) CreateSubLabel(ctx context.Context, tagID int, input model.SubLabelInput) (*ent.SubLabel, error) {
	return entops.CreateSubLabel(ctx, tagID, input)
}

func (r *mutationResolver) AddItemsToSubLabel(ctx context.Context, subLabelID int, itemIDs []int) (*ent.SubLabel, error) {
	return entops.AddItemsToSubLabel(ctx, subLabelID, itemIDs)
}

func (r *mutationResolver) RemoveItemsFromSubLabel(ctx context.Context, subLabelID int, itemIDs []int) (*ent.SubLabel, error) {
	return entops.RemoveItemsFromSubLabel(ctx, subLabelID, itemIDs)
}

func (r *mutationResolver) EditSubLabel(ctx context.Context, subLabelID int, input model.SubLabelInput) (*ent.SubLabel, error) {
	return entops.EditSubLabel(ctx, subLabelID, input)
}

func (r *mutationResolver) DeleteSubLabel(ctx context.Context, subLabelID int) (bool, error) {
	cli := ent.FromContext(ctx)
	err := cli.SubLabel.DeleteOneID(subLabelID).Exec(ctx)
	if err != nil {
		return false, err
	}
	return true, nil
}

func (r *mutationResolver) CreateShoppingList(ctx context.Context, input model.ShoppingListInput) (*ent.ShoppingList, error) {
	return entops.CreateShoppingList(ctx, input)
}

func (r *queryResolver) Items(ctx context.Context, tagID *int, negate *bool) ([]*ent.Item, error) {
	query := r.cli.Item.Query()
	if tagID != nil {
		if negate == nil {
			query = query.Where(
				item.HasTagsWith(
					tag.ID(*tagID),
				),
			)
		} else if *negate {
			query = query.Where(
				item.Not(
					item.HasTagsWith(
						tag.ID(*tagID),
					),
				),
			)
		}
	}
	return query.
		Order(ent.Asc(item.FieldName)).
		All(ctx)
}

func (r *queryResolver) ShoppingItems(ctx context.Context, after time.Time, before time.Time, itemID int) ([]*ent.ShoppingItem, error) {
	return r.cli.ShoppingItem.Query().
		Where(
			shoppingitem.HasItemWith(
				item.ID(itemID),
			),
			shoppingitem.HasShoppingWith(
				shopping.DateGTE(after),
				shopping.DateLT(before),
			),
		).All(ctx)
}

func (r *queryResolver) ShoppingItemsByTag(ctx context.Context, after time.Time, before time.Time, tagID int) ([]*ent.ShoppingItem, error) {
	return r.cli.ShoppingItem.Query().
		Where(
			shoppingitem.HasItemWith(
				item.HasTagsWith(
					tag.ID(tagID),
				),
			),
			shoppingitem.HasShoppingWith(
				shopping.DateGTE(after),
				shopping.DateLT(before),
			),
		).
		All(ctx)
}

func (r *queryResolver) UntaggedShoppingItems(ctx context.Context, after time.Time, before time.Time) ([]*ent.ShoppingItem, error) {
	return r.cli.ShoppingItem.Query().
		Where(
			shoppingitem.HasItemWith(
				item.Not(
					item.HasTags(),
				),
			),
			shoppingitem.HasShoppingWith(
				shopping.DateGTE(after),
				shopping.DateLT(before),
			),
		).
		All(ctx)
}

func (r *queryResolver) Purchases(ctx context.Context, before time.Time, after time.Time) ([]*ent.Shopping, error) {
	return r.cli.Shopping.Query().
		Where(
			shopping.And(
				shopping.DateGTE(after),
				shopping.DateLT(before),
			),
		).
		Order(ent.Desc(shopping.FieldDate, shopping.FieldCreateTime)).
		All(ctx)
}

func (r *queryResolver) Vendors(ctx context.Context) ([]*ent.Vendor, error) {
	return r.cli.Vendor.Query().
		Order(ent.Asc(vendor.FieldName)).
		All(ctx)
}

func (r *queryResolver) Node(ctx context.Context, id int) (ent.Noder, error) {
	return r.cli.Noder(ctx, id)
}

func (r *queryResolver) Tags(ctx context.Context) ([]*ent.Tag, error) {
	return r.cli.Tag.Query().
		Order(ent.Asc(tag.FieldName)).
		All(ctx)
}

func (r *queryResolver) ShoppingList(ctx context.Context, after *ent.Cursor, first *int, before *ent.Cursor, last *int) (*ent.ShoppingListConnection, error) {
	return r.cli.ShoppingList.Query().
		Paginate(ctx, after, first, before, last)
}

// Mutation returns generated.MutationResolver implementation.
func (r *Resolver) Mutation() generated.MutationResolver { return &mutationResolver{r} }

// Query returns generated.QueryResolver implementation.
func (r *Resolver) Query() generated.QueryResolver { return &queryResolver{r} }

type mutationResolver struct{ *Resolver }
type queryResolver struct{ *Resolver }
