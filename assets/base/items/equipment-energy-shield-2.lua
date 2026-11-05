---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.base_assets .. "/graphics/icons" })

---Provides methods for getting the icon of the energy shield MK2 equipment,
---`equipment-energy-shield-2/equipment-energy-shield-2-{role}.png`.
---
---#### Examples
---```lua
---local EquipmentEnergyShield2 = require("__reskins-assets-api__.assets.base.items.equipment-energy-shield-2")
---```
---@class EquipmentEnergyShield2
local M = {}

---Gets the icon for the energy shield MK2 equipment as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icons:tinted("equipment-energy-shield-2"):build_composition("get_icon_composition")

return M
