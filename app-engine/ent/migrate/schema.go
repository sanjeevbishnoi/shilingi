// Code generated by entc, DO NOT EDIT.

package migrate

import (
	"entgo.io/ent/dialect/sql/schema"
	"entgo.io/ent/schema/field"
)

var (
	// ItemsColumns holds the columns for the "items" table.
	ItemsColumns = []*schema.Column{
		{Name: "id", Type: field.TypeInt, Increment: true},
		{Name: "create_time", Type: field.TypeTime},
		{Name: "update_time", Type: field.TypeTime},
		{Name: "name", Type: field.TypeString},
		{Name: "slug", Type: field.TypeString, Unique: true, Size: 250},
	}
	// ItemsTable holds the schema information for the "items" table.
	ItemsTable = &schema.Table{
		Name:       "items",
		Columns:    ItemsColumns,
		PrimaryKey: []*schema.Column{ItemsColumns[0]},
	}
	// ShoppingsColumns holds the columns for the "shoppings" table.
	ShoppingsColumns = []*schema.Column{
		{Name: "id", Type: field.TypeInt, Increment: true},
		{Name: "create_time", Type: field.TypeTime},
		{Name: "update_time", Type: field.TypeTime},
		{Name: "date", Type: field.TypeTime},
		{Name: "vendor_purchases", Type: field.TypeInt, Nullable: true},
	}
	// ShoppingsTable holds the schema information for the "shoppings" table.
	ShoppingsTable = &schema.Table{
		Name:       "shoppings",
		Columns:    ShoppingsColumns,
		PrimaryKey: []*schema.Column{ShoppingsColumns[0]},
		ForeignKeys: []*schema.ForeignKey{
			{
				Symbol:     "shoppings_vendors_purchases",
				Columns:    []*schema.Column{ShoppingsColumns[4]},
				RefColumns: []*schema.Column{VendorsColumns[0]},
				OnDelete:   schema.SetNull,
			},
		},
	}
	// ShoppingItemsColumns holds the columns for the "shopping_items" table.
	ShoppingItemsColumns = []*schema.Column{
		{Name: "id", Type: field.TypeInt, Increment: true},
		{Name: "create_time", Type: field.TypeTime},
		{Name: "update_time", Type: field.TypeTime},
		{Name: "quantity", Type: field.TypeFloat64, Nullable: true},
		{Name: "quantity_type", Type: field.TypeString, Nullable: true},
		{Name: "units", Type: field.TypeInt, Default: 1},
		{Name: "brand", Type: field.TypeString, Nullable: true},
		{Name: "price_per_unit", Type: field.TypeFloat64, SchemaType: map[string]string{"mysql": "decimal(6,2)", "postgres": "numeric"}},
		{Name: "item_purchases", Type: field.TypeInt, Nullable: true},
		{Name: "shopping_items", Type: field.TypeInt, Nullable: true},
	}
	// ShoppingItemsTable holds the schema information for the "shopping_items" table.
	ShoppingItemsTable = &schema.Table{
		Name:       "shopping_items",
		Columns:    ShoppingItemsColumns,
		PrimaryKey: []*schema.Column{ShoppingItemsColumns[0]},
		ForeignKeys: []*schema.ForeignKey{
			{
				Symbol:     "shopping_items_items_purchases",
				Columns:    []*schema.Column{ShoppingItemsColumns[8]},
				RefColumns: []*schema.Column{ItemsColumns[0]},
				OnDelete:   schema.SetNull,
			},
			{
				Symbol:     "shopping_items_shoppings_items",
				Columns:    []*schema.Column{ShoppingItemsColumns[9]},
				RefColumns: []*schema.Column{ShoppingsColumns[0]},
				OnDelete:   schema.SetNull,
			},
		},
	}
	// VendorsColumns holds the columns for the "vendors" table.
	VendorsColumns = []*schema.Column{
		{Name: "id", Type: field.TypeInt, Increment: true},
		{Name: "create_time", Type: field.TypeTime},
		{Name: "update_time", Type: field.TypeTime},
		{Name: "name", Type: field.TypeString},
		{Name: "slug", Type: field.TypeString, Unique: true},
	}
	// VendorsTable holds the schema information for the "vendors" table.
	VendorsTable = &schema.Table{
		Name:       "vendors",
		Columns:    VendorsColumns,
		PrimaryKey: []*schema.Column{VendorsColumns[0]},
	}
	// Tables holds all the tables in the schema.
	Tables = []*schema.Table{
		ItemsTable,
		ShoppingsTable,
		ShoppingItemsTable,
		VendorsTable,
	}
)

func init() {
	ShoppingsTable.ForeignKeys[0].RefTable = VendorsTable
	ShoppingItemsTable.ForeignKeys[0].RefTable = ItemsTable
	ShoppingItemsTable.ForeignKeys[1].RefTable = ShoppingsTable
}
