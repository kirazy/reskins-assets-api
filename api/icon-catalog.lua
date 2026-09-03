---@using data
---@using Reskins.SpriteUtils
---@using Reskins.SpriteUtils.Validation

---@namespace Reskins.Assets

local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")

local _assembly = require("api.icon-builder.assembly")
local IconBuilder = require("api.icon-builder.icon-builder")
local FlatIconBuilder = require("api.icon-builder.flat-icon-builder")

---The defaults applied to every icon built from a catalog.
---@class IconCatalogParams
---The mod-relative folder containing the artwork of the catalog.
---@field folder string
---The name of the type-specific icon defaults applied to every layer. Default `"default"`.
---@field defaults_type IconDefaultsType?
---The size of the artwork of the catalog, in pixels. Defaults to the expected icon size of
---`defaults_type`.
---@field icon_size SpriteSizeType?

---@type ShapeValidator<IconCatalogParams>
local CatalogParams = V.shape({
	folder = Common.non_empty_string,
	defaults_type = Common.icon_defaults_type:optional(),
	icon_size = Common.sprite_size:optional(),
}):describe_as("an IconCatalogParams")

---Provides icon builders that share a folder of artwork and a set of defaults.
---
---An icon is described as a stack of layers over a folder of artwork, and `build` creates the
---function that draws it. The description is validated as it is written, so an invalid folder or
---layer raises an error when the catalog is loaded.
---
---#### Examples
---```lua
---local IconCatalog = require("__reskins-assets-api__.api.icon-catalog")
---
---local icons = IconCatalog:create({ folder = "__reskins-assets-base__/graphics/icons" })
---
---local get_accumulator = icons:tinted("accumulator"):build()
---local icon_data = get_accumulator({ tint = util.color("#e88b2f") })
---```
---@class IconCatalog
---The mod-relative folder containing the artwork of the catalog.
---@field folder string
---The name of the type-specific icon defaults applied to every layer.
---@field defaults_type IconDefaultsType?
---The size of the artwork of the catalog, in pixels.
---@field icon_size SpriteSizeType?
local IconCatalog = {}
IconCatalog.__index = IconCatalog

---The roles of a layer of an icon.
IconCatalog.role = _assembly.role

local check_create = V.signature("create", {
	{ "params", CatalogParams },
})

---Creates a catalog that provides builders with the given defaults.
---@generic S : IconCatalog
---@param self S The class to create an instance of.
---@param params IconCatalogParams The defaults applied to every icon built from the catalog.
---@return S # A catalog with the given defaults.
---@throws Thrown when `params` is not an `IconCatalogParams`.
---@nodiscard
function IconCatalog.create(self, params)
	check_create(params)

	return setmetatable({
		folder = params.folder,
		defaults_type = params.defaults_type,
		icon_size = params.icon_size,
	}, self)
end

---Creates the state of a builder for the icon of the given `name`.
---@param self IconCatalog The catalog.
---@param name string The name of the icon.
---@param flat boolean Whether the icon is drawn from a single file.
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

local check_icon_name = V.signature("icon_catalog_method", {
	{ "name", _assembly.IconName },
})

---Creates a builder for an icon drawn from the single file `{folder}/{name}.png`.
---@param name string The name of the icon, naming the file it is drawn from.
---@return FlatIconBuilder<{}> # A builder for the icon.
---@throws Thrown when `name` is not an icon name.
---@nodiscard
function IconCatalog:flat(name)
	check_icon_name(name)

	local state = new_state(self, name, true)
	state.layers[1] = _assembly.new_layer(nil, nil, nil, nil)

	return setmetatable({ state = state }, FlatIconBuilder)
end

---Creates a builder for an icon with no layers, drawing from the folder `{folder}/{name}/`.
---@param name string The name of the icon, naming the folder it is drawn from.
---@return IconBuilder<{}> # A builder with no layers.
---@throws Thrown when `name` is not an icon name.
---@nodiscard
function IconCatalog:layers(name)
	check_icon_name(name)

	return setmetatable({ state = new_state(self, name, false) }, IconBuilder)
end

---Creates a builder for an icon drawn as a base, a tintable mask, and highlights.
---
---The base is tinted by the `base_tint` parameter when one is given. The mask is tinted by the
---`tint` parameter, and the mask and highlights are omitted without it.
---@param name string The name of the icon, naming the folder it is drawn from.
---@return IconBuilder<{ base_tint?: Color, tint?: Color }> # A builder with the three layers.
---@throws Thrown when `name` is not an icon name.
---@nodiscard
function IconCatalog:tinted(name)
	check_icon_name(name)

	return self:layers(name):base():mask():highlights({ requires = "tint" })
end

local check_dispatch = V.signature("dispatch", {
	{ "field", _assembly.ParamName },
	{ "values", V.table() },
	{ "creator_name", Common.non_empty_string:optional() },
	{ "builder_factory", V.func():describe_as("a function returning an icon builder") },
})

---Creates a function that selects an icon by the parameter of the given `field`, for artwork in a
---different mod or folder structure.
---
---Every icon is built when the function is created; an invalid description raises an error at
---that time. The remaining parameters are passed to the creator of the selected icon.
---
---#### Parameters
---@generic const N : string, K, const V, P
---@param field N The name of the parameter selecting the icon.
---@param values table<K, V> An array of values, or a mapping of names to values, the parameter may take.
---@param creator_name string? The name used in error messages when the creator is called with invalid parameters. Default `"icon_creator"`.
---@param builder_factory fun(value: V): IconBuilder<P>|FlatIconBuilder<P> A function that returns the builder for the icon selected by the given value.
---
---#### Returns
---@return fun(params: P & { [K in N]: V }): SafeIconData[] # A function that draws the icon selected by the parameter, taking the remaining parameters of that icon.
---
---#### Examples
---```lua
---local get_icon = IconCatalog.dispatch("material", _defines.pipe_material, "get_icon", function(material)
---    return pipe_icons:flat(material .. "-pipe")
---end)
---
---local icon_data = get_icon({ material = "copper" })
---```
---@throws Thrown when `field` is not a non-empty string.
---@throws Thrown when `values` is not a table.
---@throws Thrown when `creator_name` is not a non-empty string.
---@throws Thrown when `builder_factory` is not a function.
---@nodiscard
function IconCatalog.dispatch(field, values, creator_name, builder_factory)
	check_dispatch(field, values, creator_name, builder_factory)

	local name = creator_name or "icon_creator"

	---@type table<any, fun(params?: table<string, any>): SafeIconData[]>
	local creators = {}
	for _, value in pairs(values) do
		creators[value] = builder_factory(value):build(name)
	end

	local check = V.signature(name, {
		{ "params", V.shape({ [field] = V.one_of(values) }):describe_as("the parameters of the icon") },
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

return IconCatalog
