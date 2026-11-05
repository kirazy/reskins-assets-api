---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.bobs_assets .. "/graphics/icons" })

---Provides methods for getting the icon of the vehicle fission cell equipment,
---`equipment-vehicle-fission-cell/equipment-vehicle-fission-cell-{role}.png`.
---
---#### Examples
---```lua
---local EquipmentVehicleFissionCell =
---    require("__reskins-assets-api__.assets.bobs.items.equipment-vehicle-fission-cell")
---```
---@class EquipmentVehicleFissionCell
local M = {}

---Gets the icon for the vehicle fission cell equipment as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icons:tinted("equipment-vehicle-fission-cell"):build_composition("get_icon_composition")

return M
