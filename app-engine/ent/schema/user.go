package schema

import (
	"entgo.io/ent"
	"entgo.io/ent/schema/edge"
	"entgo.io/ent/schema/field"
	"entgo.io/ent/schema/mixin"
)

// User holds the schema definition for the User entity.
type User struct {
	ent.Schema
}

// Fields of the User.
func (User) Fields() []ent.Field {
	return []ent.Field{
		field.String("external_id").
			Comment("If this user is from a different external system").
			Optional().
			Unique(),
		field.String("first_name").
			Optional(),
		field.String("other_names").
			Optional(),
		field.String("email").
			Comment("user's primary communication email").
			Unique(),
		field.Bool("is_email_verified"),
		field.Enum("external_source").
			Values("FIREBASE").
			Default("FIREBASE"),
	}
}

// Edges of the User.
func (User) Edges() []ent.Edge {
	return []ent.Edge{
		edge.To("invites", AccountInvite.Type),
		edge.To("memberships", AccountMember.Type),
	}
}

// Mixin of the User
func (User) Mixin() []ent.Mixin {
	return []ent.Mixin{
		mixin.Time{},
	}
}
