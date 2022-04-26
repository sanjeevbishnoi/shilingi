// Code generated by entc, DO NOT EDIT.

package shoppingitem

import (
	"time"

	"entgo.io/ent/dialect/sql"
	"entgo.io/ent/dialect/sql/sqlgraph"
	"github.com/kingzbauer/shilingi/app-engine/ent/predicate"
	"github.com/shopspring/decimal"
)

// ID filters vertices based on their ID field.
func ID(id int) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.EQ(s.C(FieldID), id))
	})
}

// IDEQ applies the EQ predicate on the ID field.
func IDEQ(id int) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.EQ(s.C(FieldID), id))
	})
}

// IDNEQ applies the NEQ predicate on the ID field.
func IDNEQ(id int) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.NEQ(s.C(FieldID), id))
	})
}

// IDIn applies the In predicate on the ID field.
func IDIn(ids ...int) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		// if not arguments were provided, append the FALSE constants,
		// since we can't apply "IN ()". This will make this predicate falsy.
		if len(ids) == 0 {
			s.Where(sql.False())
			return
		}
		v := make([]interface{}, len(ids))
		for i := range v {
			v[i] = ids[i]
		}
		s.Where(sql.In(s.C(FieldID), v...))
	})
}

// IDNotIn applies the NotIn predicate on the ID field.
func IDNotIn(ids ...int) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		// if not arguments were provided, append the FALSE constants,
		// since we can't apply "IN ()". This will make this predicate falsy.
		if len(ids) == 0 {
			s.Where(sql.False())
			return
		}
		v := make([]interface{}, len(ids))
		for i := range v {
			v[i] = ids[i]
		}
		s.Where(sql.NotIn(s.C(FieldID), v...))
	})
}

// IDGT applies the GT predicate on the ID field.
func IDGT(id int) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.GT(s.C(FieldID), id))
	})
}

// IDGTE applies the GTE predicate on the ID field.
func IDGTE(id int) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.GTE(s.C(FieldID), id))
	})
}

// IDLT applies the LT predicate on the ID field.
func IDLT(id int) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.LT(s.C(FieldID), id))
	})
}

// IDLTE applies the LTE predicate on the ID field.
func IDLTE(id int) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.LTE(s.C(FieldID), id))
	})
}

// CreateTime applies equality check predicate on the "create_time" field. It's identical to CreateTimeEQ.
func CreateTime(v time.Time) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.EQ(s.C(FieldCreateTime), v))
	})
}

// UpdateTime applies equality check predicate on the "update_time" field. It's identical to UpdateTimeEQ.
func UpdateTime(v time.Time) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.EQ(s.C(FieldUpdateTime), v))
	})
}

// Quantity applies equality check predicate on the "quantity" field. It's identical to QuantityEQ.
func Quantity(v float64) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.EQ(s.C(FieldQuantity), v))
	})
}

// QuantityType applies equality check predicate on the "quantity_type" field. It's identical to QuantityTypeEQ.
func QuantityType(v string) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.EQ(s.C(FieldQuantityType), v))
	})
}

// Units applies equality check predicate on the "units" field. It's identical to UnitsEQ.
func Units(v int) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.EQ(s.C(FieldUnits), v))
	})
}

// Brand applies equality check predicate on the "brand" field. It's identical to BrandEQ.
func Brand(v string) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.EQ(s.C(FieldBrand), v))
	})
}

// PricePerUnit applies equality check predicate on the "price_per_unit" field. It's identical to PricePerUnitEQ.
func PricePerUnit(v decimal.Decimal) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.EQ(s.C(FieldPricePerUnit), v))
	})
}

// CreateTimeEQ applies the EQ predicate on the "create_time" field.
func CreateTimeEQ(v time.Time) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.EQ(s.C(FieldCreateTime), v))
	})
}

// CreateTimeNEQ applies the NEQ predicate on the "create_time" field.
func CreateTimeNEQ(v time.Time) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.NEQ(s.C(FieldCreateTime), v))
	})
}

// CreateTimeIn applies the In predicate on the "create_time" field.
func CreateTimeIn(vs ...time.Time) predicate.ShoppingItem {
	v := make([]interface{}, len(vs))
	for i := range v {
		v[i] = vs[i]
	}
	return predicate.ShoppingItem(func(s *sql.Selector) {
		// if not arguments were provided, append the FALSE constants,
		// since we can't apply "IN ()". This will make this predicate falsy.
		if len(v) == 0 {
			s.Where(sql.False())
			return
		}
		s.Where(sql.In(s.C(FieldCreateTime), v...))
	})
}

// CreateTimeNotIn applies the NotIn predicate on the "create_time" field.
func CreateTimeNotIn(vs ...time.Time) predicate.ShoppingItem {
	v := make([]interface{}, len(vs))
	for i := range v {
		v[i] = vs[i]
	}
	return predicate.ShoppingItem(func(s *sql.Selector) {
		// if not arguments were provided, append the FALSE constants,
		// since we can't apply "IN ()". This will make this predicate falsy.
		if len(v) == 0 {
			s.Where(sql.False())
			return
		}
		s.Where(sql.NotIn(s.C(FieldCreateTime), v...))
	})
}

// CreateTimeGT applies the GT predicate on the "create_time" field.
func CreateTimeGT(v time.Time) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.GT(s.C(FieldCreateTime), v))
	})
}

// CreateTimeGTE applies the GTE predicate on the "create_time" field.
func CreateTimeGTE(v time.Time) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.GTE(s.C(FieldCreateTime), v))
	})
}

// CreateTimeLT applies the LT predicate on the "create_time" field.
func CreateTimeLT(v time.Time) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.LT(s.C(FieldCreateTime), v))
	})
}

// CreateTimeLTE applies the LTE predicate on the "create_time" field.
func CreateTimeLTE(v time.Time) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.LTE(s.C(FieldCreateTime), v))
	})
}

// UpdateTimeEQ applies the EQ predicate on the "update_time" field.
func UpdateTimeEQ(v time.Time) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.EQ(s.C(FieldUpdateTime), v))
	})
}

// UpdateTimeNEQ applies the NEQ predicate on the "update_time" field.
func UpdateTimeNEQ(v time.Time) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.NEQ(s.C(FieldUpdateTime), v))
	})
}

// UpdateTimeIn applies the In predicate on the "update_time" field.
func UpdateTimeIn(vs ...time.Time) predicate.ShoppingItem {
	v := make([]interface{}, len(vs))
	for i := range v {
		v[i] = vs[i]
	}
	return predicate.ShoppingItem(func(s *sql.Selector) {
		// if not arguments were provided, append the FALSE constants,
		// since we can't apply "IN ()". This will make this predicate falsy.
		if len(v) == 0 {
			s.Where(sql.False())
			return
		}
		s.Where(sql.In(s.C(FieldUpdateTime), v...))
	})
}

// UpdateTimeNotIn applies the NotIn predicate on the "update_time" field.
func UpdateTimeNotIn(vs ...time.Time) predicate.ShoppingItem {
	v := make([]interface{}, len(vs))
	for i := range v {
		v[i] = vs[i]
	}
	return predicate.ShoppingItem(func(s *sql.Selector) {
		// if not arguments were provided, append the FALSE constants,
		// since we can't apply "IN ()". This will make this predicate falsy.
		if len(v) == 0 {
			s.Where(sql.False())
			return
		}
		s.Where(sql.NotIn(s.C(FieldUpdateTime), v...))
	})
}

// UpdateTimeGT applies the GT predicate on the "update_time" field.
func UpdateTimeGT(v time.Time) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.GT(s.C(FieldUpdateTime), v))
	})
}

// UpdateTimeGTE applies the GTE predicate on the "update_time" field.
func UpdateTimeGTE(v time.Time) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.GTE(s.C(FieldUpdateTime), v))
	})
}

// UpdateTimeLT applies the LT predicate on the "update_time" field.
func UpdateTimeLT(v time.Time) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.LT(s.C(FieldUpdateTime), v))
	})
}

// UpdateTimeLTE applies the LTE predicate on the "update_time" field.
func UpdateTimeLTE(v time.Time) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.LTE(s.C(FieldUpdateTime), v))
	})
}

// QuantityEQ applies the EQ predicate on the "quantity" field.
func QuantityEQ(v float64) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.EQ(s.C(FieldQuantity), v))
	})
}

// QuantityNEQ applies the NEQ predicate on the "quantity" field.
func QuantityNEQ(v float64) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.NEQ(s.C(FieldQuantity), v))
	})
}

// QuantityIn applies the In predicate on the "quantity" field.
func QuantityIn(vs ...float64) predicate.ShoppingItem {
	v := make([]interface{}, len(vs))
	for i := range v {
		v[i] = vs[i]
	}
	return predicate.ShoppingItem(func(s *sql.Selector) {
		// if not arguments were provided, append the FALSE constants,
		// since we can't apply "IN ()". This will make this predicate falsy.
		if len(v) == 0 {
			s.Where(sql.False())
			return
		}
		s.Where(sql.In(s.C(FieldQuantity), v...))
	})
}

// QuantityNotIn applies the NotIn predicate on the "quantity" field.
func QuantityNotIn(vs ...float64) predicate.ShoppingItem {
	v := make([]interface{}, len(vs))
	for i := range v {
		v[i] = vs[i]
	}
	return predicate.ShoppingItem(func(s *sql.Selector) {
		// if not arguments were provided, append the FALSE constants,
		// since we can't apply "IN ()". This will make this predicate falsy.
		if len(v) == 0 {
			s.Where(sql.False())
			return
		}
		s.Where(sql.NotIn(s.C(FieldQuantity), v...))
	})
}

// QuantityGT applies the GT predicate on the "quantity" field.
func QuantityGT(v float64) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.GT(s.C(FieldQuantity), v))
	})
}

// QuantityGTE applies the GTE predicate on the "quantity" field.
func QuantityGTE(v float64) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.GTE(s.C(FieldQuantity), v))
	})
}

// QuantityLT applies the LT predicate on the "quantity" field.
func QuantityLT(v float64) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.LT(s.C(FieldQuantity), v))
	})
}

// QuantityLTE applies the LTE predicate on the "quantity" field.
func QuantityLTE(v float64) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.LTE(s.C(FieldQuantity), v))
	})
}

// QuantityIsNil applies the IsNil predicate on the "quantity" field.
func QuantityIsNil() predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.IsNull(s.C(FieldQuantity)))
	})
}

// QuantityNotNil applies the NotNil predicate on the "quantity" field.
func QuantityNotNil() predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.NotNull(s.C(FieldQuantity)))
	})
}

// QuantityTypeEQ applies the EQ predicate on the "quantity_type" field.
func QuantityTypeEQ(v string) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.EQ(s.C(FieldQuantityType), v))
	})
}

// QuantityTypeNEQ applies the NEQ predicate on the "quantity_type" field.
func QuantityTypeNEQ(v string) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.NEQ(s.C(FieldQuantityType), v))
	})
}

// QuantityTypeIn applies the In predicate on the "quantity_type" field.
func QuantityTypeIn(vs ...string) predicate.ShoppingItem {
	v := make([]interface{}, len(vs))
	for i := range v {
		v[i] = vs[i]
	}
	return predicate.ShoppingItem(func(s *sql.Selector) {
		// if not arguments were provided, append the FALSE constants,
		// since we can't apply "IN ()". This will make this predicate falsy.
		if len(v) == 0 {
			s.Where(sql.False())
			return
		}
		s.Where(sql.In(s.C(FieldQuantityType), v...))
	})
}

// QuantityTypeNotIn applies the NotIn predicate on the "quantity_type" field.
func QuantityTypeNotIn(vs ...string) predicate.ShoppingItem {
	v := make([]interface{}, len(vs))
	for i := range v {
		v[i] = vs[i]
	}
	return predicate.ShoppingItem(func(s *sql.Selector) {
		// if not arguments were provided, append the FALSE constants,
		// since we can't apply "IN ()". This will make this predicate falsy.
		if len(v) == 0 {
			s.Where(sql.False())
			return
		}
		s.Where(sql.NotIn(s.C(FieldQuantityType), v...))
	})
}

// QuantityTypeGT applies the GT predicate on the "quantity_type" field.
func QuantityTypeGT(v string) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.GT(s.C(FieldQuantityType), v))
	})
}

// QuantityTypeGTE applies the GTE predicate on the "quantity_type" field.
func QuantityTypeGTE(v string) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.GTE(s.C(FieldQuantityType), v))
	})
}

// QuantityTypeLT applies the LT predicate on the "quantity_type" field.
func QuantityTypeLT(v string) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.LT(s.C(FieldQuantityType), v))
	})
}

// QuantityTypeLTE applies the LTE predicate on the "quantity_type" field.
func QuantityTypeLTE(v string) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.LTE(s.C(FieldQuantityType), v))
	})
}

// QuantityTypeContains applies the Contains predicate on the "quantity_type" field.
func QuantityTypeContains(v string) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.Contains(s.C(FieldQuantityType), v))
	})
}

// QuantityTypeHasPrefix applies the HasPrefix predicate on the "quantity_type" field.
func QuantityTypeHasPrefix(v string) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.HasPrefix(s.C(FieldQuantityType), v))
	})
}

// QuantityTypeHasSuffix applies the HasSuffix predicate on the "quantity_type" field.
func QuantityTypeHasSuffix(v string) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.HasSuffix(s.C(FieldQuantityType), v))
	})
}

// QuantityTypeIsNil applies the IsNil predicate on the "quantity_type" field.
func QuantityTypeIsNil() predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.IsNull(s.C(FieldQuantityType)))
	})
}

// QuantityTypeNotNil applies the NotNil predicate on the "quantity_type" field.
func QuantityTypeNotNil() predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.NotNull(s.C(FieldQuantityType)))
	})
}

// QuantityTypeEqualFold applies the EqualFold predicate on the "quantity_type" field.
func QuantityTypeEqualFold(v string) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.EqualFold(s.C(FieldQuantityType), v))
	})
}

// QuantityTypeContainsFold applies the ContainsFold predicate on the "quantity_type" field.
func QuantityTypeContainsFold(v string) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.ContainsFold(s.C(FieldQuantityType), v))
	})
}

// UnitsEQ applies the EQ predicate on the "units" field.
func UnitsEQ(v int) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.EQ(s.C(FieldUnits), v))
	})
}

// UnitsNEQ applies the NEQ predicate on the "units" field.
func UnitsNEQ(v int) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.NEQ(s.C(FieldUnits), v))
	})
}

// UnitsIn applies the In predicate on the "units" field.
func UnitsIn(vs ...int) predicate.ShoppingItem {
	v := make([]interface{}, len(vs))
	for i := range v {
		v[i] = vs[i]
	}
	return predicate.ShoppingItem(func(s *sql.Selector) {
		// if not arguments were provided, append the FALSE constants,
		// since we can't apply "IN ()". This will make this predicate falsy.
		if len(v) == 0 {
			s.Where(sql.False())
			return
		}
		s.Where(sql.In(s.C(FieldUnits), v...))
	})
}

// UnitsNotIn applies the NotIn predicate on the "units" field.
func UnitsNotIn(vs ...int) predicate.ShoppingItem {
	v := make([]interface{}, len(vs))
	for i := range v {
		v[i] = vs[i]
	}
	return predicate.ShoppingItem(func(s *sql.Selector) {
		// if not arguments were provided, append the FALSE constants,
		// since we can't apply "IN ()". This will make this predicate falsy.
		if len(v) == 0 {
			s.Where(sql.False())
			return
		}
		s.Where(sql.NotIn(s.C(FieldUnits), v...))
	})
}

// UnitsGT applies the GT predicate on the "units" field.
func UnitsGT(v int) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.GT(s.C(FieldUnits), v))
	})
}

// UnitsGTE applies the GTE predicate on the "units" field.
func UnitsGTE(v int) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.GTE(s.C(FieldUnits), v))
	})
}

// UnitsLT applies the LT predicate on the "units" field.
func UnitsLT(v int) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.LT(s.C(FieldUnits), v))
	})
}

// UnitsLTE applies the LTE predicate on the "units" field.
func UnitsLTE(v int) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.LTE(s.C(FieldUnits), v))
	})
}

// BrandEQ applies the EQ predicate on the "brand" field.
func BrandEQ(v string) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.EQ(s.C(FieldBrand), v))
	})
}

// BrandNEQ applies the NEQ predicate on the "brand" field.
func BrandNEQ(v string) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.NEQ(s.C(FieldBrand), v))
	})
}

// BrandIn applies the In predicate on the "brand" field.
func BrandIn(vs ...string) predicate.ShoppingItem {
	v := make([]interface{}, len(vs))
	for i := range v {
		v[i] = vs[i]
	}
	return predicate.ShoppingItem(func(s *sql.Selector) {
		// if not arguments were provided, append the FALSE constants,
		// since we can't apply "IN ()". This will make this predicate falsy.
		if len(v) == 0 {
			s.Where(sql.False())
			return
		}
		s.Where(sql.In(s.C(FieldBrand), v...))
	})
}

// BrandNotIn applies the NotIn predicate on the "brand" field.
func BrandNotIn(vs ...string) predicate.ShoppingItem {
	v := make([]interface{}, len(vs))
	for i := range v {
		v[i] = vs[i]
	}
	return predicate.ShoppingItem(func(s *sql.Selector) {
		// if not arguments were provided, append the FALSE constants,
		// since we can't apply "IN ()". This will make this predicate falsy.
		if len(v) == 0 {
			s.Where(sql.False())
			return
		}
		s.Where(sql.NotIn(s.C(FieldBrand), v...))
	})
}

// BrandGT applies the GT predicate on the "brand" field.
func BrandGT(v string) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.GT(s.C(FieldBrand), v))
	})
}

// BrandGTE applies the GTE predicate on the "brand" field.
func BrandGTE(v string) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.GTE(s.C(FieldBrand), v))
	})
}

// BrandLT applies the LT predicate on the "brand" field.
func BrandLT(v string) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.LT(s.C(FieldBrand), v))
	})
}

// BrandLTE applies the LTE predicate on the "brand" field.
func BrandLTE(v string) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.LTE(s.C(FieldBrand), v))
	})
}

// BrandContains applies the Contains predicate on the "brand" field.
func BrandContains(v string) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.Contains(s.C(FieldBrand), v))
	})
}

// BrandHasPrefix applies the HasPrefix predicate on the "brand" field.
func BrandHasPrefix(v string) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.HasPrefix(s.C(FieldBrand), v))
	})
}

// BrandHasSuffix applies the HasSuffix predicate on the "brand" field.
func BrandHasSuffix(v string) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.HasSuffix(s.C(FieldBrand), v))
	})
}

// BrandIsNil applies the IsNil predicate on the "brand" field.
func BrandIsNil() predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.IsNull(s.C(FieldBrand)))
	})
}

// BrandNotNil applies the NotNil predicate on the "brand" field.
func BrandNotNil() predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.NotNull(s.C(FieldBrand)))
	})
}

// BrandEqualFold applies the EqualFold predicate on the "brand" field.
func BrandEqualFold(v string) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.EqualFold(s.C(FieldBrand), v))
	})
}

// BrandContainsFold applies the ContainsFold predicate on the "brand" field.
func BrandContainsFold(v string) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.ContainsFold(s.C(FieldBrand), v))
	})
}

// PricePerUnitEQ applies the EQ predicate on the "price_per_unit" field.
func PricePerUnitEQ(v decimal.Decimal) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.EQ(s.C(FieldPricePerUnit), v))
	})
}

// PricePerUnitNEQ applies the NEQ predicate on the "price_per_unit" field.
func PricePerUnitNEQ(v decimal.Decimal) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.NEQ(s.C(FieldPricePerUnit), v))
	})
}

// PricePerUnitIn applies the In predicate on the "price_per_unit" field.
func PricePerUnitIn(vs ...decimal.Decimal) predicate.ShoppingItem {
	v := make([]interface{}, len(vs))
	for i := range v {
		v[i] = vs[i]
	}
	return predicate.ShoppingItem(func(s *sql.Selector) {
		// if not arguments were provided, append the FALSE constants,
		// since we can't apply "IN ()". This will make this predicate falsy.
		if len(v) == 0 {
			s.Where(sql.False())
			return
		}
		s.Where(sql.In(s.C(FieldPricePerUnit), v...))
	})
}

// PricePerUnitNotIn applies the NotIn predicate on the "price_per_unit" field.
func PricePerUnitNotIn(vs ...decimal.Decimal) predicate.ShoppingItem {
	v := make([]interface{}, len(vs))
	for i := range v {
		v[i] = vs[i]
	}
	return predicate.ShoppingItem(func(s *sql.Selector) {
		// if not arguments were provided, append the FALSE constants,
		// since we can't apply "IN ()". This will make this predicate falsy.
		if len(v) == 0 {
			s.Where(sql.False())
			return
		}
		s.Where(sql.NotIn(s.C(FieldPricePerUnit), v...))
	})
}

// PricePerUnitGT applies the GT predicate on the "price_per_unit" field.
func PricePerUnitGT(v decimal.Decimal) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.GT(s.C(FieldPricePerUnit), v))
	})
}

// PricePerUnitGTE applies the GTE predicate on the "price_per_unit" field.
func PricePerUnitGTE(v decimal.Decimal) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.GTE(s.C(FieldPricePerUnit), v))
	})
}

// PricePerUnitLT applies the LT predicate on the "price_per_unit" field.
func PricePerUnitLT(v decimal.Decimal) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.LT(s.C(FieldPricePerUnit), v))
	})
}

// PricePerUnitLTE applies the LTE predicate on the "price_per_unit" field.
func PricePerUnitLTE(v decimal.Decimal) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s.Where(sql.LTE(s.C(FieldPricePerUnit), v))
	})
}

// HasItem applies the HasEdge predicate on the "item" edge.
func HasItem() predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		step := sqlgraph.NewStep(
			sqlgraph.From(Table, FieldID),
			sqlgraph.To(ItemTable, FieldID),
			sqlgraph.Edge(sqlgraph.M2O, true, ItemTable, ItemColumn),
		)
		sqlgraph.HasNeighbors(s, step)
	})
}

// HasItemWith applies the HasEdge predicate on the "item" edge with a given conditions (other predicates).
func HasItemWith(preds ...predicate.Item) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		step := sqlgraph.NewStep(
			sqlgraph.From(Table, FieldID),
			sqlgraph.To(ItemInverseTable, FieldID),
			sqlgraph.Edge(sqlgraph.M2O, true, ItemTable, ItemColumn),
		)
		sqlgraph.HasNeighborsWith(s, step, func(s *sql.Selector) {
			for _, p := range preds {
				p(s)
			}
		})
	})
}

// HasShopping applies the HasEdge predicate on the "shopping" edge.
func HasShopping() predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		step := sqlgraph.NewStep(
			sqlgraph.From(Table, FieldID),
			sqlgraph.To(ShoppingTable, FieldID),
			sqlgraph.Edge(sqlgraph.M2O, true, ShoppingTable, ShoppingColumn),
		)
		sqlgraph.HasNeighbors(s, step)
	})
}

// HasShoppingWith applies the HasEdge predicate on the "shopping" edge with a given conditions (other predicates).
func HasShoppingWith(preds ...predicate.Shopping) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		step := sqlgraph.NewStep(
			sqlgraph.From(Table, FieldID),
			sqlgraph.To(ShoppingInverseTable, FieldID),
			sqlgraph.Edge(sqlgraph.M2O, true, ShoppingTable, ShoppingColumn),
		)
		sqlgraph.HasNeighborsWith(s, step, func(s *sql.Selector) {
			for _, p := range preds {
				p(s)
			}
		})
	})
}

// HasShoppingList applies the HasEdge predicate on the "shoppingList" edge.
func HasShoppingList() predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		step := sqlgraph.NewStep(
			sqlgraph.From(Table, FieldID),
			sqlgraph.To(ShoppingListTable, FieldID),
			sqlgraph.Edge(sqlgraph.O2M, false, ShoppingListTable, ShoppingListColumn),
		)
		sqlgraph.HasNeighbors(s, step)
	})
}

// HasShoppingListWith applies the HasEdge predicate on the "shoppingList" edge with a given conditions (other predicates).
func HasShoppingListWith(preds ...predicate.ShoppingListItem) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		step := sqlgraph.NewStep(
			sqlgraph.From(Table, FieldID),
			sqlgraph.To(ShoppingListInverseTable, FieldID),
			sqlgraph.Edge(sqlgraph.O2M, false, ShoppingListTable, ShoppingListColumn),
		)
		sqlgraph.HasNeighborsWith(s, step, func(s *sql.Selector) {
			for _, p := range preds {
				p(s)
			}
		})
	})
}

// And groups predicates with the AND operator between them.
func And(predicates ...predicate.ShoppingItem) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s1 := s.Clone().SetP(nil)
		for _, p := range predicates {
			p(s1)
		}
		s.Where(s1.P())
	})
}

// Or groups predicates with the OR operator between them.
func Or(predicates ...predicate.ShoppingItem) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		s1 := s.Clone().SetP(nil)
		for i, p := range predicates {
			if i > 0 {
				s1.Or()
			}
			p(s1)
		}
		s.Where(s1.P())
	})
}

// Not applies the not operator on the given predicate.
func Not(p predicate.ShoppingItem) predicate.ShoppingItem {
	return predicate.ShoppingItem(func(s *sql.Selector) {
		p(s.Not())
	})
}
