---@using data
---@using Reskins.SpriteUtils
---@using Reskins.SpriteUtils.Validation

---@namespace Reskins.Assets

local V = require("__reskins-sprite-utils__.validation")

local _assembly = require("api.icon-builder.assembly")
local IconBuilderBase = require("api.icon-builder.icon-builder-base")
local FlatIconBuilder1 = require("api.icon-builder.flat-icon-builder-1")

---Represents a builder for an icon with one layer, taken from the file `{folder}/{stem}[-{value}].png`.
---
---The name of the icon is used as the stem when no stem is set. `{value}` is the value of the parameter added by
---`keyed`, if any.
---@class FlatIconBuilder<P> : IconBuilderBase
local FlatIconBuilder = {}
FlatIconBuilder.__index = FlatIconBuilder
setmetatable(FlatIconBuilder, IconBuilderBase)

local check_keyed = V.signature("keyed", {
	{ "name", _assembly.ParamName },
	{ "validator", V.table():describe_as("a validator") },
})

---Adds a required parameter with the given `name` that selects the artwork of the icon.
---
---The value of the parameter is converted with `tostring` and appended to the stem of the file name, as
---`{stem}-{value}.png`. For example, the file of `casting-alloy` keyed by `tier` is `casting-alloy-2.png` when `tier`
---is 2.
---@generic const N : string, const V
---@param name N The name of the parameter.
---@param validator Validator<V> The validator for the values of the parameter.
---@return FlatIconBuilder1<P, N, V> # A copy of the builder with the parameter added.
---
---#### Examples
---```lua
----- Create the alloy casting icon from casting-alloy-1.png, casting-alloy-2.png, or casting-alloy-3.png.
---local get_icon = icons:flat("casting-alloy"):keyed("tier", V.one_of({ 1, 2, 3 })):build("get_icon")
---local icon_data = get_icon({ tier = 2 })
----- The layer of icon_data is casting-alloy-2.png.
---```
---@throws When `name` is `nil` or an empty string.
---@throws When `validator` is not a validator.
---@nodiscard
function FlatIconBuilder:keyed(name, validator)
	check_keyed(name, validator)

	return _assembly.with_key(self, name, validator, nil, FlatIconBuilder1)
end

---Builds a function that returns the icon for the given parameters.
---
---The function takes one table of parameters, or none. An error is raised when the function is given a parameter.
---`creator_name` is recommended to be the name of the field to which the function is assigned.
---@param creator_name? string The name of the function in error messages. If `nil`, the name of the icon is used.
---@return fun(params?: P): SafeIconData[] # A function that returns the icon.
---@throws When `creator_name` is an empty string.
---@nodiscard
function FlatIconBuilder:build(creator_name)
	_assembly.check_build(creator_name, nil)

	return _assembly.make_creator(self.state, creator_name, nil, true)
end

---Builds a function that returns the icon as an `IconComposition`.
---
---The function takes one table of parameters, or none. An error is raised when the function is given a parameter.
---The icon is added to the canvas group of a composition with the icon defaults type of the factory.
---@param creator_name? string The name of the function in error messages. If `nil`, the name of the icon is used.
---@return fun(params?: P): IconComposition # A function that returns a composition with the icon.
---@throws When `creator_name` is an empty string.
---@see FlatIconBuilder.build
---@nodiscard
function FlatIconBuilder:build_composition(creator_name)
	_assembly.check_build(creator_name, nil)

	return _assembly.make_creator(self.state, creator_name, nil, true, _assembly.as_composition)
end

return FlatIconBuilder
