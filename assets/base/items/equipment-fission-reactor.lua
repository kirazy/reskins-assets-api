---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.base_assets .. "/graphics/icons" })

---Provides methods for getting the icon of the portable fission reactor equipment,
---`equipment-fission-reactor/equipment-fission-reactor-{role}.png`.
---
---#### Examples
---```lua
---local EquipmentFissionReactor = require("__reskins-assets-api__.assets.base.items.equipment-fission-reactor")
---```
---@class EquipmentFissionReactor
local M = {}

---Gets the icon for the portable fission reactor equipment as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icons:tinted("equipment-fission-reactor"):build_composition("get_icon_composition")

return M
