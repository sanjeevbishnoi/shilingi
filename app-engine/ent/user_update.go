// Code generated by entc, DO NOT EDIT.

package ent

import (
	"context"
	"fmt"

	"entgo.io/ent/dialect/sql"
	"entgo.io/ent/dialect/sql/sqlgraph"
	"entgo.io/ent/schema/field"
	"github.com/kingzbauer/shilingi/app-engine/ent/accountinvite"
	"github.com/kingzbauer/shilingi/app-engine/ent/accountmember"
	"github.com/kingzbauer/shilingi/app-engine/ent/predicate"
	"github.com/kingzbauer/shilingi/app-engine/ent/user"
)

// UserUpdate is the builder for updating User entities.
type UserUpdate struct {
	config
	hooks    []Hook
	mutation *UserMutation
}

// Where appends a list predicates to the UserUpdate builder.
func (uu *UserUpdate) Where(ps ...predicate.User) *UserUpdate {
	uu.mutation.Where(ps...)
	return uu
}

// SetExternalID sets the "external_id" field.
func (uu *UserUpdate) SetExternalID(s string) *UserUpdate {
	uu.mutation.SetExternalID(s)
	return uu
}

// SetNillableExternalID sets the "external_id" field if the given value is not nil.
func (uu *UserUpdate) SetNillableExternalID(s *string) *UserUpdate {
	if s != nil {
		uu.SetExternalID(*s)
	}
	return uu
}

// ClearExternalID clears the value of the "external_id" field.
func (uu *UserUpdate) ClearExternalID() *UserUpdate {
	uu.mutation.ClearExternalID()
	return uu
}

// SetFirstName sets the "first_name" field.
func (uu *UserUpdate) SetFirstName(s string) *UserUpdate {
	uu.mutation.SetFirstName(s)
	return uu
}

// SetNillableFirstName sets the "first_name" field if the given value is not nil.
func (uu *UserUpdate) SetNillableFirstName(s *string) *UserUpdate {
	if s != nil {
		uu.SetFirstName(*s)
	}
	return uu
}

// ClearFirstName clears the value of the "first_name" field.
func (uu *UserUpdate) ClearFirstName() *UserUpdate {
	uu.mutation.ClearFirstName()
	return uu
}

// SetOtherNames sets the "other_names" field.
func (uu *UserUpdate) SetOtherNames(s string) *UserUpdate {
	uu.mutation.SetOtherNames(s)
	return uu
}

// SetNillableOtherNames sets the "other_names" field if the given value is not nil.
func (uu *UserUpdate) SetNillableOtherNames(s *string) *UserUpdate {
	if s != nil {
		uu.SetOtherNames(*s)
	}
	return uu
}

// ClearOtherNames clears the value of the "other_names" field.
func (uu *UserUpdate) ClearOtherNames() *UserUpdate {
	uu.mutation.ClearOtherNames()
	return uu
}

// SetEmail sets the "email" field.
func (uu *UserUpdate) SetEmail(s string) *UserUpdate {
	uu.mutation.SetEmail(s)
	return uu
}

// SetIsEmailVerified sets the "is_email_verified" field.
func (uu *UserUpdate) SetIsEmailVerified(b bool) *UserUpdate {
	uu.mutation.SetIsEmailVerified(b)
	return uu
}

// SetExternalSource sets the "external_source" field.
func (uu *UserUpdate) SetExternalSource(us user.ExternalSource) *UserUpdate {
	uu.mutation.SetExternalSource(us)
	return uu
}

// SetNillableExternalSource sets the "external_source" field if the given value is not nil.
func (uu *UserUpdate) SetNillableExternalSource(us *user.ExternalSource) *UserUpdate {
	if us != nil {
		uu.SetExternalSource(*us)
	}
	return uu
}

// AddInviteIDs adds the "invites" edge to the AccountInvite entity by IDs.
func (uu *UserUpdate) AddInviteIDs(ids ...int) *UserUpdate {
	uu.mutation.AddInviteIDs(ids...)
	return uu
}

// AddInvites adds the "invites" edges to the AccountInvite entity.
func (uu *UserUpdate) AddInvites(a ...*AccountInvite) *UserUpdate {
	ids := make([]int, len(a))
	for i := range a {
		ids[i] = a[i].ID
	}
	return uu.AddInviteIDs(ids...)
}

// AddMembershipIDs adds the "memberships" edge to the AccountMember entity by IDs.
func (uu *UserUpdate) AddMembershipIDs(ids ...int) *UserUpdate {
	uu.mutation.AddMembershipIDs(ids...)
	return uu
}

// AddMemberships adds the "memberships" edges to the AccountMember entity.
func (uu *UserUpdate) AddMemberships(a ...*AccountMember) *UserUpdate {
	ids := make([]int, len(a))
	for i := range a {
		ids[i] = a[i].ID
	}
	return uu.AddMembershipIDs(ids...)
}

// Mutation returns the UserMutation object of the builder.
func (uu *UserUpdate) Mutation() *UserMutation {
	return uu.mutation
}

// ClearInvites clears all "invites" edges to the AccountInvite entity.
func (uu *UserUpdate) ClearInvites() *UserUpdate {
	uu.mutation.ClearInvites()
	return uu
}

// RemoveInviteIDs removes the "invites" edge to AccountInvite entities by IDs.
func (uu *UserUpdate) RemoveInviteIDs(ids ...int) *UserUpdate {
	uu.mutation.RemoveInviteIDs(ids...)
	return uu
}

// RemoveInvites removes "invites" edges to AccountInvite entities.
func (uu *UserUpdate) RemoveInvites(a ...*AccountInvite) *UserUpdate {
	ids := make([]int, len(a))
	for i := range a {
		ids[i] = a[i].ID
	}
	return uu.RemoveInviteIDs(ids...)
}

// ClearMemberships clears all "memberships" edges to the AccountMember entity.
func (uu *UserUpdate) ClearMemberships() *UserUpdate {
	uu.mutation.ClearMemberships()
	return uu
}

// RemoveMembershipIDs removes the "memberships" edge to AccountMember entities by IDs.
func (uu *UserUpdate) RemoveMembershipIDs(ids ...int) *UserUpdate {
	uu.mutation.RemoveMembershipIDs(ids...)
	return uu
}

// RemoveMemberships removes "memberships" edges to AccountMember entities.
func (uu *UserUpdate) RemoveMemberships(a ...*AccountMember) *UserUpdate {
	ids := make([]int, len(a))
	for i := range a {
		ids[i] = a[i].ID
	}
	return uu.RemoveMembershipIDs(ids...)
}

// Save executes the query and returns the number of nodes affected by the update operation.
func (uu *UserUpdate) Save(ctx context.Context) (int, error) {
	var (
		err      error
		affected int
	)
	uu.defaults()
	if len(uu.hooks) == 0 {
		if err = uu.check(); err != nil {
			return 0, err
		}
		affected, err = uu.sqlSave(ctx)
	} else {
		var mut Mutator = MutateFunc(func(ctx context.Context, m Mutation) (Value, error) {
			mutation, ok := m.(*UserMutation)
			if !ok {
				return nil, fmt.Errorf("unexpected mutation type %T", m)
			}
			if err = uu.check(); err != nil {
				return 0, err
			}
			uu.mutation = mutation
			affected, err = uu.sqlSave(ctx)
			mutation.done = true
			return affected, err
		})
		for i := len(uu.hooks) - 1; i >= 0; i-- {
			if uu.hooks[i] == nil {
				return 0, fmt.Errorf("ent: uninitialized hook (forgotten import ent/runtime?)")
			}
			mut = uu.hooks[i](mut)
		}
		if _, err := mut.Mutate(ctx, uu.mutation); err != nil {
			return 0, err
		}
	}
	return affected, err
}

// SaveX is like Save, but panics if an error occurs.
func (uu *UserUpdate) SaveX(ctx context.Context) int {
	affected, err := uu.Save(ctx)
	if err != nil {
		panic(err)
	}
	return affected
}

// Exec executes the query.
func (uu *UserUpdate) Exec(ctx context.Context) error {
	_, err := uu.Save(ctx)
	return err
}

// ExecX is like Exec, but panics if an error occurs.
func (uu *UserUpdate) ExecX(ctx context.Context) {
	if err := uu.Exec(ctx); err != nil {
		panic(err)
	}
}

// defaults sets the default values of the builder before save.
func (uu *UserUpdate) defaults() {
	if _, ok := uu.mutation.UpdateTime(); !ok {
		v := user.UpdateDefaultUpdateTime()
		uu.mutation.SetUpdateTime(v)
	}
}

// check runs all checks and user-defined validators on the builder.
func (uu *UserUpdate) check() error {
	if v, ok := uu.mutation.ExternalSource(); ok {
		if err := user.ExternalSourceValidator(v); err != nil {
			return &ValidationError{Name: "external_source", err: fmt.Errorf("ent: validator failed for field \"external_source\": %w", err)}
		}
	}
	return nil
}

func (uu *UserUpdate) sqlSave(ctx context.Context) (n int, err error) {
	_spec := &sqlgraph.UpdateSpec{
		Node: &sqlgraph.NodeSpec{
			Table:   user.Table,
			Columns: user.Columns,
			ID: &sqlgraph.FieldSpec{
				Type:   field.TypeInt,
				Column: user.FieldID,
			},
		},
	}
	if ps := uu.mutation.predicates; len(ps) > 0 {
		_spec.Predicate = func(selector *sql.Selector) {
			for i := range ps {
				ps[i](selector)
			}
		}
	}
	if value, ok := uu.mutation.UpdateTime(); ok {
		_spec.Fields.Set = append(_spec.Fields.Set, &sqlgraph.FieldSpec{
			Type:   field.TypeTime,
			Value:  value,
			Column: user.FieldUpdateTime,
		})
	}
	if value, ok := uu.mutation.ExternalID(); ok {
		_spec.Fields.Set = append(_spec.Fields.Set, &sqlgraph.FieldSpec{
			Type:   field.TypeString,
			Value:  value,
			Column: user.FieldExternalID,
		})
	}
	if uu.mutation.ExternalIDCleared() {
		_spec.Fields.Clear = append(_spec.Fields.Clear, &sqlgraph.FieldSpec{
			Type:   field.TypeString,
			Column: user.FieldExternalID,
		})
	}
	if value, ok := uu.mutation.FirstName(); ok {
		_spec.Fields.Set = append(_spec.Fields.Set, &sqlgraph.FieldSpec{
			Type:   field.TypeString,
			Value:  value,
			Column: user.FieldFirstName,
		})
	}
	if uu.mutation.FirstNameCleared() {
		_spec.Fields.Clear = append(_spec.Fields.Clear, &sqlgraph.FieldSpec{
			Type:   field.TypeString,
			Column: user.FieldFirstName,
		})
	}
	if value, ok := uu.mutation.OtherNames(); ok {
		_spec.Fields.Set = append(_spec.Fields.Set, &sqlgraph.FieldSpec{
			Type:   field.TypeString,
			Value:  value,
			Column: user.FieldOtherNames,
		})
	}
	if uu.mutation.OtherNamesCleared() {
		_spec.Fields.Clear = append(_spec.Fields.Clear, &sqlgraph.FieldSpec{
			Type:   field.TypeString,
			Column: user.FieldOtherNames,
		})
	}
	if value, ok := uu.mutation.Email(); ok {
		_spec.Fields.Set = append(_spec.Fields.Set, &sqlgraph.FieldSpec{
			Type:   field.TypeString,
			Value:  value,
			Column: user.FieldEmail,
		})
	}
	if value, ok := uu.mutation.IsEmailVerified(); ok {
		_spec.Fields.Set = append(_spec.Fields.Set, &sqlgraph.FieldSpec{
			Type:   field.TypeBool,
			Value:  value,
			Column: user.FieldIsEmailVerified,
		})
	}
	if value, ok := uu.mutation.ExternalSource(); ok {
		_spec.Fields.Set = append(_spec.Fields.Set, &sqlgraph.FieldSpec{
			Type:   field.TypeEnum,
			Value:  value,
			Column: user.FieldExternalSource,
		})
	}
	if uu.mutation.InvitesCleared() {
		edge := &sqlgraph.EdgeSpec{
			Rel:     sqlgraph.O2M,
			Inverse: false,
			Table:   user.InvitesTable,
			Columns: []string{user.InvitesColumn},
			Bidi:    false,
			Target: &sqlgraph.EdgeTarget{
				IDSpec: &sqlgraph.FieldSpec{
					Type:   field.TypeInt,
					Column: accountinvite.FieldID,
				},
			},
		}
		_spec.Edges.Clear = append(_spec.Edges.Clear, edge)
	}
	if nodes := uu.mutation.RemovedInvitesIDs(); len(nodes) > 0 && !uu.mutation.InvitesCleared() {
		edge := &sqlgraph.EdgeSpec{
			Rel:     sqlgraph.O2M,
			Inverse: false,
			Table:   user.InvitesTable,
			Columns: []string{user.InvitesColumn},
			Bidi:    false,
			Target: &sqlgraph.EdgeTarget{
				IDSpec: &sqlgraph.FieldSpec{
					Type:   field.TypeInt,
					Column: accountinvite.FieldID,
				},
			},
		}
		for _, k := range nodes {
			edge.Target.Nodes = append(edge.Target.Nodes, k)
		}
		_spec.Edges.Clear = append(_spec.Edges.Clear, edge)
	}
	if nodes := uu.mutation.InvitesIDs(); len(nodes) > 0 {
		edge := &sqlgraph.EdgeSpec{
			Rel:     sqlgraph.O2M,
			Inverse: false,
			Table:   user.InvitesTable,
			Columns: []string{user.InvitesColumn},
			Bidi:    false,
			Target: &sqlgraph.EdgeTarget{
				IDSpec: &sqlgraph.FieldSpec{
					Type:   field.TypeInt,
					Column: accountinvite.FieldID,
				},
			},
		}
		for _, k := range nodes {
			edge.Target.Nodes = append(edge.Target.Nodes, k)
		}
		_spec.Edges.Add = append(_spec.Edges.Add, edge)
	}
	if uu.mutation.MembershipsCleared() {
		edge := &sqlgraph.EdgeSpec{
			Rel:     sqlgraph.O2M,
			Inverse: false,
			Table:   user.MembershipsTable,
			Columns: []string{user.MembershipsColumn},
			Bidi:    false,
			Target: &sqlgraph.EdgeTarget{
				IDSpec: &sqlgraph.FieldSpec{
					Type:   field.TypeInt,
					Column: accountmember.FieldID,
				},
			},
		}
		_spec.Edges.Clear = append(_spec.Edges.Clear, edge)
	}
	if nodes := uu.mutation.RemovedMembershipsIDs(); len(nodes) > 0 && !uu.mutation.MembershipsCleared() {
		edge := &sqlgraph.EdgeSpec{
			Rel:     sqlgraph.O2M,
			Inverse: false,
			Table:   user.MembershipsTable,
			Columns: []string{user.MembershipsColumn},
			Bidi:    false,
			Target: &sqlgraph.EdgeTarget{
				IDSpec: &sqlgraph.FieldSpec{
					Type:   field.TypeInt,
					Column: accountmember.FieldID,
				},
			},
		}
		for _, k := range nodes {
			edge.Target.Nodes = append(edge.Target.Nodes, k)
		}
		_spec.Edges.Clear = append(_spec.Edges.Clear, edge)
	}
	if nodes := uu.mutation.MembershipsIDs(); len(nodes) > 0 {
		edge := &sqlgraph.EdgeSpec{
			Rel:     sqlgraph.O2M,
			Inverse: false,
			Table:   user.MembershipsTable,
			Columns: []string{user.MembershipsColumn},
			Bidi:    false,
			Target: &sqlgraph.EdgeTarget{
				IDSpec: &sqlgraph.FieldSpec{
					Type:   field.TypeInt,
					Column: accountmember.FieldID,
				},
			},
		}
		for _, k := range nodes {
			edge.Target.Nodes = append(edge.Target.Nodes, k)
		}
		_spec.Edges.Add = append(_spec.Edges.Add, edge)
	}
	if n, err = sqlgraph.UpdateNodes(ctx, uu.driver, _spec); err != nil {
		if _, ok := err.(*sqlgraph.NotFoundError); ok {
			err = &NotFoundError{user.Label}
		} else if sqlgraph.IsConstraintError(err) {
			err = &ConstraintError{err.Error(), err}
		}
		return 0, err
	}
	return n, nil
}

// UserUpdateOne is the builder for updating a single User entity.
type UserUpdateOne struct {
	config
	fields   []string
	hooks    []Hook
	mutation *UserMutation
}

// SetExternalID sets the "external_id" field.
func (uuo *UserUpdateOne) SetExternalID(s string) *UserUpdateOne {
	uuo.mutation.SetExternalID(s)
	return uuo
}

// SetNillableExternalID sets the "external_id" field if the given value is not nil.
func (uuo *UserUpdateOne) SetNillableExternalID(s *string) *UserUpdateOne {
	if s != nil {
		uuo.SetExternalID(*s)
	}
	return uuo
}

// ClearExternalID clears the value of the "external_id" field.
func (uuo *UserUpdateOne) ClearExternalID() *UserUpdateOne {
	uuo.mutation.ClearExternalID()
	return uuo
}

// SetFirstName sets the "first_name" field.
func (uuo *UserUpdateOne) SetFirstName(s string) *UserUpdateOne {
	uuo.mutation.SetFirstName(s)
	return uuo
}

// SetNillableFirstName sets the "first_name" field if the given value is not nil.
func (uuo *UserUpdateOne) SetNillableFirstName(s *string) *UserUpdateOne {
	if s != nil {
		uuo.SetFirstName(*s)
	}
	return uuo
}

// ClearFirstName clears the value of the "first_name" field.
func (uuo *UserUpdateOne) ClearFirstName() *UserUpdateOne {
	uuo.mutation.ClearFirstName()
	return uuo
}

// SetOtherNames sets the "other_names" field.
func (uuo *UserUpdateOne) SetOtherNames(s string) *UserUpdateOne {
	uuo.mutation.SetOtherNames(s)
	return uuo
}

// SetNillableOtherNames sets the "other_names" field if the given value is not nil.
func (uuo *UserUpdateOne) SetNillableOtherNames(s *string) *UserUpdateOne {
	if s != nil {
		uuo.SetOtherNames(*s)
	}
	return uuo
}

// ClearOtherNames clears the value of the "other_names" field.
func (uuo *UserUpdateOne) ClearOtherNames() *UserUpdateOne {
	uuo.mutation.ClearOtherNames()
	return uuo
}

// SetEmail sets the "email" field.
func (uuo *UserUpdateOne) SetEmail(s string) *UserUpdateOne {
	uuo.mutation.SetEmail(s)
	return uuo
}

// SetIsEmailVerified sets the "is_email_verified" field.
func (uuo *UserUpdateOne) SetIsEmailVerified(b bool) *UserUpdateOne {
	uuo.mutation.SetIsEmailVerified(b)
	return uuo
}

// SetExternalSource sets the "external_source" field.
func (uuo *UserUpdateOne) SetExternalSource(us user.ExternalSource) *UserUpdateOne {
	uuo.mutation.SetExternalSource(us)
	return uuo
}

// SetNillableExternalSource sets the "external_source" field if the given value is not nil.
func (uuo *UserUpdateOne) SetNillableExternalSource(us *user.ExternalSource) *UserUpdateOne {
	if us != nil {
		uuo.SetExternalSource(*us)
	}
	return uuo
}

// AddInviteIDs adds the "invites" edge to the AccountInvite entity by IDs.
func (uuo *UserUpdateOne) AddInviteIDs(ids ...int) *UserUpdateOne {
	uuo.mutation.AddInviteIDs(ids...)
	return uuo
}

// AddInvites adds the "invites" edges to the AccountInvite entity.
func (uuo *UserUpdateOne) AddInvites(a ...*AccountInvite) *UserUpdateOne {
	ids := make([]int, len(a))
	for i := range a {
		ids[i] = a[i].ID
	}
	return uuo.AddInviteIDs(ids...)
}

// AddMembershipIDs adds the "memberships" edge to the AccountMember entity by IDs.
func (uuo *UserUpdateOne) AddMembershipIDs(ids ...int) *UserUpdateOne {
	uuo.mutation.AddMembershipIDs(ids...)
	return uuo
}

// AddMemberships adds the "memberships" edges to the AccountMember entity.
func (uuo *UserUpdateOne) AddMemberships(a ...*AccountMember) *UserUpdateOne {
	ids := make([]int, len(a))
	for i := range a {
		ids[i] = a[i].ID
	}
	return uuo.AddMembershipIDs(ids...)
}

// Mutation returns the UserMutation object of the builder.
func (uuo *UserUpdateOne) Mutation() *UserMutation {
	return uuo.mutation
}

// ClearInvites clears all "invites" edges to the AccountInvite entity.
func (uuo *UserUpdateOne) ClearInvites() *UserUpdateOne {
	uuo.mutation.ClearInvites()
	return uuo
}

// RemoveInviteIDs removes the "invites" edge to AccountInvite entities by IDs.
func (uuo *UserUpdateOne) RemoveInviteIDs(ids ...int) *UserUpdateOne {
	uuo.mutation.RemoveInviteIDs(ids...)
	return uuo
}

// RemoveInvites removes "invites" edges to AccountInvite entities.
func (uuo *UserUpdateOne) RemoveInvites(a ...*AccountInvite) *UserUpdateOne {
	ids := make([]int, len(a))
	for i := range a {
		ids[i] = a[i].ID
	}
	return uuo.RemoveInviteIDs(ids...)
}

// ClearMemberships clears all "memberships" edges to the AccountMember entity.
func (uuo *UserUpdateOne) ClearMemberships() *UserUpdateOne {
	uuo.mutation.ClearMemberships()
	return uuo
}

// RemoveMembershipIDs removes the "memberships" edge to AccountMember entities by IDs.
func (uuo *UserUpdateOne) RemoveMembershipIDs(ids ...int) *UserUpdateOne {
	uuo.mutation.RemoveMembershipIDs(ids...)
	return uuo
}

// RemoveMemberships removes "memberships" edges to AccountMember entities.
func (uuo *UserUpdateOne) RemoveMemberships(a ...*AccountMember) *UserUpdateOne {
	ids := make([]int, len(a))
	for i := range a {
		ids[i] = a[i].ID
	}
	return uuo.RemoveMembershipIDs(ids...)
}

// Select allows selecting one or more fields (columns) of the returned entity.
// The default is selecting all fields defined in the entity schema.
func (uuo *UserUpdateOne) Select(field string, fields ...string) *UserUpdateOne {
	uuo.fields = append([]string{field}, fields...)
	return uuo
}

// Save executes the query and returns the updated User entity.
func (uuo *UserUpdateOne) Save(ctx context.Context) (*User, error) {
	var (
		err  error
		node *User
	)
	uuo.defaults()
	if len(uuo.hooks) == 0 {
		if err = uuo.check(); err != nil {
			return nil, err
		}
		node, err = uuo.sqlSave(ctx)
	} else {
		var mut Mutator = MutateFunc(func(ctx context.Context, m Mutation) (Value, error) {
			mutation, ok := m.(*UserMutation)
			if !ok {
				return nil, fmt.Errorf("unexpected mutation type %T", m)
			}
			if err = uuo.check(); err != nil {
				return nil, err
			}
			uuo.mutation = mutation
			node, err = uuo.sqlSave(ctx)
			mutation.done = true
			return node, err
		})
		for i := len(uuo.hooks) - 1; i >= 0; i-- {
			if uuo.hooks[i] == nil {
				return nil, fmt.Errorf("ent: uninitialized hook (forgotten import ent/runtime?)")
			}
			mut = uuo.hooks[i](mut)
		}
		if _, err := mut.Mutate(ctx, uuo.mutation); err != nil {
			return nil, err
		}
	}
	return node, err
}

// SaveX is like Save, but panics if an error occurs.
func (uuo *UserUpdateOne) SaveX(ctx context.Context) *User {
	node, err := uuo.Save(ctx)
	if err != nil {
		panic(err)
	}
	return node
}

// Exec executes the query on the entity.
func (uuo *UserUpdateOne) Exec(ctx context.Context) error {
	_, err := uuo.Save(ctx)
	return err
}

// ExecX is like Exec, but panics if an error occurs.
func (uuo *UserUpdateOne) ExecX(ctx context.Context) {
	if err := uuo.Exec(ctx); err != nil {
		panic(err)
	}
}

// defaults sets the default values of the builder before save.
func (uuo *UserUpdateOne) defaults() {
	if _, ok := uuo.mutation.UpdateTime(); !ok {
		v := user.UpdateDefaultUpdateTime()
		uuo.mutation.SetUpdateTime(v)
	}
}

// check runs all checks and user-defined validators on the builder.
func (uuo *UserUpdateOne) check() error {
	if v, ok := uuo.mutation.ExternalSource(); ok {
		if err := user.ExternalSourceValidator(v); err != nil {
			return &ValidationError{Name: "external_source", err: fmt.Errorf("ent: validator failed for field \"external_source\": %w", err)}
		}
	}
	return nil
}

func (uuo *UserUpdateOne) sqlSave(ctx context.Context) (_node *User, err error) {
	_spec := &sqlgraph.UpdateSpec{
		Node: &sqlgraph.NodeSpec{
			Table:   user.Table,
			Columns: user.Columns,
			ID: &sqlgraph.FieldSpec{
				Type:   field.TypeInt,
				Column: user.FieldID,
			},
		},
	}
	id, ok := uuo.mutation.ID()
	if !ok {
		return nil, &ValidationError{Name: "ID", err: fmt.Errorf("missing User.ID for update")}
	}
	_spec.Node.ID.Value = id
	if fields := uuo.fields; len(fields) > 0 {
		_spec.Node.Columns = make([]string, 0, len(fields))
		_spec.Node.Columns = append(_spec.Node.Columns, user.FieldID)
		for _, f := range fields {
			if !user.ValidColumn(f) {
				return nil, &ValidationError{Name: f, err: fmt.Errorf("ent: invalid field %q for query", f)}
			}
			if f != user.FieldID {
				_spec.Node.Columns = append(_spec.Node.Columns, f)
			}
		}
	}
	if ps := uuo.mutation.predicates; len(ps) > 0 {
		_spec.Predicate = func(selector *sql.Selector) {
			for i := range ps {
				ps[i](selector)
			}
		}
	}
	if value, ok := uuo.mutation.UpdateTime(); ok {
		_spec.Fields.Set = append(_spec.Fields.Set, &sqlgraph.FieldSpec{
			Type:   field.TypeTime,
			Value:  value,
			Column: user.FieldUpdateTime,
		})
	}
	if value, ok := uuo.mutation.ExternalID(); ok {
		_spec.Fields.Set = append(_spec.Fields.Set, &sqlgraph.FieldSpec{
			Type:   field.TypeString,
			Value:  value,
			Column: user.FieldExternalID,
		})
	}
	if uuo.mutation.ExternalIDCleared() {
		_spec.Fields.Clear = append(_spec.Fields.Clear, &sqlgraph.FieldSpec{
			Type:   field.TypeString,
			Column: user.FieldExternalID,
		})
	}
	if value, ok := uuo.mutation.FirstName(); ok {
		_spec.Fields.Set = append(_spec.Fields.Set, &sqlgraph.FieldSpec{
			Type:   field.TypeString,
			Value:  value,
			Column: user.FieldFirstName,
		})
	}
	if uuo.mutation.FirstNameCleared() {
		_spec.Fields.Clear = append(_spec.Fields.Clear, &sqlgraph.FieldSpec{
			Type:   field.TypeString,
			Column: user.FieldFirstName,
		})
	}
	if value, ok := uuo.mutation.OtherNames(); ok {
		_spec.Fields.Set = append(_spec.Fields.Set, &sqlgraph.FieldSpec{
			Type:   field.TypeString,
			Value:  value,
			Column: user.FieldOtherNames,
		})
	}
	if uuo.mutation.OtherNamesCleared() {
		_spec.Fields.Clear = append(_spec.Fields.Clear, &sqlgraph.FieldSpec{
			Type:   field.TypeString,
			Column: user.FieldOtherNames,
		})
	}
	if value, ok := uuo.mutation.Email(); ok {
		_spec.Fields.Set = append(_spec.Fields.Set, &sqlgraph.FieldSpec{
			Type:   field.TypeString,
			Value:  value,
			Column: user.FieldEmail,
		})
	}
	if value, ok := uuo.mutation.IsEmailVerified(); ok {
		_spec.Fields.Set = append(_spec.Fields.Set, &sqlgraph.FieldSpec{
			Type:   field.TypeBool,
			Value:  value,
			Column: user.FieldIsEmailVerified,
		})
	}
	if value, ok := uuo.mutation.ExternalSource(); ok {
		_spec.Fields.Set = append(_spec.Fields.Set, &sqlgraph.FieldSpec{
			Type:   field.TypeEnum,
			Value:  value,
			Column: user.FieldExternalSource,
		})
	}
	if uuo.mutation.InvitesCleared() {
		edge := &sqlgraph.EdgeSpec{
			Rel:     sqlgraph.O2M,
			Inverse: false,
			Table:   user.InvitesTable,
			Columns: []string{user.InvitesColumn},
			Bidi:    false,
			Target: &sqlgraph.EdgeTarget{
				IDSpec: &sqlgraph.FieldSpec{
					Type:   field.TypeInt,
					Column: accountinvite.FieldID,
				},
			},
		}
		_spec.Edges.Clear = append(_spec.Edges.Clear, edge)
	}
	if nodes := uuo.mutation.RemovedInvitesIDs(); len(nodes) > 0 && !uuo.mutation.InvitesCleared() {
		edge := &sqlgraph.EdgeSpec{
			Rel:     sqlgraph.O2M,
			Inverse: false,
			Table:   user.InvitesTable,
			Columns: []string{user.InvitesColumn},
			Bidi:    false,
			Target: &sqlgraph.EdgeTarget{
				IDSpec: &sqlgraph.FieldSpec{
					Type:   field.TypeInt,
					Column: accountinvite.FieldID,
				},
			},
		}
		for _, k := range nodes {
			edge.Target.Nodes = append(edge.Target.Nodes, k)
		}
		_spec.Edges.Clear = append(_spec.Edges.Clear, edge)
	}
	if nodes := uuo.mutation.InvitesIDs(); len(nodes) > 0 {
		edge := &sqlgraph.EdgeSpec{
			Rel:     sqlgraph.O2M,
			Inverse: false,
			Table:   user.InvitesTable,
			Columns: []string{user.InvitesColumn},
			Bidi:    false,
			Target: &sqlgraph.EdgeTarget{
				IDSpec: &sqlgraph.FieldSpec{
					Type:   field.TypeInt,
					Column: accountinvite.FieldID,
				},
			},
		}
		for _, k := range nodes {
			edge.Target.Nodes = append(edge.Target.Nodes, k)
		}
		_spec.Edges.Add = append(_spec.Edges.Add, edge)
	}
	if uuo.mutation.MembershipsCleared() {
		edge := &sqlgraph.EdgeSpec{
			Rel:     sqlgraph.O2M,
			Inverse: false,
			Table:   user.MembershipsTable,
			Columns: []string{user.MembershipsColumn},
			Bidi:    false,
			Target: &sqlgraph.EdgeTarget{
				IDSpec: &sqlgraph.FieldSpec{
					Type:   field.TypeInt,
					Column: accountmember.FieldID,
				},
			},
		}
		_spec.Edges.Clear = append(_spec.Edges.Clear, edge)
	}
	if nodes := uuo.mutation.RemovedMembershipsIDs(); len(nodes) > 0 && !uuo.mutation.MembershipsCleared() {
		edge := &sqlgraph.EdgeSpec{
			Rel:     sqlgraph.O2M,
			Inverse: false,
			Table:   user.MembershipsTable,
			Columns: []string{user.MembershipsColumn},
			Bidi:    false,
			Target: &sqlgraph.EdgeTarget{
				IDSpec: &sqlgraph.FieldSpec{
					Type:   field.TypeInt,
					Column: accountmember.FieldID,
				},
			},
		}
		for _, k := range nodes {
			edge.Target.Nodes = append(edge.Target.Nodes, k)
		}
		_spec.Edges.Clear = append(_spec.Edges.Clear, edge)
	}
	if nodes := uuo.mutation.MembershipsIDs(); len(nodes) > 0 {
		edge := &sqlgraph.EdgeSpec{
			Rel:     sqlgraph.O2M,
			Inverse: false,
			Table:   user.MembershipsTable,
			Columns: []string{user.MembershipsColumn},
			Bidi:    false,
			Target: &sqlgraph.EdgeTarget{
				IDSpec: &sqlgraph.FieldSpec{
					Type:   field.TypeInt,
					Column: accountmember.FieldID,
				},
			},
		}
		for _, k := range nodes {
			edge.Target.Nodes = append(edge.Target.Nodes, k)
		}
		_spec.Edges.Add = append(_spec.Edges.Add, edge)
	}
	_node = &User{config: uuo.config}
	_spec.Assign = _node.assignValues
	_spec.ScanValues = _node.scanValues
	if err = sqlgraph.UpdateNode(ctx, uuo.driver, _spec); err != nil {
		if _, ok := err.(*sqlgraph.NotFoundError); ok {
			err = &NotFoundError{user.Label}
		} else if sqlgraph.IsConstraintError(err) {
			err = &ConstraintError{err.Error(), err}
		}
		return nil, err
	}
	return _node, nil
}
