---@using data
---@using Reskins.SpriteUtils
---@using Reskins.SpriteUtils.Validation

---@namespace Reskins.Assets

local _assembly = require("api.icon-builder.assembly")
local IconBuilderBase = require("api.icon-builder.icon-builder-base")
local IconBuilder1 = require("api.icon-builder.icon-builder-1")

---Represents a builder for an icon with several layers, each taken from its own file.
---
---The file of each layer is `{folder}/{name}/{stem}[-{value}...][-{part}]-{role}.png`. The name of the icon is used as
---the stem when no stem is set. Each `{value}` is the value of a parameter added by `keyed`, `{part}` selects a group
---of layers within the icon, and `{role}` is the role of the layer. Each layer is drawn on top of the layers added
---before it.
---
---`build` creates a function that takes one table of parameters and returns the icon. A layer added by `base` is tinted
---by the `base_tint` parameter, and a layer added by `mask` is tinted by the `tint` parameter. Up to two further
---parameters can be added with `keyed`, `tinted_layer`, and `tinted_part`.
---@class IconBuilder<P> : IconBuilderBase
local IconBuilder = {}
IconBuilder.__index = IconBuilder
setmetatable(IconBuilder, IconBuilderBase)

---Adds a `base` layer, tinted by the `base_tint` parameter when one is given.
---
---The file name of the layer is `{stem}[-{value}...][-{part}]-base.png`, such as `accumulator-base.png`. The layer is
---always included, unless `options.requires` names a parameter.
---@param options? IconLayerOptions The options for the layer.
---@return IconBuilder<P & { base_tint?: Color }> # A copy of the builder with the layer added.
---@throws When `options` is not a valid `IconLayerOptions`.
---@nodiscard
function IconBuilder:base(options)
	_assembly.check_base(options)

	return _assembly.with_layers(self, { _assembly.base_layer(options) }, IconBuilder)
end

---Adds a `mask` layer, tinted by the `tint` parameter.
---
---The file name of the layer is `{stem}[-{value}...][-{part}]-mask.png`, such as `accumulator-mask.png`. Unless
---`options.requires` is set, the layer is omitted when `tint` is not given and it is not the first layer of the icon.
---@param options? IconLayerOptions The options for the layer.
---@return IconBuilder<P & { tint?: Color }> # A copy of the builder with the layer added.
---@throws When `options` is not a valid `IconLayerOptions`.
---@nodiscard
function IconBuilder:mask(options)
	_assembly.check_mask(options)

	return _assembly.with_layers(self, { _assembly.new_layer(_assembly.role.mask, "tint", nil, options) }, IconBuilder)
end

---Adds a `highlights` layer, which the game renders additively.
---
---The file name of the layer is `{stem}[-{value}...][-{part}]-highlights.png`, such as `accumulator-highlights.png`.
---The layer is always included, unless `options.requires` names a parameter. `options.tint` is ignored.
---@param options? IconLayerOptions The options for the layer.
---@return IconBuilder<P> # A copy of the builder with the layer added.
---@throws When `options` is not a valid `IconLayerOptions`.
---@nodiscard
function IconBuilder:highlights(options)
	_assembly.check_highlights(options)

	return _assembly.with_layers(
		self,
		{ _assembly.new_layer(_assembly.role.highlights, nil, _assembly.ADDITIVE_TINT, options) },
		IconBuilder
	)
end

---Adds the `base`, `mask`, and `highlights` layers of the given `part`.
---
---The file names of the layers are `{stem}[-{value}...]-{part}-{role}.png`, such as
---`assembling-machine-steam-smoke-stack-mask.png`. The base layer is tinted by the `base_tint` parameter when one is
---given. The mask layer is tinted by the `tint` parameter. The mask and highlights layers are omitted when `tint` is
---not given.
---@param part string The segment of the file names that selects the layers.
---@return IconBuilder<P & { base_tint?: Color, tint?: Color }> # A copy of the builder with the layers added.
---@throws When `part` is `nil` or an empty string.
---@nodiscard
function IconBuilder:tinted(part)
	_assembly.check_tinted(part)

	return _assembly.with_layers(self, _assembly.tinted_layers(part), IconBuilder)
end

---Adds a layer with the given `role`, tinted by `options.tint` when one is given.
---
---The file name of the layer is `{stem}[-{value}...][-{part}]-{role}.png`, such as `circuit-traces.png`. The layer is
---always included, unless `options.requires` names a parameter.
---@param role IconRole|string The role of the layer, which is the last segment of its file name.
---@param options? IconLayerOptions The options for the layer.
---@return IconBuilder<P> # A copy of the builder with the layer added.
---
---#### Examples
---```lua
----- Create the circuit icon from circuit-mask.png, circuit-highlights.png, and circuit-traces.png.
---local get_icon = icons:layers("circuit"):mask():highlights():layer("traces"):build("get_icon")
---local icon_data = get_icon({ tint = util.color("#e88b2f") })
----- The traces are drawn on top of the tinted mask and the highlights.
---```
---@throws When `role` is `nil` or an empty string.
---@throws When `options` is not a valid `IconLayerOptions`.
---@nodiscard
function IconBuilder:layer(role, options)
	_assembly.check_layer(role, options)

	return _assembly.with_layers(self, { _assembly.new_layer(role, nil, nil, options) }, IconBuilder)
end

---Adds a required parameter with the given `name` that selects the artwork of the icon.
---
---The value of the parameter is converted with `tostring` and appended to the stem of the file name of each of the
---given `layers`, as `{stem}-{value}[-{part}]-{role}.png`. Values are appended in the order in which their parameters
---are added. For example, the base layer of `roboport` keyed by `tier` for the `base` role is `roboport-2-base.png`
---when `tier` is 2.
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
---@return IconBuilder1<P, N, V> # A copy of the builder with the parameter added.
---
---#### Examples
---```lua
----- Create the roboport icon from roboport-{tier}-base.png, roboport-mask.png, and roboport-highlights.png.
---local get_icon = icons:tinted("roboport"):keyed("tier", V.one_of({ 1, 2, 3, 4 }), { "base" }):build("get_icon")
---local icon_data = get_icon({ tier = 2, tint = util.color("#e88b2f") })
----- The base layer of icon_data is roboport-2-base.png.
---```
---@throws When `name` is `nil` or an empty string.
---@throws When `validator` is not a validator.
---@throws When `layers` is empty, or is not an array of roles and `IconLayerSelector` objects.
---@nodiscard
function IconBuilder:keyed(name, validator, layers)
	_assembly.check_keyed(name, validator, layers)

	return _assembly.with_key(self, name, validator, layers, IconBuilder1)
end

---Adds a layer with the given `role`, tinted by the parameter with the given `name`.
---
---The file name of the layer is `{stem}[-{value}...][-{part}]-{role}.png`, such as `circuit-traces.png`. Unless
---`options.requires` is set, the layer is omitted when that parameter is not given and it is not the first layer of the
---icon.
---
---#### Parameters
---@generic const N : string
---@param role IconRole|string The role of the layer, which is the last segment of its file name.
---@param name N The name of the parameter that tints the layer.
---@param options? IconLayerOptions The options for the layer.
---
---#### Returns
---@return IconBuilder1<P, N, Color?> # A copy of the builder with the layer and the parameter added.
---@throws When `role` is `nil` or an empty string.
---@throws When `name` is `nil` or an empty string.
---@throws When `options` is not a valid `IconLayerOptions`.
---@nodiscard
function IconBuilder:tinted_layer(role, name, options)
	_assembly.check_tinted_layer(role, name, options)

	return _assembly.with_layers(self, { _assembly.new_layer(role, name, nil, options) }, IconBuilder1)
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
---@return IconBuilder1<P, N, Color?> # A copy of the builder with the layers and the parameter added.
---
---#### Examples
---```lua
----- Create the boiler icon with the fire tinted by its own parameter.
---local get_icon = icons:tinted("boiler"):tinted_part("fire", "fire_tint"):build("get_icon")
---local icon_data = get_icon({ tint = util.color("#e88b2f"), fire_tint = util.color("#ff9f22") })
----- The fire mask and fire highlights are drawn on top of the boiler.
---```
---@throws When `part` is `nil` or an empty string.
---@throws When `name` is `nil` or an empty string.
---@nodiscard
function IconBuilder:tinted_part(part, name)
	_assembly.check_tinted_part(part, name)

	return _assembly.with_layers(self, _assembly.tinted_part_layers(part, name), IconBuilder1)
end

---Builds a function that returns the icon for the given parameters.
---
---The function takes one table of parameters, or none. Each parameter is a tint, and is optional. An error is raised
---when the function is given an unknown parameter. `creator_name` is recommended to be the name of the field to which
---the function is assigned.
---@param creator_name? string The name of the function in error messages. If `nil`, the name of the icon is used.
---@param rules? IconParamsRule[] The rules that check several parameters together.
---@return fun(params?: P): SafeIconData[] # A function that returns the icon for the given parameters.
---@throws When `creator_name` is an empty string.
---@throws When `rules` is not an array of valid `IconParamsRule` objects.
---@throws When a rule has a `field` or `fields` entry that is not the name of a parameter.
---@throws When the icon has no layers.
---@nodiscard
function IconBuilder:build(creator_name, rules)
	_assembly.check_build(creator_name, rules)

	return _assembly.make_creator(self.state, creator_name, rules, true)
end

---Builds a function that returns the icon as an `IconComposition`.
---
---The function takes one table of parameters, or none. Each parameter is a tint, and is optional. An error is raised
---when the function is given an unknown parameter. `creator_name` is recommended to be the name of the field to which
---the function is assigned. The icon is added to the canvas group of a composition with the icon defaults type of the
---factory.
---@param creator_name? string The name of the function in error messages. If `nil`, the name of the icon is used.
---@param rules? IconParamsRule[] The rules that check several parameters together.
---@return fun(params?: P): IconComposition # A function that returns a composition with the icon for the given parameters.
---
---#### Examples
---```lua
----- Create the steam turbine icon with an open aperture symbol.
---local icons_api = require("__reskins-assets-api__.api.icons")
---local _defines = require("__reskins-assets-api__.api.defines")
---local tint = util.color("#e88b2f")
---
---local get_icon_composition = icons:tinted("steam-turbine"):build_composition("get_icon_composition")
---local icon_data = get_icon_composition({ tint = tint })
---    :add_symbol(icons_api.get_symbol(_defines.symbol.aperture_open, tint))
---    :build()
----- The symbol is drawn on top of the turbine.
---```
---@throws When `creator_name` is an empty string.
---@throws When `rules` is not an array of valid `IconParamsRule` objects.
---@throws When a rule has a `field` or `fields` entry that is not the name of a parameter.
---@throws When the icon has no layers.
---@see IconBuilder.build
---@nodiscard
function IconBuilder:build_composition(creator_name, rules)
	_assembly.check_build(creator_name, rules)

	return _assembly.make_creator(self.state, creator_name, rules, true, _assembly.as_composition)
end

return IconBuilder
