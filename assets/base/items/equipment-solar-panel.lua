---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.base_assets .. "/graphics/icons" })

---Provides methods for getting the icon of the portable solar panel equipment,
---`equipment-solar-panel/equipment-solar-panel-{role}.png`.
---
---#### Examples
---```lua
---local EquipmentSolarPanel = require("__reskins-assets-api__.assets.base.items.equipment-solar-panel")
---```
---@class EquipmentSolarPanel
local M = {}

---Gets the icon for the portable solar panel equipment as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icons:tinted("equipment-solar-panel"):build_composition("get_icon_composition")

return M
