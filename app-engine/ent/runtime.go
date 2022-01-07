// Code generated by entc, DO NOT EDIT.

package ent

import (
	"time"

	"github.com/kingzbauer/shilingi/app-engine/ent/item"
	"github.com/kingzbauer/shilingi/app-engine/ent/schema"
	"github.com/kingzbauer/shilingi/app-engine/ent/shopping"
	"github.com/kingzbauer/shilingi/app-engine/ent/shoppingitem"
)

// The init function reads all schema descriptors with runtime code
// (default values, validators, hooks and policies) and stitches it
// to their package variables.
func init() {
	itemMixin := schema.Item{}.Mixin()
	itemMixinFields0 := itemMixin[0].Fields()
	_ = itemMixinFields0
	itemFields := schema.Item{}.Fields()
	_ = itemFields
	// itemDescCreateTime is the schema descriptor for create_time field.
	itemDescCreateTime := itemMixinFields0[0].Descriptor()
	// item.DefaultCreateTime holds the default value on creation for the create_time field.
	item.DefaultCreateTime = itemDescCreateTime.Default.(func() time.Time)
	// itemDescUpdateTime is the schema descriptor for update_time field.
	itemDescUpdateTime := itemMixinFields0[1].Descriptor()
	// item.DefaultUpdateTime holds the default value on creation for the update_time field.
	item.DefaultUpdateTime = itemDescUpdateTime.Default.(func() time.Time)
	// item.UpdateDefaultUpdateTime holds the default value on update for the update_time field.
	item.UpdateDefaultUpdateTime = itemDescUpdateTime.UpdateDefault.(func() time.Time)
	shoppingMixin := schema.Shopping{}.Mixin()
	shoppingMixinFields0 := shoppingMixin[0].Fields()
	_ = shoppingMixinFields0
	shoppingFields := schema.Shopping{}.Fields()
	_ = shoppingFields
	// shoppingDescCreateTime is the schema descriptor for create_time field.
	shoppingDescCreateTime := shoppingMixinFields0[0].Descriptor()
	// shopping.DefaultCreateTime holds the default value on creation for the create_time field.
	shopping.DefaultCreateTime = shoppingDescCreateTime.Default.(func() time.Time)
	// shoppingDescUpdateTime is the schema descriptor for update_time field.
	shoppingDescUpdateTime := shoppingMixinFields0[1].Descriptor()
	// shopping.DefaultUpdateTime holds the default value on creation for the update_time field.
	shopping.DefaultUpdateTime = shoppingDescUpdateTime.Default.(func() time.Time)
	// shopping.UpdateDefaultUpdateTime holds the default value on update for the update_time field.
	shopping.UpdateDefaultUpdateTime = shoppingDescUpdateTime.UpdateDefault.(func() time.Time)
	// shoppingDescDate is the schema descriptor for date field.
	shoppingDescDate := shoppingFields[0].Descriptor()
	// shopping.DefaultDate holds the default value on creation for the date field.
	shopping.DefaultDate = shoppingDescDate.Default.(func() time.Time)
	shoppingitemMixin := schema.ShoppingItem{}.Mixin()
	shoppingitemMixinFields0 := shoppingitemMixin[0].Fields()
	_ = shoppingitemMixinFields0
	shoppingitemFields := schema.ShoppingItem{}.Fields()
	_ = shoppingitemFields
	// shoppingitemDescCreateTime is the schema descriptor for create_time field.
	shoppingitemDescCreateTime := shoppingitemMixinFields0[0].Descriptor()
	// shoppingitem.DefaultCreateTime holds the default value on creation for the create_time field.
	shoppingitem.DefaultCreateTime = shoppingitemDescCreateTime.Default.(func() time.Time)
	// shoppingitemDescUpdateTime is the schema descriptor for update_time field.
	shoppingitemDescUpdateTime := shoppingitemMixinFields0[1].Descriptor()
	// shoppingitem.DefaultUpdateTime holds the default value on creation for the update_time field.
	shoppingitem.DefaultUpdateTime = shoppingitemDescUpdateTime.Default.(func() time.Time)
	// shoppingitem.UpdateDefaultUpdateTime holds the default value on update for the update_time field.
	shoppingitem.UpdateDefaultUpdateTime = shoppingitemDescUpdateTime.UpdateDefault.(func() time.Time)
	// shoppingitemDescUnits is the schema descriptor for units field.
	shoppingitemDescUnits := shoppingitemFields[2].Descriptor()
	// shoppingitem.DefaultUnits holds the default value on creation for the units field.
	shoppingitem.DefaultUnits = shoppingitemDescUnits.Default.(int)
}
