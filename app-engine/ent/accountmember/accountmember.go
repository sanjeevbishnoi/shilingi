// Code generated by entc, DO NOT EDIT.

package accountmember

import (
	"fmt"
	"io"
	"strconv"
	"time"
)

const (
	// Label holds the string label denoting the accountmember type in the database.
	Label = "account_member"
	// FieldID holds the string denoting the id field in the database.
	FieldID = "id"
	// FieldCreateTime holds the string denoting the create_time field in the database.
	FieldCreateTime = "create_time"
	// FieldUpdateTime holds the string denoting the update_time field in the database.
	FieldUpdateTime = "update_time"
	// FieldType holds the string denoting the type field in the database.
	FieldType = "type"
	// EdgeAccount holds the string denoting the account edge name in mutations.
	EdgeAccount = "account"
	// EdgeUser holds the string denoting the user edge name in mutations.
	EdgeUser = "user"
	// EdgeInvite holds the string denoting the invite edge name in mutations.
	EdgeInvite = "invite"
	// Table holds the table name of the accountmember in the database.
	Table = "account_members"
	// AccountTable is the table that holds the account relation/edge.
	AccountTable = "account_members"
	// AccountInverseTable is the table name for the Account entity.
	// It exists in this package in order to avoid circular dependency with the "account" package.
	AccountInverseTable = "accounts"
	// AccountColumn is the table column denoting the account relation/edge.
	AccountColumn = "account_members"
	// UserTable is the table that holds the user relation/edge.
	UserTable = "account_members"
	// UserInverseTable is the table name for the User entity.
	// It exists in this package in order to avoid circular dependency with the "user" package.
	UserInverseTable = "users"
	// UserColumn is the table column denoting the user relation/edge.
	UserColumn = "user_memberships"
	// InviteTable is the table that holds the invite relation/edge.
	InviteTable = "account_invites"
	// InviteInverseTable is the table name for the AccountInvite entity.
	// It exists in this package in order to avoid circular dependency with the "accountinvite" package.
	InviteInverseTable = "account_invites"
	// InviteColumn is the table column denoting the invite relation/edge.
	InviteColumn = "account_member_invite"
)

// Columns holds all SQL columns for accountmember fields.
var Columns = []string{
	FieldID,
	FieldCreateTime,
	FieldUpdateTime,
	FieldType,
}

// ForeignKeys holds the SQL foreign-keys that are owned by the "account_members"
// table and are not defined as standalone fields in the schema.
var ForeignKeys = []string{
	"account_members",
	"user_memberships",
}

// ValidColumn reports if the column name is valid (part of the table columns).
func ValidColumn(column string) bool {
	for i := range Columns {
		if column == Columns[i] {
			return true
		}
	}
	for i := range ForeignKeys {
		if column == ForeignKeys[i] {
			return true
		}
	}
	return false
}

var (
	// DefaultCreateTime holds the default value on creation for the "create_time" field.
	DefaultCreateTime func() time.Time
	// DefaultUpdateTime holds the default value on creation for the "update_time" field.
	DefaultUpdateTime func() time.Time
	// UpdateDefaultUpdateTime holds the default value on update for the "update_time" field.
	UpdateDefaultUpdateTime func() time.Time
)

// Type defines the type for the "type" enum field.
type Type string

// Type values.
const (
	TypeOwner  Type = "OWNER"
	TypeMember Type = "MEMBER"
)

func (_type Type) String() string {
	return string(_type)
}

// TypeValidator is a validator for the "type" field enum values. It is called by the builders before save.
func TypeValidator(_type Type) error {
	switch _type {
	case TypeOwner, TypeMember:
		return nil
	default:
		return fmt.Errorf("accountmember: invalid enum value for type field: %q", _type)
	}
}

// MarshalGQL implements graphql.Marshaler interface.
func (_type Type) MarshalGQL(w io.Writer) {
	io.WriteString(w, strconv.Quote(_type.String()))
}

// UnmarshalGQL implements graphql.Unmarshaler interface.
func (_type *Type) UnmarshalGQL(val interface{}) error {
	str, ok := val.(string)
	if !ok {
		return fmt.Errorf("enum %T must be a string", val)
	}
	*_type = Type(str)
	if err := TypeValidator(*_type); err != nil {
		return fmt.Errorf("%s is not a valid Type", str)
	}
	return nil
}