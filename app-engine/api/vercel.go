package api

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"os"
	"runtime/debug"

	"entgo.io/contrib/entgql"
	"github.com/99designs/gqlgen/graphql"
	"github.com/99designs/gqlgen/graphql/handler"
	_ "github.com/go-sql-driver/mysql"
	"github.com/rs/cors"
	"github.com/vektah/gqlparser/v2/gqlerror"

	"github.com/kingzbauer/shilingi/app-engine/ent"
	"github.com/kingzbauer/shilingi/app-engine/ent/migrate"
	"github.com/kingzbauer/shilingi/app-engine/graph"
)

var api http.Handler

func init() {
	dbUsername := os.Getenv("PLANETSCALE_DB_USERNAME")
	dbPass := os.Getenv("PLANETSCALE_DB_PASSWORD")
	dbHost := os.Getenv("PLANETSCALE_DB_HOST")
	db := os.Getenv("PLANETSCALE_DB")
	dsn := fmt.Sprintf("%s:%s@tcp(%s)/%s?tls=skip-verify&parseTime=true",
		dbUsername, dbPass, dbHost, db)
	fmt.Println("init DSN:", dsn)
	cli, err := ent.Open("mysql", dsn)
	if err != nil {
		log.Fatal("opening ent client", err)
	}
	// defer cli.Close()

	ctx := context.Background()
	cli.Schema.Create(
		ctx,
		migrate.WithGlobalUniqueID(true),
	)

	srv := handler.NewDefaultServer(graph.NewSchema(cli))
	srv.Use(entgql.Transactioner{TxOpener: cli})
	srv.SetErrorPresenter(func(ctx context.Context, err error) *gqlerror.Error {
		graphQLErr := graphql.DefaultErrorPresenter(ctx, err)
		fmt.Printf("Errors: %s\n", err)

		return graphQLErr
	})
	srv.SetRecoverFunc(func(ctx context.Context, err interface{}) (userMessage error) {
		fmt.Printf("Recover from error: %s\n", err)
		return gqlerror.Errorf("Recoverer: %s: %s", err, debug.Stack())
	})
	api = http.Handler(srv)
}

// Shilingi serves as a Serveless Entrypoint for vercel
func Shilingi(w http.ResponseWriter, r *http.Request) {
	api := cors.Default().Handler(api)
	api.ServeHTTP(w, r)
}
