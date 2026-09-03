---@using data
---@using Reskins.SpriteUtils
---@using Reskins.SpriteUtils.Validation

---@namespace Reskins.Assets

local V = require("__reskins-sprite-utils__.validation")

local _assembly = require("api.icon-builder.assembly")
local IconBuilderBase = require("api.icon-builder.icon-builder-base")
local FlatIconBuilder1 = require("api.icon-builder.flat-icon-builder-1")

---A builder for an icon drawn from the single file `{folder}/{name}[-{key}].png`.
---
---Every method returns a new builder; the builder it was called on is not modified.
---@class FlatIconBuilder<P> : IconBuilderBase
local FlatIconBuilder = {}
FlatIconBuilder.__index = FlatIconBuilder
setmetatable(FlatIconBuilder, IconBuilderBase)

local check_keyed = V.signature("keyed", {
	{ "name", _assembly.ParamName },
	{ "validator", V.table():describe_as("a validator") },
})

---Adds a parameter selecting the file the icon is drawn from.
---
---The key is written into the file name after the name of the icon; for example, `pipe` keyed by
---`material` draws `pipe-copper.png`.
---
---#### Parameters
---@generic const N : string, const V
---@param name N The name of the parameter.
---@param validator Validator<V> A validator accepting the values the parameter may take.
---
---#### Returns
---@return FlatIconBuilder1<P, N, V> # A builder whose creator takes the parameter.
---
---#### Examples
---```lua
---local get_icon = icons:flat("pipe"):keyed("material", V.one_of({ "copper", "steel" })):build()
---local icon_data = get_icon({ material = "copper" })
---```
---@throws Thrown when `name` is not a non-empty string.
---@throws Thrown when `validator` is not a validator.
---@nodiscard
function FlatIconBuilder:keyed(name, validator)
	check_keyed(name, validator)

	return _assembly.with_key(self, name, validator, nil, FlatIconBuilder1)
end

---Builds the function that draws the described icon.
---@param creator_name string? The name used in error messages when the creator is called with invalid parameters. Defaults to the name of the icon.
---@return fun(params?: P): SafeIconData[] # A function that draws the icon.
---@throws Thrown when `creator_name` is not a non-empty string.
---@nodiscard
function FlatIconBuilder:build(creator_name)
	_assembly.check_build(creator_name, nil)

	return _assembly.make_creator(self.state, creator_name, nil, true)
end

return FlatIconBuilder
