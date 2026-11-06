---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Base.Equipment

local _defines = require("api.defines")
local Equipment = require("api.equipment")

local FOLDER = _defines.assets_source.base_assets .. "/graphics/equipment/equipment-battery"

---Provides methods for getting the sprite set of the battery equipment,
---`equipment-battery/equipment-battery-{role}.png`.
---
---#### Examples
---```lua
---local EquipmentBattery = require("__reskins-assets-api__.assets.base.equipment.equipment-battery")
---```
---@class EquipmentBattery
local M = {}

---Gets the sprite set for the battery equipment, in the tint given by `params`.
M.get_sprite_set = Equipment.tinted({
	folder = FOLDER,
	width = 64,
	height = 128,
}, "get_sprite_set")

return M
