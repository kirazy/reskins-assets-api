---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.bobs_assets .. "/graphics/icons" })

---Provides methods for getting the icon of the vehicle fission reactor equipment,
---`equipment-vehicle-fission-reactor/equipment-vehicle-fission-reactor-{role}.png`.
---
---#### Examples
---```lua
---local EquipmentVehicleFissionReactor =
---    require("__reskins-assets-api__.assets.bobs.items.equipment-vehicle-fission-reactor")
---```
---@class EquipmentVehicleFissionReactor
local M = {}

---Gets the icon for the vehicle fission reactor equipment as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icons:tinted("equipment-vehicle-fission-reactor"):build_composition("get_icon_composition")

return M
