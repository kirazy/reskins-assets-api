---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons =
	IconBuilderFactory:create({ folder = _defines.assets_source.angels_assets .. "/graphics/icons/nuclear-fuel" })

---Provides methods for getting the icons of the nuclear-fuel folder of Angel's items, such as `nuclear-fuel-2.png`.
---
---#### Examples
---```lua
---local NuclearFuel = require("__reskins-assets-api__.assets.angels.items.nuclear-fuel")
---```
---@class NuclearFuel
local M = {}

---Gets the icon for the nuclear fuel as an `IconComposition`.
M.get_nuclear_fuel_icon_composition = icons:flat("nuclear-fuel"):build_composition("get_nuclear_fuel_icon_composition")

---Gets the icon for the nuclear fuel 2 as an `IconComposition`.
M.get_nuclear_fuel_2_icon_composition =
	icons:flat("nuclear-fuel-2"):build_composition("get_nuclear_fuel_2_icon_composition")

return M
