package auth

import (
	"context"

	"firebase.google.com/go/v4/auth"
	"github.com/kingzbauer/shilingi/app-engine/ent"
	"github.com/kingzbauer/shilingi/app-engine/ent/user"
	"go.uber.org/zap"
)

// A couple of prefixes to append to external id for a user
const (
	UID_PREFIX_FIREBASE = "firebase:"
)

// User provides a generic user interface
type User interface {
	ID(context.Context) string
	IsAuthenticated(context.Context) bool
}

// entUser is a wrapper around ent.User
type entUser struct {
	*ent.User
}

func (e *entUser) ID(_ context.Context) string {
	return e.ExternalID
}

func (e *entUser) IsAuthenticated(_ context.Context) bool {
	return true
}

// GetUserFromFirebaseToken retrieves the user from the app db using credentials
// from firebase
// If the user does not exist, they are created
func GetUserFromFirebaseToken(ctx context.Context, token *auth.Token) (User, error) {
	// Prefix with firebase UID prefix to distinguish it from other sources
	// in the future
	uid := UID_PREFIX_FIREBASE + token.UID
	cli := ent.FromContext(ctx)
	us, err := cli.User.Query().
		Where(
			user.ExternalID(uid),
		).Only(ctx)
	if ent.IsNotFound(err) {
		// We can create the user
		email := token.Claims["email"].(string)
		emailVerified := token.Claims["email_verified"].(bool)
		us, err = cli.User.Create().
			SetEmail(email).
			SetIsEmailVerified(emailVerified).
			SetExternalID(uid).
			SetExternalSource(user.ExternalSourceFIREBASE).
			Save(ctx)
		zap.S().Errorf("unable to create user: %s", err)
		return nil, err
	}

	return &entUser{us}, nil
}

type key int

const userKey key = 1

// UserContext adds the provided user to the context
func UserContext(ctx context.Context, u User) context.Context {
	return context.WithValue(ctx, userKey, u)
}

// UserFromContext retrieves a user from the context
func UserFromContext(ctx context.Context) (User, bool) {
	u, ok := ctx.Value(userKey).(User)
	return u, ok
}
