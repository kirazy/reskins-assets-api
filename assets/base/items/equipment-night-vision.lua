---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.base_assets .. "/graphics/icons" })

---Provides methods for getting the icon of the night vision equipment,
---`equipment-night-vision/equipment-night-vision-{role}.png`.
---
---#### Examples
---```lua
---local EquipmentNightVision = require("__reskins-assets-api__.assets.base.items.equipment-night-vision")
---```
---@class EquipmentNightVision
local M = {}

---Gets the icon for the night vision equipment as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icons:tinted("equipment-night-vision"):build_composition("get_icon_composition")

return M
