package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"
	"time"

	"github.com/kingzbauer/shilingi/app-engine/ent"
	"github.com/kingzbauer/shilingi/app-engine/ent/item"
	"github.com/kingzbauer/shilingi/app-engine/ent/shopping"
	"github.com/kingzbauer/shilingi/app-engine/ent/shoppingitem"
	"github.com/kingzbauer/shilingi/app-engine/ent/vendor"
	"github.com/kingzbauer/shilingi/app-engine/entops"
	"github.com/kingzbauer/shilingi/app-engine/graph/generated"
	"github.com/kingzbauer/shilingi/app-engine/graph/model"
)

func (r *mutationResolver) CreateItem(ctx context.Context, input model.ItemInput) (*ent.Item, error) {
	return entops.GetItem(ctx, input.Name)
}

func (r *mutationResolver) CreatePurchase(ctx context.Context, input model.ShoppingInput) (*ent.Shopping, error) {
	return entops.CreatePurchase(ctx, input)
}

func (r *queryResolver) Items(ctx context.Context) ([]*ent.Item, error) {
	return r.cli.Item.Query().
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
