package schema

import "entgo.io/ent"

// AccountMember holds the schema definition for the AccountMember entity.
type AccountMember struct {
	ent.Schema
}

// Fields of the AccountMember.
func (AccountMember) Fields() []ent.Field {
	return nil
}

// Edges of the AccountMember.
func (AccountMember) Edges() []ent.Edge {
	return nil
}
