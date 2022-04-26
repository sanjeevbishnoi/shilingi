package schema

import (
	"entgo.io/ent"
	"entgo.io/ent/dialect/entsql"
	"entgo.io/ent/schema"
	"entgo.io/ent/schema/edge"
	"entgo.io/ent/schema/field"
	"entgo.io/ent/schema/mixin"
)

// ShoppingList holds the schema definition for the ShoppingList entity.
type ShoppingList struct {
	ent.Schema
}

// Fields of the ShoppingList.
func (ShoppingList) Fields() []ent.Field {
	return []ent.Field{
		field.String("name").
			Comment("Custom name for the shopping list"),
	}
}

// Edges of the ShoppingList.
func (ShoppingList) Edges() []ent.Edge {
	return []ent.Edge{
		edge.To("items", ShoppingListItem.Type),
		edge.From("purchases", Shopping.Type).
			Ref("shoppingList").
			Unique(),
	}
}

// Mixin of the Item
func (ShoppingList) Mixin() []ent.Mixin {
	return []ent.Mixin{
		mixin.Time{},
	}
}

// Annotations of the Item
func (ShoppingList) Annotations() []schema.Annotation {
	return []schema.Annotation{
		entsql.Annotation{
			Charset:   "utf8mb4",
			Collation: "utf8mb4_0900_ai_ci",
		},
	}
}
