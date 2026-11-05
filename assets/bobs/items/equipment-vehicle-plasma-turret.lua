---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.bobs_assets .. "/graphics/icons" })

---Provides methods for getting the icon of the vehicle plasma turret equipment,
---`equipment-vehicle-plasma-turret/equipment-vehicle-plasma-turret-{role}.png`.
---
---#### Examples
---```lua
---local EquipmentVehiclePlasmaTurret =
---    require("__reskins-assets-api__.assets.bobs.items.equipment-vehicle-plasma-turret")
---```
---@class EquipmentVehiclePlasmaTurret
local M = {}

---Gets the icon for the vehicle plasma turret equipment as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icons:tinted("equipment-vehicle-plasma-turret"):build_composition("get_icon_composition")

return M
