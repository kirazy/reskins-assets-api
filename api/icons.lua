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

---The group of the equipment background in an icon composition, in the `backdrop` stratum.
---
---- The group is not tintable. The background gets its tint from `get_icon_background_layer`.
---- The group is not included in the `pictures` projection, so the item is drawn in the world without the background.
---
---#### Examples
---```lua
----- Compose the icon of an equipment item on the background of its category.
---local composition = get_icon_composition({ tint = tint })
---    :add(icons_api.equipment_background_group, icons_api.get_icon_background_layer(util.color("#e62c2c")))
---    :outline()
---
---local icon_data, pictures = composition:build()
----- The icon has the background beneath the artwork, and the pictures have the artwork alone.
---```
---@type IconCompositionGroup
_icons.equipment_background_group = {
	name = "equipment-background",
	stratum = "backdrop",
	tintable = false,
	projections = { pictures = false },
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

local check_get_equipment_background_layer = V.signature("get_equipment_background_layer", {
	{ "category", AssetsCommon.equipment_category },
})

---Gets the icon layer of the background for the given equipment `category`, in the color of the category.
---@param category EquipmentCategory The category of the equipment.
---@return SafeIconData background The background layer.
---
---#### Examples
---```lua
----- Compose the icon of a vehicle battery on the background of energy equipment.
---local composition = EquipmentBattery2.get_icon_composition({ tint = tint })
---    :add(icons_api.equipment_background_group, icons_api.get_equipment_background_layer("energy"))
---    :outline()
---
---local icon_data, pictures = composition:build()
----- The icon has the green background beneath the artwork, and the pictures have the artwork alone.
---```
---@throws When `category` is not an `EquipmentCategory`.
---@see Reskins.Assets.Icons.equipment_background_group
---@nodiscard
function _icons.get_equipment_background_layer(category)
	check_get_equipment_background_layer(category)

	return _icons.get_icon_background_layer(equipment_background_tints[category])
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

---Gets a transparent technology icon layer that is placed beneath a miniature entity in a technology icon.
---@return SafeIconData underlay The underlay layer, in the icon defaults of a technology.
---
---#### Examples
---```lua
----- Compose the technology icon of a miniature furnace from the icon of the advanced material processing technology,
----- scaled down between the underlay and the overlay.
---local composition = IconComposition:from_icon(icons_api.get_minified_technology_underlay(), nil, "technology")
---    :add_canvas(data.raw.technology["advanced-material-processing"], { scale = 0.8 })
---    :add_symbol(icons_api.get_minified_technology_overlay())
----- The composition has the underlay, the icon of the technology at a scale of 0.8, and the overlay, in that order.
---```
---@see Reskins.Assets.Icons.get_minified_technology_overlay
---@nodiscard
function _icons.get_minified_technology_underlay()
	local icon_data = {
		icon = "__reskins-assets-api__/graphics/technology/mini-machine-underlay.png",
		icon_size = 256,
		scale = 0.5,
	}

	return icon_data
end

---Gets a technology icon layer with a symbol in the top-right corner that indicates a miniature entity.
---@return SafeIconData overlay The overlay layer, in the icon defaults of a technology.
---@see Reskins.Assets.Icons.get_minified_technology_underlay
---@nodiscard
function _icons.get_minified_technology_overlay()
	local icon_data = {
		icon = "__reskins-assets-api__/graphics/technology/mini-machine-overlay.png",
		icon_size = 256,
		scale = 0.5,
	}

	return icon_data
end

local check_get_technology_constant = V.signature("get_technology_constant", {
	{ "constant", AssetsCommon.technology_constant },
})

---Gets a technology icon layer with the given constant icon of the base game, placed in the lower-right corner as the
---`util.technology_icon_constant_*` functions of the base game place it.
---@param constant TechnologyConstant The constant.
---@return SafeIconData constant_layer The layer, in the icon defaults of a technology, with `floating` set.
---
---#### Examples
---```lua
----- Add the damage constant to a technology icon.
---local _defines = require("__reskins-assets-api__.api.defines")
---
---local composition = get_technology_icon_composition({ tint = tint })
---    :add_symbol(icons_api.get_technology_constant(_defines.technology_constant.damage))
----- The constant is drawn at half size in the lower-right corner, outside the bounds of the GUI slot.
---```
---@throws When `constant` is not a `TechnologyConstant`.
---@see Reskins.Assets.TechnologyConstant
---@nodiscard
function _icons.get_technology_constant(constant)
	check_get_technology_constant(constant)

	local icon_data = {
		icon = "__core__/graphics/icons/technology/constants/constant-" .. constant .. ".png",
		icon_size = 128,
		scale = 0.5,
		shift = { 50, 50 },
		floating = true,
	}

	return icon_data
end

local check_get_technology_equipment_overlay = V.signature("get_technology_equipment_overlay", {
	{ "equipment", AssetsCommon.equipment_overlay },
})

---Gets a technology icon layer with the overlay of the given `equipment`, placed at the bottom of the icon.
---@param equipment EquipmentOverlay The equipment of the overlay.
---@return SafeIconData overlay The overlay layer, in the icon defaults of a technology, with `floating` set.
---
---#### Examples
---```lua
----- Add the personal equipment overlay to a technology icon.
---local _defines = require("__reskins-assets-api__.api.defines")
---
---local composition = get_technology_icon_composition({ tint = tint })
---    :add_symbol(icons_api.get_technology_equipment_overlay(_defines.equipment_overlay.personal))
----- The overlay is drawn at half size at the bottom of the icon, outside the bounds of the GUI slot.
---```
---@throws When `equipment` is not an `EquipmentOverlay`.
---@see Reskins.Assets.EquipmentOverlay
---@nodiscard
function _icons.get_technology_equipment_overlay(equipment)
	check_get_technology_equipment_overlay(equipment)

	local icon_data = {
		icon = "__reskins-assets-api__/graphics/technology/" .. equipment .. "-equipment-overlay.png",
		icon_size = 128,
		scale = 0.5,
		shift = { 32, 50 },
		floating = true,
	}

	return icon_data
end

return _icons
