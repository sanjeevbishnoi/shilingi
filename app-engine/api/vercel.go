package api

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"os"

	"entgo.io/contrib/entgql"
	"github.com/99designs/gqlgen/graphql"
	"github.com/99designs/gqlgen/graphql/handler"
	_ "github.com/go-sql-driver/mysql"
	"github.com/vektah/gqlparser/v2/gqlerror"

	"github.com/kingzbauer/shilingi/app-engine/ent"
	"github.com/kingzbauer/shilingi/app-engine/ent/migrate"
	"github.com/kingzbauer/shilingi/app-engine/graph"
)

// Shilingi serves as a Serveless Entrypoint for vercel
func Shilingi(w http.ResponseWriter, r *http.Request) {
	dbUsername := os.Getenv("PLANETSCALE_DB_USERNAME")
	dbPass := os.Getenv("PLANETSCALE_DB_PASSWORD")
	dbHost := os.Getenv("PLANETSCALE_DB_HOST")
	db := os.Getenv("PLANETSCALE_DB")
	fmt.Println("URI", fmt.Sprintf("mysql://%s:%s@tcp(%s)/%s",
		dbUsername, dbPass, dbHost, db))
	cli, err := ent.Open("mysql",
		fmt.Sprintf("mysql://%s:%s@tcp(%s)/%s",
			dbUsername, dbPass, dbHost, db))
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
