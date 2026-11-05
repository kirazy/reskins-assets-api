---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.bobs_assets .. "/graphics/icons" })

---Provides methods for getting the icon of the roboport robot equipment,
---`equipment-part-robot/equipment-part-robot-{role}.png`.
---
---#### Examples
---```lua
---local EquipmentPartRobot = require("__reskins-assets-api__.assets.bobs.items.equipment-part-robot")
---```
---@class EquipmentPartRobot
local M = {}

---Gets the icon for the roboport robot equipment as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icons:tinted("equipment-part-robot"):build_composition("get_icon_composition")

return M
