---@using data
---@using Reskins.SpriteUtils
---@using Reskins.SpriteUtils.Validation

---@namespace Reskins.Assets

local _assembly = require("api.icon-builder.assembly")
local IconBuilderBase = require("api.icon-builder.icon-builder-base")
local IconBuilder2 = require("api.icon-builder.icon-builder-2")

---Represents a builder for an icon with several layers and one parameter named by the caller.
---
---`keyed`, `tinted_layer`, and `tinted_part` on an `IconBuilder` return an `IconBuilder1`. One further parameter can be
---added with the same methods.
---@class IconBuilder1<P, N1, V1> : IconBuilderBase
local IconBuilder1 = {}
IconBuilder1.__index = IconBuilder1
setmetatable(IconBuilder1, IconBuilderBase)

---Adds a `base` layer, tinted by the `base_tint` parameter when one is given.
---
---The file name of the layer is `{stem}[-{value}...][-{part}]-base.png`, such as `roboport-2-base.png`. The layer is
---always included, unless `options.requires` names a parameter.
---@param options? IconLayerOptions The options for the layer.
---@return IconBuilder1<P & { base_tint?: Color }, N1, V1> # A copy of the builder with the layer added.
---@throws When `options` is not a valid `IconLayerOptions`.
---@nodiscard
function IconBuilder1:base(options)
	_assembly.check_base(options)

	return _assembly.with_layers(self, { _assembly.base_layer(options) }, IconBuilder1)
end

---Adds a `mask` layer, tinted by the `tint` parameter.
---
---The file name of the layer is `{stem}[-{value}...][-{part}]-mask.png`, such as `roboport-mask.png`. Unless
---`options.requires` is set, the layer is omitted when `tint` is not given and it is not the first layer of the icon.
---@param options? IconLayerOptions The options for the layer.
---@return IconBuilder1<P & { tint?: Color }, N1, V1> # A copy of the builder with the layer added.
---@throws When `options` is not a valid `IconLayerOptions`.
---@nodiscard
function IconBuilder1:mask(options)
	_assembly.check_mask(options)

	return _assembly.with_layers(self, { _assembly.new_layer(_assembly.role.mask, "tint", nil, options) }, IconBuilder1)
end

---Adds a `highlights` layer, which the game renders additively.
---
---The file name of the layer is `{stem}[-{value}...][-{part}]-highlights.png`, such as `roboport-highlights.png`. The
---layer is always included, unless `options.requires` names a parameter. `options.tint` is ignored.
---@param options? IconLayerOptions The options for the layer.
---@return IconBuilder1<P, N1, V1> # A copy of the builder with the layer added.
---@throws When `options` is not a valid `IconLayerOptions`.
---@nodiscard
function IconBuilder1:highlights(options)
	_assembly.check_highlights(options)

	return _assembly.with_layers(
		self,
		{ _assembly.new_layer(_assembly.role.highlights, nil, _assembly.ADDITIVE_TINT, options) },
		IconBuilder1
	)
end

---Adds the `base`, `mask`, and `highlights` layers of the given `part`.
---
---The file names of the layers are `{stem}[-{value}...]-{part}-{role}.png`, such as
---`assembling-machine-steam-smoke-stack-mask.png`. The base layer is tinted by the `base_tint` parameter when one is
---given. The mask layer is tinted by the `tint` parameter. The mask and highlights layers are omitted when `tint` is
---not given.
---@param part string The segment of the file names that selects the layers.
---@return IconBuilder1<P & { base_tint?: Color, tint?: Color }, N1, V1> # A copy of the builder with the layers added.
---@throws When `part` is `nil` or an empty string.
---@nodiscard
function IconBuilder1:tinted(part)
	_assembly.check_tinted(part)

	return _assembly.with_layers(self, _assembly.tinted_layers(part), IconBuilder1)
end

---Adds a layer with the given `role`, tinted by `options.tint` when one is given.
---
---The file name of the layer is `{stem}[-{value}...][-{part}]-{role}.png`, such as `assembling-machine-2-gear.png`. The
---layer is always included, unless `options.requires` names a parameter.
---@param role IconRole|string The role of the layer, which is the last segment of its file name.
---@param options? IconLayerOptions The options for the layer.
---@return IconBuilder1<P, N1, V1> # A copy of the builder with the layer added.
---@throws When `role` is `nil` or an empty string.
---@throws When `options` is not a valid `IconLayerOptions`.
---@nodiscard
function IconBuilder1:layer(role, options)
	_assembly.check_layer(role, options)

	return _assembly.with_layers(self, { _assembly.new_layer(role, nil, nil, options) }, IconBuilder1)
end

---Adds a required parameter with the given `name` that selects the artwork of the icon.
---
---The value of the parameter is converted with `tostring` and appended to the stem of the file name of each of the
---given `layers`, after the value of any parameter added before it by `keyed`, as
---`{stem}-{value1}-{value2}[-{part}]-{role}.png` for a layer with both keys. For example, the base layer of
---`nuclear-reactor` keyed by `fuel` and then by `material` is `nuclear-reactor-uranium-gold-copper-base.png` when
---`fuel` is `"uranium"` and `material` is `"gold-copper"`.
---
---A role in `layers` selects the layer of that role with no part. An `IconLayerSelector` selects every layer of a part,
---or the layer of one role within a part.
---
---#### Parameters
---@generic const N : string, const V
---@param name N The name of the parameter.
---@param validator Validator<V> The validator for the values of the parameter.
---@param layers? (IconRole|string|IconLayerSelector)[] The layers for which the value of the parameter is appended to the file name. If `nil`, the value is appended for every layer.
---
---#### Returns
---@return IconBuilder2<P, N1, V1, N, V> # A copy of the builder with the parameter added.
---@throws When `name` is `nil` or an empty string.
---@throws When `validator` is not a validator.
---@throws When `layers` is empty, or is not an array of roles and `IconLayerSelector` objects.
---@nodiscard
function IconBuilder1:keyed(name, validator, layers)
	_assembly.check_keyed(name, validator, layers)

	return _assembly.with_key(self, name, validator, layers, IconBuilder2)
end

---Adds a layer with the given `role`, tinted by the parameter with the given `name`.
---
---The file name of the layer is `{stem}[-{value}...][-{part}]-{role}.png`, such as `assembling-machine-2-gear.png`.
---Unless `options.requires` is set, the layer is omitted when that parameter is not given and it is not the first layer
---of the icon.
---
---#### Parameters
---@generic const N : string
---@param role IconRole|string The role of the layer, which is the last segment of its file name.
---@param name N The name of the parameter that tints the layer.
---@param options? IconLayerOptions The options for the layer.
---
---#### Returns
---@return IconBuilder2<P, N1, V1, N, Color?> # A copy of the builder with the layer and the parameter added.
---@throws When `role` is `nil` or an empty string.
---@throws When `name` is `nil` or an empty string.
---@throws When `options` is not a valid `IconLayerOptions`.
---@nodiscard
function IconBuilder1:tinted_layer(role, name, options)
	_assembly.check_tinted_layer(role, name, options)

	return _assembly.with_layers(self, { _assembly.new_layer(role, name, nil, options) }, IconBuilder2)
end

---Adds the `mask` and `highlights` layers of the given `part`, with the mask layer tinted by the parameter with the
---given `name`.
---
---The file names of the layers are `{stem}[-{value}...]-{part}-mask.png` and
---`{stem}[-{value}...]-{part}-highlights.png`, such as `boiler-fire-mask.png`. Both layers are omitted when that
---parameter is not given, except for a mask layer that is the first layer of the icon.
---@generic const N : string
---@param part string The segment of the file names that selects the layers.
---@param name N The name of the parameter that tints the mask layer.
---@return IconBuilder2<P, N1, V1, N, Color?> # A copy of the builder with the layers and the parameter added.
---@throws When `part` is `nil` or an empty string.
---@throws When `name` is `nil` or an empty string.
---@nodiscard
function IconBuilder1:tinted_part(part, name)
	_assembly.check_tinted_part(part, name)

	return _assembly.with_layers(self, _assembly.tinted_part_layers(part, name), IconBuilder2)
end

---Builds a function that returns the icon for the given parameters.
---
---The function takes one table of parameters. A parameter added by `keyed` is required, and a tint is optional. An
---error is raised when the function is given an unknown parameter. `creator_name` is recommended to be the name of the
---field to which the function is assigned.
---@param creator_name? string The name of the function in error messages. If `nil`, the name of the icon is used.
---@param rules? IconParamsRule[] The rules that check several parameters together, such as a rule that rejects a value for which no artwork exists.
---@return fun(params: P & { [K in N1]: V1 }): SafeIconData[] # A function that returns the icon for the given parameters.
---@throws When `creator_name` is an empty string.
---@throws When `rules` is not an array of valid `IconParamsRule` objects.
---@throws When a rule has a `field` or `fields` entry that is not the name of a parameter.
---@throws When the icon has no layers.
---@throws When two parameters have the same name.
---@throws When a key selects a layer that the icon does not have.
---@nodiscard
function IconBuilder1:build(creator_name, rules)
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
---@param rules? IconParamsRule[] The rules that check several parameters together, such as a rule that rejects a value for which no artwork exists.
---@return fun(params: P & { [K in N1]: V1 }): IconComposition # A function that returns a composition with the icon for the given parameters.
---@throws When `creator_name` is an empty string.
---@throws When `rules` is not an array of valid `IconParamsRule` objects.
---@throws When a rule has a `field` or `fields` entry that is not the name of a parameter.
---@throws When the icon has no layers.
---@throws When two parameters have the same name.
---@throws When a key selects a layer that the icon does not have.
---@see IconBuilder1.build
---@nodiscard
function IconBuilder1:build_composition(creator_name, rules)
	_assembly.check_build(creator_name, rules)

	return _assembly.make_creator(self.state, creator_name, rules, false, _assembly.as_composition)
end

return IconBuilder1
