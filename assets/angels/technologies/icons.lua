---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Technologies

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local technologies = IconBuilderFactory:create({
	folder = _defines.assets_source.angels_assets .. "/graphics/technology",
	defaults_type = "technology",
})

---Provides methods for getting the technology icons of Angel's technologies at the root of the technology folder, such
---as `thorium-power.png`.
---
---#### Examples
---```lua
---local Icons = require("__reskins-assets-api__.assets.angels.technologies.icons")
---```
---@class Icons
local M = {}

local logistic_warehouses = technologies:flat("logistic-warehouses")

---Gets the technology icon for logistic warehouses.
M.get_logistic_warehouses_icon = logistic_warehouses:build("get_logistic_warehouses_icon")

---Gets the technology icon for logistic warehouses as an `IconComposition`.
M.get_logistic_warehouses_icon_composition =
	logistic_warehouses:build_composition("get_logistic_warehouses_icon_composition")

local thorium_power = technologies:flat("thorium-power")

---Gets the technology icon for thorium power.
M.get_thorium_power_icon = thorium_power:build("get_thorium_power_icon")

---Gets the technology icon for thorium power as an `IconComposition`.
M.get_thorium_power_icon_composition = thorium_power:build_composition("get_thorium_power_icon_composition")

local warehouses = technologies:flat("warehouses")

---Gets the technology icon for warehouses.
M.get_warehouses_icon = warehouses:build("get_warehouses_icon")

---Gets the technology icon for warehouses as an `IconComposition`.
M.get_warehouses_icon_composition = warehouses:build_composition("get_warehouses_icon_composition")

return M
