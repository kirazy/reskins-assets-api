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

---Provides methods for getting the technology icon of the personal roboport equipment,
---`equipment-personal-roboport-1/equipment-personal-roboport-1-{role}.png`.
---
---#### Examples
---```lua
---local EquipmentPersonalRoboport1 =
---    require("__reskins-assets-api__.assets.base.technologies.equipment-personal-roboport-1")
---```
---@class EquipmentPersonalRoboport1
local M = {}

local icon_builder = technologies:tinted("equipment-personal-roboport-1")

---Gets the technology icon for the personal roboport equipment, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for the personal roboport equipment as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
