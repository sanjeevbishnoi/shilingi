package schema

import (
	"entgo.io/ent"
	"entgo.io/ent/dialect/entsql"
	"entgo.io/ent/schema"
	"entgo.io/ent/schema/edge"
	"entgo.io/ent/schema/field"
	"entgo.io/ent/schema/mixin"
)

// Item holds the schema definition for the Item entity.
type Item struct {
	ent.Schema
}

// Fields of the Item.
func (Item) Fields() []ent.Field {
	return []ent.Field{
		field.String("name").
			Comment("A simple name for the item"),
		field.String("slug").
			Comment("slug is used to uniquely identify a particular item").
			MaxLen(250).
			Unique(),
	}
}

// Edges of the Item.
func (Item) Edges() []ent.Edge {
	return []ent.Edge{
		edge.To("purchases", ShoppingItem.Type),
		edge.To("tags", Tag.Type),
		edge.From("sublabel", SubLabel.Type).
			Ref("items").
			Unique(),
		edge.To("shoppingList", ShoppingListItem.Type),
	}
}

// Mixin of the Item
func (Item) Mixin() []ent.Mixin {
	return []ent.Mixin{
		mixin.Time{},
	}
}

// Annotations of the Item
func (Item) Annotations() []schema.Annotation {
	return []schema.Annotation{
		entsql.Annotation{
			Charset:   "utf8mb4",
			Collation: "utf8mb4_0900_ai_ci",
		},
	}
}
