---@using data
---@using Reskins.SpriteUtils
---@using Reskins.SpriteUtils.Validation

---@namespace Reskins.Assets

local _assembly = require("api.icon-builder.assembly")
local IconBuilderBase = require("api.icon-builder.icon-builder-base")
local IconBuilder2 = require("api.icon-builder.icon-builder-2")

---A builder for an icon whose creator takes one parameter named by the caller, in addition to the
---tints of its `base` and `mask` layers. Returned by `keyed`, `tinted_layer`, and `tinted_part`
---on an `IconBuilder`.
---@class IconBuilder1<P, N1, V1> : IconBuilderBase
local IconBuilder1 = {}
IconBuilder1.__index = IconBuilder1
setmetatable(IconBuilder1, IconBuilderBase)

---Adds the body of the icon, tinted by the `base_tint` parameter when one is given.
---@param options IconLayerOptions? Controls how the layer is drawn.
---@return IconBuilder1<P & { base_tint?: Color }, N1, V1>
---@throws Thrown when `options` is not an `IconLayerOptions`.
---@nodiscard
function IconBuilder1:base(options)
	_assembly.check_layer_options(options)

	return _assembly.with_layers(self, { _assembly.base_layer(options) }, IconBuilder1)
end

---Adds the tintable body of the icon, tinted by the `tint` parameter.
---@param options IconLayerOptions? Controls how the layer is drawn.
---@return IconBuilder1<P & { tint?: Color }, N1, V1>
---@throws Thrown when `options` is not an `IconLayerOptions`.
---@nodiscard
function IconBuilder1:mask(options)
	_assembly.check_layer_options(options)

	return _assembly.with_layers(self, { _assembly.new_layer(_assembly.role.mask, "tint", nil, options) }, IconBuilder1)
end

---Adds the highlights of the icon, rendered additively over the body.
---@param options IconLayerOptions? Controls how the layer is drawn.
---@return IconBuilder1<P, N1, V1>
---@throws Thrown when `options` is not an `IconLayerOptions`.
---@nodiscard
function IconBuilder1:highlights(options)
	_assembly.check_layer_options(options)

	return _assembly.with_layers(
		self,
		{ _assembly.new_layer(_assembly.role.highlights, nil, _assembly.ADDITIVE_TINT, options) },
		IconBuilder1
	)
end

---Adds the base, mask, and highlights of the given `part`, tinted like the body of the icon: the
---base by `base_tint` when one is given, the mask by `tint`, and the mask and highlights omitted
---without it.
---@param part string The filename segment selecting the layers, such as the `stack` in `boiler-stack-mask.png`.
---@return IconBuilder1<P & { base_tint?: Color, tint?: Color }, N1, V1> # A builder drawing the added layers.
---@throws Thrown when `part` is not a non-empty string.
---@nodiscard
function IconBuilder1:tinted(part)
	_assembly.check_tinted(part)

	return _assembly.with_layers(self, _assembly.tinted_layers(part), IconBuilder1)
end

---Adds a layer in the given `role`, drawn untinted or in the color given by `options`.
---@param role IconRole|string The trailing segment of the file name of the layer.
---@param options IconLayerOptions? Controls how the layer is drawn.
---@return IconBuilder1<P, N1, V1>
---@throws Thrown when `role` is not an icon role.
---@throws Thrown when `options` is not an `IconLayerOptions`.
---@nodiscard
function IconBuilder1:layer(role, options)
	_assembly.check_layer(role, options)

	return _assembly.with_layers(self, { _assembly.new_layer(role, nil, nil, options) }, IconBuilder1)
end

---Adds a parameter selecting the artwork the icon is drawn from.
---
---The key is written into the file name stem of each layer it applies to, after any key added
---before it.
---
---#### Parameters
---@generic const N : string, const V
---@param name N The name of the parameter.
---@param validator Validator<V> A validator accepting the values the parameter may take.
---@param roles (IconRole|string)[]? The roles the key is written into. Defaults to every role.
---
---#### Returns
---@return IconBuilder2<P, N1, V1, N, V> # A builder whose creator takes the parameter.
---@throws Thrown when `name` is not a non-empty string.
---@throws Thrown when `validator` is not a validator.
---@throws Thrown when `roles` is not a non-empty array of icon roles.
---@nodiscard
function IconBuilder1:keyed(name, validator, roles)
	_assembly.check_keyed(name, validator, roles)

	return _assembly.with_key(self, name, validator, roles, IconBuilder2)
end

---Adds a layer in the given `role`, tinted by the parameter of the given `name`.
---@generic const N : string
---@param role IconRole|string The trailing segment of the file name of the layer.
---@param name N The name of the parameter supplying the color.
---@param options IconLayerOptions? Controls how the layer is drawn.
---@return IconBuilder2<P, N1, V1, N, Color?> # A builder whose creator takes the parameter.
---@throws Thrown when `role` is not an icon role.
---@throws Thrown when `name` is not a non-empty string.
---@throws Thrown when `options` is not an `IconLayerOptions`.
---@nodiscard
function IconBuilder1:tinted_layer(role, name, options)
	_assembly.check_tinted_layer(role, name, options)

	return _assembly.with_layers(self, { _assembly.new_layer(role, name, nil, options) }, IconBuilder2)
end

---Adds a mask and its highlights for the given `part`, the mask tinted by the parameter of the
---given `name`. Both layers are omitted when the creator is called without that parameter.
---@generic const N : string
---@param part string The file name segment selecting the layers, such as the `fire` in `boiler-fire-mask.png`.
---@param name N The name of the parameter supplying the color.
---@return IconBuilder2<P, N1, V1, N, Color?> # A builder whose creator takes the parameter.
---@throws Thrown when `part` is not a non-empty string.
---@throws Thrown when `name` is not a non-empty string.
---@nodiscard
function IconBuilder1:tinted_part(part, name)
	_assembly.check_tinted_part(part, name)

	return _assembly.with_layers(self, _assembly.tinted_part_layers(part, name), IconBuilder2)
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
---@return fun(params: P & { [K in N1]: V1 }): SafeIconData[] # A function that draws the icon for the given parameters.
---@throws Thrown when `creator_name` is not a non-empty string.
---@throws Thrown when `rules` is not an array of `IconParamsRule` objects, or a rule names a parameter the icon does not take.
---@throws Thrown when the icon draws no layers, or names a parameter twice.
---@nodiscard
function IconBuilder1:build(creator_name, rules)
	_assembly.check_build(creator_name, rules)

	return _assembly.make_creator(self.state, creator_name, rules, false)
end

return IconBuilder1
