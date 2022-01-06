// Code generated by entc, DO NOT EDIT.

package ent

import (
	"fmt"
	"strings"

	"entgo.io/ent/dialect/sql"
	"github.com/kingzbauer/shilingi/app-engine/ent/shoppingitem"
)

// ShoppingItem is the model entity for the ShoppingItem schema.
type ShoppingItem struct {
	config
	// ID of the ent.
	ID int `json:"id,omitempty"`
}

// scanValues returns the types for scanning values from sql.Rows.
func (*ShoppingItem) scanValues(columns []string) ([]interface{}, error) {
	values := make([]interface{}, len(columns))
	for i := range columns {
		switch columns[i] {
		case shoppingitem.FieldID:
			values[i] = new(sql.NullInt64)
		default:
			return nil, fmt.Errorf("unexpected column %q for type ShoppingItem", columns[i])
		}
	}
	return values, nil
}

// assignValues assigns the values that were returned from sql.Rows (after scanning)
// to the ShoppingItem fields.
func (si *ShoppingItem) assignValues(columns []string, values []interface{}) error {
	if m, n := len(values), len(columns); m < n {
		return fmt.Errorf("mismatch number of scan values: %d != %d", m, n)
	}
	for i := range columns {
		switch columns[i] {
		case shoppingitem.FieldID:
			value, ok := values[i].(*sql.NullInt64)
			if !ok {
				return fmt.Errorf("unexpected type %T for field id", value)
			}
			si.ID = int(value.Int64)
		}
	}
	return nil
}

// Update returns a builder for updating this ShoppingItem.
// Note that you need to call ShoppingItem.Unwrap() before calling this method if this ShoppingItem
// was returned from a transaction, and the transaction was committed or rolled back.
func (si *ShoppingItem) Update() *ShoppingItemUpdateOne {
	return (&ShoppingItemClient{config: si.config}).UpdateOne(si)
}

// Unwrap unwraps the ShoppingItem entity that was returned from a transaction after it was closed,
// so that all future queries will be executed through the driver which created the transaction.
func (si *ShoppingItem) Unwrap() *ShoppingItem {
	tx, ok := si.config.driver.(*txDriver)
	if !ok {
		panic("ent: ShoppingItem is not a transactional entity")
	}
	si.config.driver = tx.drv
	return si
}

// String implements the fmt.Stringer.
func (si *ShoppingItem) String() string {
	var builder strings.Builder
	builder.WriteString("ShoppingItem(")
	builder.WriteString(fmt.Sprintf("id=%v", si.ID))
	builder.WriteByte(')')
	return builder.String()
}

// ShoppingItems is a parsable slice of ShoppingItem.
type ShoppingItems []*ShoppingItem

func (si ShoppingItems) config(cfg config) {
	for _i := range si {
		si[_i].config = cfg
	}
}
