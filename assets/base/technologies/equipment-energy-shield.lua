---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Technologies

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local technologies = IconBuilderFactory:create({
	folder = _defines.assets_source.base_assets .. "/graphics/technology",
	defaults_type = "technology",
})

---Provides methods for getting the technology icon of the energy shield equipment,
---`equipment-energy-shield/equipment-energy-shield-{role}.png`.
---
---#### Examples
---```lua
---local EquipmentEnergyShield = require("__reskins-assets-api__.assets.base.technologies.equipment-energy-shield")
---```
---@class EquipmentEnergyShield
local M = {}

local icon_builder = technologies:tinted("equipment-energy-shield")

---Gets the technology icon for the energy shield equipment, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for the energy shield equipment as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
