package schema

import "entgo.io/ent"

// AccountInvite holds the schema definition for the AccountInvite entity.
type AccountInvite struct {
	ent.Schema
}

// Fields of the AccountInvite.
func (AccountInvite) Fields() []ent.Field {
	return nil
}

// Edges of the AccountInvite.
func (AccountInvite) Edges() []ent.Edge {
	return nil
}
