// Code generated by github.com/99designs/gqlgen, DO NOT EDIT.

package model

import (
	"time"

	"github.com/shopspring/decimal"
)

type CreatePurchaseFromShoppingListInput struct {
	Vendor int                              `json:"vendor"`
	Items  []*PurchaseShoppingListItemInput `json:"items"`
}

type ItemInput struct {
	Name string `json:"name"`
}

type PurchaseShoppingListItemInput struct {
	Item         int             `json:"item"`
	Units        *int            `json:"units"`
	PricePerUnit decimal.Decimal `json:"pricePerUnit"`
	Quantity     *float64        `json:"quantity"`
	QuantityType *string         `json:"quantityType"`
	Brand        *string         `json:"brand"`
}

type ShoppingInput struct {
	Date   *time.Time           `json:"date"`
	Vendor *VendorInput         `json:"vendor"`
	Items  []*ShoppingItemInput `json:"items"`
}

type ShoppingItemInput struct {
	Quantity     *float64        `json:"quantity"`
	QuantityType *string         `json:"quantityType"`
	Units        *int            `json:"units"`
	Brand        *string         `json:"brand"`
	PricePerUnit decimal.Decimal `json:"pricePerUnit"`
	Item         int             `json:"item"`
}

type ShoppingListInput struct {
	Name  string                   `json:"name"`
	Items []*ShoppingListItemInput `json:"items"`
}

type ShoppingListItemInput struct {
	Item int `json:"item"`
}

type SubLabelInput struct {
	Name string `json:"name"`
}

type TagInput struct {
	Name string `json:"name"`
}

type UpdateShoppingListItemInput struct {
	Note *string `json:"note"`
}

type VendorInput struct {
	ID int `json:"id"`
}
