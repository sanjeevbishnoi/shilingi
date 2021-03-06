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
	"github.com/kingzbauer/shilingi/app-engine/ent/item"
	"github.com/kingzbauer/shilingi/app-engine/ent/predicate"
	"github.com/kingzbauer/shilingi/app-engine/ent/shoppingitem"
	"github.com/kingzbauer/shilingi/app-engine/ent/shoppinglist"
	"github.com/kingzbauer/shilingi/app-engine/ent/shoppinglistitem"
)

// ShoppingListItemQuery is the builder for querying ShoppingListItem entities.
type ShoppingListItemQuery struct {
	config
	limit      *int
	offset     *int
	unique     *bool
	order      []OrderFunc
	fields     []string
	predicates []predicate.ShoppingListItem
	// eager-loading edges.
	withShoppingList *ShoppingListQuery
	withItem         *ItemQuery
	withPurchase     *ShoppingItemQuery
	withFKs          bool
	// intermediate query (i.e. traversal path).
	sql  *sql.Selector
	path func(context.Context) (*sql.Selector, error)
}

// Where adds a new predicate for the ShoppingListItemQuery builder.
func (sliq *ShoppingListItemQuery) Where(ps ...predicate.ShoppingListItem) *ShoppingListItemQuery {
	sliq.predicates = append(sliq.predicates, ps...)
	return sliq
}

// Limit adds a limit step to the query.
func (sliq *ShoppingListItemQuery) Limit(limit int) *ShoppingListItemQuery {
	sliq.limit = &limit
	return sliq
}

// Offset adds an offset step to the query.
func (sliq *ShoppingListItemQuery) Offset(offset int) *ShoppingListItemQuery {
	sliq.offset = &offset
	return sliq
}

// Unique configures the query builder to filter duplicate records on query.
// By default, unique is set to true, and can be disabled using this method.
func (sliq *ShoppingListItemQuery) Unique(unique bool) *ShoppingListItemQuery {
	sliq.unique = &unique
	return sliq
}

// Order adds an order step to the query.
func (sliq *ShoppingListItemQuery) Order(o ...OrderFunc) *ShoppingListItemQuery {
	sliq.order = append(sliq.order, o...)
	return sliq
}

// QueryShoppingList chains the current query on the "shoppingList" edge.
func (sliq *ShoppingListItemQuery) QueryShoppingList() *ShoppingListQuery {
	query := &ShoppingListQuery{config: sliq.config}
	query.path = func(ctx context.Context) (fromU *sql.Selector, err error) {
		if err := sliq.prepareQuery(ctx); err != nil {
			return nil, err
		}
		selector := sliq.sqlQuery(ctx)
		if err := selector.Err(); err != nil {
			return nil, err
		}
		step := sqlgraph.NewStep(
			sqlgraph.From(shoppinglistitem.Table, shoppinglistitem.FieldID, selector),
			sqlgraph.To(shoppinglist.Table, shoppinglist.FieldID),
			sqlgraph.Edge(sqlgraph.M2O, true, shoppinglistitem.ShoppingListTable, shoppinglistitem.ShoppingListColumn),
		)
		fromU = sqlgraph.SetNeighbors(sliq.driver.Dialect(), step)
		return fromU, nil
	}
	return query
}

// QueryItem chains the current query on the "item" edge.
func (sliq *ShoppingListItemQuery) QueryItem() *ItemQuery {
	query := &ItemQuery{config: sliq.config}
	query.path = func(ctx context.Context) (fromU *sql.Selector, err error) {
		if err := sliq.prepareQuery(ctx); err != nil {
			return nil, err
		}
		selector := sliq.sqlQuery(ctx)
		if err := selector.Err(); err != nil {
			return nil, err
		}
		step := sqlgraph.NewStep(
			sqlgraph.From(shoppinglistitem.Table, shoppinglistitem.FieldID, selector),
			sqlgraph.To(item.Table, item.FieldID),
			sqlgraph.Edge(sqlgraph.M2O, true, shoppinglistitem.ItemTable, shoppinglistitem.ItemColumn),
		)
		fromU = sqlgraph.SetNeighbors(sliq.driver.Dialect(), step)
		return fromU, nil
	}
	return query
}

// QueryPurchase chains the current query on the "purchase" edge.
func (sliq *ShoppingListItemQuery) QueryPurchase() *ShoppingItemQuery {
	query := &ShoppingItemQuery{config: sliq.config}
	query.path = func(ctx context.Context) (fromU *sql.Selector, err error) {
		if err := sliq.prepareQuery(ctx); err != nil {
			return nil, err
		}
		selector := sliq.sqlQuery(ctx)
		if err := selector.Err(); err != nil {
			return nil, err
		}
		step := sqlgraph.NewStep(
			sqlgraph.From(shoppinglistitem.Table, shoppinglistitem.FieldID, selector),
			sqlgraph.To(shoppingitem.Table, shoppingitem.FieldID),
			sqlgraph.Edge(sqlgraph.M2O, true, shoppinglistitem.PurchaseTable, shoppinglistitem.PurchaseColumn),
		)
		fromU = sqlgraph.SetNeighbors(sliq.driver.Dialect(), step)
		return fromU, nil
	}
	return query
}

// First returns the first ShoppingListItem entity from the query.
// Returns a *NotFoundError when no ShoppingListItem was found.
func (sliq *ShoppingListItemQuery) First(ctx context.Context) (*ShoppingListItem, error) {
	nodes, err := sliq.Limit(1).All(ctx)
	if err != nil {
		return nil, err
	}
	if len(nodes) == 0 {
		return nil, &NotFoundError{shoppinglistitem.Label}
	}
	return nodes[0], nil
}

// FirstX is like First, but panics if an error occurs.
func (sliq *ShoppingListItemQuery) FirstX(ctx context.Context) *ShoppingListItem {
	node, err := sliq.First(ctx)
	if err != nil && !IsNotFound(err) {
		panic(err)
	}
	return node
}

// FirstID returns the first ShoppingListItem ID from the query.
// Returns a *NotFoundError when no ShoppingListItem ID was found.
func (sliq *ShoppingListItemQuery) FirstID(ctx context.Context) (id int, err error) {
	var ids []int
	if ids, err = sliq.Limit(1).IDs(ctx); err != nil {
		return
	}
	if len(ids) == 0 {
		err = &NotFoundError{shoppinglistitem.Label}
		return
	}
	return ids[0], nil
}

// FirstIDX is like FirstID, but panics if an error occurs.
func (sliq *ShoppingListItemQuery) FirstIDX(ctx context.Context) int {
	id, err := sliq.FirstID(ctx)
	if err != nil && !IsNotFound(err) {
		panic(err)
	}
	return id
}

// Only returns a single ShoppingListItem entity found by the query, ensuring it only returns one.
// Returns a *NotSingularError when exactly one ShoppingListItem entity is not found.
// Returns a *NotFoundError when no ShoppingListItem entities are found.
func (sliq *ShoppingListItemQuery) Only(ctx context.Context) (*ShoppingListItem, error) {
	nodes, err := sliq.Limit(2).All(ctx)
	if err != nil {
		return nil, err
	}
	switch len(nodes) {
	case 1:
		return nodes[0], nil
	case 0:
		return nil, &NotFoundError{shoppinglistitem.Label}
	default:
		return nil, &NotSingularError{shoppinglistitem.Label}
	}
}

// OnlyX is like Only, but panics if an error occurs.
func (sliq *ShoppingListItemQuery) OnlyX(ctx context.Context) *ShoppingListItem {
	node, err := sliq.Only(ctx)
	if err != nil {
		panic(err)
	}
	return node
}

// OnlyID is like Only, but returns the only ShoppingListItem ID in the query.
// Returns a *NotSingularError when exactly one ShoppingListItem ID is not found.
// Returns a *NotFoundError when no entities are found.
func (sliq *ShoppingListItemQuery) OnlyID(ctx context.Context) (id int, err error) {
	var ids []int
	if ids, err = sliq.Limit(2).IDs(ctx); err != nil {
		return
	}
	switch len(ids) {
	case 1:
		id = ids[0]
	case 0:
		err = &NotFoundError{shoppinglistitem.Label}
	default:
		err = &NotSingularError{shoppinglistitem.Label}
	}
	return
}

// OnlyIDX is like OnlyID, but panics if an error occurs.
func (sliq *ShoppingListItemQuery) OnlyIDX(ctx context.Context) int {
	id, err := sliq.OnlyID(ctx)
	if err != nil {
		panic(err)
	}
	return id
}

// All executes the query and returns a list of ShoppingListItems.
func (sliq *ShoppingListItemQuery) All(ctx context.Context) ([]*ShoppingListItem, error) {
	if err := sliq.prepareQuery(ctx); err != nil {
		return nil, err
	}
	return sliq.sqlAll(ctx)
}

// AllX is like All, but panics if an error occurs.
func (sliq *ShoppingListItemQuery) AllX(ctx context.Context) []*ShoppingListItem {
	nodes, err := sliq.All(ctx)
	if err != nil {
		panic(err)
	}
	return nodes
}

// IDs executes the query and returns a list of ShoppingListItem IDs.
func (sliq *ShoppingListItemQuery) IDs(ctx context.Context) ([]int, error) {
	var ids []int
	if err := sliq.Select(shoppinglistitem.FieldID).Scan(ctx, &ids); err != nil {
		return nil, err
	}
	return ids, nil
}

// IDsX is like IDs, but panics if an error occurs.
func (sliq *ShoppingListItemQuery) IDsX(ctx context.Context) []int {
	ids, err := sliq.IDs(ctx)
	if err != nil {
		panic(err)
	}
	return ids
}

// Count returns the count of the given query.
func (sliq *ShoppingListItemQuery) Count(ctx context.Context) (int, error) {
	if err := sliq.prepareQuery(ctx); err != nil {
		return 0, err
	}
	return sliq.sqlCount(ctx)
}

// CountX is like Count, but panics if an error occurs.
func (sliq *ShoppingListItemQuery) CountX(ctx context.Context) int {
	count, err := sliq.Count(ctx)
	if err != nil {
		panic(err)
	}
	return count
}

// Exist returns true if the query has elements in the graph.
func (sliq *ShoppingListItemQuery) Exist(ctx context.Context) (bool, error) {
	if err := sliq.prepareQuery(ctx); err != nil {
		return false, err
	}
	return sliq.sqlExist(ctx)
}

// ExistX is like Exist, but panics if an error occurs.
func (sliq *ShoppingListItemQuery) ExistX(ctx context.Context) bool {
	exist, err := sliq.Exist(ctx)
	if err != nil {
		panic(err)
	}
	return exist
}

// Clone returns a duplicate of the ShoppingListItemQuery builder, including all associated steps. It can be
// used to prepare common query builders and use them differently after the clone is made.
func (sliq *ShoppingListItemQuery) Clone() *ShoppingListItemQuery {
	if sliq == nil {
		return nil
	}
	return &ShoppingListItemQuery{
		config:           sliq.config,
		limit:            sliq.limit,
		offset:           sliq.offset,
		order:            append([]OrderFunc{}, sliq.order...),
		predicates:       append([]predicate.ShoppingListItem{}, sliq.predicates...),
		withShoppingList: sliq.withShoppingList.Clone(),
		withItem:         sliq.withItem.Clone(),
		withPurchase:     sliq.withPurchase.Clone(),
		// clone intermediate query.
		sql:  sliq.sql.Clone(),
		path: sliq.path,
	}
}

// WithShoppingList tells the query-builder to eager-load the nodes that are connected to
// the "shoppingList" edge. The optional arguments are used to configure the query builder of the edge.
func (sliq *ShoppingListItemQuery) WithShoppingList(opts ...func(*ShoppingListQuery)) *ShoppingListItemQuery {
	query := &ShoppingListQuery{config: sliq.config}
	for _, opt := range opts {
		opt(query)
	}
	sliq.withShoppingList = query
	return sliq
}

// WithItem tells the query-builder to eager-load the nodes that are connected to
// the "item" edge. The optional arguments are used to configure the query builder of the edge.
func (sliq *ShoppingListItemQuery) WithItem(opts ...func(*ItemQuery)) *ShoppingListItemQuery {
	query := &ItemQuery{config: sliq.config}
	for _, opt := range opts {
		opt(query)
	}
	sliq.withItem = query
	return sliq
}

// WithPurchase tells the query-builder to eager-load the nodes that are connected to
// the "purchase" edge. The optional arguments are used to configure the query builder of the edge.
func (sliq *ShoppingListItemQuery) WithPurchase(opts ...func(*ShoppingItemQuery)) *ShoppingListItemQuery {
	query := &ShoppingItemQuery{config: sliq.config}
	for _, opt := range opts {
		opt(query)
	}
	sliq.withPurchase = query
	return sliq
}

// GroupBy is used to group vertices by one or more fields/columns.
// It is often used with aggregate functions, like: count, max, mean, min, sum.
//
// Example:
//
//	var v []struct {
//		Note string `json:"note,omitempty"`
//		Count int `json:"count,omitempty"`
//	}
//
//	client.ShoppingListItem.Query().
//		GroupBy(shoppinglistitem.FieldNote).
//		Aggregate(ent.Count()).
//		Scan(ctx, &v)
//
func (sliq *ShoppingListItemQuery) GroupBy(field string, fields ...string) *ShoppingListItemGroupBy {
	group := &ShoppingListItemGroupBy{config: sliq.config}
	group.fields = append([]string{field}, fields...)
	group.path = func(ctx context.Context) (prev *sql.Selector, err error) {
		if err := sliq.prepareQuery(ctx); err != nil {
			return nil, err
		}
		return sliq.sqlQuery(ctx), nil
	}
	return group
}

// Select allows the selection one or more fields/columns for the given query,
// instead of selecting all fields in the entity.
//
// Example:
//
//	var v []struct {
//		Note string `json:"note,omitempty"`
//	}
//
//	client.ShoppingListItem.Query().
//		Select(shoppinglistitem.FieldNote).
//		Scan(ctx, &v)
//
func (sliq *ShoppingListItemQuery) Select(fields ...string) *ShoppingListItemSelect {
	sliq.fields = append(sliq.fields, fields...)
	return &ShoppingListItemSelect{ShoppingListItemQuery: sliq}
}

func (sliq *ShoppingListItemQuery) prepareQuery(ctx context.Context) error {
	for _, f := range sliq.fields {
		if !shoppinglistitem.ValidColumn(f) {
			return &ValidationError{Name: f, err: fmt.Errorf("ent: invalid field %q for query", f)}
		}
	}
	if sliq.path != nil {
		prev, err := sliq.path(ctx)
		if err != nil {
			return err
		}
		sliq.sql = prev
	}
	return nil
}

func (sliq *ShoppingListItemQuery) sqlAll(ctx context.Context) ([]*ShoppingListItem, error) {
	var (
		nodes       = []*ShoppingListItem{}
		withFKs     = sliq.withFKs
		_spec       = sliq.querySpec()
		loadedTypes = [3]bool{
			sliq.withShoppingList != nil,
			sliq.withItem != nil,
			sliq.withPurchase != nil,
		}
	)
	if sliq.withShoppingList != nil || sliq.withItem != nil || sliq.withPurchase != nil {
		withFKs = true
	}
	if withFKs {
		_spec.Node.Columns = append(_spec.Node.Columns, shoppinglistitem.ForeignKeys...)
	}
	_spec.ScanValues = func(columns []string) ([]interface{}, error) {
		node := &ShoppingListItem{config: sliq.config}
		nodes = append(nodes, node)
		return node.scanValues(columns)
	}
	_spec.Assign = func(columns []string, values []interface{}) error {
		if len(nodes) == 0 {
			return fmt.Errorf("ent: Assign called without calling ScanValues")
		}
		node := nodes[len(nodes)-1]
		node.Edges.loadedTypes = loadedTypes
		return node.assignValues(columns, values)
	}
	if err := sqlgraph.QueryNodes(ctx, sliq.driver, _spec); err != nil {
		return nil, err
	}
	if len(nodes) == 0 {
		return nodes, nil
	}

	if query := sliq.withShoppingList; query != nil {
		ids := make([]int, 0, len(nodes))
		nodeids := make(map[int][]*ShoppingListItem)
		for i := range nodes {
			if nodes[i].shopping_list_items == nil {
				continue
			}
			fk := *nodes[i].shopping_list_items
			if _, ok := nodeids[fk]; !ok {
				ids = append(ids, fk)
			}
			nodeids[fk] = append(nodeids[fk], nodes[i])
		}
		query.Where(shoppinglist.IDIn(ids...))
		neighbors, err := query.All(ctx)
		if err != nil {
			return nil, err
		}
		for _, n := range neighbors {
			nodes, ok := nodeids[n.ID]
			if !ok {
				return nil, fmt.Errorf(`unexpected foreign-key "shopping_list_items" returned %v`, n.ID)
			}
			for i := range nodes {
				nodes[i].Edges.ShoppingList = n
			}
		}
	}

	if query := sliq.withItem; query != nil {
		ids := make([]int, 0, len(nodes))
		nodeids := make(map[int][]*ShoppingListItem)
		for i := range nodes {
			if nodes[i].item_shopping_list == nil {
				continue
			}
			fk := *nodes[i].item_shopping_list
			if _, ok := nodeids[fk]; !ok {
				ids = append(ids, fk)
			}
			nodeids[fk] = append(nodeids[fk], nodes[i])
		}
		query.Where(item.IDIn(ids...))
		neighbors, err := query.All(ctx)
		if err != nil {
			return nil, err
		}
		for _, n := range neighbors {
			nodes, ok := nodeids[n.ID]
			if !ok {
				return nil, fmt.Errorf(`unexpected foreign-key "item_shopping_list" returned %v`, n.ID)
			}
			for i := range nodes {
				nodes[i].Edges.Item = n
			}
		}
	}

	if query := sliq.withPurchase; query != nil {
		ids := make([]int, 0, len(nodes))
		nodeids := make(map[int][]*ShoppingListItem)
		for i := range nodes {
			if nodes[i].shopping_item_shopping_list == nil {
				continue
			}
			fk := *nodes[i].shopping_item_shopping_list
			if _, ok := nodeids[fk]; !ok {
				ids = append(ids, fk)
			}
			nodeids[fk] = append(nodeids[fk], nodes[i])
		}
		query.Where(shoppingitem.IDIn(ids...))
		neighbors, err := query.All(ctx)
		if err != nil {
			return nil, err
		}
		for _, n := range neighbors {
			nodes, ok := nodeids[n.ID]
			if !ok {
				return nil, fmt.Errorf(`unexpected foreign-key "shopping_item_shopping_list" returned %v`, n.ID)
			}
			for i := range nodes {
				nodes[i].Edges.Purchase = n
			}
		}
	}

	return nodes, nil
}

func (sliq *ShoppingListItemQuery) sqlCount(ctx context.Context) (int, error) {
	_spec := sliq.querySpec()
	return sqlgraph.CountNodes(ctx, sliq.driver, _spec)
}

func (sliq *ShoppingListItemQuery) sqlExist(ctx context.Context) (bool, error) {
	n, err := sliq.sqlCount(ctx)
	if err != nil {
		return false, fmt.Errorf("ent: check existence: %w", err)
	}
	return n > 0, nil
}

func (sliq *ShoppingListItemQuery) querySpec() *sqlgraph.QuerySpec {
	_spec := &sqlgraph.QuerySpec{
		Node: &sqlgraph.NodeSpec{
			Table:   shoppinglistitem.Table,
			Columns: shoppinglistitem.Columns,
			ID: &sqlgraph.FieldSpec{
				Type:   field.TypeInt,
				Column: shoppinglistitem.FieldID,
			},
		},
		From:   sliq.sql,
		Unique: true,
	}
	if unique := sliq.unique; unique != nil {
		_spec.Unique = *unique
	}
	if fields := sliq.fields; len(fields) > 0 {
		_spec.Node.Columns = make([]string, 0, len(fields))
		_spec.Node.Columns = append(_spec.Node.Columns, shoppinglistitem.FieldID)
		for i := range fields {
			if fields[i] != shoppinglistitem.FieldID {
				_spec.Node.Columns = append(_spec.Node.Columns, fields[i])
			}
		}
	}
	if ps := sliq.predicates; len(ps) > 0 {
		_spec.Predicate = func(selector *sql.Selector) {
			for i := range ps {
				ps[i](selector)
			}
		}
	}
	if limit := sliq.limit; limit != nil {
		_spec.Limit = *limit
	}
	if offset := sliq.offset; offset != nil {
		_spec.Offset = *offset
	}
	if ps := sliq.order; len(ps) > 0 {
		_spec.Order = func(selector *sql.Selector) {
			for i := range ps {
				ps[i](selector)
			}
		}
	}
	return _spec
}

func (sliq *ShoppingListItemQuery) sqlQuery(ctx context.Context) *sql.Selector {
	builder := sql.Dialect(sliq.driver.Dialect())
	t1 := builder.Table(shoppinglistitem.Table)
	columns := sliq.fields
	if len(columns) == 0 {
		columns = shoppinglistitem.Columns
	}
	selector := builder.Select(t1.Columns(columns...)...).From(t1)
	if sliq.sql != nil {
		selector = sliq.sql
		selector.Select(selector.Columns(columns...)...)
	}
	for _, p := range sliq.predicates {
		p(selector)
	}
	for _, p := range sliq.order {
		p(selector)
	}
	if offset := sliq.offset; offset != nil {
		// limit is mandatory for offset clause. We start
		// with default value, and override it below if needed.
		selector.Offset(*offset).Limit(math.MaxInt32)
	}
	if limit := sliq.limit; limit != nil {
		selector.Limit(*limit)
	}
	return selector
}

// ShoppingListItemGroupBy is the group-by builder for ShoppingListItem entities.
type ShoppingListItemGroupBy struct {
	config
	fields []string
	fns    []AggregateFunc
	// intermediate query (i.e. traversal path).
	sql  *sql.Selector
	path func(context.Context) (*sql.Selector, error)
}

// Aggregate adds the given aggregation functions to the group-by query.
func (sligb *ShoppingListItemGroupBy) Aggregate(fns ...AggregateFunc) *ShoppingListItemGroupBy {
	sligb.fns = append(sligb.fns, fns...)
	return sligb
}

// Scan applies the group-by query and scans the result into the given value.
func (sligb *ShoppingListItemGroupBy) Scan(ctx context.Context, v interface{}) error {
	query, err := sligb.path(ctx)
	if err != nil {
		return err
	}
	sligb.sql = query
	return sligb.sqlScan(ctx, v)
}

// ScanX is like Scan, but panics if an error occurs.
func (sligb *ShoppingListItemGroupBy) ScanX(ctx context.Context, v interface{}) {
	if err := sligb.Scan(ctx, v); err != nil {
		panic(err)
	}
}

// Strings returns list of strings from group-by.
// It is only allowed when executing a group-by query with one field.
func (sligb *ShoppingListItemGroupBy) Strings(ctx context.Context) ([]string, error) {
	if len(sligb.fields) > 1 {
		return nil, errors.New("ent: ShoppingListItemGroupBy.Strings is not achievable when grouping more than 1 field")
	}
	var v []string
	if err := sligb.Scan(ctx, &v); err != nil {
		return nil, err
	}
	return v, nil
}

// StringsX is like Strings, but panics if an error occurs.
func (sligb *ShoppingListItemGroupBy) StringsX(ctx context.Context) []string {
	v, err := sligb.Strings(ctx)
	if err != nil {
		panic(err)
	}
	return v
}

// String returns a single string from a group-by query.
// It is only allowed when executing a group-by query with one field.
func (sligb *ShoppingListItemGroupBy) String(ctx context.Context) (_ string, err error) {
	var v []string
	if v, err = sligb.Strings(ctx); err != nil {
		return
	}
	switch len(v) {
	case 1:
		return v[0], nil
	case 0:
		err = &NotFoundError{shoppinglistitem.Label}
	default:
		err = fmt.Errorf("ent: ShoppingListItemGroupBy.Strings returned %d results when one was expected", len(v))
	}
	return
}

// StringX is like String, but panics if an error occurs.
func (sligb *ShoppingListItemGroupBy) StringX(ctx context.Context) string {
	v, err := sligb.String(ctx)
	if err != nil {
		panic(err)
	}
	return v
}

// Ints returns list of ints from group-by.
// It is only allowed when executing a group-by query with one field.
func (sligb *ShoppingListItemGroupBy) Ints(ctx context.Context) ([]int, error) {
	if len(sligb.fields) > 1 {
		return nil, errors.New("ent: ShoppingListItemGroupBy.Ints is not achievable when grouping more than 1 field")
	}
	var v []int
	if err := sligb.Scan(ctx, &v); err != nil {
		return nil, err
	}
	return v, nil
}

// IntsX is like Ints, but panics if an error occurs.
func (sligb *ShoppingListItemGroupBy) IntsX(ctx context.Context) []int {
	v, err := sligb.Ints(ctx)
	if err != nil {
		panic(err)
	}
	return v
}

// Int returns a single int from a group-by query.
// It is only allowed when executing a group-by query with one field.
func (sligb *ShoppingListItemGroupBy) Int(ctx context.Context) (_ int, err error) {
	var v []int
	if v, err = sligb.Ints(ctx); err != nil {
		return
	}
	switch len(v) {
	case 1:
		return v[0], nil
	case 0:
		err = &NotFoundError{shoppinglistitem.Label}
	default:
		err = fmt.Errorf("ent: ShoppingListItemGroupBy.Ints returned %d results when one was expected", len(v))
	}
	return
}

// IntX is like Int, but panics if an error occurs.
func (sligb *ShoppingListItemGroupBy) IntX(ctx context.Context) int {
	v, err := sligb.Int(ctx)
	if err != nil {
		panic(err)
	}
	return v
}

// Float64s returns list of float64s from group-by.
// It is only allowed when executing a group-by query with one field.
func (sligb *ShoppingListItemGroupBy) Float64s(ctx context.Context) ([]float64, error) {
	if len(sligb.fields) > 1 {
		return nil, errors.New("ent: ShoppingListItemGroupBy.Float64s is not achievable when grouping more than 1 field")
	}
	var v []float64
	if err := sligb.Scan(ctx, &v); err != nil {
		return nil, err
	}
	return v, nil
}

// Float64sX is like Float64s, but panics if an error occurs.
func (sligb *ShoppingListItemGroupBy) Float64sX(ctx context.Context) []float64 {
	v, err := sligb.Float64s(ctx)
	if err != nil {
		panic(err)
	}
	return v
}

// Float64 returns a single float64 from a group-by query.
// It is only allowed when executing a group-by query with one field.
func (sligb *ShoppingListItemGroupBy) Float64(ctx context.Context) (_ float64, err error) {
	var v []float64
	if v, err = sligb.Float64s(ctx); err != nil {
		return
	}
	switch len(v) {
	case 1:
		return v[0], nil
	case 0:
		err = &NotFoundError{shoppinglistitem.Label}
	default:
		err = fmt.Errorf("ent: ShoppingListItemGroupBy.Float64s returned %d results when one was expected", len(v))
	}
	return
}

// Float64X is like Float64, but panics if an error occurs.
func (sligb *ShoppingListItemGroupBy) Float64X(ctx context.Context) float64 {
	v, err := sligb.Float64(ctx)
	if err != nil {
		panic(err)
	}
	return v
}

// Bools returns list of bools from group-by.
// It is only allowed when executing a group-by query with one field.
func (sligb *ShoppingListItemGroupBy) Bools(ctx context.Context) ([]bool, error) {
	if len(sligb.fields) > 1 {
		return nil, errors.New("ent: ShoppingListItemGroupBy.Bools is not achievable when grouping more than 1 field")
	}
	var v []bool
	if err := sligb.Scan(ctx, &v); err != nil {
		return nil, err
	}
	return v, nil
}

// BoolsX is like Bools, but panics if an error occurs.
func (sligb *ShoppingListItemGroupBy) BoolsX(ctx context.Context) []bool {
	v, err := sligb.Bools(ctx)
	if err != nil {
		panic(err)
	}
	return v
}

// Bool returns a single bool from a group-by query.
// It is only allowed when executing a group-by query with one field.
func (sligb *ShoppingListItemGroupBy) Bool(ctx context.Context) (_ bool, err error) {
	var v []bool
	if v, err = sligb.Bools(ctx); err != nil {
		return
	}
	switch len(v) {
	case 1:
		return v[0], nil
	case 0:
		err = &NotFoundError{shoppinglistitem.Label}
	default:
		err = fmt.Errorf("ent: ShoppingListItemGroupBy.Bools returned %d results when one was expected", len(v))
	}
	return
}

// BoolX is like Bool, but panics if an error occurs.
func (sligb *ShoppingListItemGroupBy) BoolX(ctx context.Context) bool {
	v, err := sligb.Bool(ctx)
	if err != nil {
		panic(err)
	}
	return v
}

func (sligb *ShoppingListItemGroupBy) sqlScan(ctx context.Context, v interface{}) error {
	for _, f := range sligb.fields {
		if !shoppinglistitem.ValidColumn(f) {
			return &ValidationError{Name: f, err: fmt.Errorf("invalid field %q for group-by", f)}
		}
	}
	selector := sligb.sqlQuery()
	if err := selector.Err(); err != nil {
		return err
	}
	rows := &sql.Rows{}
	query, args := selector.Query()
	if err := sligb.driver.Query(ctx, query, args, rows); err != nil {
		return err
	}
	defer rows.Close()
	return sql.ScanSlice(rows, v)
}

func (sligb *ShoppingListItemGroupBy) sqlQuery() *sql.Selector {
	selector := sligb.sql.Select()
	aggregation := make([]string, 0, len(sligb.fns))
	for _, fn := range sligb.fns {
		aggregation = append(aggregation, fn(selector))
	}
	// If no columns were selected in a custom aggregation function, the default
	// selection is the fields used for "group-by", and the aggregation functions.
	if len(selector.SelectedColumns()) == 0 {
		columns := make([]string, 0, len(sligb.fields)+len(sligb.fns))
		for _, f := range sligb.fields {
			columns = append(columns, selector.C(f))
		}
		for _, c := range aggregation {
			columns = append(columns, c)
		}
		selector.Select(columns...)
	}
	return selector.GroupBy(selector.Columns(sligb.fields...)...)
}

// ShoppingListItemSelect is the builder for selecting fields of ShoppingListItem entities.
type ShoppingListItemSelect struct {
	*ShoppingListItemQuery
	// intermediate query (i.e. traversal path).
	sql *sql.Selector
}

// Scan applies the selector query and scans the result into the given value.
func (slis *ShoppingListItemSelect) Scan(ctx context.Context, v interface{}) error {
	if err := slis.prepareQuery(ctx); err != nil {
		return err
	}
	slis.sql = slis.ShoppingListItemQuery.sqlQuery(ctx)
	return slis.sqlScan(ctx, v)
}

// ScanX is like Scan, but panics if an error occurs.
func (slis *ShoppingListItemSelect) ScanX(ctx context.Context, v interface{}) {
	if err := slis.Scan(ctx, v); err != nil {
		panic(err)
	}
}

// Strings returns list of strings from a selector. It is only allowed when selecting one field.
func (slis *ShoppingListItemSelect) Strings(ctx context.Context) ([]string, error) {
	if len(slis.fields) > 1 {
		return nil, errors.New("ent: ShoppingListItemSelect.Strings is not achievable when selecting more than 1 field")
	}
	var v []string
	if err := slis.Scan(ctx, &v); err != nil {
		return nil, err
	}
	return v, nil
}

// StringsX is like Strings, but panics if an error occurs.
func (slis *ShoppingListItemSelect) StringsX(ctx context.Context) []string {
	v, err := slis.Strings(ctx)
	if err != nil {
		panic(err)
	}
	return v
}

// String returns a single string from a selector. It is only allowed when selecting one field.
func (slis *ShoppingListItemSelect) String(ctx context.Context) (_ string, err error) {
	var v []string
	if v, err = slis.Strings(ctx); err != nil {
		return
	}
	switch len(v) {
	case 1:
		return v[0], nil
	case 0:
		err = &NotFoundError{shoppinglistitem.Label}
	default:
		err = fmt.Errorf("ent: ShoppingListItemSelect.Strings returned %d results when one was expected", len(v))
	}
	return
}

// StringX is like String, but panics if an error occurs.
func (slis *ShoppingListItemSelect) StringX(ctx context.Context) string {
	v, err := slis.String(ctx)
	if err != nil {
		panic(err)
	}
	return v
}

// Ints returns list of ints from a selector. It is only allowed when selecting one field.
func (slis *ShoppingListItemSelect) Ints(ctx context.Context) ([]int, error) {
	if len(slis.fields) > 1 {
		return nil, errors.New("ent: ShoppingListItemSelect.Ints is not achievable when selecting more than 1 field")
	}
	var v []int
	if err := slis.Scan(ctx, &v); err != nil {
		return nil, err
	}
	return v, nil
}

// IntsX is like Ints, but panics if an error occurs.
func (slis *ShoppingListItemSelect) IntsX(ctx context.Context) []int {
	v, err := slis.Ints(ctx)
	if err != nil {
		panic(err)
	}
	return v
}

// Int returns a single int from a selector. It is only allowed when selecting one field.
func (slis *ShoppingListItemSelect) Int(ctx context.Context) (_ int, err error) {
	var v []int
	if v, err = slis.Ints(ctx); err != nil {
		return
	}
	switch len(v) {
	case 1:
		return v[0], nil
	case 0:
		err = &NotFoundError{shoppinglistitem.Label}
	default:
		err = fmt.Errorf("ent: ShoppingListItemSelect.Ints returned %d results when one was expected", len(v))
	}
	return
}

// IntX is like Int, but panics if an error occurs.
func (slis *ShoppingListItemSelect) IntX(ctx context.Context) int {
	v, err := slis.Int(ctx)
	if err != nil {
		panic(err)
	}
	return v
}

// Float64s returns list of float64s from a selector. It is only allowed when selecting one field.
func (slis *ShoppingListItemSelect) Float64s(ctx context.Context) ([]float64, error) {
	if len(slis.fields) > 1 {
		return nil, errors.New("ent: ShoppingListItemSelect.Float64s is not achievable when selecting more than 1 field")
	}
	var v []float64
	if err := slis.Scan(ctx, &v); err != nil {
		return nil, err
	}
	return v, nil
}

// Float64sX is like Float64s, but panics if an error occurs.
func (slis *ShoppingListItemSelect) Float64sX(ctx context.Context) []float64 {
	v, err := slis.Float64s(ctx)
	if err != nil {
		panic(err)
	}
	return v
}

// Float64 returns a single float64 from a selector. It is only allowed when selecting one field.
func (slis *ShoppingListItemSelect) Float64(ctx context.Context) (_ float64, err error) {
	var v []float64
	if v, err = slis.Float64s(ctx); err != nil {
		return
	}
	switch len(v) {
	case 1:
		return v[0], nil
	case 0:
		err = &NotFoundError{shoppinglistitem.Label}
	default:
		err = fmt.Errorf("ent: ShoppingListItemSelect.Float64s returned %d results when one was expected", len(v))
	}
	return
}

// Float64X is like Float64, but panics if an error occurs.
func (slis *ShoppingListItemSelect) Float64X(ctx context.Context) float64 {
	v, err := slis.Float64(ctx)
	if err != nil {
		panic(err)
	}
	return v
}

// Bools returns list of bools from a selector. It is only allowed when selecting one field.
func (slis *ShoppingListItemSelect) Bools(ctx context.Context) ([]bool, error) {
	if len(slis.fields) > 1 {
		return nil, errors.New("ent: ShoppingListItemSelect.Bools is not achievable when selecting more than 1 field")
	}
	var v []bool
	if err := slis.Scan(ctx, &v); err != nil {
		return nil, err
	}
	return v, nil
}

// BoolsX is like Bools, but panics if an error occurs.
func (slis *ShoppingListItemSelect) BoolsX(ctx context.Context) []bool {
	v, err := slis.Bools(ctx)
	if err != nil {
		panic(err)
	}
	return v
}

// Bool returns a single bool from a selector. It is only allowed when selecting one field.
func (slis *ShoppingListItemSelect) Bool(ctx context.Context) (_ bool, err error) {
	var v []bool
	if v, err = slis.Bools(ctx); err != nil {
		return
	}
	switch len(v) {
	case 1:
		return v[0], nil
	case 0:
		err = &NotFoundError{shoppinglistitem.Label}
	default:
		err = fmt.Errorf("ent: ShoppingListItemSelect.Bools returned %d results when one was expected", len(v))
	}
	return
}

// BoolX is like Bool, but panics if an error occurs.
func (slis *ShoppingListItemSelect) BoolX(ctx context.Context) bool {
	v, err := slis.Bool(ctx)
	if err != nil {
		panic(err)
	}
	return v
}

func (slis *ShoppingListItemSelect) sqlScan(ctx context.Context, v interface{}) error {
	rows := &sql.Rows{}
	query, args := slis.sql.Query()
	if err := slis.driver.Query(ctx, query, args, rows); err != nil {
		return err
	}
	defer rows.Close()
	return sql.ScanSlice(rows, v)
}
