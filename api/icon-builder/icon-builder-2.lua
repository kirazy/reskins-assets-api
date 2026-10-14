---@using data
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets

local _assembly = require("api.icon-builder.assembly")
local IconBuilderBase = require("api.icon-builder.icon-builder-base")

---Represents a builder for an icon with several layers and two parameters named by the caller.
---
---`keyed`, `tinted_layer`, and `tinted_part` on an `IconBuilder1` return an `IconBuilder2`. No further parameters named
---by the caller can be added.
---@class IconBuilder2<P, N1, V1, N2, V2> : IconBuilderBase
local IconBuilder2 = {}
IconBuilder2.__index = IconBuilder2
setmetatable(IconBuilder2, IconBuilderBase)

---Adds a `base` layer, tinted by the `base_tint` parameter when one is given.
---
---The file name of the layer is `{stem}[-{value}...][-{part}]-base.png`, such as
---`nuclear-reactor-uranium-gold-copper-base.png`. The layer is always included, unless `options.requires` names a
---parameter.
---@param options? IconLayerOptions The options for the layer.
---@return IconBuilder2<P & { base_tint?: Color }, N1, V1, N2, V2> # A copy of the builder with the layer added.
---@throws When `options` is not a valid `IconLayerOptions`.
---@nodiscard
function IconBuilder2:base(options)
	_assembly.check_base(options)

	return _assembly.with_layers(self, { _assembly.base_layer(options) }, IconBuilder2)
end

---Adds a `mask` layer, tinted by the `tint` parameter.
---
---The file name of the layer is `{stem}[-{value}...][-{part}]-mask.png`, such as `nuclear-reactor-mask.png`. Unless
---`options.requires` is set, the layer is omitted when `tint` is not given and it is not the first layer of the icon.
---@param options? IconLayerOptions The options for the layer.
---@return IconBuilder2<P & { tint?: Color }, N1, V1, N2, V2> # A copy of the builder with the layer added.
---@throws When `options` is not a valid `IconLayerOptions`.
---@nodiscard
function IconBuilder2:mask(options)
	_assembly.check_mask(options)

	return _assembly.with_layers(self, { _assembly.new_layer(_assembly.role.mask, "tint", nil, options) }, IconBuilder2)
end

---Adds a `highlights` layer, which the game renders additively.
---
---The file name of the layer is `{stem}[-{value}...][-{part}]-highlights.png`, such as
---`nuclear-reactor-highlights.png`. The layer is always included, unless `options.requires` names a parameter.
---`options.tint` is ignored.
---@param options? IconLayerOptions The options for the layer.
---@return IconBuilder2<P, N1, V1, N2, V2> # A copy of the builder with the layer added.
---@throws When `options` is not a valid `IconLayerOptions`.
---@nodiscard
function IconBuilder2:highlights(options)
	_assembly.check_highlights(options)

	return _assembly.with_layers(
		self,
		{ _assembly.new_layer(_assembly.role.highlights, nil, _assembly.ADDITIVE_TINT, options) },
		IconBuilder2
	)
end

---Adds the `base`, `mask`, and `highlights` layers of the given `part`.
---
---The file names of the layers are `{stem}[-{value}...]-{part}-{role}.png`, such as
---`assembling-machine-steam-smoke-stack-mask.png`. The base layer is tinted by the `base_tint` parameter when one is
---given. The mask layer is tinted by the `tint` parameter. The mask and highlights layers are omitted when `tint` is
---not given.
---@param part string The segment of the file names that selects the layers.
---@return IconBuilder2<P & { base_tint?: Color, tint?: Color }, N1, V1, N2, V2> # A copy of the builder with the layers added.
---@throws When `part` is `nil` or an empty string.
---@nodiscard
function IconBuilder2:tinted(part)
	_assembly.check_tinted(part)

	return _assembly.with_layers(self, _assembly.tinted_layers(part), IconBuilder2)
end

---Adds a layer with the given `role`, tinted by `options.tint` when one is given.
---
---The file name of the layer is `{stem}[-{value}...][-{part}]-{role}.png`, such as `assembling-machine-2-gear.png`. The
---layer is always included, unless `options.requires` names a parameter.
---@param role IconRole|string The role of the layer, which is the last segment of its file name.
---@param options? IconLayerOptions The options for the layer.
---@return IconBuilder2<P, N1, V1, N2, V2> # A copy of the builder with the layer added.
---@throws When `role` is `nil` or an empty string.
---@throws When `options` is not a valid `IconLayerOptions`.
---@nodiscard
function IconBuilder2:layer(role, options)
	_assembly.check_layer(role, options)

	return _assembly.with_layers(self, { _assembly.new_layer(role, nil, nil, options) }, IconBuilder2)
end

---Builds a function that returns the icon for the given parameters.
---
---The function takes one table of parameters. A parameter added by `keyed` is required, and a tint is optional. An
---error is raised when the function is given an unknown parameter. `creator_name` is recommended to be the name of the
---field to which the function is assigned.
---@param creator_name? string The name of the function in error messages. If `nil`, the name of the icon is used.
---@param rules? IconParamsRule[] The rules that check several parameters together, such as a rule that rejects a combination of values for which no artwork exists.
---@return fun(params: P & { [K in N1]: V1 } & { [K in N2]: V2 }): SafeIconData[] # A function that returns the icon for the given parameters.
---@throws When `creator_name` is an empty string.
---@throws When `rules` is not an array of valid `IconParamsRule` objects.
---@throws When a rule has a `field` or `fields` entry that is not the name of a parameter.
---@throws When the icon has no layers.
---@throws When two parameters have the same name.
---@throws When a key selects a layer that the icon does not have.
---@nodiscard
function IconBuilder2:build(creator_name, rules)
	_assembly.check_build(creator_name, rules)

	return _assembly.make_creator(self.state, creator_name, rules, false)
end

---Builds a function that returns the icon as an `IconComposition`.
---
---The function takes one table of parameters. A parameter added by `keyed` is required, and a tint is optional. An
---error is raised when the function is given an unknown parameter. `creator_name` is recommended to be the name of the
---field to which the function is assigned. The icon is added to the canvas group of a composition with the icon
---defaults type of the factory.
---@param creator_name? string The name of the function in error messages. If `nil`, the name of the icon is used.
---@param rules? IconParamsRule[] The rules that check several parameters together, such as a rule that rejects a combination of values for which no artwork exists.
---@return fun(params: P & { [K in N1]: V1 } & { [K in N2]: V2 }): IconComposition # A function that returns a composition with the icon for the given parameters.
---@throws When `creator_name` is an empty string.
---@throws When `rules` is not an array of valid `IconParamsRule` objects.
---@throws When a rule has a `field` or `fields` entry that is not the name of a parameter.
---@throws When the icon has no layers.
---@throws When two parameters have the same name.
---@throws When a key selects a layer that the icon does not have.
---@see IconBuilder2.build
---@nodiscard
function IconBuilder2:build_composition(creator_name, rules)
	_assembly.check_build(creator_name, rules)

	return _assembly.make_creator(self.state, creator_name, rules, false, _assembly.as_composition)
end

return IconBuilder2
