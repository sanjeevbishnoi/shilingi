// Code generated by entc, DO NOT EDIT.

package ent

import (
	"context"
	"errors"
	"fmt"

	"entgo.io/ent/dialect/sql"
	"entgo.io/ent/dialect/sql/sqlgraph"
	"entgo.io/ent/schema/field"
	"github.com/kingzbauer/shilingi/app-engine/ent/item"
	"github.com/kingzbauer/shilingi/app-engine/ent/predicate"
	"github.com/kingzbauer/shilingi/app-engine/ent/shoppingitem"
	"github.com/kingzbauer/shilingi/app-engine/ent/shoppinglist"
	"github.com/kingzbauer/shilingi/app-engine/ent/shoppinglistitem"
)

// ShoppingListItemUpdate is the builder for updating ShoppingListItem entities.
type ShoppingListItemUpdate struct {
	config
	hooks    []Hook
	mutation *ShoppingListItemMutation
}

// Where appends a list predicates to the ShoppingListItemUpdate builder.
func (sliu *ShoppingListItemUpdate) Where(ps ...predicate.ShoppingListItem) *ShoppingListItemUpdate {
	sliu.mutation.Where(ps...)
	return sliu
}

// SetShoppingListID sets the "shoppingList" edge to the ShoppingList entity by ID.
func (sliu *ShoppingListItemUpdate) SetShoppingListID(id int) *ShoppingListItemUpdate {
	sliu.mutation.SetShoppingListID(id)
	return sliu
}

// SetShoppingList sets the "shoppingList" edge to the ShoppingList entity.
func (sliu *ShoppingListItemUpdate) SetShoppingList(s *ShoppingList) *ShoppingListItemUpdate {
	return sliu.SetShoppingListID(s.ID)
}

// SetItemID sets the "item" edge to the Item entity by ID.
func (sliu *ShoppingListItemUpdate) SetItemID(id int) *ShoppingListItemUpdate {
	sliu.mutation.SetItemID(id)
	return sliu
}

// SetItem sets the "item" edge to the Item entity.
func (sliu *ShoppingListItemUpdate) SetItem(i *Item) *ShoppingListItemUpdate {
	return sliu.SetItemID(i.ID)
}

// SetPurchaseID sets the "purchase" edge to the ShoppingItem entity by ID.
func (sliu *ShoppingListItemUpdate) SetPurchaseID(id int) *ShoppingListItemUpdate {
	sliu.mutation.SetPurchaseID(id)
	return sliu
}

// SetNillablePurchaseID sets the "purchase" edge to the ShoppingItem entity by ID if the given value is not nil.
func (sliu *ShoppingListItemUpdate) SetNillablePurchaseID(id *int) *ShoppingListItemUpdate {
	if id != nil {
		sliu = sliu.SetPurchaseID(*id)
	}
	return sliu
}

// SetPurchase sets the "purchase" edge to the ShoppingItem entity.
func (sliu *ShoppingListItemUpdate) SetPurchase(s *ShoppingItem) *ShoppingListItemUpdate {
	return sliu.SetPurchaseID(s.ID)
}

// Mutation returns the ShoppingListItemMutation object of the builder.
func (sliu *ShoppingListItemUpdate) Mutation() *ShoppingListItemMutation {
	return sliu.mutation
}

// ClearShoppingList clears the "shoppingList" edge to the ShoppingList entity.
func (sliu *ShoppingListItemUpdate) ClearShoppingList() *ShoppingListItemUpdate {
	sliu.mutation.ClearShoppingList()
	return sliu
}

// ClearItem clears the "item" edge to the Item entity.
func (sliu *ShoppingListItemUpdate) ClearItem() *ShoppingListItemUpdate {
	sliu.mutation.ClearItem()
	return sliu
}

// ClearPurchase clears the "purchase" edge to the ShoppingItem entity.
func (sliu *ShoppingListItemUpdate) ClearPurchase() *ShoppingListItemUpdate {
	sliu.mutation.ClearPurchase()
	return sliu
}

// Save executes the query and returns the number of nodes affected by the update operation.
func (sliu *ShoppingListItemUpdate) Save(ctx context.Context) (int, error) {
	var (
		err      error
		affected int
	)
	if len(sliu.hooks) == 0 {
		if err = sliu.check(); err != nil {
			return 0, err
		}
		affected, err = sliu.sqlSave(ctx)
	} else {
		var mut Mutator = MutateFunc(func(ctx context.Context, m Mutation) (Value, error) {
			mutation, ok := m.(*ShoppingListItemMutation)
			if !ok {
				return nil, fmt.Errorf("unexpected mutation type %T", m)
			}
			if err = sliu.check(); err != nil {
				return 0, err
			}
			sliu.mutation = mutation
			affected, err = sliu.sqlSave(ctx)
			mutation.done = true
			return affected, err
		})
		for i := len(sliu.hooks) - 1; i >= 0; i-- {
			if sliu.hooks[i] == nil {
				return 0, fmt.Errorf("ent: uninitialized hook (forgotten import ent/runtime?)")
			}
			mut = sliu.hooks[i](mut)
		}
		if _, err := mut.Mutate(ctx, sliu.mutation); err != nil {
			return 0, err
		}
	}
	return affected, err
}

// SaveX is like Save, but panics if an error occurs.
func (sliu *ShoppingListItemUpdate) SaveX(ctx context.Context) int {
	affected, err := sliu.Save(ctx)
	if err != nil {
		panic(err)
	}
	return affected
}

// Exec executes the query.
func (sliu *ShoppingListItemUpdate) Exec(ctx context.Context) error {
	_, err := sliu.Save(ctx)
	return err
}

// ExecX is like Exec, but panics if an error occurs.
func (sliu *ShoppingListItemUpdate) ExecX(ctx context.Context) {
	if err := sliu.Exec(ctx); err != nil {
		panic(err)
	}
}

// check runs all checks and user-defined validators on the builder.
func (sliu *ShoppingListItemUpdate) check() error {
	if _, ok := sliu.mutation.ShoppingListID(); sliu.mutation.ShoppingListCleared() && !ok {
		return errors.New("ent: clearing a required unique edge \"shoppingList\"")
	}
	if _, ok := sliu.mutation.ItemID(); sliu.mutation.ItemCleared() && !ok {
		return errors.New("ent: clearing a required unique edge \"item\"")
	}
	return nil
}

func (sliu *ShoppingListItemUpdate) sqlSave(ctx context.Context) (n int, err error) {
	_spec := &sqlgraph.UpdateSpec{
		Node: &sqlgraph.NodeSpec{
			Table:   shoppinglistitem.Table,
			Columns: shoppinglistitem.Columns,
			ID: &sqlgraph.FieldSpec{
				Type:   field.TypeInt,
				Column: shoppinglistitem.FieldID,
			},
		},
	}
	if ps := sliu.mutation.predicates; len(ps) > 0 {
		_spec.Predicate = func(selector *sql.Selector) {
			for i := range ps {
				ps[i](selector)
			}
		}
	}
	if sliu.mutation.ShoppingListCleared() {
		edge := &sqlgraph.EdgeSpec{
			Rel:     sqlgraph.M2O,
			Inverse: true,
			Table:   shoppinglistitem.ShoppingListTable,
			Columns: []string{shoppinglistitem.ShoppingListColumn},
			Bidi:    false,
			Target: &sqlgraph.EdgeTarget{
				IDSpec: &sqlgraph.FieldSpec{
					Type:   field.TypeInt,
					Column: shoppinglist.FieldID,
				},
			},
		}
		_spec.Edges.Clear = append(_spec.Edges.Clear, edge)
	}
	if nodes := sliu.mutation.ShoppingListIDs(); len(nodes) > 0 {
		edge := &sqlgraph.EdgeSpec{
			Rel:     sqlgraph.M2O,
			Inverse: true,
			Table:   shoppinglistitem.ShoppingListTable,
			Columns: []string{shoppinglistitem.ShoppingListColumn},
			Bidi:    false,
			Target: &sqlgraph.EdgeTarget{
				IDSpec: &sqlgraph.FieldSpec{
					Type:   field.TypeInt,
					Column: shoppinglist.FieldID,
				},
			},
		}
		for _, k := range nodes {
			edge.Target.Nodes = append(edge.Target.Nodes, k)
		}
		_spec.Edges.Add = append(_spec.Edges.Add, edge)
	}
	if sliu.mutation.ItemCleared() {
		edge := &sqlgraph.EdgeSpec{
			Rel:     sqlgraph.M2O,
			Inverse: true,
			Table:   shoppinglistitem.ItemTable,
			Columns: []string{shoppinglistitem.ItemColumn},
			Bidi:    false,
			Target: &sqlgraph.EdgeTarget{
				IDSpec: &sqlgraph.FieldSpec{
					Type:   field.TypeInt,
					Column: item.FieldID,
				},
			},
		}
		_spec.Edges.Clear = append(_spec.Edges.Clear, edge)
	}
	if nodes := sliu.mutation.ItemIDs(); len(nodes) > 0 {
		edge := &sqlgraph.EdgeSpec{
			Rel:     sqlgraph.M2O,
			Inverse: true,
			Table:   shoppinglistitem.ItemTable,
			Columns: []string{shoppinglistitem.ItemColumn},
			Bidi:    false,
			Target: &sqlgraph.EdgeTarget{
				IDSpec: &sqlgraph.FieldSpec{
					Type:   field.TypeInt,
					Column: item.FieldID,
				},
			},
		}
		for _, k := range nodes {
			edge.Target.Nodes = append(edge.Target.Nodes, k)
		}
		_spec.Edges.Add = append(_spec.Edges.Add, edge)
	}
	if sliu.mutation.PurchaseCleared() {
		edge := &sqlgraph.EdgeSpec{
			Rel:     sqlgraph.M2O,
			Inverse: true,
			Table:   shoppinglistitem.PurchaseTable,
			Columns: []string{shoppinglistitem.PurchaseColumn},
			Bidi:    false,
			Target: &sqlgraph.EdgeTarget{
				IDSpec: &sqlgraph.FieldSpec{
					Type:   field.TypeInt,
					Column: shoppingitem.FieldID,
				},
			},
		}
		_spec.Edges.Clear = append(_spec.Edges.Clear, edge)
	}
	if nodes := sliu.mutation.PurchaseIDs(); len(nodes) > 0 {
		edge := &sqlgraph.EdgeSpec{
			Rel:     sqlgraph.M2O,
			Inverse: true,
			Table:   shoppinglistitem.PurchaseTable,
			Columns: []string{shoppinglistitem.PurchaseColumn},
			Bidi:    false,
			Target: &sqlgraph.EdgeTarget{
				IDSpec: &sqlgraph.FieldSpec{
					Type:   field.TypeInt,
					Column: shoppingitem.FieldID,
				},
			},
		}
		for _, k := range nodes {
			edge.Target.Nodes = append(edge.Target.Nodes, k)
		}
		_spec.Edges.Add = append(_spec.Edges.Add, edge)
	}
	if n, err = sqlgraph.UpdateNodes(ctx, sliu.driver, _spec); err != nil {
		if _, ok := err.(*sqlgraph.NotFoundError); ok {
			err = &NotFoundError{shoppinglistitem.Label}
		} else if sqlgraph.IsConstraintError(err) {
			err = &ConstraintError{err.Error(), err}
		}
		return 0, err
	}
	return n, nil
}

// ShoppingListItemUpdateOne is the builder for updating a single ShoppingListItem entity.
type ShoppingListItemUpdateOne struct {
	config
	fields   []string
	hooks    []Hook
	mutation *ShoppingListItemMutation
}

// SetShoppingListID sets the "shoppingList" edge to the ShoppingList entity by ID.
func (sliuo *ShoppingListItemUpdateOne) SetShoppingListID(id int) *ShoppingListItemUpdateOne {
	sliuo.mutation.SetShoppingListID(id)
	return sliuo
}

// SetShoppingList sets the "shoppingList" edge to the ShoppingList entity.
func (sliuo *ShoppingListItemUpdateOne) SetShoppingList(s *ShoppingList) *ShoppingListItemUpdateOne {
	return sliuo.SetShoppingListID(s.ID)
}

// SetItemID sets the "item" edge to the Item entity by ID.
func (sliuo *ShoppingListItemUpdateOne) SetItemID(id int) *ShoppingListItemUpdateOne {
	sliuo.mutation.SetItemID(id)
	return sliuo
}

// SetItem sets the "item" edge to the Item entity.
func (sliuo *ShoppingListItemUpdateOne) SetItem(i *Item) *ShoppingListItemUpdateOne {
	return sliuo.SetItemID(i.ID)
}

// SetPurchaseID sets the "purchase" edge to the ShoppingItem entity by ID.
func (sliuo *ShoppingListItemUpdateOne) SetPurchaseID(id int) *ShoppingListItemUpdateOne {
	sliuo.mutation.SetPurchaseID(id)
	return sliuo
}

// SetNillablePurchaseID sets the "purchase" edge to the ShoppingItem entity by ID if the given value is not nil.
func (sliuo *ShoppingListItemUpdateOne) SetNillablePurchaseID(id *int) *ShoppingListItemUpdateOne {
	if id != nil {
		sliuo = sliuo.SetPurchaseID(*id)
	}
	return sliuo
}

// SetPurchase sets the "purchase" edge to the ShoppingItem entity.
func (sliuo *ShoppingListItemUpdateOne) SetPurchase(s *ShoppingItem) *ShoppingListItemUpdateOne {
	return sliuo.SetPurchaseID(s.ID)
}

// Mutation returns the ShoppingListItemMutation object of the builder.
func (sliuo *ShoppingListItemUpdateOne) Mutation() *ShoppingListItemMutation {
	return sliuo.mutation
}

// ClearShoppingList clears the "shoppingList" edge to the ShoppingList entity.
func (sliuo *ShoppingListItemUpdateOne) ClearShoppingList() *ShoppingListItemUpdateOne {
	sliuo.mutation.ClearShoppingList()
	return sliuo
}

// ClearItem clears the "item" edge to the Item entity.
func (sliuo *ShoppingListItemUpdateOne) ClearItem() *ShoppingListItemUpdateOne {
	sliuo.mutation.ClearItem()
	return sliuo
}

// ClearPurchase clears the "purchase" edge to the ShoppingItem entity.
func (sliuo *ShoppingListItemUpdateOne) ClearPurchase() *ShoppingListItemUpdateOne {
	sliuo.mutation.ClearPurchase()
	return sliuo
}

// Select allows selecting one or more fields (columns) of the returned entity.
// The default is selecting all fields defined in the entity schema.
func (sliuo *ShoppingListItemUpdateOne) Select(field string, fields ...string) *ShoppingListItemUpdateOne {
	sliuo.fields = append([]string{field}, fields...)
	return sliuo
}

// Save executes the query and returns the updated ShoppingListItem entity.
func (sliuo *ShoppingListItemUpdateOne) Save(ctx context.Context) (*ShoppingListItem, error) {
	var (
		err  error
		node *ShoppingListItem
	)
	if len(sliuo.hooks) == 0 {
		if err = sliuo.check(); err != nil {
			return nil, err
		}
		node, err = sliuo.sqlSave(ctx)
	} else {
		var mut Mutator = MutateFunc(func(ctx context.Context, m Mutation) (Value, error) {
			mutation, ok := m.(*ShoppingListItemMutation)
			if !ok {
				return nil, fmt.Errorf("unexpected mutation type %T", m)
			}
			if err = sliuo.check(); err != nil {
				return nil, err
			}
			sliuo.mutation = mutation
			node, err = sliuo.sqlSave(ctx)
			mutation.done = true
			return node, err
		})
		for i := len(sliuo.hooks) - 1; i >= 0; i-- {
			if sliuo.hooks[i] == nil {
				return nil, fmt.Errorf("ent: uninitialized hook (forgotten import ent/runtime?)")
			}
			mut = sliuo.hooks[i](mut)
		}
		if _, err := mut.Mutate(ctx, sliuo.mutation); err != nil {
			return nil, err
		}
	}
	return node, err
}

// SaveX is like Save, but panics if an error occurs.
func (sliuo *ShoppingListItemUpdateOne) SaveX(ctx context.Context) *ShoppingListItem {
	node, err := sliuo.Save(ctx)
	if err != nil {
		panic(err)
	}
	return node
}

// Exec executes the query on the entity.
func (sliuo *ShoppingListItemUpdateOne) Exec(ctx context.Context) error {
	_, err := sliuo.Save(ctx)
	return err
}

// ExecX is like Exec, but panics if an error occurs.
func (sliuo *ShoppingListItemUpdateOne) ExecX(ctx context.Context) {
	if err := sliuo.Exec(ctx); err != nil {
		panic(err)
	}
}

// check runs all checks and user-defined validators on the builder.
func (sliuo *ShoppingListItemUpdateOne) check() error {
	if _, ok := sliuo.mutation.ShoppingListID(); sliuo.mutation.ShoppingListCleared() && !ok {
		return errors.New("ent: clearing a required unique edge \"shoppingList\"")
	}
	if _, ok := sliuo.mutation.ItemID(); sliuo.mutation.ItemCleared() && !ok {
		return errors.New("ent: clearing a required unique edge \"item\"")
	}
	return nil
}

func (sliuo *ShoppingListItemUpdateOne) sqlSave(ctx context.Context) (_node *ShoppingListItem, err error) {
	_spec := &sqlgraph.UpdateSpec{
		Node: &sqlgraph.NodeSpec{
			Table:   shoppinglistitem.Table,
			Columns: shoppinglistitem.Columns,
			ID: &sqlgraph.FieldSpec{
				Type:   field.TypeInt,
				Column: shoppinglistitem.FieldID,
			},
		},
	}
	id, ok := sliuo.mutation.ID()
	if !ok {
		return nil, &ValidationError{Name: "ID", err: fmt.Errorf("missing ShoppingListItem.ID for update")}
	}
	_spec.Node.ID.Value = id
	if fields := sliuo.fields; len(fields) > 0 {
		_spec.Node.Columns = make([]string, 0, len(fields))
		_spec.Node.Columns = append(_spec.Node.Columns, shoppinglistitem.FieldID)
		for _, f := range fields {
			if !shoppinglistitem.ValidColumn(f) {
				return nil, &ValidationError{Name: f, err: fmt.Errorf("ent: invalid field %q for query", f)}
			}
			if f != shoppinglistitem.FieldID {
				_spec.Node.Columns = append(_spec.Node.Columns, f)
			}
		}
	}
	if ps := sliuo.mutation.predicates; len(ps) > 0 {
		_spec.Predicate = func(selector *sql.Selector) {
			for i := range ps {
				ps[i](selector)
			}
		}
	}
	if sliuo.mutation.ShoppingListCleared() {
		edge := &sqlgraph.EdgeSpec{
			Rel:     sqlgraph.M2O,
			Inverse: true,
			Table:   shoppinglistitem.ShoppingListTable,
			Columns: []string{shoppinglistitem.ShoppingListColumn},
			Bidi:    false,
			Target: &sqlgraph.EdgeTarget{
				IDSpec: &sqlgraph.FieldSpec{
					Type:   field.TypeInt,
					Column: shoppinglist.FieldID,
				},
			},
		}
		_spec.Edges.Clear = append(_spec.Edges.Clear, edge)
	}
	if nodes := sliuo.mutation.ShoppingListIDs(); len(nodes) > 0 {
		edge := &sqlgraph.EdgeSpec{
			Rel:     sqlgraph.M2O,
			Inverse: true,
			Table:   shoppinglistitem.ShoppingListTable,
			Columns: []string{shoppinglistitem.ShoppingListColumn},
			Bidi:    false,
			Target: &sqlgraph.EdgeTarget{
				IDSpec: &sqlgraph.FieldSpec{
					Type:   field.TypeInt,
					Column: shoppinglist.FieldID,
				},
			},
		}
		for _, k := range nodes {
			edge.Target.Nodes = append(edge.Target.Nodes, k)
		}
		_spec.Edges.Add = append(_spec.Edges.Add, edge)
	}
	if sliuo.mutation.ItemCleared() {
		edge := &sqlgraph.EdgeSpec{
			Rel:     sqlgraph.M2O,
			Inverse: true,
			Table:   shoppinglistitem.ItemTable,
			Columns: []string{shoppinglistitem.ItemColumn},
			Bidi:    false,
			Target: &sqlgraph.EdgeTarget{
				IDSpec: &sqlgraph.FieldSpec{
					Type:   field.TypeInt,
					Column: item.FieldID,
				},
			},
		}
		_spec.Edges.Clear = append(_spec.Edges.Clear, edge)
	}
	if nodes := sliuo.mutation.ItemIDs(); len(nodes) > 0 {
		edge := &sqlgraph.EdgeSpec{
			Rel:     sqlgraph.M2O,
			Inverse: true,
			Table:   shoppinglistitem.ItemTable,
			Columns: []string{shoppinglistitem.ItemColumn},
			Bidi:    false,
			Target: &sqlgraph.EdgeTarget{
				IDSpec: &sqlgraph.FieldSpec{
					Type:   field.TypeInt,
					Column: item.FieldID,
				},
			},
		}
		for _, k := range nodes {
			edge.Target.Nodes = append(edge.Target.Nodes, k)
		}
		_spec.Edges.Add = append(_spec.Edges.Add, edge)
	}
	if sliuo.mutation.PurchaseCleared() {
		edge := &sqlgraph.EdgeSpec{
			Rel:     sqlgraph.M2O,
			Inverse: true,
			Table:   shoppinglistitem.PurchaseTable,
			Columns: []string{shoppinglistitem.PurchaseColumn},
			Bidi:    false,
			Target: &sqlgraph.EdgeTarget{
				IDSpec: &sqlgraph.FieldSpec{
					Type:   field.TypeInt,
					Column: shoppingitem.FieldID,
				},
			},
		}
		_spec.Edges.Clear = append(_spec.Edges.Clear, edge)
	}
	if nodes := sliuo.mutation.PurchaseIDs(); len(nodes) > 0 {
		edge := &sqlgraph.EdgeSpec{
			Rel:     sqlgraph.M2O,
			Inverse: true,
			Table:   shoppinglistitem.PurchaseTable,
			Columns: []string{shoppinglistitem.PurchaseColumn},
			Bidi:    false,
			Target: &sqlgraph.EdgeTarget{
				IDSpec: &sqlgraph.FieldSpec{
					Type:   field.TypeInt,
					Column: shoppingitem.FieldID,
				},
			},
		}
		for _, k := range nodes {
			edge.Target.Nodes = append(edge.Target.Nodes, k)
		}
		_spec.Edges.Add = append(_spec.Edges.Add, edge)
	}
	_node = &ShoppingListItem{config: sliuo.config}
	_spec.Assign = _node.assignValues
	_spec.ScanValues = _node.scanValues
	if err = sqlgraph.UpdateNode(ctx, sliuo.driver, _spec); err != nil {
		if _, ok := err.(*sqlgraph.NotFoundError); ok {
			err = &NotFoundError{shoppinglistitem.Label}
		} else if sqlgraph.IsConstraintError(err) {
			err = &ConstraintError{err.Error(), err}
		}
		return nil, err
	}
	return _node, nil
}
