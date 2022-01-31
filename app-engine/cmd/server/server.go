package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"os"

	"entgo.io/contrib/entgql"
	"github.com/99designs/gqlgen/graphql"
	"github.com/99designs/gqlgen/graphql/handler"
	"github.com/99designs/gqlgen/graphql/playground"
	_ "github.com/go-sql-driver/mysql"
	_ "github.com/mattn/go-sqlite3"
	"github.com/vektah/gqlparser/v2/gqlerror"

	"github.com/kingzbauer/shilingi/app-engine/config"
	"github.com/kingzbauer/shilingi/app-engine/ent"
	"github.com/kingzbauer/shilingi/app-engine/ent/migrate"
	_ "github.com/kingzbauer/shilingi/app-engine/ent/runtime"
	"github.com/kingzbauer/shilingi/app-engine/graph"
)

const defaultPort = "8080"

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = defaultPort
	}
	cfg := config.SetupConfig()
	fmt.Printf("%+v\n", cfg)

	// Open a DB connection
	cli, err := ent.Open(cfg.DBType, cfg.DBURI)
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

	http.Handle("/", playground.Handler("GraphQL playground", "/query"))
	http.Handle("/query", srv)

	log.Printf("connect to http://localhost:%s/ for GraphQL playground", port)
	log.Fatal(http.ListenAndServe(":"+port, nil))
}
