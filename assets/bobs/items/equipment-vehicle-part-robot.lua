---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.bobs_assets .. "/graphics/icons" })

---Provides methods for getting the icon of the vehicle roboport robot equipment,
---`equipment-vehicle-part-robot/equipment-vehicle-part-robot-{role}.png`.
---
---#### Examples
---```lua
---local EquipmentVehiclePartRobot = require("__reskins-assets-api__.assets.bobs.items.equipment-vehicle-part-robot")
---```
---@class EquipmentVehiclePartRobot
local M = {}

---Gets the icon for the vehicle roboport robot equipment as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icons:tinted("equipment-vehicle-part-robot"):build_composition("get_icon_composition")

return M
