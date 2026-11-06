---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Base.Equipment

local _defines = require("api.defines")
local Equipment = require("api.equipment")

local FOLDER = _defines.assets_source.base_assets .. "/graphics/equipment/equipment-laser-defense"

---Provides methods for getting the sprite set of the personal laser defense equipment,
---`equipment-laser-defense/equipment-laser-defense-{role}.png`.
---
---#### Examples
---```lua
---local EquipmentLaserDefense = require("__reskins-assets-api__.assets.base.equipment.equipment-laser-defense")
---```
---@class EquipmentLaserDefense
local M = {}

---Gets the sprite set for the personal laser defense equipment, in the tint given by `params`.
M.get_sprite_set = Equipment.tinted({
	folder = FOLDER,
	width = 128,
	height = 128,
}, "get_sprite_set")

return M
