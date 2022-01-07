package graph

import (
	"github.com/99designs/gqlgen/graphql"
	"github.com/kingzbauer/shilingi/app-engine/ent"
	"github.com/kingzbauer/shilingi/app-engine/graph/generated"
)

//go:generate go run github.com/99designs/gqlgen

// This file will not be regenerated automatically.
//
// It serves as dependency injection for your app, add any dependencies you require here.

// Resolver is the root resolver instance for dependency injection
type Resolver struct {
	cli *ent.Client
}

// NewSchema initializes a new executable schema and passes the root resolver instance
func NewSchema(cli *ent.Client) graphql.ExecutableSchema {
	return generated.NewExecutableSchema(generated.Config{Resolvers: &Resolver{cli: cli}})
}
