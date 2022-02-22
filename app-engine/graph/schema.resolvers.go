package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"
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

	cli.Item.Update().
		Where(
			item.IDIn(itemIDs...),
		).
		AddTagIDs(tagID).
		Save(ctx)

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

func (r *queryResolver) Items(ctx context.Context, tagID *int) ([]*ent.Item, error) {
	query := r.cli.Item.Query()
	if tagID != nil {
		query.Where(
			item.HasTagsWith(
				tag.ID(*tagID),
			),
		)
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
				shopping.DateLTE(before),
			),
		).All(ctx)
}

func (r *queryResolver) Purchases(ctx context.Context, before time.Time, after time.Time) ([]*ent.Shopping, error) {
	return r.cli.Shopping.Query().
		Where(
			shopping.And(
				shopping.DateGTE(after),
				shopping.DateLTE(before),
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
	return r.cli.Tag.Query().All(ctx)
}

// Mutation returns generated.MutationResolver implementation.
func (r *Resolver) Mutation() generated.MutationResolver { return &mutationResolver{r} }

// Query returns generated.QueryResolver implementation.
func (r *Resolver) Query() generated.QueryResolver { return &queryResolver{r} }

type mutationResolver struct{ *Resolver }
type queryResolver struct{ *Resolver }
