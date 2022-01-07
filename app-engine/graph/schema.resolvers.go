package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"

	"github.com/kingzbauer/shilingi/app-engine/ent"
	"github.com/kingzbauer/shilingi/app-engine/graph/generated"
	"github.com/kingzbauer/shilingi/app-engine/graph/model"
)

func (r *mutationResolver) CreateItem(ctx context.Context, input model.ItemInput) (*ent.Item, error) {
	cli := ent.FromContext(ctx)
	return cli.Item.Create().SetName(input.Name).Save(ctx)
}

func (r *mutationResolver) CreatePurchase(ctx context.Context, input model.ShoppingInput) (*ent.Shopping, error) {
	cli := ent.FromContext(ctx)
	shopping, err := cli.Shopping.Create().
		SetDate(input.Date).
		SetMarket(input.Market).
		Save(ctx)
	if err != nil {
		return nil, err
	}

	itemCreate := []*ent.ShoppingItemCreate{}
	for _, item := range input.Items {
		shoppingItem := cli.ShoppingItem.Create().
			SetQuantity(item.Quantity).
			SetQuantityType(item.QuantityType).
			// SetNillableUnits(item.Units).
			SetNillableBrand(item.Brand).
			SetPricePerUnit(item.PricePerUnit).
			SetItemID(item.Item).
			SetShopping(shopping)
		itemCreate = append(itemCreate, shoppingItem)
	}
	if _, err = cli.ShoppingItem.CreateBulk(itemCreate...).Save(ctx); err != nil {
		return nil, err
	}

	return shopping, nil
}

func (r *queryResolver) Items(ctx context.Context) ([]*ent.Item, error) {
	return r.cli.Item.Query().All(ctx)
}

func (r *queryResolver) Purchases(ctx context.Context) ([]*ent.Shopping, error) {
	return r.cli.Shopping.Query().All(ctx)
}

// Mutation returns generated.MutationResolver implementation.
func (r *Resolver) Mutation() generated.MutationResolver { return &mutationResolver{r} }

// Query returns generated.QueryResolver implementation.
func (r *Resolver) Query() generated.QueryResolver { return &queryResolver{r} }

type mutationResolver struct{ *Resolver }
type queryResolver struct{ *Resolver }
