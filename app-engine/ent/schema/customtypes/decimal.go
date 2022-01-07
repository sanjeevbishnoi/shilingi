package customtypes

import (
	"encoding/json"
	"fmt"
	"io"

	"github.com/99designs/gqlgen/graphql"
	"github.com/shopspring/decimal"
)

// MarshalDecimal marshals the decimal value into a API compatible value
func MarshalDecimal(val decimal.Decimal) graphql.Marshaler {
	return graphql.WriterFunc(func(writer io.Writer) {
		floatVal, _ := val.Float64()
		json.NewEncoder(writer).Encode(floatVal)
	})
}

// UnmarshalDecimal returns a decimal from provided raw value
func UnmarshalDecimal(val interface{}) (decimal.Decimal, error) {
	switch t := val.(type) {
	case float64:
		return decimal.NewFromFloat(t), nil
	case float32:
		return decimal.NewFromFloat32(t), nil
	case string:
		return decimal.NewFromString(t)
	case []byte:
		return decimal.NewFromString(string(t))
	case int64:
		return decimal.NewFromInt(t), nil
	default:
		return decimal.Decimal{}, fmt.Errorf("unsupported type for decimal: %T", t)
	}
}
