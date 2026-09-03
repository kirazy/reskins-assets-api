---@using data
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets

local _assembly = require("api.icon-builder.assembly")
local IconBuilderBase = require("api.icon-builder.icon-builder-base")

---A builder for an icon drawn from a single file selected by one parameter named by the caller.
---Returned by `keyed` on a `FlatIconBuilder`.
---@class FlatIconBuilder1<P, N1, V1> : IconBuilderBase
local FlatIconBuilder1 = {}
FlatIconBuilder1.__index = FlatIconBuilder1
setmetatable(FlatIconBuilder1, IconBuilderBase)

---Builds the function that draws the described icon.
---
---The creator takes one table of parameters, holding the key. Unrecognized parameters are
---rejected.
---
---#### Parameters
---@param creator_name string? The name used in error messages when the creator is called with invalid parameters. Defaults to the name of the icon.
---@param rules IconParamsRule[]? Rules that check several parameters together.
---
---#### Returns
---@return fun(params: P & { [K in N1]: V1 }): SafeIconData[] # A function that draws the icon for the given parameters.
---@throws Thrown when `creator_name` is not a non-empty string.
---@throws Thrown when `rules` is not an array of `IconParamsRule` objects, or a rule names a parameter the icon does not take.
---@nodiscard
function FlatIconBuilder1:build(creator_name, rules)
	_assembly.check_build(creator_name, rules)

	return _assembly.make_creator(self.state, creator_name, rules, false)
end

return FlatIconBuilder1
