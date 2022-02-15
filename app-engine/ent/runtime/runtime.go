// Code generated by entc, DO NOT EDIT.

package runtime

import (
	"time"

	"github.com/kingzbauer/shilingi/app-engine/ent/item"
	"github.com/kingzbauer/shilingi/app-engine/ent/schema"
	"github.com/kingzbauer/shilingi/app-engine/ent/shopping"
	"github.com/kingzbauer/shilingi/app-engine/ent/shoppingitem"
	"github.com/kingzbauer/shilingi/app-engine/ent/tag"
	"github.com/kingzbauer/shilingi/app-engine/ent/vendor"
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
	// itemDescSlug is the schema descriptor for slug field.
	itemDescSlug := itemFields[1].Descriptor()
	// item.SlugValidator is a validator for the "slug" field. It is called by the builders before save.
	item.SlugValidator = itemDescSlug.Validators[0].(func(string) error)
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
	tagMixin := schema.Tag{}.Mixin()
	tagHooks := schema.Tag{}.Hooks()
	tag.Hooks[0] = tagHooks[0]
	tagMixinFields0 := tagMixin[0].Fields()
	_ = tagMixinFields0
	tagFields := schema.Tag{}.Fields()
	_ = tagFields
	// tagDescCreateTime is the schema descriptor for create_time field.
	tagDescCreateTime := tagMixinFields0[0].Descriptor()
	// tag.DefaultCreateTime holds the default value on creation for the create_time field.
	tag.DefaultCreateTime = tagDescCreateTime.Default.(func() time.Time)
	// tagDescUpdateTime is the schema descriptor for update_time field.
	tagDescUpdateTime := tagMixinFields0[1].Descriptor()
	// tag.DefaultUpdateTime holds the default value on creation for the update_time field.
	tag.DefaultUpdateTime = tagDescUpdateTime.Default.(func() time.Time)
	// tag.UpdateDefaultUpdateTime holds the default value on update for the update_time field.
	tag.UpdateDefaultUpdateTime = tagDescUpdateTime.UpdateDefault.(func() time.Time)
	vendorMixin := schema.Vendor{}.Mixin()
	vendorMixinFields0 := vendorMixin[0].Fields()
	_ = vendorMixinFields0
	vendorFields := schema.Vendor{}.Fields()
	_ = vendorFields
	// vendorDescCreateTime is the schema descriptor for create_time field.
	vendorDescCreateTime := vendorMixinFields0[0].Descriptor()
	// vendor.DefaultCreateTime holds the default value on creation for the create_time field.
	vendor.DefaultCreateTime = vendorDescCreateTime.Default.(func() time.Time)
	// vendorDescUpdateTime is the schema descriptor for update_time field.
	vendorDescUpdateTime := vendorMixinFields0[1].Descriptor()
	// vendor.DefaultUpdateTime holds the default value on creation for the update_time field.
	vendor.DefaultUpdateTime = vendorDescUpdateTime.Default.(func() time.Time)
	// vendor.UpdateDefaultUpdateTime holds the default value on update for the update_time field.
	vendor.UpdateDefaultUpdateTime = vendorDescUpdateTime.UpdateDefault.(func() time.Time)
}

const (
	Version = "(devel)" // Version of ent codegen.
)
