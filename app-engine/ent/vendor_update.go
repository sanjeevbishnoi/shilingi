// Code generated by entc, DO NOT EDIT.

package ent

import (
	"context"
	"fmt"

	"entgo.io/ent/dialect/sql"
	"entgo.io/ent/dialect/sql/sqlgraph"
	"entgo.io/ent/schema/field"
	"github.com/kingzbauer/shilingi/app-engine/ent/predicate"
	"github.com/kingzbauer/shilingi/app-engine/ent/shopping"
	"github.com/kingzbauer/shilingi/app-engine/ent/vendor"
)

// VendorUpdate is the builder for updating Vendor entities.
type VendorUpdate struct {
	config
	hooks    []Hook
	mutation *VendorMutation
}

// Where appends a list predicates to the VendorUpdate builder.
func (vu *VendorUpdate) Where(ps ...predicate.Vendor) *VendorUpdate {
	vu.mutation.Where(ps...)
	return vu
}

// SetName sets the "name" field.
func (vu *VendorUpdate) SetName(s string) *VendorUpdate {
	vu.mutation.SetName(s)
	return vu
}

// SetSlug sets the "slug" field.
func (vu *VendorUpdate) SetSlug(s string) *VendorUpdate {
	vu.mutation.SetSlug(s)
	return vu
}

// AddPurchaseIDs adds the "purchases" edge to the Shopping entity by IDs.
func (vu *VendorUpdate) AddPurchaseIDs(ids ...int) *VendorUpdate {
	vu.mutation.AddPurchaseIDs(ids...)
	return vu
}

// AddPurchases adds the "purchases" edges to the Shopping entity.
func (vu *VendorUpdate) AddPurchases(s ...*Shopping) *VendorUpdate {
	ids := make([]int, len(s))
	for i := range s {
		ids[i] = s[i].ID
	}
	return vu.AddPurchaseIDs(ids...)
}

// Mutation returns the VendorMutation object of the builder.
func (vu *VendorUpdate) Mutation() *VendorMutation {
	return vu.mutation
}

// ClearPurchases clears all "purchases" edges to the Shopping entity.
func (vu *VendorUpdate) ClearPurchases() *VendorUpdate {
	vu.mutation.ClearPurchases()
	return vu
}

// RemovePurchaseIDs removes the "purchases" edge to Shopping entities by IDs.
func (vu *VendorUpdate) RemovePurchaseIDs(ids ...int) *VendorUpdate {
	vu.mutation.RemovePurchaseIDs(ids...)
	return vu
}

// RemovePurchases removes "purchases" edges to Shopping entities.
func (vu *VendorUpdate) RemovePurchases(s ...*Shopping) *VendorUpdate {
	ids := make([]int, len(s))
	for i := range s {
		ids[i] = s[i].ID
	}
	return vu.RemovePurchaseIDs(ids...)
}

// Save executes the query and returns the number of nodes affected by the update operation.
func (vu *VendorUpdate) Save(ctx context.Context) (int, error) {
	var (
		err      error
		affected int
	)
	if len(vu.hooks) == 0 {
		affected, err = vu.sqlSave(ctx)
	} else {
		var mut Mutator = MutateFunc(func(ctx context.Context, m Mutation) (Value, error) {
			mutation, ok := m.(*VendorMutation)
			if !ok {
				return nil, fmt.Errorf("unexpected mutation type %T", m)
			}
			vu.mutation = mutation
			affected, err = vu.sqlSave(ctx)
			mutation.done = true
			return affected, err
		})
		for i := len(vu.hooks) - 1; i >= 0; i-- {
			if vu.hooks[i] == nil {
				return 0, fmt.Errorf("ent: uninitialized hook (forgotten import ent/runtime?)")
			}
			mut = vu.hooks[i](mut)
		}
		if _, err := mut.Mutate(ctx, vu.mutation); err != nil {
			return 0, err
		}
	}
	return affected, err
}

// SaveX is like Save, but panics if an error occurs.
func (vu *VendorUpdate) SaveX(ctx context.Context) int {
	affected, err := vu.Save(ctx)
	if err != nil {
		panic(err)
	}
	return affected
}

// Exec executes the query.
func (vu *VendorUpdate) Exec(ctx context.Context) error {
	_, err := vu.Save(ctx)
	return err
}

// ExecX is like Exec, but panics if an error occurs.
func (vu *VendorUpdate) ExecX(ctx context.Context) {
	if err := vu.Exec(ctx); err != nil {
		panic(err)
	}
}

func (vu *VendorUpdate) sqlSave(ctx context.Context) (n int, err error) {
	_spec := &sqlgraph.UpdateSpec{
		Node: &sqlgraph.NodeSpec{
			Table:   vendor.Table,
			Columns: vendor.Columns,
			ID: &sqlgraph.FieldSpec{
				Type:   field.TypeInt,
				Column: vendor.FieldID,
			},
		},
	}
	if ps := vu.mutation.predicates; len(ps) > 0 {
		_spec.Predicate = func(selector *sql.Selector) {
			for i := range ps {
				ps[i](selector)
			}
		}
	}
	if value, ok := vu.mutation.Name(); ok {
		_spec.Fields.Set = append(_spec.Fields.Set, &sqlgraph.FieldSpec{
			Type:   field.TypeString,
			Value:  value,
			Column: vendor.FieldName,
		})
	}
	if value, ok := vu.mutation.Slug(); ok {
		_spec.Fields.Set = append(_spec.Fields.Set, &sqlgraph.FieldSpec{
			Type:   field.TypeString,
			Value:  value,
			Column: vendor.FieldSlug,
		})
	}
	if vu.mutation.PurchasesCleared() {
		edge := &sqlgraph.EdgeSpec{
			Rel:     sqlgraph.O2M,
			Inverse: false,
			Table:   vendor.PurchasesTable,
			Columns: []string{vendor.PurchasesColumn},
			Bidi:    false,
			Target: &sqlgraph.EdgeTarget{
				IDSpec: &sqlgraph.FieldSpec{
					Type:   field.TypeInt,
					Column: shopping.FieldID,
				},
			},
		}
		_spec.Edges.Clear = append(_spec.Edges.Clear, edge)
	}
	if nodes := vu.mutation.RemovedPurchasesIDs(); len(nodes) > 0 && !vu.mutation.PurchasesCleared() {
		edge := &sqlgraph.EdgeSpec{
			Rel:     sqlgraph.O2M,
			Inverse: false,
			Table:   vendor.PurchasesTable,
			Columns: []string{vendor.PurchasesColumn},
			Bidi:    false,
			Target: &sqlgraph.EdgeTarget{
				IDSpec: &sqlgraph.FieldSpec{
					Type:   field.TypeInt,
					Column: shopping.FieldID,
				},
			},
		}
		for _, k := range nodes {
			edge.Target.Nodes = append(edge.Target.Nodes, k)
		}
		_spec.Edges.Clear = append(_spec.Edges.Clear, edge)
	}
	if nodes := vu.mutation.PurchasesIDs(); len(nodes) > 0 {
		edge := &sqlgraph.EdgeSpec{
			Rel:     sqlgraph.O2M,
			Inverse: false,
			Table:   vendor.PurchasesTable,
			Columns: []string{vendor.PurchasesColumn},
			Bidi:    false,
			Target: &sqlgraph.EdgeTarget{
				IDSpec: &sqlgraph.FieldSpec{
					Type:   field.TypeInt,
					Column: shopping.FieldID,
				},
			},
		}
		for _, k := range nodes {
			edge.Target.Nodes = append(edge.Target.Nodes, k)
		}
		_spec.Edges.Add = append(_spec.Edges.Add, edge)
	}
	if n, err = sqlgraph.UpdateNodes(ctx, vu.driver, _spec); err != nil {
		if _, ok := err.(*sqlgraph.NotFoundError); ok {
			err = &NotFoundError{vendor.Label}
		} else if sqlgraph.IsConstraintError(err) {
			err = &ConstraintError{err.Error(), err}
		}
		return 0, err
	}
	return n, nil
}

// VendorUpdateOne is the builder for updating a single Vendor entity.
type VendorUpdateOne struct {
	config
	fields   []string
	hooks    []Hook
	mutation *VendorMutation
}

// SetName sets the "name" field.
func (vuo *VendorUpdateOne) SetName(s string) *VendorUpdateOne {
	vuo.mutation.SetName(s)
	return vuo
}

// SetSlug sets the "slug" field.
func (vuo *VendorUpdateOne) SetSlug(s string) *VendorUpdateOne {
	vuo.mutation.SetSlug(s)
	return vuo
}

// AddPurchaseIDs adds the "purchases" edge to the Shopping entity by IDs.
func (vuo *VendorUpdateOne) AddPurchaseIDs(ids ...int) *VendorUpdateOne {
	vuo.mutation.AddPurchaseIDs(ids...)
	return vuo
}

// AddPurchases adds the "purchases" edges to the Shopping entity.
func (vuo *VendorUpdateOne) AddPurchases(s ...*Shopping) *VendorUpdateOne {
	ids := make([]int, len(s))
	for i := range s {
		ids[i] = s[i].ID
	}
	return vuo.AddPurchaseIDs(ids...)
}

// Mutation returns the VendorMutation object of the builder.
func (vuo *VendorUpdateOne) Mutation() *VendorMutation {
	return vuo.mutation
}

// ClearPurchases clears all "purchases" edges to the Shopping entity.
func (vuo *VendorUpdateOne) ClearPurchases() *VendorUpdateOne {
	vuo.mutation.ClearPurchases()
	return vuo
}

// RemovePurchaseIDs removes the "purchases" edge to Shopping entities by IDs.
func (vuo *VendorUpdateOne) RemovePurchaseIDs(ids ...int) *VendorUpdateOne {
	vuo.mutation.RemovePurchaseIDs(ids...)
	return vuo
}

// RemovePurchases removes "purchases" edges to Shopping entities.
func (vuo *VendorUpdateOne) RemovePurchases(s ...*Shopping) *VendorUpdateOne {
	ids := make([]int, len(s))
	for i := range s {
		ids[i] = s[i].ID
	}
	return vuo.RemovePurchaseIDs(ids...)
}

// Select allows selecting one or more fields (columns) of the returned entity.
// The default is selecting all fields defined in the entity schema.
func (vuo *VendorUpdateOne) Select(field string, fields ...string) *VendorUpdateOne {
	vuo.fields = append([]string{field}, fields...)
	return vuo
}

// Save executes the query and returns the updated Vendor entity.
func (vuo *VendorUpdateOne) Save(ctx context.Context) (*Vendor, error) {
	var (
		err  error
		node *Vendor
	)
	if len(vuo.hooks) == 0 {
		node, err = vuo.sqlSave(ctx)
	} else {
		var mut Mutator = MutateFunc(func(ctx context.Context, m Mutation) (Value, error) {
			mutation, ok := m.(*VendorMutation)
			if !ok {
				return nil, fmt.Errorf("unexpected mutation type %T", m)
			}
			vuo.mutation = mutation
			node, err = vuo.sqlSave(ctx)
			mutation.done = true
			return node, err
		})
		for i := len(vuo.hooks) - 1; i >= 0; i-- {
			if vuo.hooks[i] == nil {
				return nil, fmt.Errorf("ent: uninitialized hook (forgotten import ent/runtime?)")
			}
			mut = vuo.hooks[i](mut)
		}
		if _, err := mut.Mutate(ctx, vuo.mutation); err != nil {
			return nil, err
		}
	}
	return node, err
}

// SaveX is like Save, but panics if an error occurs.
func (vuo *VendorUpdateOne) SaveX(ctx context.Context) *Vendor {
	node, err := vuo.Save(ctx)
	if err != nil {
		panic(err)
	}
	return node
}

// Exec executes the query on the entity.
func (vuo *VendorUpdateOne) Exec(ctx context.Context) error {
	_, err := vuo.Save(ctx)
	return err
}

// ExecX is like Exec, but panics if an error occurs.
func (vuo *VendorUpdateOne) ExecX(ctx context.Context) {
	if err := vuo.Exec(ctx); err != nil {
		panic(err)
	}
}

func (vuo *VendorUpdateOne) sqlSave(ctx context.Context) (_node *Vendor, err error) {
	_spec := &sqlgraph.UpdateSpec{
		Node: &sqlgraph.NodeSpec{
			Table:   vendor.Table,
			Columns: vendor.Columns,
			ID: &sqlgraph.FieldSpec{
				Type:   field.TypeInt,
				Column: vendor.FieldID,
			},
		},
	}
	id, ok := vuo.mutation.ID()
	if !ok {
		return nil, &ValidationError{Name: "ID", err: fmt.Errorf("missing Vendor.ID for update")}
	}
	_spec.Node.ID.Value = id
	if fields := vuo.fields; len(fields) > 0 {
		_spec.Node.Columns = make([]string, 0, len(fields))
		_spec.Node.Columns = append(_spec.Node.Columns, vendor.FieldID)
		for _, f := range fields {
			if !vendor.ValidColumn(f) {
				return nil, &ValidationError{Name: f, err: fmt.Errorf("ent: invalid field %q for query", f)}
			}
			if f != vendor.FieldID {
				_spec.Node.Columns = append(_spec.Node.Columns, f)
			}
		}
	}
	if ps := vuo.mutation.predicates; len(ps) > 0 {
		_spec.Predicate = func(selector *sql.Selector) {
			for i := range ps {
				ps[i](selector)
			}
		}
	}
	if value, ok := vuo.mutation.Name(); ok {
		_spec.Fields.Set = append(_spec.Fields.Set, &sqlgraph.FieldSpec{
			Type:   field.TypeString,
			Value:  value,
			Column: vendor.FieldName,
		})
	}
	if value, ok := vuo.mutation.Slug(); ok {
		_spec.Fields.Set = append(_spec.Fields.Set, &sqlgraph.FieldSpec{
			Type:   field.TypeString,
			Value:  value,
			Column: vendor.FieldSlug,
		})
	}
	if vuo.mutation.PurchasesCleared() {
		edge := &sqlgraph.EdgeSpec{
			Rel:     sqlgraph.O2M,
			Inverse: false,
			Table:   vendor.PurchasesTable,
			Columns: []string{vendor.PurchasesColumn},
			Bidi:    false,
			Target: &sqlgraph.EdgeTarget{
				IDSpec: &sqlgraph.FieldSpec{
					Type:   field.TypeInt,
					Column: shopping.FieldID,
				},
			},
		}
		_spec.Edges.Clear = append(_spec.Edges.Clear, edge)
	}
	if nodes := vuo.mutation.RemovedPurchasesIDs(); len(nodes) > 0 && !vuo.mutation.PurchasesCleared() {
		edge := &sqlgraph.EdgeSpec{
			Rel:     sqlgraph.O2M,
			Inverse: false,
			Table:   vendor.PurchasesTable,
			Columns: []string{vendor.PurchasesColumn},
			Bidi:    false,
			Target: &sqlgraph.EdgeTarget{
				IDSpec: &sqlgraph.FieldSpec{
					Type:   field.TypeInt,
					Column: shopping.FieldID,
				},
			},
		}
		for _, k := range nodes {
			edge.Target.Nodes = append(edge.Target.Nodes, k)
		}
		_spec.Edges.Clear = append(_spec.Edges.Clear, edge)
	}
	if nodes := vuo.mutation.PurchasesIDs(); len(nodes) > 0 {
		edge := &sqlgraph.EdgeSpec{
			Rel:     sqlgraph.O2M,
			Inverse: false,
			Table:   vendor.PurchasesTable,
			Columns: []string{vendor.PurchasesColumn},
			Bidi:    false,
			Target: &sqlgraph.EdgeTarget{
				IDSpec: &sqlgraph.FieldSpec{
					Type:   field.TypeInt,
					Column: shopping.FieldID,
				},
			},
		}
		for _, k := range nodes {
			edge.Target.Nodes = append(edge.Target.Nodes, k)
		}
		_spec.Edges.Add = append(_spec.Edges.Add, edge)
	}
	_node = &Vendor{config: vuo.config}
	_spec.Assign = _node.assignValues
	_spec.ScanValues = _node.scanValues
	if err = sqlgraph.UpdateNode(ctx, vuo.driver, _spec); err != nil {
		if _, ok := err.(*sqlgraph.NotFoundError); ok {
			err = &NotFoundError{vendor.Label}
		} else if sqlgraph.IsConstraintError(err) {
			err = &ConstraintError{err.Error(), err}
		}
		return nil, err
	}
	return _node, nil
}
