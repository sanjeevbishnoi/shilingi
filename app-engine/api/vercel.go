package api

import (
	"context"
	"fmt"
	"log"
	"net/http"

	"entgo.io/contrib/entgql"
	"github.com/99designs/gqlgen/graphql"
	"github.com/99designs/gqlgen/graphql/handler"
	_ "github.com/go-sql-driver/mysql"
	"github.com/vektah/gqlparser/v2/gqlerror"

	"github.com/kingzbauer/shilingi/app-engine/config"
	"github.com/kingzbauer/shilingi/app-engine/ent"
	"github.com/kingzbauer/shilingi/app-engine/ent/migrate"
	"github.com/kingzbauer/shilingi/app-engine/graph"
)

// Shilingi serves as a Serveless Entrypoint for vercel
func Shilingi(w http.ResponseWriter, r *http.Request) {
	cfg := config.SetupConfig()
	log.Printf("Confis: %+v", cfg)

	cli, err := ent.Open("mysql", cfg.PlanetScaleURI())
	if err != nil {
		log.Fatal("opening ent client", err)
	}
	defer cli.Close()

	ctx := context.Background()
	cli.Schema.Create(
		ctx,
		migrate.WithGlobalUniqueID(true),
	)

	srv := handler.NewDefaultServer(graph.NewSchema(cli))
	srv.Use(entgql.Transactioner{TxOpener: cli})
	srv.SetErrorPresenter(func(ctx context.Context, err error) *gqlerror.Error {
		graphQLErr := graphql.DefaultErrorPresenter(ctx, err)
		fmt.Printf("Error: %s\n", err)

		return graphQLErr
	})

	srv.ServeHTTP(w, r)
}
