---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Technologies

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local technologies = IconBuilderFactory:create({
	folder = _defines.assets_source.bobs_assets .. "/graphics/technology",
	defaults_type = "technology",
})

---Provides methods for getting the technology icon of the vehicle energy shield equipment,
---`equipment-vehicle-energy-shield/equipment-vehicle-energy-shield-{role}.png`.
---
---#### Examples
---```lua
---local EquipmentVehicleEnergyShield =
---    require("__reskins-assets-api__.assets.bobs.technologies.equipment-vehicle-energy-shield")
---```
---@class EquipmentVehicleEnergyShield
local M = {}

local icon_builder = technologies:tinted("equipment-vehicle-energy-shield")

---Gets the technology icon for the vehicle energy shield equipment, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for the vehicle energy shield equipment as an `IconComposition`, in the tints given by
---`params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
