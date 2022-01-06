// Code generated by entc, DO NOT EDIT.

package ent

import (
	"context"
	"errors"
	"fmt"
	"math"

	"entgo.io/ent/dialect/sql"
	"entgo.io/ent/dialect/sql/sqlgraph"
	"entgo.io/ent/schema/field"
	"github.com/kingzbauer/shilingi/app-engine/ent/predicate"
	"github.com/kingzbauer/shilingi/app-engine/ent/shoppingitem"
)

// ShoppingItemQuery is the builder for querying ShoppingItem entities.
type ShoppingItemQuery struct {
	config
	limit      *int
	offset     *int
	unique     *bool
	order      []OrderFunc
	fields     []string
	predicates []predicate.ShoppingItem
	// intermediate query (i.e. traversal path).
	sql  *sql.Selector
	path func(context.Context) (*sql.Selector, error)
}

// Where adds a new predicate for the ShoppingItemQuery builder.
func (siq *ShoppingItemQuery) Where(ps ...predicate.ShoppingItem) *ShoppingItemQuery {
	siq.predicates = append(siq.predicates, ps...)
	return siq
}

// Limit adds a limit step to the query.
func (siq *ShoppingItemQuery) Limit(limit int) *ShoppingItemQuery {
	siq.limit = &limit
	return siq
}

// Offset adds an offset step to the query.
func (siq *ShoppingItemQuery) Offset(offset int) *ShoppingItemQuery {
	siq.offset = &offset
	return siq
}

// Unique configures the query builder to filter duplicate records on query.
// By default, unique is set to true, and can be disabled using this method.
func (siq *ShoppingItemQuery) Unique(unique bool) *ShoppingItemQuery {
	siq.unique = &unique
	return siq
}

// Order adds an order step to the query.
func (siq *ShoppingItemQuery) Order(o ...OrderFunc) *ShoppingItemQuery {
	siq.order = append(siq.order, o...)
	return siq
}

// First returns the first ShoppingItem entity from the query.
// Returns a *NotFoundError when no ShoppingItem was found.
func (siq *ShoppingItemQuery) First(ctx context.Context) (*ShoppingItem, error) {
	nodes, err := siq.Limit(1).All(ctx)
	if err != nil {
		return nil, err
	}
	if len(nodes) == 0 {
		return nil, &NotFoundError{shoppingitem.Label}
	}
	return nodes[0], nil
}

// FirstX is like First, but panics if an error occurs.
func (siq *ShoppingItemQuery) FirstX(ctx context.Context) *ShoppingItem {
	node, err := siq.First(ctx)
	if err != nil && !IsNotFound(err) {
		panic(err)
	}
	return node
}

// FirstID returns the first ShoppingItem ID from the query.
// Returns a *NotFoundError when no ShoppingItem ID was found.
func (siq *ShoppingItemQuery) FirstID(ctx context.Context) (id int, err error) {
	var ids []int
	if ids, err = siq.Limit(1).IDs(ctx); err != nil {
		return
	}
	if len(ids) == 0 {
		err = &NotFoundError{shoppingitem.Label}
		return
	}
	return ids[0], nil
}

// FirstIDX is like FirstID, but panics if an error occurs.
func (siq *ShoppingItemQuery) FirstIDX(ctx context.Context) int {
	id, err := siq.FirstID(ctx)
	if err != nil && !IsNotFound(err) {
		panic(err)
	}
	return id
}

// Only returns a single ShoppingItem entity found by the query, ensuring it only returns one.
// Returns a *NotSingularError when exactly one ShoppingItem entity is not found.
// Returns a *NotFoundError when no ShoppingItem entities are found.
func (siq *ShoppingItemQuery) Only(ctx context.Context) (*ShoppingItem, error) {
	nodes, err := siq.Limit(2).All(ctx)
	if err != nil {
		return nil, err
	}
	switch len(nodes) {
	case 1:
		return nodes[0], nil
	case 0:
		return nil, &NotFoundError{shoppingitem.Label}
	default:
		return nil, &NotSingularError{shoppingitem.Label}
	}
}

// OnlyX is like Only, but panics if an error occurs.
func (siq *ShoppingItemQuery) OnlyX(ctx context.Context) *ShoppingItem {
	node, err := siq.Only(ctx)
	if err != nil {
		panic(err)
	}
	return node
}

// OnlyID is like Only, but returns the only ShoppingItem ID in the query.
// Returns a *NotSingularError when exactly one ShoppingItem ID is not found.
// Returns a *NotFoundError when no entities are found.
func (siq *ShoppingItemQuery) OnlyID(ctx context.Context) (id int, err error) {
	var ids []int
	if ids, err = siq.Limit(2).IDs(ctx); err != nil {
		return
	}
	switch len(ids) {
	case 1:
		id = ids[0]
	case 0:
		err = &NotFoundError{shoppingitem.Label}
	default:
		err = &NotSingularError{shoppingitem.Label}
	}
	return
}

// OnlyIDX is like OnlyID, but panics if an error occurs.
func (siq *ShoppingItemQuery) OnlyIDX(ctx context.Context) int {
	id, err := siq.OnlyID(ctx)
	if err != nil {
		panic(err)
	}
	return id
}

// All executes the query and returns a list of ShoppingItems.
func (siq *ShoppingItemQuery) All(ctx context.Context) ([]*ShoppingItem, error) {
	if err := siq.prepareQuery(ctx); err != nil {
		return nil, err
	}
	return siq.sqlAll(ctx)
}

// AllX is like All, but panics if an error occurs.
func (siq *ShoppingItemQuery) AllX(ctx context.Context) []*ShoppingItem {
	nodes, err := siq.All(ctx)
	if err != nil {
		panic(err)
	}
	return nodes
}

// IDs executes the query and returns a list of ShoppingItem IDs.
func (siq *ShoppingItemQuery) IDs(ctx context.Context) ([]int, error) {
	var ids []int
	if err := siq.Select(shoppingitem.FieldID).Scan(ctx, &ids); err != nil {
		return nil, err
	}
	return ids, nil
}

// IDsX is like IDs, but panics if an error occurs.
func (siq *ShoppingItemQuery) IDsX(ctx context.Context) []int {
	ids, err := siq.IDs(ctx)
	if err != nil {
		panic(err)
	}
	return ids
}

// Count returns the count of the given query.
func (siq *ShoppingItemQuery) Count(ctx context.Context) (int, error) {
	if err := siq.prepareQuery(ctx); err != nil {
		return 0, err
	}
	return siq.sqlCount(ctx)
}

// CountX is like Count, but panics if an error occurs.
func (siq *ShoppingItemQuery) CountX(ctx context.Context) int {
	count, err := siq.Count(ctx)
	if err != nil {
		panic(err)
	}
	return count
}

// Exist returns true if the query has elements in the graph.
func (siq *ShoppingItemQuery) Exist(ctx context.Context) (bool, error) {
	if err := siq.prepareQuery(ctx); err != nil {
		return false, err
	}
	return siq.sqlExist(ctx)
}

// ExistX is like Exist, but panics if an error occurs.
func (siq *ShoppingItemQuery) ExistX(ctx context.Context) bool {
	exist, err := siq.Exist(ctx)
	if err != nil {
		panic(err)
	}
	return exist
}

// Clone returns a duplicate of the ShoppingItemQuery builder, including all associated steps. It can be
// used to prepare common query builders and use them differently after the clone is made.
func (siq *ShoppingItemQuery) Clone() *ShoppingItemQuery {
	if siq == nil {
		return nil
	}
	return &ShoppingItemQuery{
		config:     siq.config,
		limit:      siq.limit,
		offset:     siq.offset,
		order:      append([]OrderFunc{}, siq.order...),
		predicates: append([]predicate.ShoppingItem{}, siq.predicates...),
		// clone intermediate query.
		sql:  siq.sql.Clone(),
		path: siq.path,
	}
}

// GroupBy is used to group vertices by one or more fields/columns.
// It is often used with aggregate functions, like: count, max, mean, min, sum.
func (siq *ShoppingItemQuery) GroupBy(field string, fields ...string) *ShoppingItemGroupBy {
	group := &ShoppingItemGroupBy{config: siq.config}
	group.fields = append([]string{field}, fields...)
	group.path = func(ctx context.Context) (prev *sql.Selector, err error) {
		if err := siq.prepareQuery(ctx); err != nil {
			return nil, err
		}
		return siq.sqlQuery(ctx), nil
	}
	return group
}

// Select allows the selection one or more fields/columns for the given query,
// instead of selecting all fields in the entity.
func (siq *ShoppingItemQuery) Select(fields ...string) *ShoppingItemSelect {
	siq.fields = append(siq.fields, fields...)
	return &ShoppingItemSelect{ShoppingItemQuery: siq}
}

func (siq *ShoppingItemQuery) prepareQuery(ctx context.Context) error {
	for _, f := range siq.fields {
		if !shoppingitem.ValidColumn(f) {
			return &ValidationError{Name: f, err: fmt.Errorf("ent: invalid field %q for query", f)}
		}
	}
	if siq.path != nil {
		prev, err := siq.path(ctx)
		if err != nil {
			return err
		}
		siq.sql = prev
	}
	return nil
}

func (siq *ShoppingItemQuery) sqlAll(ctx context.Context) ([]*ShoppingItem, error) {
	var (
		nodes = []*ShoppingItem{}
		_spec = siq.querySpec()
	)
	_spec.ScanValues = func(columns []string) ([]interface{}, error) {
		node := &ShoppingItem{config: siq.config}
		nodes = append(nodes, node)
		return node.scanValues(columns)
	}
	_spec.Assign = func(columns []string, values []interface{}) error {
		if len(nodes) == 0 {
			return fmt.Errorf("ent: Assign called without calling ScanValues")
		}
		node := nodes[len(nodes)-1]
		return node.assignValues(columns, values)
	}
	if err := sqlgraph.QueryNodes(ctx, siq.driver, _spec); err != nil {
		return nil, err
	}
	if len(nodes) == 0 {
		return nodes, nil
	}
	return nodes, nil
}

func (siq *ShoppingItemQuery) sqlCount(ctx context.Context) (int, error) {
	_spec := siq.querySpec()
	return sqlgraph.CountNodes(ctx, siq.driver, _spec)
}

func (siq *ShoppingItemQuery) sqlExist(ctx context.Context) (bool, error) {
	n, err := siq.sqlCount(ctx)
	if err != nil {
		return false, fmt.Errorf("ent: check existence: %w", err)
	}
	return n > 0, nil
}

func (siq *ShoppingItemQuery) querySpec() *sqlgraph.QuerySpec {
	_spec := &sqlgraph.QuerySpec{
		Node: &sqlgraph.NodeSpec{
			Table:   shoppingitem.Table,
			Columns: shoppingitem.Columns,
			ID: &sqlgraph.FieldSpec{
				Type:   field.TypeInt,
				Column: shoppingitem.FieldID,
			},
		},
		From:   siq.sql,
		Unique: true,
	}
	if unique := siq.unique; unique != nil {
		_spec.Unique = *unique
	}
	if fields := siq.fields; len(fields) > 0 {
		_spec.Node.Columns = make([]string, 0, len(fields))
		_spec.Node.Columns = append(_spec.Node.Columns, shoppingitem.FieldID)
		for i := range fields {
			if fields[i] != shoppingitem.FieldID {
				_spec.Node.Columns = append(_spec.Node.Columns, fields[i])
			}
		}
	}
	if ps := siq.predicates; len(ps) > 0 {
		_spec.Predicate = func(selector *sql.Selector) {
			for i := range ps {
				ps[i](selector)
			}
		}
	}
	if limit := siq.limit; limit != nil {
		_spec.Limit = *limit
	}
	if offset := siq.offset; offset != nil {
		_spec.Offset = *offset
	}
	if ps := siq.order; len(ps) > 0 {
		_spec.Order = func(selector *sql.Selector) {
			for i := range ps {
				ps[i](selector)
			}
		}
	}
	return _spec
}

func (siq *ShoppingItemQuery) sqlQuery(ctx context.Context) *sql.Selector {
	builder := sql.Dialect(siq.driver.Dialect())
	t1 := builder.Table(shoppingitem.Table)
	columns := siq.fields
	if len(columns) == 0 {
		columns = shoppingitem.Columns
	}
	selector := builder.Select(t1.Columns(columns...)...).From(t1)
	if siq.sql != nil {
		selector = siq.sql
		selector.Select(selector.Columns(columns...)...)
	}
	for _, p := range siq.predicates {
		p(selector)
	}
	for _, p := range siq.order {
		p(selector)
	}
	if offset := siq.offset; offset != nil {
		// limit is mandatory for offset clause. We start
		// with default value, and override it below if needed.
		selector.Offset(*offset).Limit(math.MaxInt32)
	}
	if limit := siq.limit; limit != nil {
		selector.Limit(*limit)
	}
	return selector
}

// ShoppingItemGroupBy is the group-by builder for ShoppingItem entities.
type ShoppingItemGroupBy struct {
	config
	fields []string
	fns    []AggregateFunc
	// intermediate query (i.e. traversal path).
	sql  *sql.Selector
	path func(context.Context) (*sql.Selector, error)
}

// Aggregate adds the given aggregation functions to the group-by query.
func (sigb *ShoppingItemGroupBy) Aggregate(fns ...AggregateFunc) *ShoppingItemGroupBy {
	sigb.fns = append(sigb.fns, fns...)
	return sigb
}

// Scan applies the group-by query and scans the result into the given value.
func (sigb *ShoppingItemGroupBy) Scan(ctx context.Context, v interface{}) error {
	query, err := sigb.path(ctx)
	if err != nil {
		return err
	}
	sigb.sql = query
	return sigb.sqlScan(ctx, v)
}

// ScanX is like Scan, but panics if an error occurs.
func (sigb *ShoppingItemGroupBy) ScanX(ctx context.Context, v interface{}) {
	if err := sigb.Scan(ctx, v); err != nil {
		panic(err)
	}
}

// Strings returns list of strings from group-by.
// It is only allowed when executing a group-by query with one field.
func (sigb *ShoppingItemGroupBy) Strings(ctx context.Context) ([]string, error) {
	if len(sigb.fields) > 1 {
		return nil, errors.New("ent: ShoppingItemGroupBy.Strings is not achievable when grouping more than 1 field")
	}
	var v []string
	if err := sigb.Scan(ctx, &v); err != nil {
		return nil, err
	}
	return v, nil
}

// StringsX is like Strings, but panics if an error occurs.
func (sigb *ShoppingItemGroupBy) StringsX(ctx context.Context) []string {
	v, err := sigb.Strings(ctx)
	if err != nil {
		panic(err)
	}
	return v
}

// String returns a single string from a group-by query.
// It is only allowed when executing a group-by query with one field.
func (sigb *ShoppingItemGroupBy) String(ctx context.Context) (_ string, err error) {
	var v []string
	if v, err = sigb.Strings(ctx); err != nil {
		return
	}
	switch len(v) {
	case 1:
		return v[0], nil
	case 0:
		err = &NotFoundError{shoppingitem.Label}
	default:
		err = fmt.Errorf("ent: ShoppingItemGroupBy.Strings returned %d results when one was expected", len(v))
	}
	return
}

// StringX is like String, but panics if an error occurs.
func (sigb *ShoppingItemGroupBy) StringX(ctx context.Context) string {
	v, err := sigb.String(ctx)
	if err != nil {
		panic(err)
	}
	return v
}

// Ints returns list of ints from group-by.
// It is only allowed when executing a group-by query with one field.
func (sigb *ShoppingItemGroupBy) Ints(ctx context.Context) ([]int, error) {
	if len(sigb.fields) > 1 {
		return nil, errors.New("ent: ShoppingItemGroupBy.Ints is not achievable when grouping more than 1 field")
	}
	var v []int
	if err := sigb.Scan(ctx, &v); err != nil {
		return nil, err
	}
	return v, nil
}

// IntsX is like Ints, but panics if an error occurs.
func (sigb *ShoppingItemGroupBy) IntsX(ctx context.Context) []int {
	v, err := sigb.Ints(ctx)
	if err != nil {
		panic(err)
	}
	return v
}

// Int returns a single int from a group-by query.
// It is only allowed when executing a group-by query with one field.
func (sigb *ShoppingItemGroupBy) Int(ctx context.Context) (_ int, err error) {
	var v []int
	if v, err = sigb.Ints(ctx); err != nil {
		return
	}
	switch len(v) {
	case 1:
		return v[0], nil
	case 0:
		err = &NotFoundError{shoppingitem.Label}
	default:
		err = fmt.Errorf("ent: ShoppingItemGroupBy.Ints returned %d results when one was expected", len(v))
	}
	return
}

// IntX is like Int, but panics if an error occurs.
func (sigb *ShoppingItemGroupBy) IntX(ctx context.Context) int {
	v, err := sigb.Int(ctx)
	if err != nil {
		panic(err)
	}
	return v
}

// Float64s returns list of float64s from group-by.
// It is only allowed when executing a group-by query with one field.
func (sigb *ShoppingItemGroupBy) Float64s(ctx context.Context) ([]float64, error) {
	if len(sigb.fields) > 1 {
		return nil, errors.New("ent: ShoppingItemGroupBy.Float64s is not achievable when grouping more than 1 field")
	}
	var v []float64
	if err := sigb.Scan(ctx, &v); err != nil {
		return nil, err
	}
	return v, nil
}

// Float64sX is like Float64s, but panics if an error occurs.
func (sigb *ShoppingItemGroupBy) Float64sX(ctx context.Context) []float64 {
	v, err := sigb.Float64s(ctx)
	if err != nil {
		panic(err)
	}
	return v
}

// Float64 returns a single float64 from a group-by query.
// It is only allowed when executing a group-by query with one field.
func (sigb *ShoppingItemGroupBy) Float64(ctx context.Context) (_ float64, err error) {
	var v []float64
	if v, err = sigb.Float64s(ctx); err != nil {
		return
	}
	switch len(v) {
	case 1:
		return v[0], nil
	case 0:
		err = &NotFoundError{shoppingitem.Label}
	default:
		err = fmt.Errorf("ent: ShoppingItemGroupBy.Float64s returned %d results when one was expected", len(v))
	}
	return
}

// Float64X is like Float64, but panics if an error occurs.
func (sigb *ShoppingItemGroupBy) Float64X(ctx context.Context) float64 {
	v, err := sigb.Float64(ctx)
	if err != nil {
		panic(err)
	}
	return v
}

// Bools returns list of bools from group-by.
// It is only allowed when executing a group-by query with one field.
func (sigb *ShoppingItemGroupBy) Bools(ctx context.Context) ([]bool, error) {
	if len(sigb.fields) > 1 {
		return nil, errors.New("ent: ShoppingItemGroupBy.Bools is not achievable when grouping more than 1 field")
	}
	var v []bool
	if err := sigb.Scan(ctx, &v); err != nil {
		return nil, err
	}
	return v, nil
}

// BoolsX is like Bools, but panics if an error occurs.
func (sigb *ShoppingItemGroupBy) BoolsX(ctx context.Context) []bool {
	v, err := sigb.Bools(ctx)
	if err != nil {
		panic(err)
	}
	return v
}

// Bool returns a single bool from a group-by query.
// It is only allowed when executing a group-by query with one field.
func (sigb *ShoppingItemGroupBy) Bool(ctx context.Context) (_ bool, err error) {
	var v []bool
	if v, err = sigb.Bools(ctx); err != nil {
		return
	}
	switch len(v) {
	case 1:
		return v[0], nil
	case 0:
		err = &NotFoundError{shoppingitem.Label}
	default:
		err = fmt.Errorf("ent: ShoppingItemGroupBy.Bools returned %d results when one was expected", len(v))
	}
	return
}

// BoolX is like Bool, but panics if an error occurs.
func (sigb *ShoppingItemGroupBy) BoolX(ctx context.Context) bool {
	v, err := sigb.Bool(ctx)
	if err != nil {
		panic(err)
	}
	return v
}

func (sigb *ShoppingItemGroupBy) sqlScan(ctx context.Context, v interface{}) error {
	for _, f := range sigb.fields {
		if !shoppingitem.ValidColumn(f) {
			return &ValidationError{Name: f, err: fmt.Errorf("invalid field %q for group-by", f)}
		}
	}
	selector := sigb.sqlQuery()
	if err := selector.Err(); err != nil {
		return err
	}
	rows := &sql.Rows{}
	query, args := selector.Query()
	if err := sigb.driver.Query(ctx, query, args, rows); err != nil {
		return err
	}
	defer rows.Close()
	return sql.ScanSlice(rows, v)
}

func (sigb *ShoppingItemGroupBy) sqlQuery() *sql.Selector {
	selector := sigb.sql.Select()
	aggregation := make([]string, 0, len(sigb.fns))
	for _, fn := range sigb.fns {
		aggregation = append(aggregation, fn(selector))
	}
	// If no columns were selected in a custom aggregation function, the default
	// selection is the fields used for "group-by", and the aggregation functions.
	if len(selector.SelectedColumns()) == 0 {
		columns := make([]string, 0, len(sigb.fields)+len(sigb.fns))
		for _, f := range sigb.fields {
			columns = append(columns, selector.C(f))
		}
		for _, c := range aggregation {
			columns = append(columns, c)
		}
		selector.Select(columns...)
	}
	return selector.GroupBy(selector.Columns(sigb.fields...)...)
}

// ShoppingItemSelect is the builder for selecting fields of ShoppingItem entities.
type ShoppingItemSelect struct {
	*ShoppingItemQuery
	// intermediate query (i.e. traversal path).
	sql *sql.Selector
}

// Scan applies the selector query and scans the result into the given value.
func (sis *ShoppingItemSelect) Scan(ctx context.Context, v interface{}) error {
	if err := sis.prepareQuery(ctx); err != nil {
		return err
	}
	sis.sql = sis.ShoppingItemQuery.sqlQuery(ctx)
	return sis.sqlScan(ctx, v)
}

// ScanX is like Scan, but panics if an error occurs.
func (sis *ShoppingItemSelect) ScanX(ctx context.Context, v interface{}) {
	if err := sis.Scan(ctx, v); err != nil {
		panic(err)
	}
}

// Strings returns list of strings from a selector. It is only allowed when selecting one field.
func (sis *ShoppingItemSelect) Strings(ctx context.Context) ([]string, error) {
	if len(sis.fields) > 1 {
		return nil, errors.New("ent: ShoppingItemSelect.Strings is not achievable when selecting more than 1 field")
	}
	var v []string
	if err := sis.Scan(ctx, &v); err != nil {
		return nil, err
	}
	return v, nil
}

// StringsX is like Strings, but panics if an error occurs.
func (sis *ShoppingItemSelect) StringsX(ctx context.Context) []string {
	v, err := sis.Strings(ctx)
	if err != nil {
		panic(err)
	}
	return v
}

// String returns a single string from a selector. It is only allowed when selecting one field.
func (sis *ShoppingItemSelect) String(ctx context.Context) (_ string, err error) {
	var v []string
	if v, err = sis.Strings(ctx); err != nil {
		return
	}
	switch len(v) {
	case 1:
		return v[0], nil
	case 0:
		err = &NotFoundError{shoppingitem.Label}
	default:
		err = fmt.Errorf("ent: ShoppingItemSelect.Strings returned %d results when one was expected", len(v))
	}
	return
}

// StringX is like String, but panics if an error occurs.
func (sis *ShoppingItemSelect) StringX(ctx context.Context) string {
	v, err := sis.String(ctx)
	if err != nil {
		panic(err)
	}
	return v
}

// Ints returns list of ints from a selector. It is only allowed when selecting one field.
func (sis *ShoppingItemSelect) Ints(ctx context.Context) ([]int, error) {
	if len(sis.fields) > 1 {
		return nil, errors.New("ent: ShoppingItemSelect.Ints is not achievable when selecting more than 1 field")
	}
	var v []int
	if err := sis.Scan(ctx, &v); err != nil {
		return nil, err
	}
	return v, nil
}

// IntsX is like Ints, but panics if an error occurs.
func (sis *ShoppingItemSelect) IntsX(ctx context.Context) []int {
	v, err := sis.Ints(ctx)
	if err != nil {
		panic(err)
	}
	return v
}

// Int returns a single int from a selector. It is only allowed when selecting one field.
func (sis *ShoppingItemSelect) Int(ctx context.Context) (_ int, err error) {
	var v []int
	if v, err = sis.Ints(ctx); err != nil {
		return
	}
	switch len(v) {
	case 1:
		return v[0], nil
	case 0:
		err = &NotFoundError{shoppingitem.Label}
	default:
		err = fmt.Errorf("ent: ShoppingItemSelect.Ints returned %d results when one was expected", len(v))
	}
	return
}

// IntX is like Int, but panics if an error occurs.
func (sis *ShoppingItemSelect) IntX(ctx context.Context) int {
	v, err := sis.Int(ctx)
	if err != nil {
		panic(err)
	}
	return v
}

// Float64s returns list of float64s from a selector. It is only allowed when selecting one field.
func (sis *ShoppingItemSelect) Float64s(ctx context.Context) ([]float64, error) {
	if len(sis.fields) > 1 {
		return nil, errors.New("ent: ShoppingItemSelect.Float64s is not achievable when selecting more than 1 field")
	}
	var v []float64
	if err := sis.Scan(ctx, &v); err != nil {
		return nil, err
	}
	return v, nil
}

// Float64sX is like Float64s, but panics if an error occurs.
func (sis *ShoppingItemSelect) Float64sX(ctx context.Context) []float64 {
	v, err := sis.Float64s(ctx)
	if err != nil {
		panic(err)
	}
	return v
}

// Float64 returns a single float64 from a selector. It is only allowed when selecting one field.
func (sis *ShoppingItemSelect) Float64(ctx context.Context) (_ float64, err error) {
	var v []float64
	if v, err = sis.Float64s(ctx); err != nil {
		return
	}
	switch len(v) {
	case 1:
		return v[0], nil
	case 0:
		err = &NotFoundError{shoppingitem.Label}
	default:
		err = fmt.Errorf("ent: ShoppingItemSelect.Float64s returned %d results when one was expected", len(v))
	}
	return
}

// Float64X is like Float64, but panics if an error occurs.
func (sis *ShoppingItemSelect) Float64X(ctx context.Context) float64 {
	v, err := sis.Float64(ctx)
	if err != nil {
		panic(err)
	}
	return v
}

// Bools returns list of bools from a selector. It is only allowed when selecting one field.
func (sis *ShoppingItemSelect) Bools(ctx context.Context) ([]bool, error) {
	if len(sis.fields) > 1 {
		return nil, errors.New("ent: ShoppingItemSelect.Bools is not achievable when selecting more than 1 field")
	}
	var v []bool
	if err := sis.Scan(ctx, &v); err != nil {
		return nil, err
	}
	return v, nil
}

// BoolsX is like Bools, but panics if an error occurs.
func (sis *ShoppingItemSelect) BoolsX(ctx context.Context) []bool {
	v, err := sis.Bools(ctx)
	if err != nil {
		panic(err)
	}
	return v
}

// Bool returns a single bool from a selector. It is only allowed when selecting one field.
func (sis *ShoppingItemSelect) Bool(ctx context.Context) (_ bool, err error) {
	var v []bool
	if v, err = sis.Bools(ctx); err != nil {
		return
	}
	switch len(v) {
	case 1:
		return v[0], nil
	case 0:
		err = &NotFoundError{shoppingitem.Label}
	default:
		err = fmt.Errorf("ent: ShoppingItemSelect.Bools returned %d results when one was expected", len(v))
	}
	return
}

// BoolX is like Bool, but panics if an error occurs.
func (sis *ShoppingItemSelect) BoolX(ctx context.Context) bool {
	v, err := sis.Bool(ctx)
	if err != nil {
		panic(err)
	}
	return v
}

func (sis *ShoppingItemSelect) sqlScan(ctx context.Context, v interface{}) error {
	rows := &sql.Rows{}
	query, args := sis.sql.Query()
	if err := sis.driver.Query(ctx, query, args, rows); err != nil {
		return err
	}
	defer rows.Close()
	return sql.ScanSlice(rows, v)
}
