package schema

import (
	"context"
	"regexp"
	"strings"

	"entgo.io/ent"
	"entgo.io/ent/schema/field"
	"entgo.io/ent/schema/index"
	"entgo.io/ent/schema/mixin"

	gen "github.com/kingzbauer/shilingi/app-engine/ent"
	"github.com/kingzbauer/shilingi/app-engine/ent/hook"
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

var rmSpecialChars = regexp.MustCompile(`[^\w\s]`)
var extraSpaces = regexp.MustCompile(`\s+`)

// Hooks of the Tag
func (Tag) Hooks() []ent.Hook {
	return []ent.Hook{
		hook.On(
			func(next ent.Mutator) ent.Mutator {
				return hook.TagFunc(func(ctx context.Context, m *gen.TagMutation) (ent.Value, error) {
					// We will do a bit of cleaning for the tag name
					if name, exists := m.Name(); exists {
						// remove special
						name = rmSpecialChars.ReplaceAllLiteralString(name, "")
						name = extraSpaces.ReplaceAllLiteralString(name, " ")
						name = strings.ToLower(name)
						m.SetName(name)
					}

					return next.Mutate(ctx, m)
				})
			},
			ent.OpCreate|ent.OpUpdate|ent.OpUpdateOne,
		),
	}
}
