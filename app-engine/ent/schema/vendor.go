package schema

import (
	"entgo.io/contrib/entgql"
	"entgo.io/ent"
	"entgo.io/ent/schema/edge"
	"entgo.io/ent/schema/field"
	"entgo.io/ent/schema/mixin"
)

// Vendor holds the schema definition for the Vendor entity.
type Vendor struct {
	ent.Schema
}

// Fields of the Vendor.
func (Vendor) Fields() []ent.Field {
	return []ent.Field{
		field.String("name"),
		field.String("slug").
			Unique(),
	}
}

// Edges of the Vendor.
func (Vendor) Edges() []ent.Edge {
	return []ent.Edge{
		edge.To("purchases", Shopping.Type).
			Annotations(entgql.Bind()),
	}
}

// Mixin of the Vendor
func (Vendor) Mixin() []ent.Mixin {
	return []ent.Mixin{
		mixin.Time{},
	}
}
