package schema

import (
	"entgo.io/ent"
	"entgo.io/ent/schema/edge"
	"entgo.io/ent/schema/field"
	"entgo.io/ent/schema/index"
	"entgo.io/ent/schema/mixin"
)

// SubLabel holds the schema definition for the SubLabel entity.
type SubLabel struct {
	ent.Schema
}

// Fields of the SubLabel.
func (SubLabel) Fields() []ent.Field {
	return []ent.Field{
		field.String("name").
			Comment("Label name").
			StructTag(`conform:"trim"`),
	}
}

// Edges of the SubLabel.
func (SubLabel) Edges() []ent.Edge {
	return []ent.Edge{
		edge.From("parent", Tag.Type).
			Ref("children").
			Unique(),
		edge.To("items", Item.Type),
	}
}

// Mixin of the SubLabel
func (SubLabel) Mixin() []ent.Mixin {
	return []ent.Mixin{
		mixin.Time{},
	}
}

// Indexes of the SubLabel
func (SubLabel) Indexes() []ent.Index {
	return []ent.Index{
		index.Fields("name").
			Edges("parent").
			Unique(),
	}
}
