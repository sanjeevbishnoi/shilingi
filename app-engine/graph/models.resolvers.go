package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"

	"entgo.io/ent/dialect/sql"
	"github.com/kingzbauer/shilingi/app-engine/ent"
	"github.com/kingzbauer/shilingi/app-engine/ent/shopping"
	"github.com/kingzbauer/shilingi/app-engine/ent/shoppingitem"
	"github.com/kingzbauer/shilingi/app-engine/graph/generated"
	"github.com/shopspring/decimal"
)

func (r *itemResolver) Purchases(ctx context.Context, obj *ent.Item, after *ent.Cursor, first *int, before *ent.Cursor, last *int) (*ent.ShoppingItemConnection, error) {
	return obj.QueryPurchases().
		Order(func(s *sql.Selector) {
			t := sql.Table(shopping.Table)
			s.Join(t).On(s.C(shoppingitem.ShoppingColumn), t.C(shopping.FieldID))
			s.OrderBy(sql.Desc(t.C(shopping.FieldDate)))
		}).
		// Weird error is through since we are ordering by a field in a related entity
		// The specific field: FieldDate is not part of the Select list statement and
		// ent by default includes a Distinct keyword to the id field which is also used to
		// order by
		Unique(false).
		Paginate(ctx, after, first, before, last)
}

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

// Item returns generated.ItemResolver implementation.
func (r *Resolver) Item() generated.ItemResolver { return &itemResolver{r} }

// Shopping returns generated.ShoppingResolver implementation.
func (r *Resolver) Shopping() generated.ShoppingResolver { return &shoppingResolver{r} }

// ShoppingItem returns generated.ShoppingItemResolver implementation.
func (r *Resolver) ShoppingItem() generated.ShoppingItemResolver { return &shoppingItemResolver{r} }

type itemResolver struct{ *Resolver }
type shoppingResolver struct{ *Resolver }
type shoppingItemResolver struct{ *Resolver }
