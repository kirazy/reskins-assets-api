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

---Provides methods for getting the technology icon of the personal roboport MK2 equipment,
---`equipment-personal-roboport-2/equipment-personal-roboport-2-{role}.png`.
---
---#### Examples
---```lua
---local EquipmentPersonalRoboport2 =
---    require("__reskins-assets-api__.assets.base.technologies.equipment-personal-roboport-2")
---```
---@class EquipmentPersonalRoboport2
local M = {}

local icon_builder = technologies:tinted("equipment-personal-roboport-2")

---Gets the technology icon for the personal roboport MK2 equipment, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for the personal roboport MK2 equipment as an `IconComposition`, in the tints given by
---`params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
