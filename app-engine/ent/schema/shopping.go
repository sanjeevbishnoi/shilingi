package schema

import (
	"time"

	"entgo.io/contrib/entgql"
	"entgo.io/ent"
	"entgo.io/ent/schema/edge"
	"entgo.io/ent/schema/field"
	"entgo.io/ent/schema/mixin"
)

// Shopping holds the schema definition for the Shopping entity.
type Shopping struct {
	ent.Schema
}

// Fields of the Shopping.
func (Shopping) Fields() []ent.Field {
	return []ent.Field{
		field.Time("date").
			Comment("When was the shopping done").
			Default(time.Now),
	}
}

// Edges of the Shopping.
func (Shopping) Edges() []ent.Edge {
	return []ent.Edge{
		edge.To("items", ShoppingItem.Type).
			Annotations(entgql.Bind()),
		edge.From("vendor", Vendor.Type).
			Ref("purchases").
			Annotations(entgql.Bind()).
			Unique(),
		edge.To("shoppingList", ShoppingList.Type),
	}
}

// Mixin of the Shopping
func (Shopping) Mixin() []ent.Mixin {
	return []ent.Mixin{
		mixin.Time{},
	}
}
