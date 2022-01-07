// Code generated by github.com/99designs/gqlgen, DO NOT EDIT.

package model

import (
	"time"

	"github.com/shopspring/decimal"
)

type ItemInput struct {
	Name string `json:"name"`
}

type ShoppingInput struct {
	Date   *time.Time           `json:"date"`
	Market string               `json:"market"`
	Items  []*ShoppingItemInput `json:"items"`
}

type ShoppingItemInput struct {
	Quantity     float64         `json:"quantity"`
	QuantityType string          `json:"quantityType"`
	Units        *int            `json:"units"`
	Brand        *string         `json:"brand"`
	PricePerUnit decimal.Decimal `json:"pricePerUnit"`
	Item         int             `json:"item"`
}
