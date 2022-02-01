package schema

import (
	"entgo.io/contrib/entgql"
	"entgo.io/ent"
	"entgo.io/ent/dialect"
	"entgo.io/ent/schema/edge"
	"entgo.io/ent/schema/field"
	"entgo.io/ent/schema/mixin"

	"github.com/shopspring/decimal"
)

// ShoppingItem holds the schema definition for the ShoppingItem entity.
type ShoppingItem struct {
	ent.Schema
}

// Fields of the ShoppingItem.
func (ShoppingItem) Fields() []ent.Field {
	return []ent.Field{
		field.Float("quantity").
			Comment("This is the raw value. Enhances it's semantics together with quantity type").
			Optional(),
		field.String("quantity_type").
			Comment("E.g liters, grams, kilograms etc.").
			Optional(),
		field.Int("units").
			Comment("How many individual items purchase").
			Default(1),
		field.String("brand").
			Comment("If the specific item is of a particular brand, company").
			Optional(),
		field.Float("price_per_unit").
			GoType(decimal.Decimal{}).
			SchemaType(map[string]string{
				dialect.MySQL:    "decimal(12,2)",
				dialect.Postgres: "numeric",
			}),
	}
}

// Edges of the ShoppingItem.
func (ShoppingItem) Edges() []ent.Edge {
	return []ent.Edge{
		edge.From("item", Item.Type).
			Ref("purchases").
			Unique().
			Required().
			Annotations(entgql.Bind()),
		edge.From("shopping", Shopping.Type).
			Ref("items").
			Unique().
			Required(),
	}
}

// Mixin of the ShoppingItem
func (ShoppingItem) Mixin() []ent.Mixin {
	return []ent.Mixin{
		mixin.Time{},
	}
}
