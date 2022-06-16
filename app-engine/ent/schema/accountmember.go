package schema

import (
	"entgo.io/ent"
	"entgo.io/ent/schema/edge"
	"entgo.io/ent/schema/field"
	"entgo.io/ent/schema/mixin"
)

// AccountMember holds the schema definition for the AccountMember entity.
type AccountMember struct {
	ent.Schema
}

// Fields of the AccountMember.
func (AccountMember) Fields() []ent.Field {
	return []ent.Field{
		field.Enum("type").
			NamedValues(
				"Owner", "OWNER",
				"Member", "MEMBER",
			),
	}
}

// Edges of the AccountMember.
func (AccountMember) Edges() []ent.Edge {
	return []ent.Edge{
		edge.From("account", Account.Type).
			Ref("members").
			Required().
			Unique(),
		edge.From("user", User.Type).
			Ref("memberships").
			Unique().
			Required(),
		edge.To("invite", AccountInvite.Type),
	}
}

// Mixin of the AccountMember
func (AccountMember) Mixin() []ent.Mixin {
	return []ent.Mixin{
		mixin.Time{},
	}
}
