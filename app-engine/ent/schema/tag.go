package schema

import (
	"entgo.io/ent"
	"entgo.io/ent/entc/integration/json/ent/hook"
	"entgo.io/ent/schema/field"
	"entgo.io/ent/schema/index"
	"entgo.io/ent/schema/mixin"
)

// Tag holds the schema definition for the Tag entity.
type Tag struct {
	ent.Schema
}

// Fields of the Tag.
func (Tag) Fields() []ent.Field {
	return []ent.Field{
		field.String("name").
			Comment("Tag name"),
	}
}

// Edges of the Tag.
func (Tag) Edges() []ent.Edge {
	return nil
}

// Mixin of the Tag
func (Tag) Mixin() []ent.Mixin {
	return []ent.Mixin{
		mixin.Time{},
	}
}

// Indexes of the Tag
func (Tag) Indexes() []ent.Index {
	return []ent.Index{
		index.Fields("name"),
	}
}

// Hooks of the Tag
func (Tag) Hooks() []ent.Hook {
	return []ent.Hook{
		hook.On(
			func(m ent.Mutator) ent.Mutator {
				return nil
			},
			ent.OpCreate|ent.OpUpdate|ent.OpUpdateOne,
		),
	}
}
