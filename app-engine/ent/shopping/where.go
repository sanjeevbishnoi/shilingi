// Code generated by entc, DO NOT EDIT.

package shopping

import (
	"time"

	"entgo.io/ent/dialect/sql"
	"entgo.io/ent/dialect/sql/sqlgraph"
	"github.com/kingzbauer/shilingi/app-engine/ent/predicate"
)

// ID filters vertices based on their ID field.
func ID(id int) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s.Where(sql.EQ(s.C(FieldID), id))
	})
}

// IDEQ applies the EQ predicate on the ID field.
func IDEQ(id int) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s.Where(sql.EQ(s.C(FieldID), id))
	})
}

// IDNEQ applies the NEQ predicate on the ID field.
func IDNEQ(id int) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s.Where(sql.NEQ(s.C(FieldID), id))
	})
}

// IDIn applies the In predicate on the ID field.
func IDIn(ids ...int) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
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
func IDNotIn(ids ...int) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
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
func IDGT(id int) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s.Where(sql.GT(s.C(FieldID), id))
	})
}

// IDGTE applies the GTE predicate on the ID field.
func IDGTE(id int) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s.Where(sql.GTE(s.C(FieldID), id))
	})
}

// IDLT applies the LT predicate on the ID field.
func IDLT(id int) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s.Where(sql.LT(s.C(FieldID), id))
	})
}

// IDLTE applies the LTE predicate on the ID field.
func IDLTE(id int) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s.Where(sql.LTE(s.C(FieldID), id))
	})
}

// CreateTime applies equality check predicate on the "create_time" field. It's identical to CreateTimeEQ.
func CreateTime(v time.Time) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s.Where(sql.EQ(s.C(FieldCreateTime), v))
	})
}

// UpdateTime applies equality check predicate on the "update_time" field. It's identical to UpdateTimeEQ.
func UpdateTime(v time.Time) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s.Where(sql.EQ(s.C(FieldUpdateTime), v))
	})
}

// Date applies equality check predicate on the "date" field. It's identical to DateEQ.
func Date(v time.Time) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s.Where(sql.EQ(s.C(FieldDate), v))
	})
}

// Market applies equality check predicate on the "market" field. It's identical to MarketEQ.
func Market(v string) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s.Where(sql.EQ(s.C(FieldMarket), v))
	})
}

// CreateTimeEQ applies the EQ predicate on the "create_time" field.
func CreateTimeEQ(v time.Time) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s.Where(sql.EQ(s.C(FieldCreateTime), v))
	})
}

// CreateTimeNEQ applies the NEQ predicate on the "create_time" field.
func CreateTimeNEQ(v time.Time) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s.Where(sql.NEQ(s.C(FieldCreateTime), v))
	})
}

// CreateTimeIn applies the In predicate on the "create_time" field.
func CreateTimeIn(vs ...time.Time) predicate.Shopping {
	v := make([]interface{}, len(vs))
	for i := range v {
		v[i] = vs[i]
	}
	return predicate.Shopping(func(s *sql.Selector) {
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
func CreateTimeNotIn(vs ...time.Time) predicate.Shopping {
	v := make([]interface{}, len(vs))
	for i := range v {
		v[i] = vs[i]
	}
	return predicate.Shopping(func(s *sql.Selector) {
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
func CreateTimeGT(v time.Time) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s.Where(sql.GT(s.C(FieldCreateTime), v))
	})
}

// CreateTimeGTE applies the GTE predicate on the "create_time" field.
func CreateTimeGTE(v time.Time) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s.Where(sql.GTE(s.C(FieldCreateTime), v))
	})
}

// CreateTimeLT applies the LT predicate on the "create_time" field.
func CreateTimeLT(v time.Time) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s.Where(sql.LT(s.C(FieldCreateTime), v))
	})
}

// CreateTimeLTE applies the LTE predicate on the "create_time" field.
func CreateTimeLTE(v time.Time) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s.Where(sql.LTE(s.C(FieldCreateTime), v))
	})
}

// UpdateTimeEQ applies the EQ predicate on the "update_time" field.
func UpdateTimeEQ(v time.Time) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s.Where(sql.EQ(s.C(FieldUpdateTime), v))
	})
}

// UpdateTimeNEQ applies the NEQ predicate on the "update_time" field.
func UpdateTimeNEQ(v time.Time) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s.Where(sql.NEQ(s.C(FieldUpdateTime), v))
	})
}

// UpdateTimeIn applies the In predicate on the "update_time" field.
func UpdateTimeIn(vs ...time.Time) predicate.Shopping {
	v := make([]interface{}, len(vs))
	for i := range v {
		v[i] = vs[i]
	}
	return predicate.Shopping(func(s *sql.Selector) {
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
func UpdateTimeNotIn(vs ...time.Time) predicate.Shopping {
	v := make([]interface{}, len(vs))
	for i := range v {
		v[i] = vs[i]
	}
	return predicate.Shopping(func(s *sql.Selector) {
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
func UpdateTimeGT(v time.Time) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s.Where(sql.GT(s.C(FieldUpdateTime), v))
	})
}

// UpdateTimeGTE applies the GTE predicate on the "update_time" field.
func UpdateTimeGTE(v time.Time) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s.Where(sql.GTE(s.C(FieldUpdateTime), v))
	})
}

// UpdateTimeLT applies the LT predicate on the "update_time" field.
func UpdateTimeLT(v time.Time) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s.Where(sql.LT(s.C(FieldUpdateTime), v))
	})
}

// UpdateTimeLTE applies the LTE predicate on the "update_time" field.
func UpdateTimeLTE(v time.Time) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s.Where(sql.LTE(s.C(FieldUpdateTime), v))
	})
}

// DateEQ applies the EQ predicate on the "date" field.
func DateEQ(v time.Time) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s.Where(sql.EQ(s.C(FieldDate), v))
	})
}

// DateNEQ applies the NEQ predicate on the "date" field.
func DateNEQ(v time.Time) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s.Where(sql.NEQ(s.C(FieldDate), v))
	})
}

// DateIn applies the In predicate on the "date" field.
func DateIn(vs ...time.Time) predicate.Shopping {
	v := make([]interface{}, len(vs))
	for i := range v {
		v[i] = vs[i]
	}
	return predicate.Shopping(func(s *sql.Selector) {
		// if not arguments were provided, append the FALSE constants,
		// since we can't apply "IN ()". This will make this predicate falsy.
		if len(v) == 0 {
			s.Where(sql.False())
			return
		}
		s.Where(sql.In(s.C(FieldDate), v...))
	})
}

// DateNotIn applies the NotIn predicate on the "date" field.
func DateNotIn(vs ...time.Time) predicate.Shopping {
	v := make([]interface{}, len(vs))
	for i := range v {
		v[i] = vs[i]
	}
	return predicate.Shopping(func(s *sql.Selector) {
		// if not arguments were provided, append the FALSE constants,
		// since we can't apply "IN ()". This will make this predicate falsy.
		if len(v) == 0 {
			s.Where(sql.False())
			return
		}
		s.Where(sql.NotIn(s.C(FieldDate), v...))
	})
}

// DateGT applies the GT predicate on the "date" field.
func DateGT(v time.Time) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s.Where(sql.GT(s.C(FieldDate), v))
	})
}

// DateGTE applies the GTE predicate on the "date" field.
func DateGTE(v time.Time) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s.Where(sql.GTE(s.C(FieldDate), v))
	})
}

// DateLT applies the LT predicate on the "date" field.
func DateLT(v time.Time) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s.Where(sql.LT(s.C(FieldDate), v))
	})
}

// DateLTE applies the LTE predicate on the "date" field.
func DateLTE(v time.Time) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s.Where(sql.LTE(s.C(FieldDate), v))
	})
}

// MarketEQ applies the EQ predicate on the "market" field.
func MarketEQ(v string) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s.Where(sql.EQ(s.C(FieldMarket), v))
	})
}

// MarketNEQ applies the NEQ predicate on the "market" field.
func MarketNEQ(v string) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s.Where(sql.NEQ(s.C(FieldMarket), v))
	})
}

// MarketIn applies the In predicate on the "market" field.
func MarketIn(vs ...string) predicate.Shopping {
	v := make([]interface{}, len(vs))
	for i := range v {
		v[i] = vs[i]
	}
	return predicate.Shopping(func(s *sql.Selector) {
		// if not arguments were provided, append the FALSE constants,
		// since we can't apply "IN ()". This will make this predicate falsy.
		if len(v) == 0 {
			s.Where(sql.False())
			return
		}
		s.Where(sql.In(s.C(FieldMarket), v...))
	})
}

// MarketNotIn applies the NotIn predicate on the "market" field.
func MarketNotIn(vs ...string) predicate.Shopping {
	v := make([]interface{}, len(vs))
	for i := range v {
		v[i] = vs[i]
	}
	return predicate.Shopping(func(s *sql.Selector) {
		// if not arguments were provided, append the FALSE constants,
		// since we can't apply "IN ()". This will make this predicate falsy.
		if len(v) == 0 {
			s.Where(sql.False())
			return
		}
		s.Where(sql.NotIn(s.C(FieldMarket), v...))
	})
}

// MarketGT applies the GT predicate on the "market" field.
func MarketGT(v string) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s.Where(sql.GT(s.C(FieldMarket), v))
	})
}

// MarketGTE applies the GTE predicate on the "market" field.
func MarketGTE(v string) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s.Where(sql.GTE(s.C(FieldMarket), v))
	})
}

// MarketLT applies the LT predicate on the "market" field.
func MarketLT(v string) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s.Where(sql.LT(s.C(FieldMarket), v))
	})
}

// MarketLTE applies the LTE predicate on the "market" field.
func MarketLTE(v string) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s.Where(sql.LTE(s.C(FieldMarket), v))
	})
}

// MarketContains applies the Contains predicate on the "market" field.
func MarketContains(v string) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s.Where(sql.Contains(s.C(FieldMarket), v))
	})
}

// MarketHasPrefix applies the HasPrefix predicate on the "market" field.
func MarketHasPrefix(v string) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s.Where(sql.HasPrefix(s.C(FieldMarket), v))
	})
}

// MarketHasSuffix applies the HasSuffix predicate on the "market" field.
func MarketHasSuffix(v string) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s.Where(sql.HasSuffix(s.C(FieldMarket), v))
	})
}

// MarketEqualFold applies the EqualFold predicate on the "market" field.
func MarketEqualFold(v string) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s.Where(sql.EqualFold(s.C(FieldMarket), v))
	})
}

// MarketContainsFold applies the ContainsFold predicate on the "market" field.
func MarketContainsFold(v string) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s.Where(sql.ContainsFold(s.C(FieldMarket), v))
	})
}

// HasItems applies the HasEdge predicate on the "items" edge.
func HasItems() predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		step := sqlgraph.NewStep(
			sqlgraph.From(Table, FieldID),
			sqlgraph.To(ItemsTable, FieldID),
			sqlgraph.Edge(sqlgraph.O2M, false, ItemsTable, ItemsColumn),
		)
		sqlgraph.HasNeighbors(s, step)
	})
}

// HasItemsWith applies the HasEdge predicate on the "items" edge with a given conditions (other predicates).
func HasItemsWith(preds ...predicate.ShoppingItem) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		step := sqlgraph.NewStep(
			sqlgraph.From(Table, FieldID),
			sqlgraph.To(ItemsInverseTable, FieldID),
			sqlgraph.Edge(sqlgraph.O2M, false, ItemsTable, ItemsColumn),
		)
		sqlgraph.HasNeighborsWith(s, step, func(s *sql.Selector) {
			for _, p := range preds {
				p(s)
			}
		})
	})
}

// And groups predicates with the AND operator between them.
func And(predicates ...predicate.Shopping) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		s1 := s.Clone().SetP(nil)
		for _, p := range predicates {
			p(s1)
		}
		s.Where(s1.P())
	})
}

// Or groups predicates with the OR operator between them.
func Or(predicates ...predicate.Shopping) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
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
func Not(p predicate.Shopping) predicate.Shopping {
	return predicate.Shopping(func(s *sql.Selector) {
		p(s.Not())
	})
}
