---@using data
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets

local _assembly = require("api.icon-builder.assembly")
local IconBuilderBase = require("api.icon-builder.icon-builder-base")

---A builder for an icon whose creator takes two parameters named by the caller, in addition to
---the tints of its `base` and `mask` layers. Returned by `keyed`, `tinted_layer`, and
---`tinted_part` on an `IconBuilder1`.
---
---No further parameters may be added.
---@class IconBuilder2<P, N1, V1, N2, V2> : IconBuilderBase
local IconBuilder2 = {}
IconBuilder2.__index = IconBuilder2
setmetatable(IconBuilder2, IconBuilderBase)

---Adds the body of the icon, tinted by the `base_tint` parameter when one is given.
---@param options IconLayerOptions? Controls how the layer is drawn.
---@return IconBuilder2<P & { base_tint?: Color }, N1, V1, N2, V2>
---@throws Thrown when `options` is not an `IconLayerOptions`.
---@nodiscard
function IconBuilder2:base(options)
	_assembly.check_layer_options(options)

	return _assembly.with_layers(self, { _assembly.base_layer(options) }, IconBuilder2)
end

---Adds the tintable body of the icon, tinted by the `tint` parameter.
---@param options IconLayerOptions? Controls how the layer is drawn.
---@return IconBuilder2<P & { tint?: Color }, N1, V1, N2, V2>
---@throws Thrown when `options` is not an `IconLayerOptions`.
---@nodiscard
function IconBuilder2:mask(options)
	_assembly.check_layer_options(options)

	return _assembly.with_layers(self, { _assembly.new_layer(_assembly.role.mask, "tint", nil, options) }, IconBuilder2)
end

---Adds the highlights of the icon, rendered additively over the body.
---@param options IconLayerOptions? Controls how the layer is drawn.
---@return IconBuilder2<P, N1, V1, N2, V2>
---@throws Thrown when `options` is not an `IconLayerOptions`.
---@nodiscard
function IconBuilder2:highlights(options)
	_assembly.check_layer_options(options)

	return _assembly.with_layers(
		self,
		{ _assembly.new_layer(_assembly.role.highlights, nil, _assembly.ADDITIVE_TINT, options) },
		IconBuilder2
	)
end

---Adds the base, mask, and highlights of the given `part`, tinted like the body of the icon: the
---base by `base_tint` when one is given, the mask by `tint`, and the mask and highlights omitted
---without it.
---@param part string The filename segment selecting the layers, such as the `stack` in `boiler-stack-mask.png`.
---@return IconBuilder2<P & { base_tint?: Color, tint?: Color }, N1, V1, N2, V2> # A builder drawing the added layers.
---@throws Thrown when `part` is not a non-empty string.
---@nodiscard
function IconBuilder2:tinted(part)
	_assembly.check_tinted(part)

	return _assembly.with_layers(self, _assembly.tinted_layers(part), IconBuilder2)
end

---Adds a layer in the given `role`, drawn untinted or in the color given by `options`.
---@param role IconRole|string The trailing segment of the file name of the layer.
---@param options IconLayerOptions? Controls how the layer is drawn.
---@return IconBuilder2<P, N1, V1, N2, V2>
---@throws Thrown when `role` is not an icon role.
---@throws Thrown when `options` is not an `IconLayerOptions`.
---@nodiscard
function IconBuilder2:layer(role, options)
	_assembly.check_layer(role, options)

	return _assembly.with_layers(self, { _assembly.new_layer(role, nil, nil, options) }, IconBuilder2)
end

---Builds the function that draws the described icon.
---
---The creator takes one table of parameters: each key, which is required, and each tint, which
---is optional. Unrecognized parameters are rejected.
---
---#### Parameters
---@param creator_name string? The name used in error messages when the creator is called with invalid parameters. Defaults to the name of the icon.
---@param rules IconParamsRule[]? Rules that check several parameters together, such as a combination of keys with no artwork.
---
---#### Returns
---@return fun(params: P & { [K in N1]: V1 } & { [K in N2]: V2 }): SafeIconData[] # A function that draws the icon for the given parameters.
---@throws Thrown when `creator_name` is not a non-empty string.
---@throws Thrown when `rules` is not an array of `IconParamsRule` objects, or a rule names a parameter the icon does not take.
---@throws Thrown when the icon draws no layers, or names a parameter twice.
---@nodiscard
function IconBuilder2:build(creator_name, rules)
	_assembly.check_build(creator_name, rules)

	return _assembly.make_creator(self.state, creator_name, rules, false)
end

return IconBuilder2
