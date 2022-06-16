package entops

import (
	"net/http"

	"github.com/kingzbauer/shilingi/app-engine/ent"
)

// Middleware adds the ent cli to the context
func Middleware(cli *ent.Client) func(http.Handler) http.Handler {
	return func(h http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			ctx := ent.NewContext(r.Context(), cli)
			r = r.WithContext(ctx)
			h.ServeHTTP(w, r)
		})

	}
}
