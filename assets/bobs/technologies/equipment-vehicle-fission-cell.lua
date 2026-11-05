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

---Provides methods for getting the technology icon of the vehicle fission cell equipment,
---`equipment-vehicle-fission-cell/equipment-vehicle-fission-cell-{role}.png`.
---
---#### Examples
---```lua
---local EquipmentVehicleFissionCell =
---    require("__reskins-assets-api__.assets.bobs.technologies.equipment-vehicle-fission-cell")
---```
---@class EquipmentVehicleFissionCell
local M = {}

local icon_builder = technologies:tinted("equipment-vehicle-fission-cell")

---Gets the technology icon for the vehicle fission cell equipment, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for the vehicle fission cell equipment as an `IconComposition`, in the tints given by
---`params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
