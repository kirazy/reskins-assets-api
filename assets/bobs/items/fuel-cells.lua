---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.bobs_assets .. "/graphics/icons/fuel-cells" })

---Provides methods for getting the icons of the fuel-cells folder, such as
---`fuel-cells/depleted-deuterium-fuel-cell-blue.png`.
---
---#### Examples
---```lua
---local FuelCells = require("__reskins-assets-api__.assets.bobs.items.fuel-cells")
---```
---@class FuelCells
local M = {}

---Gets the icon for the depleted deuterium fuel cell as an `IconComposition`, with blue deuterium.
M.get_depleted_deuterium_fuel_cell_blue_icon_composition = icons
	:flat("depleted-deuterium-fuel-cell-blue")
	:build_composition("get_depleted_deuterium_fuel_cell_blue_icon_composition")

---Gets the icon for the depleted deuterium fuel cell as an `IconComposition`, with pink deuterium.
M.get_depleted_deuterium_fuel_cell_pink_icon_composition = icons
	:flat("depleted-deuterium-fuel-cell-pink")
	:build_composition("get_depleted_deuterium_fuel_cell_pink_icon_composition")

---Gets the icon for the depleted thorium fuel cell as an `IconComposition`.
M.get_depleted_thorium_fuel_cell_icon_composition =
	icons:flat("depleted-thorium-fuel-cell"):build_composition("get_depleted_thorium_fuel_cell_icon_composition")

---Gets the icon for the deuterium fuel cell 2 as an `IconComposition`, with blue deuterium.
M.get_deuterium_fuel_cell_2_blue_icon_composition =
	icons:flat("deuterium-fuel-cell-2-blue"):build_composition("get_deuterium_fuel_cell_2_blue_icon_composition")

---Gets the icon for the deuterium fuel cell 2 as an `IconComposition`, with pink deuterium.
M.get_deuterium_fuel_cell_2_pink_icon_composition =
	icons:flat("deuterium-fuel-cell-2-pink"):build_composition("get_deuterium_fuel_cell_2_pink_icon_composition")

---Gets the icon for the deuterium fuel cell as an `IconComposition`, with blue deuterium.
M.get_deuterium_fuel_cell_blue_icon_composition =
	icons:flat("deuterium-fuel-cell-blue"):build_composition("get_deuterium_fuel_cell_blue_icon_composition")

---Gets the icon for the deuterium fuel cell as an `IconComposition`, with pink deuterium.
M.get_deuterium_fuel_cell_pink_icon_composition =
	icons:flat("deuterium-fuel-cell-pink"):build_composition("get_deuterium_fuel_cell_pink_icon_composition")

---Gets the icon for the plutonium fuel cell as an `IconComposition`.
M.get_plutonium_fuel_cell_icon_composition =
	icons:flat("plutonium-fuel-cell"):build_composition("get_plutonium_fuel_cell_icon_composition")

---Gets the icon for the thorium fuel cell as an `IconComposition`.
M.get_thorium_fuel_cell_icon_composition =
	icons:flat("thorium-fuel-cell"):build_composition("get_thorium_fuel_cell_icon_composition")

---Gets the icon for the thorium-plutonium fuel cell as an `IconComposition`.
M.get_thorium_plutonium_fuel_cell_icon_composition =
	icons:flat("thorium-plutonium-fuel-cell"):build_composition("get_thorium_plutonium_fuel_cell_icon_composition")

return M
