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
	"github.com/kingzbauer/shilingi/app-engine/ent/sublabel"
	"github.com/kingzbauer/shilingi/app-engine/ent/tag"
)

// SubLabelCreate is the builder for creating a SubLabel entity.
type SubLabelCreate struct {
	config
	mutation *SubLabelMutation
	hooks    []Hook
}

// SetCreateTime sets the "create_time" field.
func (slc *SubLabelCreate) SetCreateTime(t time.Time) *SubLabelCreate {
	slc.mutation.SetCreateTime(t)
	return slc
}

// SetNillableCreateTime sets the "create_time" field if the given value is not nil.
func (slc *SubLabelCreate) SetNillableCreateTime(t *time.Time) *SubLabelCreate {
	if t != nil {
		slc.SetCreateTime(*t)
	}
	return slc
}

// SetUpdateTime sets the "update_time" field.
func (slc *SubLabelCreate) SetUpdateTime(t time.Time) *SubLabelCreate {
	slc.mutation.SetUpdateTime(t)
	return slc
}

// SetNillableUpdateTime sets the "update_time" field if the given value is not nil.
func (slc *SubLabelCreate) SetNillableUpdateTime(t *time.Time) *SubLabelCreate {
	if t != nil {
		slc.SetUpdateTime(*t)
	}
	return slc
}

// SetName sets the "name" field.
func (slc *SubLabelCreate) SetName(s string) *SubLabelCreate {
	slc.mutation.SetName(s)
	return slc
}

// SetParentID sets the "parent" edge to the Tag entity by ID.
func (slc *SubLabelCreate) SetParentID(id int) *SubLabelCreate {
	slc.mutation.SetParentID(id)
	return slc
}

// SetNillableParentID sets the "parent" edge to the Tag entity by ID if the given value is not nil.
func (slc *SubLabelCreate) SetNillableParentID(id *int) *SubLabelCreate {
	if id != nil {
		slc = slc.SetParentID(*id)
	}
	return slc
}

// SetParent sets the "parent" edge to the Tag entity.
func (slc *SubLabelCreate) SetParent(t *Tag) *SubLabelCreate {
	return slc.SetParentID(t.ID)
}

// AddItemIDs adds the "items" edge to the Item entity by IDs.
func (slc *SubLabelCreate) AddItemIDs(ids ...int) *SubLabelCreate {
	slc.mutation.AddItemIDs(ids...)
	return slc
}

// AddItems adds the "items" edges to the Item entity.
func (slc *SubLabelCreate) AddItems(i ...*Item) *SubLabelCreate {
	ids := make([]int, len(i))
	for j := range i {
		ids[j] = i[j].ID
	}
	return slc.AddItemIDs(ids...)
}

// Mutation returns the SubLabelMutation object of the builder.
func (slc *SubLabelCreate) Mutation() *SubLabelMutation {
	return slc.mutation
}

// Save creates the SubLabel in the database.
func (slc *SubLabelCreate) Save(ctx context.Context) (*SubLabel, error) {
	var (
		err  error
		node *SubLabel
	)
	slc.defaults()
	if len(slc.hooks) == 0 {
		if err = slc.check(); err != nil {
			return nil, err
		}
		node, err = slc.sqlSave(ctx)
	} else {
		var mut Mutator = MutateFunc(func(ctx context.Context, m Mutation) (Value, error) {
			mutation, ok := m.(*SubLabelMutation)
			if !ok {
				return nil, fmt.Errorf("unexpected mutation type %T", m)
			}
			if err = slc.check(); err != nil {
				return nil, err
			}
			slc.mutation = mutation
			if node, err = slc.sqlSave(ctx); err != nil {
				return nil, err
			}
			mutation.id = &node.ID
			mutation.done = true
			return node, err
		})
		for i := len(slc.hooks) - 1; i >= 0; i-- {
			if slc.hooks[i] == nil {
				return nil, fmt.Errorf("ent: uninitialized hook (forgotten import ent/runtime?)")
			}
			mut = slc.hooks[i](mut)
		}
		if _, err := mut.Mutate(ctx, slc.mutation); err != nil {
			return nil, err
		}
	}
	return node, err
}

// SaveX calls Save and panics if Save returns an error.
func (slc *SubLabelCreate) SaveX(ctx context.Context) *SubLabel {
	v, err := slc.Save(ctx)
	if err != nil {
		panic(err)
	}
	return v
}

// Exec executes the query.
func (slc *SubLabelCreate) Exec(ctx context.Context) error {
	_, err := slc.Save(ctx)
	return err
}

// ExecX is like Exec, but panics if an error occurs.
func (slc *SubLabelCreate) ExecX(ctx context.Context) {
	if err := slc.Exec(ctx); err != nil {
		panic(err)
	}
}

// defaults sets the default values of the builder before save.
func (slc *SubLabelCreate) defaults() {
	if _, ok := slc.mutation.CreateTime(); !ok {
		v := sublabel.DefaultCreateTime()
		slc.mutation.SetCreateTime(v)
	}
	if _, ok := slc.mutation.UpdateTime(); !ok {
		v := sublabel.DefaultUpdateTime()
		slc.mutation.SetUpdateTime(v)
	}
}

// check runs all checks and user-defined validators on the builder.
func (slc *SubLabelCreate) check() error {
	if _, ok := slc.mutation.CreateTime(); !ok {
		return &ValidationError{Name: "create_time", err: errors.New(`ent: missing required field "create_time"`)}
	}
	if _, ok := slc.mutation.UpdateTime(); !ok {
		return &ValidationError{Name: "update_time", err: errors.New(`ent: missing required field "update_time"`)}
	}
	if _, ok := slc.mutation.Name(); !ok {
		return &ValidationError{Name: "name", err: errors.New(`ent: missing required field "name"`)}
	}
	return nil
}

func (slc *SubLabelCreate) sqlSave(ctx context.Context) (*SubLabel, error) {
	_node, _spec := slc.createSpec()
	if err := sqlgraph.CreateNode(ctx, slc.driver, _spec); err != nil {
		if sqlgraph.IsConstraintError(err) {
			err = &ConstraintError{err.Error(), err}
		}
		return nil, err
	}
	id := _spec.ID.Value.(int64)
	_node.ID = int(id)
	return _node, nil
}

func (slc *SubLabelCreate) createSpec() (*SubLabel, *sqlgraph.CreateSpec) {
	var (
		_node = &SubLabel{config: slc.config}
		_spec = &sqlgraph.CreateSpec{
			Table: sublabel.Table,
			ID: &sqlgraph.FieldSpec{
				Type:   field.TypeInt,
				Column: sublabel.FieldID,
			},
		}
	)
	if value, ok := slc.mutation.CreateTime(); ok {
		_spec.Fields = append(_spec.Fields, &sqlgraph.FieldSpec{
			Type:   field.TypeTime,
			Value:  value,
			Column: sublabel.FieldCreateTime,
		})
		_node.CreateTime = value
	}
	if value, ok := slc.mutation.UpdateTime(); ok {
		_spec.Fields = append(_spec.Fields, &sqlgraph.FieldSpec{
			Type:   field.TypeTime,
			Value:  value,
			Column: sublabel.FieldUpdateTime,
		})
		_node.UpdateTime = value
	}
	if value, ok := slc.mutation.Name(); ok {
		_spec.Fields = append(_spec.Fields, &sqlgraph.FieldSpec{
			Type:   field.TypeString,
			Value:  value,
			Column: sublabel.FieldName,
		})
		_node.Name = value
	}
	if nodes := slc.mutation.ParentIDs(); len(nodes) > 0 {
		edge := &sqlgraph.EdgeSpec{
			Rel:     sqlgraph.M2O,
			Inverse: true,
			Table:   sublabel.ParentTable,
			Columns: []string{sublabel.ParentColumn},
			Bidi:    false,
			Target: &sqlgraph.EdgeTarget{
				IDSpec: &sqlgraph.FieldSpec{
					Type:   field.TypeInt,
					Column: tag.FieldID,
				},
			},
		}
		for _, k := range nodes {
			edge.Target.Nodes = append(edge.Target.Nodes, k)
		}
		_node.tag_children = &nodes[0]
		_spec.Edges = append(_spec.Edges, edge)
	}
	if nodes := slc.mutation.ItemsIDs(); len(nodes) > 0 {
		edge := &sqlgraph.EdgeSpec{
			Rel:     sqlgraph.O2M,
			Inverse: false,
			Table:   sublabel.ItemsTable,
			Columns: []string{sublabel.ItemsColumn},
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
		_spec.Edges = append(_spec.Edges, edge)
	}
	return _node, _spec
}

// SubLabelCreateBulk is the builder for creating many SubLabel entities in bulk.
type SubLabelCreateBulk struct {
	config
	builders []*SubLabelCreate
}

// Save creates the SubLabel entities in the database.
func (slcb *SubLabelCreateBulk) Save(ctx context.Context) ([]*SubLabel, error) {
	specs := make([]*sqlgraph.CreateSpec, len(slcb.builders))
	nodes := make([]*SubLabel, len(slcb.builders))
	mutators := make([]Mutator, len(slcb.builders))
	for i := range slcb.builders {
		func(i int, root context.Context) {
			builder := slcb.builders[i]
			builder.defaults()
			var mut Mutator = MutateFunc(func(ctx context.Context, m Mutation) (Value, error) {
				mutation, ok := m.(*SubLabelMutation)
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
					_, err = mutators[i+1].Mutate(root, slcb.builders[i+1].mutation)
				} else {
					spec := &sqlgraph.BatchCreateSpec{Nodes: specs}
					// Invoke the actual operation on the latest mutation in the chain.
					if err = sqlgraph.BatchCreate(ctx, slcb.driver, spec); err != nil {
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
		if _, err := mutators[0].Mutate(ctx, slcb.builders[0].mutation); err != nil {
			return nil, err
		}
	}
	return nodes, nil
}

// SaveX is like Save, but panics if an error occurs.
func (slcb *SubLabelCreateBulk) SaveX(ctx context.Context) []*SubLabel {
	v, err := slcb.Save(ctx)
	if err != nil {
		panic(err)
	}
	return v
}

// Exec executes the query.
func (slcb *SubLabelCreateBulk) Exec(ctx context.Context) error {
	_, err := slcb.Save(ctx)
	return err
}

// ExecX is like Exec, but panics if an error occurs.
func (slcb *SubLabelCreateBulk) ExecX(ctx context.Context) {
	if err := slcb.Exec(ctx); err != nil {
		panic(err)
	}
}
