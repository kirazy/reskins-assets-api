---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local IconBuilderFactory = require("api.icon-builder-factory")

-- The colors with artwork for the fuel cell of each fuel.
local FUEL_COLORS = {
	["deuterium"] = { ["blue"] = true, ["pink"] = true },
	["deuterium-2"] = { ["blue"] = true, ["pink"] = true },
	["depleted-deuterium"] = { ["blue"] = true, ["pink"] = true },
	["thorium"] = { ["yellow"] = true },
	["depleted-thorium"] = { ["yellow"] = true },
	["plutonium"] = { ["green"] = true },
	["thorium-plutonium"] = { ["orange"] = true },
}

local FUEL = V.one_of({
	"deuterium",
	"deuterium-2",
	"depleted-deuterium",
	"thorium",
	"depleted-thorium",
	"plutonium",
	"thorium-plutonium",
})
local COLOR = V.one_of({ "blue", "green", "orange", "pink", "yellow" })

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.bobs_assets .. "/graphics/icons" })

---Provides methods for getting the icons of the fuel-cells folder, `fuel-cells/{fuel}/fuel-cell-{fuel}-{color}.png`.
---
---#### Examples
---```lua
---local FuelCells = require("__reskins-assets-api__.assets.bobs.items.fuel-cells")
---```
---@class FuelCells
local M = {}

---Gets the icon for the fuel cell of the given `fuel` in the given `color` as an `IconComposition`.
---
---Not every fuel has artwork in every color.
---
---#### Examples
---```lua
----- Get the icon for the deuterium fuel cell in blue.
---local icon_data = FuelCells.get_icon_composition({ fuel = "deuterium", color = "blue" }):build()
----- The icon is fuel-cells/deuterium/fuel-cell-deuterium-blue.png.
---```
M.get_icon_composition = icons
	:collection("fuel-cells", "fuel", FUEL)
	:stem("fuel-cell")
	:keyed("color", COLOR)
	:build_composition("get_icon_composition", {
		{
			field = "color",
			fields = { "fuel", "color" },
			check = function(fuel, color)
				return FUEL_COLORS[fuel][color] == true
			end,
			message = "a color in which the fuel cell of the given fuel has artwork",
		},
	})

return M
