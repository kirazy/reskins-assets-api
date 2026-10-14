---@using data
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets

---Provides methods for manipulating icons specific to Artisanal Reskins.
---
---#### Examples
---```lua
---local icons_api = require("__reskins-assets-api__.api.icons")
---```
---@class Icons
local _icons = {}

local _sprite_utils = { icons = require("__reskins-sprite-utils__.icons") }
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local AssetsCommon = require("api.validation")

---Indicates whether the given `icon_datum` uses artwork from Artisanal Reskins.
---@param icon_datum IconData An `IconData` object.
---@return boolean # `true` when the `icon` path of the layer starts with `__reskins-`; otherwise, `false`.
---@nodiscard
local function is_icon_using_reskins_images(icon_datum)
	return icon_datum.icon:find("^__reskins%-") ~= nil
end

local check_is_icons_using_reskins_images = V.signature("is_icons_using_reskins_images", {
	{ "icon_data", Common.icon_data },
})

---Indicates whether any layer of the given `icon_data` uses artwork from Artisanal Reskins.
---@param icon_data IconData[] An icon represented by an array of `IconData` objects.
---@return boolean # `true` when the `icon` path of any layer starts with `__reskins-`; otherwise, `false`.
---@throws When `icon_data` is not a non-empty array of `IconData` objects.
---@nodiscard
function _icons.is_icons_using_reskins_images(icon_data)
	check_is_icons_using_reskins_images(icon_data)

	for index = #icon_data, 1, -1 do
		if is_icon_using_reskins_images(icon_data[index]) then
			return true
		end
	end

	return false
end

local check_get_tinted_icon = V.signature("get_tinted_icon", {
	{ "icon", Common.mod_file_path },
	{ "tint", Common.color },
	{ "icon_size", Common.sprite_size:optional() },
	{ "defaults_type", Common.icon_defaults_type:optional() },
})

---Creates a two-layer icon from the given `icon`. The first layer is the untinted `icon`, and the second layer is a
---copy tinted with `tint` at 75% opacity.
---
---This method defines the effect used to produce colored symbols when provided a grayscale tintable symbol icon.
---
---#### Parameters
---@param icon FileName The file name of the icon to tint.
---@param tint Color The color to tint the icon.
---@param icon_size? SpriteSizeType The size, in pixels, of the icon on disk. When `nil`, the expected icon size of `defaults_type` is used.
---@param defaults_type? IconDefaultsType The name of the type-specific icon defaults applied to the icon. Default `"default"`.
---
---#### Returns
---@return SafeIconData[] # The icon.
---
---@throws When `icon` is not a mod-relative file path.
---@throws When `tint` is not a `Color`.
---@throws When `icon_size` is not a sprite size in pixels.
---@throws When `defaults_type` is an empty string.
---@nodiscard
function _icons.get_tinted_icon(icon, tint, icon_size, defaults_type)
	check_get_tinted_icon(icon, tint, icon_size, defaults_type)

	---@diagnostic disable-next-line: param-type-mismatch
	local tinted_color = util.get_color_with_alpha(tint, 0.75) --[[@as Color]]

	---@type IconData[]
	local icon_data = {
		{
			icon = icon,
			icon_size = icon_size,
		},
		{
			icon = icon,
			icon_size = icon_size,
			tint = tinted_color,
		},
	}

	return _sprite_utils.icons.add_missing_icons_defaults(icon_data, defaults_type)
end

local check_get_symbol = V.signature("get_symbol", {
	{ "symbol", AssetsCommon.symbol },
	{ "tint", Common.color },
})

---Gets an icon representing the given `symbol` and colored with the given `tint`.
---@param symbol Symbol The symbol for which the icon is created.
---@param tint Color The color to tint the icon.
---@return SafeIconData[] # The symbol icon.
---
---#### Examples
---```lua
----- Add a red area drill symbol to the steel furnace icon.
---local icons_api = require("__reskins-assets-api__.api.icons")
---local sprite_utils_icons = require("__reskins-sprite-utils__.icons")
---local _defines = require("__reskins-assets-api__.api.defines")
---
---local steel_furnace = data.raw["furnace"]["steel-furnace"]
---local steel_furnace_icon = sprite_utils_icons.get_icon_from_prototype(steel_furnace)
---local symbol_icon = icons_api.get_symbol(_defines.symbol.area_drill, util.color("#ff0000"))
---
---steel_furnace.icons = sprite_utils_icons.compose_icons(nil, steel_furnace_icon, symbol_icon)
----- The symbol is drawn on top of the steel furnace.
---```
---@throws When `symbol` is not one of `"area-drill"`, `"filter"`, `"shield"`, `"aperture-open"`, or `"aperture-closed"`.
---@throws When `tint` is not a `Color`.
---@see Reskins.Assets.Icons.get_tinted_icon
---@see Reskins.Assets.Symbol
---@see Reskins.SpriteUtils.Icons.get_icon_from_prototype
---@nodiscard
function _icons.get_symbol(symbol, tint)
	check_get_symbol(symbol, tint)

	return _icons.get_tinted_icon("__reskins-assets-api__/graphics/icons/symbols/" .. symbol .. "-symbol.png", tint)
end

local check_remove_symbols_from_icons = V.signature("remove_symbols_from_icons", {
	{ "icon_data", Common.icon_data },
})

---Removes any symbol icon layers from a copy of the given `icon_data`, if found.
---
---`icon_data` is not modified.
---
---#### Parameters
---@param icon_data IconData[] An icon represented by an array of `IconData` objects.
---
---#### Returns
---@return IconData[] icon_data A copy of `icon_data` without the symbol layers.
---@return IconData[]? removed_layers A copy of the symbol layers removed from `icon_data`, if any.
---
---#### Examples
---```lua
----- Remove the symbol from the inserter icon.
---local icons_api = require("__reskins-assets-api__.api.icons")
---local sprite_utils_icons = require("__reskins-sprite-utils__.icons")
---
---local icon_with_symbol = sprite_utils_icons.get_icon_from_named_prototype("inserter", "inserter")
---local icon_without_symbol, removed_layers = icons_api.remove_symbols_from_icons(icon_with_symbol)
----- removed_layers is nil when the icon has no symbol.
---```
---@throws When `icon_data` is not a non-empty array of `IconData` objects.
---@see Reskins.SpriteUtils.Icons.get_icon_from_named_prototype
---@nodiscard
function _icons.remove_symbols_from_icons(icon_data)
	check_remove_symbols_from_icons(icon_data)

	---@type IconData[]
	local stripped_icon_data = {}

	---@type IconData[]
	local removed_layers = {}

	for _, icon_datum in pairs(util.copy(icon_data)) do
		if is_icon_using_reskins_images(icon_datum) and icon_datum.icon:find("%-symbol.png") then
			removed_layers[#removed_layers + 1] = icon_datum
		else
			stripped_icon_data[#stripped_icon_data + 1] = icon_datum
		end
	end

	return stripped_icon_data, #removed_layers > 0 and removed_layers or nil
end

local check_get_letter = V.signature("get_letter", {
	{ "letter", AssetsCommon.letter },
	{ "tint", Common.color },
})

---Gets an icon representing the given `letter` and colored with the given `tint`.
---@param letter Letter The letter for which the icon is created.
---@param tint Color The color to tint the icon.
---@return SafeIconData[] # The letter icon.
---
---#### Examples
---```lua
----- Add a red "F" to the steel furnace icon.
---local icons_api = require("__reskins-assets-api__.api.icons")
---local sprite_utils_icons = require("__reskins-sprite-utils__.icons")
---
---local steel_furnace = data.raw["furnace"]["steel-furnace"]
---local steel_furnace_icon = sprite_utils_icons.get_icon_from_prototype(steel_furnace)
---local letter_icon = icons_api.get_letter("F", util.color("#ff0000"))
---
---steel_furnace.icons = sprite_utils_icons.compose_icons(nil, steel_furnace_icon, letter_icon)
----- The letter is drawn on top of the steel furnace.
---```
---@throws When `letter` is not one of `"F"`, `"H"`, `"L"`, `"M"`, or `"S"`.
---@throws When `tint` is not a `Color`.
---@see Reskins.Assets.Icons.get_tinted_icon
---@see Reskins.SpriteUtils.Icons.compose_icons
---@see Reskins.SpriteUtils.Icons.get_icon_from_prototype
---@nodiscard
function _icons.get_letter(letter, tint)
	check_get_letter(letter, tint)
	---@cast letter string

	return _icons.get_tinted_icon(
		"__reskins-assets-api__/graphics/icons/letters/letter-" .. letter:lower() .. ".png",
		tint
	)
end

local check_remove_letters_from_icons = V.signature("remove_letters_from_icons", {
	{ "icon_data", Common.icon_data },
})

---Removes any letter icon layers from a copy of the given `icon_data`, if found.
---
---`icon_data` is not modified.
---
---#### Parameters
---@param icon_data IconData[] An icon represented by an array of `IconData` objects.
---
---#### Returns
---@return IconData[] icon_data A copy of `icon_data` without the letter layers.
---@return IconData[]? removed_layers A copy of the letter layers removed from `icon_data`, if any.
---
---#### Examples
---```lua
----- Remove the letter from the small solar panel icon.
---local icons_api = require("__reskins-assets-api__.api.icons")
---local sprite_utils_icons = require("__reskins-sprite-utils__.icons")
---
---local icon_with_letter = sprite_utils_icons.get_icon_from_named_prototype("solar-panel-small", "solar-panel")
---local icon_without_letter, removed_layers = icons_api.remove_letters_from_icons(icon_with_letter)
----- removed_layers is nil when the icon has no letter.
---```
---@throws When `icon_data` is not a non-empty array of `IconData` objects.
---@see Reskins.SpriteUtils.Icons.get_icon_from_named_prototype
---@nodiscard
function _icons.remove_letters_from_icons(icon_data)
	check_remove_letters_from_icons(icon_data)

	---@type IconData[]
	local stripped_icon_data = {}

	---@type IconData[]
	local removed_layers = {}

	for _, icon_datum in pairs(util.copy(icon_data)) do
		if is_icon_using_reskins_images(icon_datum) and icon_datum.icon:find("letter%-.%.png") then
			removed_layers[#removed_layers + 1] = icon_datum
		else
			stripped_icon_data[#stripped_icon_data + 1] = icon_datum
		end
	end

	return stripped_icon_data, #removed_layers > 0 and removed_layers or nil
end

-- FIXME: Move to reskins-framework/reskins-bobs.
---Defines the categories of equipment, each of which has its own background color.
---@alias EquipmentCategory
---| "defense" # A blue background for defense equipment.
---| "energy" # A green background for energy equipment.
---| "offense" # A red background for offense equipment.
---| "utility" # A gray background for utility equipment.

-- FIXME: Move to reskins-framework/reskins-bobs.
local equipment_background_tints = {
	["offense"] = util.color("#e62c2c"),
	["defense"] = util.color("#3282d1"),
	["energy"] = util.color("#32d167"),
	["utility"] = util.color("#cccccc"),
}

local check_get_icon_background_layer = V.signature("get_icon_background_layer", {
	{ "tint", Common.color:optional() },
})

---Gets an icon layer that is a flat, square background with rounded corners in the given `tint`.
---@param tint? Color The color of the background.
---@return SafeIconData background The background layer.
---
---#### Examples
---```lua
----- Add a red background beneath the iron plate icon.
---local icons_api = require("__reskins-assets-api__.api.icons")
---local sprite_utils_icons = require("__reskins-sprite-utils__.icons")
---
---local iron_plate = data.raw["item"]["iron-plate"]
---local iron_plate_icon = sprite_utils_icons.get_icon_from_prototype(iron_plate)
---local background = icons_api.get_icon_background_layer(util.color("#ff0000"))
---
---iron_plate.icons = sprite_utils_icons.compose_icons(nil, background, iron_plate_icon)
----- The background is the first layer of the icon.
---```
---@throws When `tint` is not a `Color`.
---@see Reskins.SpriteUtils.Icons.compose_icons
---@see Reskins.SpriteUtils.Icons.get_icon_from_prototype
---@nodiscard
function _icons.get_icon_background_layer(tint)
	check_get_icon_background_layer(tint)

	local icon_data = {
		icon = "__reskins-assets-api__/graphics/icons/equipment-background.png",
		icon_size = 64,
		scale = 0.5,
		tint = tint,
	}

	return icon_data
end

---Gets an icon layer with a symbol in the top-right corner that indicates a miniature entity.
---@return SafeIconData overlay The overlay layer.
---
---#### Examples
---```lua
----- Add the overlay to the steel furnace item icon.
---local icons_api = require("__reskins-assets-api__.api.icons")
---local sprite_utils_icons = require("__reskins-sprite-utils__.icons")
---
---local steel_furnace = data.raw["item"]["steel-furnace"]
---local steel_furnace_icon = sprite_utils_icons.get_icon_from_prototype(steel_furnace)
---local overlay = icons_api.get_minified_symbol_overlay()
---
---steel_furnace.icons = sprite_utils_icons.compose_icons(nil, steel_furnace_icon, overlay)
----- The overlay is drawn on top of the steel furnace.
---```
---@see Reskins.SpriteUtils.Icons.compose_icons
---@see Reskins.SpriteUtils.Icons.get_icon_from_prototype
---@nodiscard
function _icons.get_minified_symbol_overlay()
	local icon_data = {
		icon = "__reskins-assets-api__/graphics/icons/mini-machine-overlay.png",
		icon_size = 64,
		scale = 0.5,
	}

	return icon_data
end

return _icons
