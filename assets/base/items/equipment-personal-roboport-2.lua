---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.base_assets .. "/graphics/icons" })

---Provides methods for getting the icon of the personal roboport MK2 equipment,
---`equipment-personal-roboport-2/equipment-personal-roboport-2-{role}.png`.
---
---#### Examples
---```lua
---local EquipmentPersonalRoboport2 = require("__reskins-assets-api__.assets.base.items.equipment-personal-roboport-2")
---```
---@class EquipmentPersonalRoboport2
local M = {}

---Gets the icon for the personal roboport MK2 equipment as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icons:tinted("equipment-personal-roboport-2"):build_composition("get_icon_composition")

return M
