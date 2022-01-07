// Code generated by entc, DO NOT EDIT.

package ent

import (
	"context"
	"errors"
	"fmt"
	"time"

	"entgo.io/ent/dialect/sql/sqlgraph"
	"entgo.io/ent/schema/field"
	"github.com/kingzbauer/shilingi/app-engine/ent/item"
	"github.com/kingzbauer/shilingi/app-engine/ent/shopping"
	"github.com/kingzbauer/shilingi/app-engine/ent/shoppingitem"
	"github.com/shopspring/decimal"
)

// ShoppingItemCreate is the builder for creating a ShoppingItem entity.
type ShoppingItemCreate struct {
	config
	mutation *ShoppingItemMutation
	hooks    []Hook
}

// SetCreateTime sets the "create_time" field.
func (sic *ShoppingItemCreate) SetCreateTime(t time.Time) *ShoppingItemCreate {
	sic.mutation.SetCreateTime(t)
	return sic
}

// SetNillableCreateTime sets the "create_time" field if the given value is not nil.
func (sic *ShoppingItemCreate) SetNillableCreateTime(t *time.Time) *ShoppingItemCreate {
	if t != nil {
		sic.SetCreateTime(*t)
	}
	return sic
}

// SetUpdateTime sets the "update_time" field.
func (sic *ShoppingItemCreate) SetUpdateTime(t time.Time) *ShoppingItemCreate {
	sic.mutation.SetUpdateTime(t)
	return sic
}

// SetNillableUpdateTime sets the "update_time" field if the given value is not nil.
func (sic *ShoppingItemCreate) SetNillableUpdateTime(t *time.Time) *ShoppingItemCreate {
	if t != nil {
		sic.SetUpdateTime(*t)
	}
	return sic
}

// SetQuantity sets the "quantity" field.
func (sic *ShoppingItemCreate) SetQuantity(f float64) *ShoppingItemCreate {
	sic.mutation.SetQuantity(f)
	return sic
}

// SetQuantityType sets the "quantity_type" field.
func (sic *ShoppingItemCreate) SetQuantityType(s string) *ShoppingItemCreate {
	sic.mutation.SetQuantityType(s)
	return sic
}

// SetUnits sets the "units" field.
func (sic *ShoppingItemCreate) SetUnits(i int) *ShoppingItemCreate {
	sic.mutation.SetUnits(i)
	return sic
}

// SetNillableUnits sets the "units" field if the given value is not nil.
func (sic *ShoppingItemCreate) SetNillableUnits(i *int) *ShoppingItemCreate {
	if i != nil {
		sic.SetUnits(*i)
	}
	return sic
}

// SetBrand sets the "brand" field.
func (sic *ShoppingItemCreate) SetBrand(s string) *ShoppingItemCreate {
	sic.mutation.SetBrand(s)
	return sic
}

// SetNillableBrand sets the "brand" field if the given value is not nil.
func (sic *ShoppingItemCreate) SetNillableBrand(s *string) *ShoppingItemCreate {
	if s != nil {
		sic.SetBrand(*s)
	}
	return sic
}

// SetPricePerUnit sets the "price_per_unit" field.
func (sic *ShoppingItemCreate) SetPricePerUnit(d decimal.Decimal) *ShoppingItemCreate {
	sic.mutation.SetPricePerUnit(d)
	return sic
}

// SetItemID sets the "item" edge to the Item entity by ID.
func (sic *ShoppingItemCreate) SetItemID(id int) *ShoppingItemCreate {
	sic.mutation.SetItemID(id)
	return sic
}

// SetItem sets the "item" edge to the Item entity.
func (sic *ShoppingItemCreate) SetItem(i *Item) *ShoppingItemCreate {
	return sic.SetItemID(i.ID)
}

// SetShoppingID sets the "shopping" edge to the Shopping entity by ID.
func (sic *ShoppingItemCreate) SetShoppingID(id int) *ShoppingItemCreate {
	sic.mutation.SetShoppingID(id)
	return sic
}

// SetShopping sets the "shopping" edge to the Shopping entity.
func (sic *ShoppingItemCreate) SetShopping(s *Shopping) *ShoppingItemCreate {
	return sic.SetShoppingID(s.ID)
}

// Mutation returns the ShoppingItemMutation object of the builder.
func (sic *ShoppingItemCreate) Mutation() *ShoppingItemMutation {
	return sic.mutation
}

// Save creates the ShoppingItem in the database.
func (sic *ShoppingItemCreate) Save(ctx context.Context) (*ShoppingItem, error) {
	var (
		err  error
		node *ShoppingItem
	)
	sic.defaults()
	if len(sic.hooks) == 0 {
		if err = sic.check(); err != nil {
			return nil, err
		}
		node, err = sic.sqlSave(ctx)
	} else {
		var mut Mutator = MutateFunc(func(ctx context.Context, m Mutation) (Value, error) {
			mutation, ok := m.(*ShoppingItemMutation)
			if !ok {
				return nil, fmt.Errorf("unexpected mutation type %T", m)
			}
			if err = sic.check(); err != nil {
				return nil, err
			}
			sic.mutation = mutation
			if node, err = sic.sqlSave(ctx); err != nil {
				return nil, err
			}
			mutation.id = &node.ID
			mutation.done = true
			return node, err
		})
		for i := len(sic.hooks) - 1; i >= 0; i-- {
			if sic.hooks[i] == nil {
				return nil, fmt.Errorf("ent: uninitialized hook (forgotten import ent/runtime?)")
			}
			mut = sic.hooks[i](mut)
		}
		if _, err := mut.Mutate(ctx, sic.mutation); err != nil {
			return nil, err
		}
	}
	return node, err
}

// SaveX calls Save and panics if Save returns an error.
func (sic *ShoppingItemCreate) SaveX(ctx context.Context) *ShoppingItem {
	v, err := sic.Save(ctx)
	if err != nil {
		panic(err)
	}
	return v
}

// Exec executes the query.
func (sic *ShoppingItemCreate) Exec(ctx context.Context) error {
	_, err := sic.Save(ctx)
	return err
}

// ExecX is like Exec, but panics if an error occurs.
func (sic *ShoppingItemCreate) ExecX(ctx context.Context) {
	if err := sic.Exec(ctx); err != nil {
		panic(err)
	}
}

// defaults sets the default values of the builder before save.
func (sic *ShoppingItemCreate) defaults() {
	if _, ok := sic.mutation.CreateTime(); !ok {
		v := shoppingitem.DefaultCreateTime()
		sic.mutation.SetCreateTime(v)
	}
	if _, ok := sic.mutation.UpdateTime(); !ok {
		v := shoppingitem.DefaultUpdateTime()
		sic.mutation.SetUpdateTime(v)
	}
	if _, ok := sic.mutation.Units(); !ok {
		v := shoppingitem.DefaultUnits
		sic.mutation.SetUnits(v)
	}
}

// check runs all checks and user-defined validators on the builder.
func (sic *ShoppingItemCreate) check() error {
	if _, ok := sic.mutation.CreateTime(); !ok {
		return &ValidationError{Name: "create_time", err: errors.New(`ent: missing required field "create_time"`)}
	}
	if _, ok := sic.mutation.UpdateTime(); !ok {
		return &ValidationError{Name: "update_time", err: errors.New(`ent: missing required field "update_time"`)}
	}
	if _, ok := sic.mutation.Quantity(); !ok {
		return &ValidationError{Name: "quantity", err: errors.New(`ent: missing required field "quantity"`)}
	}
	if _, ok := sic.mutation.QuantityType(); !ok {
		return &ValidationError{Name: "quantity_type", err: errors.New(`ent: missing required field "quantity_type"`)}
	}
	if _, ok := sic.mutation.Units(); !ok {
		return &ValidationError{Name: "units", err: errors.New(`ent: missing required field "units"`)}
	}
	if _, ok := sic.mutation.PricePerUnit(); !ok {
		return &ValidationError{Name: "price_per_unit", err: errors.New(`ent: missing required field "price_per_unit"`)}
	}
	if _, ok := sic.mutation.ItemID(); !ok {
		return &ValidationError{Name: "item", err: errors.New("ent: missing required edge \"item\"")}
	}
	if _, ok := sic.mutation.ShoppingID(); !ok {
		return &ValidationError{Name: "shopping", err: errors.New("ent: missing required edge \"shopping\"")}
	}
	return nil
}

func (sic *ShoppingItemCreate) sqlSave(ctx context.Context) (*ShoppingItem, error) {
	_node, _spec := sic.createSpec()
	if err := sqlgraph.CreateNode(ctx, sic.driver, _spec); err != nil {
		if sqlgraph.IsConstraintError(err) {
			err = &ConstraintError{err.Error(), err}
		}
		return nil, err
	}
	id := _spec.ID.Value.(int64)
	_node.ID = int(id)
	return _node, nil
}

func (sic *ShoppingItemCreate) createSpec() (*ShoppingItem, *sqlgraph.CreateSpec) {
	var (
		_node = &ShoppingItem{config: sic.config}
		_spec = &sqlgraph.CreateSpec{
			Table: shoppingitem.Table,
			ID: &sqlgraph.FieldSpec{
				Type:   field.TypeInt,
				Column: shoppingitem.FieldID,
			},
		}
	)
	if value, ok := sic.mutation.CreateTime(); ok {
		_spec.Fields = append(_spec.Fields, &sqlgraph.FieldSpec{
			Type:   field.TypeTime,
			Value:  value,
			Column: shoppingitem.FieldCreateTime,
		})
		_node.CreateTime = value
	}
	if value, ok := sic.mutation.UpdateTime(); ok {
		_spec.Fields = append(_spec.Fields, &sqlgraph.FieldSpec{
			Type:   field.TypeTime,
			Value:  value,
			Column: shoppingitem.FieldUpdateTime,
		})
		_node.UpdateTime = value
	}
	if value, ok := sic.mutation.Quantity(); ok {
		_spec.Fields = append(_spec.Fields, &sqlgraph.FieldSpec{
			Type:   field.TypeFloat64,
			Value:  value,
			Column: shoppingitem.FieldQuantity,
		})
		_node.Quantity = value
	}
	if value, ok := sic.mutation.QuantityType(); ok {
		_spec.Fields = append(_spec.Fields, &sqlgraph.FieldSpec{
			Type:   field.TypeString,
			Value:  value,
			Column: shoppingitem.FieldQuantityType,
		})
		_node.QuantityType = value
	}
	if value, ok := sic.mutation.Units(); ok {
		_spec.Fields = append(_spec.Fields, &sqlgraph.FieldSpec{
			Type:   field.TypeInt,
			Value:  value,
			Column: shoppingitem.FieldUnits,
		})
		_node.Units = value
	}
	if value, ok := sic.mutation.Brand(); ok {
		_spec.Fields = append(_spec.Fields, &sqlgraph.FieldSpec{
			Type:   field.TypeString,
			Value:  value,
			Column: shoppingitem.FieldBrand,
		})
		_node.Brand = value
	}
	if value, ok := sic.mutation.PricePerUnit(); ok {
		_spec.Fields = append(_spec.Fields, &sqlgraph.FieldSpec{
			Type:   field.TypeFloat64,
			Value:  value,
			Column: shoppingitem.FieldPricePerUnit,
		})
		_node.PricePerUnit = value
	}
	if nodes := sic.mutation.ItemIDs(); len(nodes) > 0 {
		edge := &sqlgraph.EdgeSpec{
			Rel:     sqlgraph.M2O,
			Inverse: true,
			Table:   shoppingitem.ItemTable,
			Columns: []string{shoppingitem.ItemColumn},
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
		_node.item_purchases = &nodes[0]
		_spec.Edges = append(_spec.Edges, edge)
	}
	if nodes := sic.mutation.ShoppingIDs(); len(nodes) > 0 {
		edge := &sqlgraph.EdgeSpec{
			Rel:     sqlgraph.M2O,
			Inverse: true,
			Table:   shoppingitem.ShoppingTable,
			Columns: []string{shoppingitem.ShoppingColumn},
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
		_node.shopping_items = &nodes[0]
		_spec.Edges = append(_spec.Edges, edge)
	}
	return _node, _spec
}

// ShoppingItemCreateBulk is the builder for creating many ShoppingItem entities in bulk.
type ShoppingItemCreateBulk struct {
	config
	builders []*ShoppingItemCreate
}

// Save creates the ShoppingItem entities in the database.
func (sicb *ShoppingItemCreateBulk) Save(ctx context.Context) ([]*ShoppingItem, error) {
	specs := make([]*sqlgraph.CreateSpec, len(sicb.builders))
	nodes := make([]*ShoppingItem, len(sicb.builders))
	mutators := make([]Mutator, len(sicb.builders))
	for i := range sicb.builders {
		func(i int, root context.Context) {
			builder := sicb.builders[i]
			builder.defaults()
			var mut Mutator = MutateFunc(func(ctx context.Context, m Mutation) (Value, error) {
				mutation, ok := m.(*ShoppingItemMutation)
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
					_, err = mutators[i+1].Mutate(root, sicb.builders[i+1].mutation)
				} else {
					spec := &sqlgraph.BatchCreateSpec{Nodes: specs}
					// Invoke the actual operation on the latest mutation in the chain.
					if err = sqlgraph.BatchCreate(ctx, sicb.driver, spec); err != nil {
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
		if _, err := mutators[0].Mutate(ctx, sicb.builders[0].mutation); err != nil {
			return nil, err
		}
	}
	return nodes, nil
}

// SaveX is like Save, but panics if an error occurs.
func (sicb *ShoppingItemCreateBulk) SaveX(ctx context.Context) []*ShoppingItem {
	v, err := sicb.Save(ctx)
	if err != nil {
		panic(err)
	}
	return v
}

// Exec executes the query.
func (sicb *ShoppingItemCreateBulk) Exec(ctx context.Context) error {
	_, err := sicb.Save(ctx)
	return err
}

// ExecX is like Exec, but panics if an error occurs.
func (sicb *ShoppingItemCreateBulk) ExecX(ctx context.Context) {
	if err := sicb.Exec(ctx); err != nil {
		panic(err)
	}
}