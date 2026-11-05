---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.base_assets .. "/graphics/icons" })

---Provides methods for getting the icon of the battery MK2 equipment,
---`equipment-battery-2/equipment-battery-2-{role}.png`.
---
---#### Examples
---```lua
---local EquipmentBattery2 = require("__reskins-assets-api__.assets.base.items.equipment-battery-2")
---```
---@class EquipmentBattery2
local M = {}

---Gets the icon for the battery MK2 equipment as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icons:tinted("equipment-battery-2"):build_composition("get_icon_composition")

return M
