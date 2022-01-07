// Code generated by entc, DO NOT EDIT.

package ent

import (
	"context"
	"errors"
	"fmt"
	"time"

	"entgo.io/ent/dialect/sql/sqlgraph"
	"entgo.io/ent/schema/field"
	"github.com/kingzbauer/shilingi/app-engine/ent/shopping"
	"github.com/kingzbauer/shilingi/app-engine/ent/shoppingitem"
)

// ShoppingCreate is the builder for creating a Shopping entity.
type ShoppingCreate struct {
	config
	mutation *ShoppingMutation
	hooks    []Hook
}

// SetCreateTime sets the "create_time" field.
func (sc *ShoppingCreate) SetCreateTime(t time.Time) *ShoppingCreate {
	sc.mutation.SetCreateTime(t)
	return sc
}

// SetNillableCreateTime sets the "create_time" field if the given value is not nil.
func (sc *ShoppingCreate) SetNillableCreateTime(t *time.Time) *ShoppingCreate {
	if t != nil {
		sc.SetCreateTime(*t)
	}
	return sc
}

// SetUpdateTime sets the "update_time" field.
func (sc *ShoppingCreate) SetUpdateTime(t time.Time) *ShoppingCreate {
	sc.mutation.SetUpdateTime(t)
	return sc
}

// SetNillableUpdateTime sets the "update_time" field if the given value is not nil.
func (sc *ShoppingCreate) SetNillableUpdateTime(t *time.Time) *ShoppingCreate {
	if t != nil {
		sc.SetUpdateTime(*t)
	}
	return sc
}

// SetDate sets the "date" field.
func (sc *ShoppingCreate) SetDate(t time.Time) *ShoppingCreate {
	sc.mutation.SetDate(t)
	return sc
}

// SetMarket sets the "market" field.
func (sc *ShoppingCreate) SetMarket(s string) *ShoppingCreate {
	sc.mutation.SetMarket(s)
	return sc
}

// AddItemIDs adds the "items" edge to the ShoppingItem entity by IDs.
func (sc *ShoppingCreate) AddItemIDs(ids ...int) *ShoppingCreate {
	sc.mutation.AddItemIDs(ids...)
	return sc
}

// AddItems adds the "items" edges to the ShoppingItem entity.
func (sc *ShoppingCreate) AddItems(s ...*ShoppingItem) *ShoppingCreate {
	ids := make([]int, len(s))
	for i := range s {
		ids[i] = s[i].ID
	}
	return sc.AddItemIDs(ids...)
}

// Mutation returns the ShoppingMutation object of the builder.
func (sc *ShoppingCreate) Mutation() *ShoppingMutation {
	return sc.mutation
}

// Save creates the Shopping in the database.
func (sc *ShoppingCreate) Save(ctx context.Context) (*Shopping, error) {
	var (
		err  error
		node *Shopping
	)
	sc.defaults()
	if len(sc.hooks) == 0 {
		if err = sc.check(); err != nil {
			return nil, err
		}
		node, err = sc.sqlSave(ctx)
	} else {
		var mut Mutator = MutateFunc(func(ctx context.Context, m Mutation) (Value, error) {
			mutation, ok := m.(*ShoppingMutation)
			if !ok {
				return nil, fmt.Errorf("unexpected mutation type %T", m)
			}
			if err = sc.check(); err != nil {
				return nil, err
			}
			sc.mutation = mutation
			if node, err = sc.sqlSave(ctx); err != nil {
				return nil, err
			}
			mutation.id = &node.ID
			mutation.done = true
			return node, err
		})
		for i := len(sc.hooks) - 1; i >= 0; i-- {
			if sc.hooks[i] == nil {
				return nil, fmt.Errorf("ent: uninitialized hook (forgotten import ent/runtime?)")
			}
			mut = sc.hooks[i](mut)
		}
		if _, err := mut.Mutate(ctx, sc.mutation); err != nil {
			return nil, err
		}
	}
	return node, err
}

// SaveX calls Save and panics if Save returns an error.
func (sc *ShoppingCreate) SaveX(ctx context.Context) *Shopping {
	v, err := sc.Save(ctx)
	if err != nil {
		panic(err)
	}
	return v
}

// Exec executes the query.
func (sc *ShoppingCreate) Exec(ctx context.Context) error {
	_, err := sc.Save(ctx)
	return err
}

// ExecX is like Exec, but panics if an error occurs.
func (sc *ShoppingCreate) ExecX(ctx context.Context) {
	if err := sc.Exec(ctx); err != nil {
		panic(err)
	}
}

// defaults sets the default values of the builder before save.
func (sc *ShoppingCreate) defaults() {
	if _, ok := sc.mutation.CreateTime(); !ok {
		v := shopping.DefaultCreateTime()
		sc.mutation.SetCreateTime(v)
	}
	if _, ok := sc.mutation.UpdateTime(); !ok {
		v := shopping.DefaultUpdateTime()
		sc.mutation.SetUpdateTime(v)
	}
}

// check runs all checks and user-defined validators on the builder.
func (sc *ShoppingCreate) check() error {
	if _, ok := sc.mutation.CreateTime(); !ok {
		return &ValidationError{Name: "create_time", err: errors.New(`ent: missing required field "create_time"`)}
	}
	if _, ok := sc.mutation.UpdateTime(); !ok {
		return &ValidationError{Name: "update_time", err: errors.New(`ent: missing required field "update_time"`)}
	}
	if _, ok := sc.mutation.Date(); !ok {
		return &ValidationError{Name: "date", err: errors.New(`ent: missing required field "date"`)}
	}
	if _, ok := sc.mutation.Market(); !ok {
		return &ValidationError{Name: "market", err: errors.New(`ent: missing required field "market"`)}
	}
	return nil
}

func (sc *ShoppingCreate) sqlSave(ctx context.Context) (*Shopping, error) {
	_node, _spec := sc.createSpec()
	if err := sqlgraph.CreateNode(ctx, sc.driver, _spec); err != nil {
		if sqlgraph.IsConstraintError(err) {
			err = &ConstraintError{err.Error(), err}
		}
		return nil, err
	}
	id := _spec.ID.Value.(int64)
	_node.ID = int(id)
	return _node, nil
}

func (sc *ShoppingCreate) createSpec() (*Shopping, *sqlgraph.CreateSpec) {
	var (
		_node = &Shopping{config: sc.config}
		_spec = &sqlgraph.CreateSpec{
			Table: shopping.Table,
			ID: &sqlgraph.FieldSpec{
				Type:   field.TypeInt,
				Column: shopping.FieldID,
			},
		}
	)
	if value, ok := sc.mutation.CreateTime(); ok {
		_spec.Fields = append(_spec.Fields, &sqlgraph.FieldSpec{
			Type:   field.TypeTime,
			Value:  value,
			Column: shopping.FieldCreateTime,
		})
		_node.CreateTime = value
	}
	if value, ok := sc.mutation.UpdateTime(); ok {
		_spec.Fields = append(_spec.Fields, &sqlgraph.FieldSpec{
			Type:   field.TypeTime,
			Value:  value,
			Column: shopping.FieldUpdateTime,
		})
		_node.UpdateTime = value
	}
	if value, ok := sc.mutation.Date(); ok {
		_spec.Fields = append(_spec.Fields, &sqlgraph.FieldSpec{
			Type:   field.TypeTime,
			Value:  value,
			Column: shopping.FieldDate,
		})
		_node.Date = value
	}
	if value, ok := sc.mutation.Market(); ok {
		_spec.Fields = append(_spec.Fields, &sqlgraph.FieldSpec{
			Type:   field.TypeString,
			Value:  value,
			Column: shopping.FieldMarket,
		})
		_node.Market = value
	}
	if nodes := sc.mutation.ItemsIDs(); len(nodes) > 0 {
		edge := &sqlgraph.EdgeSpec{
			Rel:     sqlgraph.O2M,
			Inverse: false,
			Table:   shopping.ItemsTable,
			Columns: []string{shopping.ItemsColumn},
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
		_spec.Edges = append(_spec.Edges, edge)
	}
	return _node, _spec
}

// ShoppingCreateBulk is the builder for creating many Shopping entities in bulk.
type ShoppingCreateBulk struct {
	config
	builders []*ShoppingCreate
}

// Save creates the Shopping entities in the database.
func (scb *ShoppingCreateBulk) Save(ctx context.Context) ([]*Shopping, error) {
	specs := make([]*sqlgraph.CreateSpec, len(scb.builders))
	nodes := make([]*Shopping, len(scb.builders))
	mutators := make([]Mutator, len(scb.builders))
	for i := range scb.builders {
		func(i int, root context.Context) {
			builder := scb.builders[i]
			builder.defaults()
			var mut Mutator = MutateFunc(func(ctx context.Context, m Mutation) (Value, error) {
				mutation, ok := m.(*ShoppingMutation)
				if !ok {
					return nil, fmt.Errorf("unexpected mutation type %T", m)
				}
				if err := builder.check(); err != nil {
					return nil, err
				}
				builder.mutation = mutation
				nodes[i], specs[i] = builder.createSpec()
				var err error
				if i < len(mutators)-1 {
					_, err = mutators[i+1].Mutate(root, scb.builders[i+1].mutation)
				} else {
					spec := &sqlgraph.BatchCreateSpec{Nodes: specs}
					// Invoke the actual operation on the latest mutation in the chain.
					if err = sqlgraph.BatchCreate(ctx, scb.driver, spec); err != nil {
						if sqlgraph.IsConstraintError(err) {
							err = &ConstraintError{err.Error(), err}
						}
					}
				}
				if err != nil {
					return nil, err
				}
				mutation.id = &nodes[i].ID
				mutation.done = true
				if specs[i].ID.Value != nil {
					id := specs[i].ID.Value.(int64)
					nodes[i].ID = int(id)
				}
				return nodes[i], nil
			})
			for i := len(builder.hooks) - 1; i >= 0; i-- {
				mut = builder.hooks[i](mut)
			}
			mutators[i] = mut
		}(i, ctx)
	}
	if len(mutators) > 0 {
		if _, err := mutators[0].Mutate(ctx, scb.builders[0].mutation); err != nil {
			return nil, err
		}
	}
	return nodes, nil
}

// SaveX is like Save, but panics if an error occurs.
func (scb *ShoppingCreateBulk) SaveX(ctx context.Context) []*Shopping {
	v, err := scb.Save(ctx)
	if err != nil {
		panic(err)
	}
	return v
}

// Exec executes the query.
func (scb *ShoppingCreateBulk) Exec(ctx context.Context) error {
	_, err := scb.Save(ctx)
	return err
}

// ExecX is like Exec, but panics if an error occurs.
func (scb *ShoppingCreateBulk) ExecX(ctx context.Context) {
	if err := scb.Exec(ctx); err != nil {
		panic(err)
	}
}