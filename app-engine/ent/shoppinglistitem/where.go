// Code generated by entc, DO NOT EDIT.

package shoppinglistitem

import (
	"entgo.io/ent/dialect/sql"
	"entgo.io/ent/dialect/sql/sqlgraph"
	"github.com/kingzbauer/shilingi/app-engine/ent/predicate"
)

// ID filters vertices based on their ID field.
func ID(id int) predicate.ShoppingListItem {
	return predicate.ShoppingListItem(func(s *sql.Selector) {
		s.Where(sql.EQ(s.C(FieldID), id))
	})
}

// IDEQ applies the EQ predicate on the ID field.
func IDEQ(id int) predicate.ShoppingListItem {
	return predicate.ShoppingListItem(func(s *sql.Selector) {
		s.Where(sql.EQ(s.C(FieldID), id))
	})
}

// IDNEQ applies the NEQ predicate on the ID field.
func IDNEQ(id int) predicate.ShoppingListItem {
	return predicate.ShoppingListItem(func(s *sql.Selector) {
		s.Where(sql.NEQ(s.C(FieldID), id))
	})
}

// IDIn applies the In predicate on the ID field.
func IDIn(ids ...int) predicate.ShoppingListItem {
	return predicate.ShoppingListItem(func(s *sql.Selector) {
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
func IDNotIn(ids ...int) predicate.ShoppingListItem {
	return predicate.ShoppingListItem(func(s *sql.Selector) {
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
func IDGT(id int) predicate.ShoppingListItem {
	return predicate.ShoppingListItem(func(s *sql.Selector) {
		s.Where(sql.GT(s.C(FieldID), id))
	})
}

// IDGTE applies the GTE predicate on the ID field.
func IDGTE(id int) predicate.ShoppingListItem {
	return predicate.ShoppingListItem(func(s *sql.Selector) {
		s.Where(sql.GTE(s.C(FieldID), id))
	})
}

// IDLT applies the LT predicate on the ID field.
func IDLT(id int) predicate.ShoppingListItem {
	return predicate.ShoppingListItem(func(s *sql.Selector) {
		s.Where(sql.LT(s.C(FieldID), id))
	})
}

// IDLTE applies the LTE predicate on the ID field.
func IDLTE(id int) predicate.ShoppingListItem {
	return predicate.ShoppingListItem(func(s *sql.Selector) {
		s.Where(sql.LTE(s.C(FieldID), id))
	})
}

// HasShoppingList applies the HasEdge predicate on the "shoppingList" edge.
func HasShoppingList() predicate.ShoppingListItem {
	return predicate.ShoppingListItem(func(s *sql.Selector) {
		step := sqlgraph.NewStep(
			sqlgraph.From(Table, FieldID),
			sqlgraph.To(ShoppingListTable, FieldID),
			sqlgraph.Edge(sqlgraph.M2O, true, ShoppingListTable, ShoppingListColumn),
		)
		sqlgraph.HasNeighbors(s, step)
	})
}

// HasShoppingListWith applies the HasEdge predicate on the "shoppingList" edge with a given conditions (other predicates).
func HasShoppingListWith(preds ...predicate.ShoppingList) predicate.ShoppingListItem {
	return predicate.ShoppingListItem(func(s *sql.Selector) {
		step := sqlgraph.NewStep(
			sqlgraph.From(Table, FieldID),
			sqlgraph.To(ShoppingListInverseTable, FieldID),
			sqlgraph.Edge(sqlgraph.M2O, true, ShoppingListTable, ShoppingListColumn),
		)
		sqlgraph.HasNeighborsWith(s, step, func(s *sql.Selector) {
			for _, p := range preds {
				p(s)
			}
		})
	})
}

// HasItem applies the HasEdge predicate on the "item" edge.
func HasItem() predicate.ShoppingListItem {
	return predicate.ShoppingListItem(func(s *sql.Selector) {
		step := sqlgraph.NewStep(
			sqlgraph.From(Table, FieldID),
			sqlgraph.To(ItemTable, FieldID),
			sqlgraph.Edge(sqlgraph.M2O, true, ItemTable, ItemColumn),
		)
		sqlgraph.HasNeighbors(s, step)
	})
}

// HasItemWith applies the HasEdge predicate on the "item" edge with a given conditions (other predicates).
func HasItemWith(preds ...predicate.Item) predicate.ShoppingListItem {
	return predicate.ShoppingListItem(func(s *sql.Selector) {
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

// HasPurchase applies the HasEdge predicate on the "purchase" edge.
func HasPurchase() predicate.ShoppingListItem {
	return predicate.ShoppingListItem(func(s *sql.Selector) {
		step := sqlgraph.NewStep(
			sqlgraph.From(Table, FieldID),
			sqlgraph.To(PurchaseTable, FieldID),
			sqlgraph.Edge(sqlgraph.M2O, true, PurchaseTable, PurchaseColumn),
		)
		sqlgraph.HasNeighbors(s, step)
	})
}

// HasPurchaseWith applies the HasEdge predicate on the "purchase" edge with a given conditions (other predicates).
func HasPurchaseWith(preds ...predicate.ShoppingItem) predicate.ShoppingListItem {
	return predicate.ShoppingListItem(func(s *sql.Selector) {
		step := sqlgraph.NewStep(
			sqlgraph.From(Table, FieldID),
			sqlgraph.To(PurchaseInverseTable, FieldID),
			sqlgraph.Edge(sqlgraph.M2O, true, PurchaseTable, PurchaseColumn),
		)
		sqlgraph.HasNeighborsWith(s, step, func(s *sql.Selector) {
			for _, p := range preds {
				p(s)
			}
		})
	})
}

// And groups predicates with the AND operator between them.
func And(predicates ...predicate.ShoppingListItem) predicate.ShoppingListItem {
	return predicate.ShoppingListItem(func(s *sql.Selector) {
		s1 := s.Clone().SetP(nil)
		for _, p := range predicates {
			p(s1)
		}
		s.Where(s1.P())
	})
}

// Or groups predicates with the OR operator between them.
func Or(predicates ...predicate.ShoppingListItem) predicate.ShoppingListItem {
	return predicate.ShoppingListItem(func(s *sql.Selector) {
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
func Not(p predicate.ShoppingListItem) predicate.ShoppingListItem {
	return predicate.ShoppingListItem(func(s *sql.Selector) {
		p(s.Not())
	})
}