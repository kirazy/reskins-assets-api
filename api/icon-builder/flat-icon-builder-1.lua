---@using data
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets

local _assembly = require("api.icon-builder.assembly")
local IconBuilderBase = require("api.icon-builder.icon-builder-base")

---Represents a builder for an icon with one layer, taken from a file selected by one parameter named by the caller.
---
---`keyed` on a `FlatIconBuilder` returns a `FlatIconBuilder1`. No further parameters can be added.
---@class FlatIconBuilder1<P, N1, V1> : IconBuilderBase
local FlatIconBuilder1 = {}
FlatIconBuilder1.__index = FlatIconBuilder1
setmetatable(FlatIconBuilder1, IconBuilderBase)

---Builds a function that returns the icon for the given parameters.
---
---The function takes one table of parameters, in which the parameter added by `keyed` is required. An error is raised
---when the function is given an unknown parameter. `creator_name` is recommended to be the name of the field to which
---the function is assigned.
---@param creator_name? string The name of the function in error messages. If `nil`, the name of the icon is used.
---@param rules? IconParamsRule[] The rules that check several parameters together, such as a rule that rejects a value for which no artwork exists.
---@return fun(params: P & { [K in N1]: V1 }): SafeIconData[] # A function that returns the icon for the given parameters.
---@throws When `creator_name` is an empty string.
---@throws When `rules` is not an array of valid `IconParamsRule` objects.
---@throws When a rule has a `field` or `fields` entry that is not the name of a parameter.
---@nodiscard
function FlatIconBuilder1:build(creator_name, rules)
	_assembly.check_build(creator_name, rules)

	return _assembly.make_creator(self.state, creator_name, rules, false)
end

---Builds a function that returns the icon as an `IconComposition`.
---
---The function takes one table of parameters, in which the parameter added by `keyed` is required. An error is raised
---when the function is given an unknown parameter. `creator_name` is recommended to be the name of the field to which
---the function is assigned. The icon is added to the canvas group of a composition with the icon defaults type of the
---factory.
---@param creator_name? string The name of the function in error messages. If `nil`, the name of the icon is used.
---@param rules? IconParamsRule[] The rules that check several parameters together, such as a rule that rejects a value for which no artwork exists.
---@return fun(params: P & { [K in N1]: V1 }): IconComposition # A function that returns a composition with the icon for the given parameters.
---@throws When `creator_name` is an empty string.
---@throws When `rules` is not an array of valid `IconParamsRule` objects.
---@throws When a rule has a `field` or `fields` entry that is not the name of a parameter.
---@see FlatIconBuilder1.build
---@nodiscard
function FlatIconBuilder1:build_composition(creator_name, rules)
	_assembly.check_build(creator_name, rules)

	return _assembly.make_creator(self.state, creator_name, rules, false, _assembly.as_composition)
end

return FlatIconBuilder1
