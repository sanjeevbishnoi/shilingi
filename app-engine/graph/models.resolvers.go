package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"

	"github.com/kingzbauer/shilingi/app-engine/ent"
	"github.com/kingzbauer/shilingi/app-engine/ent/shoppingitem"
	"github.com/kingzbauer/shilingi/app-engine/graph/generated"
	"github.com/shopspring/decimal"
)

func (r *shoppingResolver) Total(ctx context.Context, obj *ent.Shopping) (*decimal.Decimal, error) {
	items, err := obj.QueryItems().
		Select(shoppingitem.FieldPricePerUnit, shoppingitem.FieldUnits).
		All(ctx)
	if err != nil {
		return nil, err
	}
	totalVal := decimal.NewFromInt(0)
	for _, item := range items {
		totalVal = item.PricePerUnit.Mul(
			decimal.NewFromInt(int64(item.Units))).Add(totalVal)
	}

	return &totalVal, nil
}

func (r *shoppingItemResolver) Total(ctx context.Context, obj *ent.ShoppingItem) (*decimal.Decimal, error) {
	if obj.Units < 1 {
		return &obj.PricePerUnit, nil
	}
	val := obj.PricePerUnit.Mul(decimal.NewFromInt(int64(obj.Units)))
	return &val, nil
}

// Shopping returns generated.ShoppingResolver implementation.
func (r *Resolver) Shopping() generated.ShoppingResolver { return &shoppingResolver{r} }

// ShoppingItem returns generated.ShoppingItemResolver implementation.
func (r *Resolver) ShoppingItem() generated.ShoppingItemResolver { return &shoppingItemResolver{r} }

type shoppingResolver struct{ *Resolver }
type shoppingItemResolver struct{ *Resolver }
