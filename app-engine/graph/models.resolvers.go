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

// Shopping returns generated.ShoppingResolver implementation.
func (r *Resolver) Shopping() generated.ShoppingResolver { return &shoppingResolver{r} }

type shoppingResolver struct{ *Resolver }
