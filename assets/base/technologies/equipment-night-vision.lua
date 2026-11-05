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

---Provides methods for getting the technology icon of the night vision equipment,
---`equipment-night-vision/equipment-night-vision-{role}.png`.
---
---#### Examples
---```lua
---local EquipmentNightVision = require("__reskins-assets-api__.assets.base.technologies.equipment-night-vision")
---```
---@class EquipmentNightVision
local M = {}

local icon_builder = technologies:tinted("equipment-night-vision")

---Gets the technology icon for the night vision equipment, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for the night vision equipment as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
