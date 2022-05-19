package schema

import (
	"entgo.io/ent"
	"entgo.io/ent/schema/edge"
	"entgo.io/ent/schema/field"
)

// ShoppingListItem holds the schema definition for the ShoppingListItem entity.
type ShoppingListItem struct {
	ent.Schema
}

// Fields of the ShoppingListItem.
func (ShoppingListItem) Fields() []ent.Field {
	return []ent.Field{
		field.String("note").
			Optional().
			Comment("Additional details about the shopping list entry").
			MaxLen(255),
	}
}

// Edges of the ShoppingListItem.
func (ShoppingListItem) Edges() []ent.Edge {
	return []ent.Edge{
		edge.From("shoppingList", ShoppingList.Type).
			Ref("items").
			Unique().
			Required(),
		edge.From("item", Item.Type).
			Ref("shoppingList").
			Unique().
			Required(),
		edge.From("purchase", ShoppingItem.Type).
			Ref("shoppingList").
			Unique(),
	}
}
