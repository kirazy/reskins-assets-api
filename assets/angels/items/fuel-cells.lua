---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local FUELS = {
	"deuterium",
	"mixed-oxide",
	"thorium",
	"uranium",
	"uranium-234",
}

---Provides methods for getting the icons of the fuel-cells folder of Angel's items, `fuel-cells/{fuel}-fuel-cell.png`.
---
---#### Examples
---```lua
---local FuelCells = require("__reskins-assets-api__.assets.angels.items.fuel-cells")
---```
---@class FuelCells
local M = {}

---Gets the icon for the fuel cell of the given `fuel` as an `IconComposition`.
---
---#### Examples
---```lua
----- Get the icon for the thorium fuel cell.
---local composition = FuelCells.get_icon_composition({ fuel = "thorium" })
----- The icon is fuel-cells/thorium-fuel-cell.png.
---```
M.get_icon_composition = IconBuilderFactory.dispatch_composition("fuel", FUELS, "get_icon_composition", function(fuel)
	return IconBuilderFactory:create({ folder = _defines.assets_source.angels_assets .. "/graphics/icons/fuel-cells" })
		:flat(fuel .. "-fuel-cell")
end)

return M
