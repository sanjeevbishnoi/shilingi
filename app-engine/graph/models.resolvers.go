package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"
	"fmt"

	"github.com/kingzbauer/shilingi/app-engine/ent"
	"github.com/kingzbauer/shilingi/app-engine/graph/generated"
)

func (r *shoppingItemResolver) Units(ctx context.Context, obj *ent.ShoppingItem) (*string, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *shoppingItemResolver) PricePerUnit(ctx context.Context, obj *ent.ShoppingItem) (float64, error) {
	panic(fmt.Errorf("not implemented"))
}

// ShoppingItem returns generated.ShoppingItemResolver implementation.
func (r *Resolver) ShoppingItem() generated.ShoppingItemResolver { return &shoppingItemResolver{r} }

type shoppingItemResolver struct{ *Resolver }
