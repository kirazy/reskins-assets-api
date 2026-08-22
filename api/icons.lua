---@using data
---@using Reskins.SpriteUtils

-- THIS MODULE IS STABLE
-- Methods may be added to it, but methods already defined are unlikely to change.

---Provides methods for manipulating icons specific to Artisanal Reskins.
---Includes the Artisanal Reskins: Sprite Utils icon utilities.
---
---### Examples
---```lua
---local icons_api = require("__reskins-assets-api__.prototypes.icons")
---```
---@class Reskins.Icons:Reskins.SpriteUtils.Icons
local icons_api = require("__reskins-sprite-utils__.icons")

---Indicates if the given `icon_datum` is using images from Artisanal Reskins.
---
---### Parameters
---@param icon_datum IconData # An `IconData` object.
---
---### Returns
---@return boolean # `true` if the icon is using images from Artisanal Reskins.
---@nodiscard
local function is_icon_using_reskins_images(icon_datum)
	return icon_datum and icon_datum.icon:find("__reskins%-") ~= nil
end

---Indicates if the given `icon_data` is using images from Artisanal Reskins.
---
---### Parameters
---@param icon_data IconData[] # An icon represented by an array of `IconData` objects.
---
---### Returns
---@return boolean # `true` if any of the icons in `icon_data` are using images from Artisanal Reskins.
---@nodiscard
function icons_api.is_icons_using_reskins_images(icon_data)
	if icon_data ~= nil then
		for i = #icon_data, 1, -1 do
			if is_icon_using_reskins_images(icon_data[i]) then
				return true
			end
		end
	end

	return false
end

local supported_symbols = {
	["area-drill"] = true,
	["filter"] = true,
	["shield"] = true,
	["aperture-open"] = true,
	["aperture-closed"] = true,
}

---Gets an icon representing the given `symbol` and colored with the given `tint`.
---
---### Parameters
---@param symbol Reskins.Defines.Symbol # The symbol to get an icon for.
---@param tint Color # The color to tint the icon.
---
---### Returns
---@return SafeIconData[] # An array of `IconData` objects representing the letter icon.
---
---### Examples
---Get the "area-drill" symbol icon in red and add it to the steel furnace.
---```lua
---local icons_api = require("__reskins-assets-api__.api.icons")
---local _defines = require("__reskins-assets-api__.api.defines")
---local symbol_icon = icons_api.get_symbol(_defines.symbols.area_drill, util.color("#ff0000"))
---
----- Add the symbol to the steel furnace icon.
---local steel_furnace = data.raw["furnace"]["steel-furnace"]
---steel_furnace.icons = icons_api.compose_icons(icons_api.get_icon_from_prototype(steel_furnace), symbol_icon)
---```
---
---### Exceptions
---*@throws* `string` — Thrown when `symbol` is not one of `"area-drill"`, `"filter"`, or `"shield"`.
---
---@see Reskins.Defines.Symbol
---@see Reskins.Icons.get_icon_from_prototype
---@nodiscard
function icons_api.get_symbol(symbol, tint)
	local safe_symbol = tostring(symbol)
	assert(
		supported_symbols[safe_symbol],
		"Invalid parameter: 'symbol' must be one of 'area-drill', 'filter', or 'shield'."
	)

	---@type SafeIconData[]
	local icon_data = {
		{
			icon = "__reskins-assets-api__/graphics/icons/symbols/" .. safe_symbol:lower() .. "-symbol.png",
			icon_size = 64,
			scale = 0.5,
		},
		{
			icon = "__reskins-assets-api__/graphics/icons/symbols/" .. safe_symbol:lower() .. "-symbol.png",
			icon_size = 64,
			scale = 0.5,
			---@diagnostic disable-next-line: param-type-mismatch
			tint = util.get_color_with_alpha(tint, 0.75) --[[@as Color]],
		},
	}

	return icon_data
end

---Removes any symbol icon layers from a copy of the given `icon_data`, if found.
---
---`icon_data` is not modified.
---
---### Parameters
---@param icon_data IconData[] # An icon represented by an array of `IconData` objects.
---
---### Returns
---@return IconData[] icon_data # A copy of `icon_data`, without the symbol icon layer.
---@return IconData[]|nil removed_layers  # A copy of the symbol icon layer removed from `icon_data`, if found; otherwise, `nil`.
---
---### Examples
---Assuming that the inserter icon has a filter symbol applied to it, do the following
---to remove the symbol from the inserter icon.
---```lua
---local icons_api = require("__reskins-assets-api__.api.icons")
---local icon_with_symbol = icons_api.get_icon_from_named_prototype("inserter", "inserter")
---
----- Remove any symbols, discarding the removed symbols.
---local icon_without_symbol = icons_api.remove_symbols_from_icons(icon_with_symbol)
---
----- Remove any symbols, and keep a copy of the removed symbol icon layers.
---local icon_without_symbol, removed_symbol = __tiers.remove_symbols_from_icons(icon_with_symbol)
---```
---
---### Exceptions
---*@throws* `string` — Thrown when `icon_data` is `nil`.
---
---@see Reskins.Icons.get_icon_from_named_prototype
---@nodiscard
function icons_api.remove_symbols_from_icons(icon_data)
	assert(icon_data, "Invalid parameter: 'icon_data' must not be nil.")

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

local supported_letters = {
	["F"] = true,
	["H"] = true,
	["L"] = true,
	["M"] = true,
	["S"] = true,
}

---Gets an icon representing the given `letter` and colored with the given `tint`.
---
---The icon is comprised of two layers, an untinted base and a tinted mask over top to create the effect.
---
---### Parameters
---@param letter Reskins.Defines.Letter # The letter to get an icon for.
---@param tint Color # The color to tint the icon.
---
---### Returns
---@return SafeIconData[] # An array of `IconData` objects representing the letter icon.
---
---### Examples
---Get the "F" letter icon in red and add it to the steel furnace.
---```lua
---local icons_api = require("__reskins-assets-api__.api.icons")
---local letter_icon = icons_api.get_letter("F", util.color("#ff0000"))
---
----- Add the letter to the steel furnace icon.
---local steel_furnace = data.raw["furnace"]["steel-furnace"]
---steel_furnace.icons = icons_api.compose_icons(icons_api.get_icon_from_prototype(steel_furnace), letter_icon)
---```
---
---### Exceptions
---*@throws* `string` — Thrown when `letter` is not one of `"F"`, `"H"`, `"L"`, `"M"`, or `"S"`.
---
---@see Reskins.Icons.compose_icons
---@see Reskins.Icons.get_icon_from_prototype
---@nodiscard
function icons_api.get_letter(letter, tint)
	local safe_letter = tostring(letter)
	assert(supported_letters[safe_letter], "Invalid parameter: 'letter' must be one of 'F', 'H', 'L', 'M', or 'S'.")

	---@type SafeIconData[]
	local icon_data = {
		{
			icon = "__reskins-assets-api__/graphics/icons/letters/letter-" .. safe_letter:lower() .. ".png",
			icon_size = 64,
			scale = 0.5,
		},
		{
			icon = "__reskins-assets-api__/graphics/icons/letters/letter-" .. safe_letter:lower() .. ".png",
			icon_size = 64,
			scale = 0.5,
			---@diagnostic disable-next-line: param-type-mismatch
			tint = util.get_color_with_alpha(tint, 0.75) --[[@as Color]],
		},
	}

	return icon_data
end

---Removes any letter icon layers from a copy of the given `icon_data`, if found.
---
---`icon_data` is not modified.
---
---### Parameters
---@param icon_data IconData[] # An icon represented by an array of `IconData` objects.
---
---### Returns
---@return IconData[] icon_data # A copy of `icon_data`, without the letter icon layer.
---@return IconData[]|nil removed_layers  # A copy of the letter icon layers removed from `icon_data`, if any.
---
---### Examples
---Remove any letters from the `solar-panel-small` icon.
---```lua
---local icons_api = require("__reskins-assets-api__.api.icons")
---local icon_with_letters = icons_api.get_icon_from_named_prototype("solar-panel-small", "solar-panel")
---
----- Remove any letters, discarding the removed letters.
---local icon_without_letters = icons_api.remove_letters_from_icons(icon_with_letters)
---
----- Remove any letters, and keep a copy of the removed symbol icon layers.
---local icon_without_letters, removed_letters = __tiers.remove_letters_from_icons(icon_with_letters)
---```
---
---### Exceptions
---*@throws* `string` — Thrown when `icon_data` is `nil`.
---
---@see Reskins.Icons.get_icon_from_named_prototype
---@nodiscard
function icons_api.remove_letters_from_icons(icon_data)
	assert(icon_data, "Invalid parameter: 'icon_data' must not be nil.")

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

---Gets an icon layer that is a flat, square background with rounded corners in the specified `tint`.
---
---### Parameters
---@param tint Color? The color of the background.
---
---### Returns
---@return SafeIconData background # An [IconData](lua://IconData) layer that serves as a background.
---
---### Examples
---Add a red background layer underneath the iron plate icon.
---```lua
----- Get the red background layer.
---local icons_api = require("__reskins-assets-api__.api.icons")
---local background = icons_api.get_icon_background_layer(util.color("#ff0000"))
---
----- Add the background under the iron plate icon.
---local iron_plate = data.raw["item"]["iron-plate"]
---iron_plate.icons = icons_api.compose_icons(background, icons_api.get_icon_from_prototype(iron_plate))
---```
---@see Reskins.Icons.compose_icons
---@see Reskins.Icons.get_icon_from_prototype
---@nodiscard
function icons_api.get_icon_background_layer(tint)
	---@type SafeIconData
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
---@return SafeIconData overlay # An [IconData](lua://IconData) layer that serves as an overlay.
---
---### Examples
---Add the minified symbol to the steel furnace item.
---```lua
----- Get the overlay
---local icons_api = require("__reskins-assets-api__.api.icons")
---local overlay = icons_api.get_minified_symbol_overlay()
---
----- Add the overlay over the steel furnace icon.
---local steel_furnace = data.raw["item"]["steel-furnace"]
---steel_furnace.icons = icons_api.compose_icons(icons_api.get_icon_from_prototype(steel_furnace), overlay)
---```
---@see Reskins.Icons.compose_icons
---@see Reskins.Icons.get_icon_from_prototype
---@nodiscard
function icons_api.get_minified_symbol_overlay()
	---@type SafeIconData
	local icon_data = {
		icon = "__reskins-assets-api__/graphics/icons/mini-machine-overlay.png",
		icon_size = 64,
		scale = 0.5,
	}

	return icon_data
end

return icons_api
