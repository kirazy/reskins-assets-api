---@using data
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets

---Provides methods for manipulating icons specific to Artisanal Reskins.
---
---### Examples
---```lua
---local icons_api = require("__reskins-assets-api__.api.icons")
---```
---@class Icons
local _icons = {}

local _sprite_utils = { icons = require("__reskins-sprite-utils__.icons") }
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local AssetsCommon = require("api.validation")

---Indicates if the given `icon_datum` is using images from Artisanal Reskins.
---
---### Parameters
---@param icon_datum IconData # An `IconData` object.
---
---### Returns
---@return boolean # `true` if the icon is using images from Artisanal Reskins.
---@nodiscard
local function is_icon_using_reskins_images(icon_datum)
	return icon_datum.icon:find("__reskins%-") ~= nil
end

local check_is_icons_using_reskins_images = V.signature("is_icons_using_reskins_images", {
	{ "icon_data", Common.icon_data },
})

---Indicates if the given `icon_data` is using images from Artisanal Reskins.
---
---### Parameters
---@param icon_data IconData[] # An icon represented by an array of `IconData` objects.
---
---### Returns
---@return boolean # `true` if any of the icons in `icon_data` are using images from Artisanal Reskins.
---
---### Exceptions
---*@throws* `string` — Thrown when `icon_data` is not a non-empty array of `IconData` objects.
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

---Creates a two-layer icon from `icon`: an untinted base, and a copy of it tinted with `tint` at 75%
---opacity layered on top. This is the effect used to color symbols, letters, and tier pips.
---
---### Parameters
---@param icon FileName # The file name of the icon to tint.
---@param tint Color # The color to tint the icon.
---@param icon_size SpriteSizeType? # The size, in pixels, the icon is authored at. Defaults to the size `defaults_type` implies.
---@param defaults_type IconDefaultsType? # The type-specific icon defaults to fill in. Defaults to `"default"`.
---
---### Returns
---@return SafeIconData[] # An array of two `IconData` objects, sized and scaled: the untinted base, then the tinted copy.
---
---### Examples
---```lua
---local icons_api = require("__reskins-assets-api__.api.icons")
---local tinted_gear = icons_api.get_tinted_icon("__my-mod__/graphics/icons/gear.png", util.color("#ff0000"))
---```
---
---### Exceptions
---*@throws* `string` — Thrown when `icon` is not a mod-relative file path.\
---*@throws* `string` — Thrown when `tint` is not a `Color`.\
---*@throws* `string` — Thrown when `icon_size` is not a sprite size in pixels.\
---*@throws* `string` — Thrown when `defaults_type` is not a non-empty string.
---
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
---
---### Parameters
---@param symbol Symbol # The symbol to get an icon for.
---@param tint Color # The color to tint the icon.
---
---### Returns
---@return SafeIconData[] # An array of `IconData` objects representing the symbol icon.
---
---### Examples
---Get the "area-drill" symbol icon in red and add it to the steel furnace.
---```lua
---local icons_api = require("__reskins-assets-api__.api.icons")
---local sprite_utils_icons = require("__reskins-sprite-utils__.icons")
---local _defines = require("__reskins-assets-api__.api.defines")
---local symbol_icon = icons_api.get_symbol(_defines.symbol.area_drill, util.color("#ff0000"))
---
----- Add the symbol to the steel furnace icon.
---local steel_furnace = data.raw["furnace"]["steel-furnace"]
---local steel_furnace_icon = sprite_utils_icons.get_icon_from_prototype(steel_furnace)
---steel_furnace.icons = sprite_utils_icons.compose_icons(steel_furnace_icon, symbol_icon)
---```
---
---### Exceptions
---*@throws* `string` — Thrown when `symbol` is not one of `"area-drill"`, `"filter"`, `"shield"`, `"aperture-open"`, or `"aperture-closed"`.\
---*@throws* `string` — Thrown when `tint` is not a `Color`.
---
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
---### Parameters
---@param icon_data IconData[] # An icon represented by an array of `IconData` objects.
---
---### Returns
---@return IconData[] icon_data # A copy of `icon_data`, without the symbol icon layer.
---@return IconData[]|nil removed_layers # A copy of the symbol icon layer removed from `icon_data`, if found; otherwise, `nil`.
---
---### Examples
---Assuming that the inserter icon has a filter symbol applied to it, do the following
---to remove the symbol from the inserter icon.
---```lua
---local icons_api = require("__reskins-assets-api__.api.icons")
---local sprite_utils_icons = require("__reskins-sprite-utils__.icons")
---local icon_with_symbol = sprite_utils_icons.get_icon_from_named_prototype("inserter", "inserter")
---
----- Remove any symbols, discarding the removed symbols.
---local icon_without_symbol = icons_api.remove_symbols_from_icons(icon_with_symbol)
---
----- Remove any symbols, and keep a copy of the removed symbol icon layers.
---local icon_without_symbol, removed_symbol = icons_api.remove_symbols_from_icons(icon_with_symbol)
---```
---
---### Exceptions
---*@throws* `string` — Thrown when `icon_data` is not a non-empty array of `IconData` objects.
---
---@see Reskins.SpriteUtils.Icons.get_icon_from_named_prototype
---@nodiscard
function _icons.remove_symbols_from_icons(icon_data)
	check_remove_symbols_from_icons(icon_data)

	local icon_data_copy = util.copy(icon_data)

	---@type IconData[]
	local removed_layers = {}

	if #icon_data >= 2 then
		for i = #icon_data_copy, 1, -1 do
			if is_icon_using_reskins_images(icon_data_copy[i]) and icon_data_copy[i].icon:find("%-symbol.png") then
				table.insert(removed_layers, 1, table.remove(icon_data_copy, i))
			end
		end
	end

	return icon_data_copy, #removed_layers > 0 and removed_layers or nil
end

local check_get_letter = V.signature("get_letter", {
	{ "letter", AssetsCommon.letter },
	{ "tint", Common.color },
})

---Gets an icon representing the given `letter` and colored with the given `tint`.
---
---The icon is comprised of two layers, an untinted base and a tinted mask over top to create the effect.
---
---### Parameters
---@param letter Letter # The letter to get an icon for.
---@param tint Color # The color to tint the icon.
---
---### Returns
---@return SafeIconData[] # An array of `IconData` objects representing the letter icon.
---
---### Examples
---Get the "F" letter icon in red and add it to the steel furnace.
---```lua
---local icons_api = require("__reskins-assets-api__.api.icons")
---local sprite_utils_icons = require("__reskins-sprite-utils__.icons")
---local letter_icon = icons_api.get_letter("F", util.color("#ff0000"))
---
----- Add the letter to the steel furnace icon.
---local steel_furnace = data.raw["furnace"]["steel-furnace"]
---local steel_furnace_icon = sprite_utils_icons.get_icon_from_prototype(steel_furnace)
---steel_furnace.icons = sprite_utils_icons.compose_icons(steel_furnace_icon, letter_icon)
---```
---
---### Exceptions
---*@throws* `string` — Thrown when `letter` is not one of `"F"`, `"H"`, `"L"`, `"M"`, or `"S"`.\
---*@throws* `string` — Thrown when `tint` is not a `Color`.
---
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
---### Parameters
---@param icon_data IconData[] # An icon represented by an array of `IconData` objects.
---
---### Returns
---@return IconData[] icon_data # A copy of `icon_data`, without the letter icon layer.
---@return IconData[]|nil removed_layers # A copy of the letter icon layers removed from `icon_data`, if any.
---
---### Examples
---Remove any letters from the `solar-panel-small` icon.
---```lua
---local icons_api = require("__reskins-assets-api__.api.icons")
---local sprite_utils_icons = require("__reskins-sprite-utils__.icons")
---local icon_with_letters = sprite_utils_icons.get_icon_from_named_prototype("solar-panel-small", "solar-panel")
---
----- Remove any letters, discarding the removed letters.
---local icon_without_letters = icons_api.remove_letters_from_icons(icon_with_letters)
---
----- Remove any letters, and keep a copy of the removed letter icon layers.
---local icon_without_letters, removed_letters = icons_api.remove_letters_from_icons(icon_with_letters)
---```
---
---### Exceptions
---*@throws* `string` — Thrown when `icon_data` is not a non-empty array of `IconData` objects.
---
---@see Reskins.SpriteUtils.Icons.get_icon_from_named_prototype
---@nodiscard
function _icons.remove_letters_from_icons(icon_data)
	check_remove_letters_from_icons(icon_data)

	local icon_data_copy = util.copy(icon_data)

	---@type IconData[]
	local removed_layers = {}

	if #icon_data > 2 then
		for i = #icon_data_copy, 1, -1 do
			if is_icon_using_reskins_images(icon_data_copy[i]) and icon_data_copy[i].icon:find("letter%-.%.png") then
				table.insert(removed_layers, 1, table.remove(icon_data_copy, i))
			end
		end
	end

	return icon_data_copy, #removed_layers > 0 and removed_layers or nil
end

-- FIXME: Move to reskins-framework/reskins-bobs.
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

---Gets an icon layer that is a flat, square background with rounded corners in the specified `tint`.
---
---### Parameters
---@param tint Color? The color of the background.
---
---### Returns
---@return SafeIconData background # An IconData layer that serves as a background.
---
---### Examples
---Add a red background layer underneath the iron plate icon.
---```lua
----- Get the red background layer.
---local icons_api = require("__reskins-assets-api__.api.icons")
---local sprite_utils_icons = require("__reskins-sprite-utils__.icons")
---local background = icons_api.get_icon_background_layer(util.color("#ff0000"))
---
----- Add the background under the iron plate icon.
---local iron_plate = data.raw["item"]["iron-plate"]
---local iron_plate_icon = sprite_utils_icons.get_icon_from_prototype(iron_plate)
---iron_plate.icons = sprite_utils_icons.compose_icons(background, iron_plate_icon)
---```
---### Exceptions
---*@throws* `string` — Thrown when `tint` is not a `Color`.
---
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

---Gets an icon layer with a symbol in the top-right corner suitable for indicating a miniature entity.
---
---### Returns
---@return SafeIconData overlay # An IconData layer that serves as an overlay.
---
---### Examples
---Add the minified symbol to the steel furnace item.
---```lua
----- Get the overlay
---local icons_api = require("__reskins-assets-api__.api.icons")
---local sprite_utils_icons = require("__reskins-sprite-utils__.icons")
---local overlay = icons_api.get_minified_symbol_overlay()
---
----- Add the overlay over the steel furnace icon.
---local steel_furnace = data.raw["item"]["steel-furnace"]
---local steel_furnace_icon = sprite_utils_icons.get_icon_from_prototype(steel_furnace)
---steel_furnace.icons = sprite_utils_icons.compose_icons(steel_furnace_icon, overlay)
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
