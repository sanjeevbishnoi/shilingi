package middlewares

import (
	"context"
	"net/http"
	"strings"

	firebase "firebase.google.com/go/v4"
	"firebase.google.com/go/v4/auth"
	"go.uber.org/zap"
	"google.golang.org/api/option"

	"github.com/kingzbauer/shilingi/app-engine/config"
)

// Auth verifies that the provided request has a proper and valid authorization token
func Auth(view http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// For now we just log the Authorization header
		auth := r.Header.Get("authorization")
		if strings.HasPrefix(auth, "Bearer ") {
			parts := strings.Split(auth, " ")
			if len(parts) == 1 {
				w.WriteHeader(http.StatusUnauthorized)
				return
			}
			auth = strings.TrimSpace(parts[1])
		}

		cli, exists := AuthClientFromContext(r.Context())
		if !exists {
			w.WriteHeader(http.StatusInternalServerError)
			return
		}
		_, err := cli.VerifyIDToken(r.Context(), auth)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			return
		}

		view.ServeHTTP(w, r)
	})
}

type key int

const authKey key = 0

// NewAuthClient initializes a new firebase auth client and adds it to the context
func NewAuthClient(view http.Handler) http.Handler {
	cfg := config.SetupConfig()
	opt := option.WithCredentialsFile(cfg.FirebasePrivKeyPath)
	ctx := context.Background()
	app, err := firebase.NewApp(ctx, nil, opt)
	if err != nil {
		zap.S().Panicf("unable to initialize firebase app: %s", err)
	}

	cli, err := app.Auth(ctx)
	if err != nil {
		zap.S().Panicf("unable to initialize firebase app: %s", err)
	}

	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		ctx := context.WithValue(r.Context(), authKey, cli)
		r = r.WithContext(ctx)

		view.ServeHTTP(w, r)
	})
}

// AuthClientFromContext ...
func AuthClientFromContext(ctx context.Context) (*auth.Client, bool) {
	val := ctx.Value(authKey)
	if val == nil {
		return nil, false
	}

	cli, ok := val.(*auth.Client)
	return cli, ok
}
