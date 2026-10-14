---@using data
---@using Reskins.SpriteUtils
---@using Reskins.SpriteUtils.Validation

---@namespace Reskins.Assets

local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")

local _assembly = require("api.icon-builder.assembly")
local IconBuilder = require("api.icon-builder.icon-builder")
local FlatIconBuilder = require("api.icon-builder.flat-icon-builder")

---Defines the defaults applied to every icon built from a factory.
---@class IconBuilderFactoryParams
---The path of the root folder of the icon artwork, such as `__reskins-assets-base__/graphics/icons`.
---@field folder string
---The name of the type-specific icon defaults applied to every layer. Default `"default"`.
---@field defaults_type? IconDefaultsType
---The size of the icon files, in pixels. When `nil`, the expected icon size of `defaults_type` is used.
---@field icon_size? SpriteSizeType

---A validator that checks that a value is an `IconBuilderFactoryParams` object.
---@type StructValidator<IconBuilderFactoryParams>
local FactoryParams = V.struct({
	folder = Common.non_empty_string,
	defaults_type = Common.icon_defaults_type:optional(),
	icon_size = Common.sprite_size:optional(),
}):describe_as("an IconBuilderFactoryParams")

---Represents a factory of icon builders for a root folder of icon artwork, such as the icon folder of an asset mod.
---
---Every icon built from it uses the root folder, icon size, and icon defaults type of the factory.
---
---#### Examples
---```lua
---local IconBuilderFactory = require("__reskins-assets-api__.api.icon-builder-factory")
---```
---@class IconBuilderFactory
---The path of the root folder of the icon artwork.
---@field folder string
---The name of the type-specific icon defaults applied to every layer.
---@field defaults_type? IconDefaultsType
---The size of the icon files, in pixels.
---@field icon_size? SpriteSizeType
local IconBuilderFactory = {}
IconBuilderFactory.__index = IconBuilderFactory

---The roles of the layers of an icon.
IconBuilderFactory.role = _assembly.role

local check_create = V.signature("create", {
	{ "params", FactoryParams },
})

---Creates a factory with the given defaults.
---
---#### Examples
---```lua
----- Create a factory for the technology icons of the base game.
---local technologies = IconBuilderFactory:create({
---    folder = "__reskins-assets-base__/graphics/technology",
---    defaults_type = "technology",
---})
----- Icons built from the factory take their files from the technology folder and use the icon size of the
----- technology icon defaults.
---```
---@param params IconBuilderFactoryParams The defaults applied to every icon built from the factory.
---@return self
---@throws When `params` is not a valid `IconBuilderFactoryParams`.
---@nodiscard
function IconBuilderFactory:create(params)
	check_create(params)

	return setmetatable({
		folder = params.folder,
		defaults_type = params.defaults_type,
		icon_size = params.icon_size,
	}, self)
end

---Creates the state of a builder for the icon of the given `name`.
---@param self IconBuilderFactory
---@param name string
---@param flat boolean
---@return IconBuilderState
---@nodiscard
local function new_state(self, name, flat)
	---@type IconBuilderState
	return {
		folder = self.folder,
		name = name,
		defaults_type = self.defaults_type,
		icon_size = self.icon_size,
		flat = flat,
		layers = {},
		keys = {},
	}
end

local check_flat = V.signature("flat", {
	{ "name", _assembly.IconName },
})

---Creates a builder for an icon with one layer, from the file `{folder}/{name}.png`, such as `brass-pipe.png`.
---@param name string The name of the icon, which is the default stem of its file name.
---@return FlatIconBuilder<{}>
---@throws When `name` is `nil` or an empty string.
---@nodiscard
function IconBuilderFactory:flat(name)
	check_flat(name)

	local state = new_state(self, name, true)
	state.layers[1] = _assembly.new_layer(nil, nil, nil, nil)

	return setmetatable({ state = state }, FlatIconBuilder)
end

local check_layers = V.signature("layers", {
	{ "name", _assembly.IconName },
})

---Creates a builder with no layers for an icon with its artwork in the subfolder `{folder}/{name}`.
---
---The files of the layers are in that subfolder, such as `circuit/circuit-traces.png`.
---@param name string The name of the icon, which names its subfolder and is the default stem of its file names.
---@return IconBuilder<{}>
---@throws When `name` is `nil` or an empty string.
---@nodiscard
function IconBuilderFactory:layers(name)
	check_layers(name)

	return setmetatable({ state = new_state(self, name, false) }, IconBuilder)
end

local check_tinted = V.signature("tinted", {
	{ "name", _assembly.IconName },
})

---Creates a builder for an icon with a `base`, a `mask`, and a `highlights` layer.
---
---The files of the layers are `{folder}/{name}/{name}-base.png`, `{name}-mask.png`, and `{name}-highlights.png`. The
---base layer is tinted by the `base_tint` parameter when one is given. The mask layer is tinted by the `tint`
---parameter. The mask and highlights layers are omitted when `tint` is not given.
---@param name string The name of the icon, which names its subfolder and is the default stem of its file names.
---@return IconBuilder<{ base_tint?: Color, tint?: Color }>
---
---#### Examples
---```lua
----- Create the accumulator icon from accumulator-base.png, accumulator-mask.png, and accumulator-highlights.png.
---local icons = IconBuilderFactory:create({ folder = "__reskins-assets-base__/graphics/icons" })
---
---local get_icon = icons:tinted("accumulator"):build("get_icon")
---local icon_data = get_icon({ tint = util.color("#e88b2f") })
----- The mask layer of icon_data is tinted orange.
---```
---@throws When `name` is `nil` or an empty string.
---@nodiscard
function IconBuilderFactory:tinted(name)
	check_tinted(name)

	return self:layers(name):base():mask():highlights({ requires = "tint" })
end

local check_dispatch = V.signature("dispatch", {
	{ "field", _assembly.ParamName },
	{ "values", V.table() },
	{ "creator_name", Common.non_empty_string:optional() },
	{ "builder_factory", V.func():describe_as("a function that returns an icon builder") },
})

---Creates a function that returns the icon selected by the value of the parameter named `field`.
---
---The builder of each icon is created and built when `dispatch` is called, so an error in the declaration of any icon
---is raised at that time. The other parameters are passed to the function of the selected icon. `dispatch` is
---recommended when the icons are in different asset mods or folders.
---
---#### Parameters
---@generic const N : string, K, const V, P
---@param field N The name of the parameter that selects the icon.
---@param values table<K, V> The values that the parameter can take, as an array or as a table of names to values.
---@param creator_name? string The name of the function in error messages. Default `"icon_creator"`.
---@param builder_factory fun(value: V): IconBuilder<P>|FlatIconBuilder<P> A function that returns the builder for the icon selected by the given value.
---
---#### Returns
---@return fun(params: P & { [K in N]: V }): SafeIconData[] # A function that returns the icon selected by the parameter, for the given parameters.
---
---#### Examples
---```lua
----- Select the pipe icon of the given material from the asset mod that has its artwork.
---local get_icon = IconBuilderFactory.dispatch("material", { "brass", "ceramic" }, "get_icon", function(material)
---    local asset_mod = material == "ceramic" and "__reskins-assets-angels__" or "__reskins-assets-bobs__"
---
---    return IconBuilderFactory:create({ folder = asset_mod .. "/graphics/icons/pipe" }):flat(material .. "-pipe")
---end)
---
---local icon_data = get_icon({ material = "ceramic" })
----- The layer of icon_data is __reskins-assets-angels__/graphics/icons/pipe/ceramic-pipe.png.
---```
---@throws When `field` is `nil` or an empty string.
---@throws When `values` is not a table.
---@throws When `creator_name` is an empty string.
---@throws When `builder_factory` is not a function.
---@nodiscard
function IconBuilderFactory.dispatch(field, values, creator_name, builder_factory)
	check_dispatch(field, values, creator_name, builder_factory)

	local name = creator_name or "icon_creator"

	---@type table<any, fun(params?: table<string, any>): SafeIconData[]>
	local creators = {}
	for _, value in pairs(values) do
		creators[value] = builder_factory(value):build(name)
	end

	local check = V.signature(name, {
		{ "params", V.struct({ [field] = V.one_of(values) }):describe_as("the parameters of the icon") },
	})

	return function(params)
		check(params)

		local rest = {}
		for key, value in pairs(params) do
			if key ~= field then
				rest[key] = value
			end
		end

		return creators[params[field]](rest)
	end
end

return IconBuilderFactory
