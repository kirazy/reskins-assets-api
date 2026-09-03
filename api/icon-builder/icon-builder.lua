---@using data
---@using Reskins.SpriteUtils
---@using Reskins.SpriteUtils.Validation

---@namespace Reskins.Assets

local _assembly = require("api.icon-builder.assembly")
local IconBuilderBase = require("api.icon-builder.icon-builder-base")
local IconBuilder1 = require("api.icon-builder.icon-builder-1")

---A builder for an icon drawn as a stack of layers over a folder of artwork.
---
---The files of the layers are named `{folder}/{name}/{stem}[-{key}][-{part}]-{role}.png`, where a
---key selects the artwork and a part selects a group of layers within it. Every method returns a
---new builder; the builder it was called on is not modified.
---
---The creator function returned by `build` takes one table of parameters. A layer added by `base`
---is tinted by `base_tint`, and a layer added by `mask` by `tint`; both are optional. `keyed`,
---`tinted_layer`, and `tinted_part` add a parameter named by the caller, and return an
---`IconBuilder1`.
---
---#### Examples
---```lua
---local IconCatalog = require("__reskins-assets-api__.api.icon-catalog")
---
---local icons = IconCatalog:create({ folder = "__reskins-assets-base__/graphics/icons" })
---
---local get_circuit = icons:layers("circuit"):mask():highlights():layer("traces"):build()
---local icon_data = get_circuit({ tint = util.color("#e88b2f") })
---```
---@class IconBuilder<P> : IconBuilderBase
local IconBuilder = {}
IconBuilder.__index = IconBuilder
setmetatable(IconBuilder, IconBuilderBase)

---Adds the body of the icon, tinted by the `base_tint` parameter when one is given.
---@param options IconLayerOptions? Controls how the layer is drawn.
---@return IconBuilder<P & { base_tint?: Color }> # A builder drawing the added layer.
---@throws Thrown when `options` is not an `IconLayerOptions`.
---@nodiscard
function IconBuilder:base(options)
	_assembly.check_layer_options(options)

	return _assembly.with_layers(self, { _assembly.base_layer(options) }, IconBuilder)
end

---Adds the tintable body of the icon, tinted by the `tint` parameter.
---
---The layer is omitted when the creator is called without `tint`, unless it is the first layer
---of the icon, which is then drawn untinted.
---@param options IconLayerOptions? Controls how the layer is drawn.
---@return IconBuilder<P & { tint?: Color }> # A builder drawing the added layer.
---@throws Thrown when `options` is not an `IconLayerOptions`.
---@nodiscard
function IconBuilder:mask(options)
	_assembly.check_layer_options(options)

	return _assembly.with_layers(self, { _assembly.new_layer(_assembly.role.mask, "tint", nil, options) }, IconBuilder)
end

---Adds the highlights of the icon, rendered additively over the body.
---
---The layer is always drawn unless `options.requires` names a parameter.
---@param options IconLayerOptions? Controls how the layer is drawn.
---@return IconBuilder<P> # A builder drawing the added layer.
---@throws Thrown when `options` is not an `IconLayerOptions`.
---@nodiscard
function IconBuilder:highlights(options)
	_assembly.check_layer_options(options)

	return _assembly.with_layers(
		self,
		{ _assembly.new_layer(_assembly.role.highlights, nil, _assembly.ADDITIVE_TINT, options) },
		IconBuilder
	)
end

---Adds the base, mask, and highlights of the given `part`, tinted like the body of the icon: the
---base by `base_tint` when one is given, the mask by `tint`, and the mask and highlights omitted
---without it.
---@param part string The filename segment selecting the layers, such as the `stack` in `boiler-stack-mask.png`.
---@return IconBuilder<P & { base_tint?: Color, tint?: Color }> # A builder drawing the added layers.
---@throws Thrown when `part` is not a non-empty string.
---@nodiscard
function IconBuilder:tinted(part)
	_assembly.check_tinted(part)

	return _assembly.with_layers(self, _assembly.tinted_layers(part), IconBuilder)
end

---Adds a layer in the given `role`, drawn untinted or in the color given by `options`.
---@param role IconRole|string The trailing segment of the file name of the layer.
---@param options IconLayerOptions? Controls how the layer is drawn.
---@return IconBuilder<P> # A builder drawing the added layer.
---
---#### Examples
---```lua
---local get_circuit = icons:layers("circuit"):mask():highlights():layer("traces"):build()
---```
---@throws Thrown when `role` is not an icon role.
---@throws Thrown when `options` is not an `IconLayerOptions`.
---@nodiscard
function IconBuilder:layer(role, options)
	_assembly.check_layer(role, options)

	return _assembly.with_layers(self, { _assembly.new_layer(role, nil, nil, options) }, IconBuilder)
end

---Adds a parameter selecting the artwork the icon is drawn from.
---
---The key is written into the file name stem of each layer it applies to; for example, `roboport`
---keyed by `tier` draws `roboport-1-base.png`. Keys are written in the order they are added.
---
---#### Parameters
---@generic const N : string, const V
---@param name N The name of the parameter.
---@param validator Validator<V> A validator accepting the values the parameter may take.
---@param roles (IconRole|string)[]? The roles the key is written into. Defaults to every role.
---
---#### Returns
---@return IconBuilder1<P, N, V> # A builder whose creator takes the parameter.
---
---#### Examples
---```lua
----- Draws roboport-1-base.png over a shared roboport-mask.png.
---local get_icon = icons:tinted("roboport"):keyed("tier", V.integer():in_range(1, 4), { "base" }):build()
---local icon_data = get_icon({ tier = 1, tint = util.color("#e88b2f") })
---```
---@throws Thrown when `name` is not a non-empty string.
---@throws Thrown when `validator` is not a validator.
---@throws Thrown when `roles` is not a non-empty array of icon roles.
---@nodiscard
function IconBuilder:keyed(name, validator, roles)
	_assembly.check_keyed(name, validator, roles)

	return _assembly.with_key(self, name, validator, roles, IconBuilder1)
end

---Adds a layer in the given `role`, tinted by the parameter of the given `name`.
---
---The layer is omitted when the creator is called without that parameter, unless it is the first
---layer of the icon, which is then drawn untinted.
---
---#### Parameters
---@generic const N : string
---@param role IconRole|string The trailing segment of the file name of the layer.
---@param name N The name of the parameter supplying the color.
---@param options IconLayerOptions? Controls how the layer is drawn.
---
---#### Returns
---@return IconBuilder1<P, N, Color?> # A builder whose creator takes the parameter.
---@throws Thrown when `role` is not an icon role.
---@throws Thrown when `name` is not a non-empty string.
---@throws Thrown when `options` is not an `IconLayerOptions`.
---@nodiscard
function IconBuilder:tinted_layer(role, name, options)
	_assembly.check_tinted_layer(role, name, options)

	return _assembly.with_layers(self, { _assembly.new_layer(role, name, nil, options) }, IconBuilder1)
end

---Adds a mask and its highlights for the given `part`, the mask tinted by the parameter of the
---given `name`. Both layers are omitted when the creator is called without that parameter.
---
---#### Parameters
---@generic const N : string
---@param part string The file name segment selecting the layers, such as the `fire` in `boiler-fire-mask.png`.
---@param name N The name of the parameter supplying the color.
---
---#### Returns
---@return IconBuilder1<P, N, Color?> # A builder whose creator takes the parameter.
---
---#### Examples
---```lua
---local get_icon = icons:tinted("boiler"):tinted_part("fire", "fire_tint"):build()
---local icon_data = get_icon({ tint = util.color("#e88b2f"), fire_tint = util.color("#ff9f22") })
---```
---@throws Thrown when `part` is not a non-empty string.
---@throws Thrown when `name` is not a non-empty string.
---@nodiscard
function IconBuilder:tinted_part(part, name)
	_assembly.check_tinted_part(part, name)

	return _assembly.with_layers(self, _assembly.tinted_part_layers(part, name), IconBuilder1)
end

---Builds the function that draws the described icon.
---
---The creator takes one table of parameters, or none: the tints of the icon, each optional.
---Unrecognized parameters are rejected.
---
---#### Parameters
---@param creator_name string? The name used in error messages when the creator is called with invalid parameters. Defaults to the name of the icon.
---@param rules IconParamsRule[]? Rules that check several parameters together.
---
---#### Returns
---@return fun(params?: P): SafeIconData[] # A function that draws the icon for the given parameters.
---@throws Thrown when `creator_name` is not a non-empty string.
---@throws Thrown when `rules` is not an array of `IconParamsRule` objects, or a rule names a parameter the icon does not take.
---@throws Thrown when the icon draws no layers.
---@nodiscard
function IconBuilder:build(creator_name, rules)
	_assembly.check_build(creator_name, rules)

	return _assembly.make_creator(self.state, creator_name, rules, true)
end

return IconBuilder
