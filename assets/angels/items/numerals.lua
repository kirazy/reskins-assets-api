---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Items

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")

local FOLDER = _defines.assets_source.refining_graphics .. "/graphics/icons/numerals/"

---Provides methods for getting the numerals of Angel's mods, `numerals/num-{number}.png` and
---`numerals/num-{number}-outline.png` in Angel's Refining Graphics.
---
---#### Examples
---```lua
---local Numerals = require("__reskins-assets-api__.assets.angels.items.numerals")
---```
---@class Numerals
local M = {}

---The number drawn by a numeral of Angel's mods.
---@alias NumeralNumber 0|1|2|3|4|5|6|7|8|9|10

---Defines the options for the icon of a numeral.
---@class NumeralIconParams
---The number drawn by the numeral.
---@field number NumeralNumber
---The color to tint the numeral. When `nil`, the numeral is not tinted.
---@field tint? data.Color

local check_get_icon = V.signature("get_icon", {
	{
		"params",
		V.struct({
			number = V.one_of({ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }),
			tint = Common.color:optional(),
		}),
	},
})

---Gets the icon of the numeral for the given `params.number`, drawn over its black outline, in the size of a default
---icon.
---@param params NumeralIconParams The options for the icon.
---@return SafeIconData[] # The icon.
---
---#### Examples
---```lua
----- Get the icon for the second tier, tinted with the `number_tint` of Angel's smelting.
---local label = Numerals.get_icon({ number = 2, tint = angelsmods.smelting.number_tint })
----- The first layer is num-2-outline.png tinted black, and the second layer is num-2.png tinted with `number_tint`.
---```
---@throws When `params.number` is not an integer between 0 and 10.
---@throws When `params.tint` is not a `Color`.
---@nodiscard
function M.get_icon(params)
	check_get_icon(params)

	---@type SafeIconData[]
	local icon_data = {
		{
			icon = FOLDER .. "num-" .. params.number .. "-outline.png",
			icon_size = 64,
			scale = 0.5,
			tint = { 0, 0, 0, 1 },
		},
		{
			icon = FOLDER .. "num-" .. params.number .. ".png",
			icon_size = 64,
			scale = 0.5,
			tint = params.tint,
		},
	}

	return icon_data
end

return M
