package schema

import (
	"entgo.io/ent"
	"entgo.io/ent/schema/edge"
	"entgo.io/ent/schema/field"
	"entgo.io/ent/schema/mixin"
)

// AccountInvite holds the schema definition for the AccountInvite entity.
type AccountInvite struct {
	ent.Schema
}

// Fields of the AccountInvite.
func (AccountInvite) Fields() []ent.Field {
	return []ent.Field{
		field.String("email").
			Comment("Email for the invited user"),
		field.Enum("status").
			NamedValues(
				"Pending", "PENDING",
				"Declined", "DECLINED",
				"Accepted", "ACCEPTED",
			).
			Default("PENDING"),
	}
}

// Edges of the AccountInvite.
func (AccountInvite) Edges() []ent.Edge {
	return []ent.Edge{
		edge.From("account", Account.Type).
			Ref("invites").
			Required().
			Unique(),
		edge.From("user", User.Type).
			Ref("invites").
			Unique(),
		edge.From("member", AccountMember.Type).
			Ref("invite").
			Unique(),
	}
}

// Mixin of the AccountInvite
func (AccountInvite) Mixin() []ent.Mixin {
	return []ent.Mixin{
		mixin.Time{},
	}
}
