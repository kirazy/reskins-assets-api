---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Bobs.Equipment

local _defines = require("api.defines")
local Equipment = require("api.equipment")

local FOLDER = _defines.assets_source.bobs_assets .. "/graphics/equipment/equipment-vehicle-battery"

---Provides methods for getting the sprite set of the vehicle battery equipment,
---`equipment-vehicle-battery/equipment-vehicle-battery-{role}.png`.
---
---#### Examples
---```lua
---local EquipmentVehicleBattery = require("__reskins-assets-api__.assets.bobs.equipment.equipment-vehicle-battery")
---```
---@class EquipmentVehicleBattery
local M = {}

---Gets the sprite set for the vehicle battery equipment, in the tint given by `params`.
M.get_sprite_set = Equipment.tinted({
	folder = FOLDER,
	width = 64,
	height = 64,
}, "get_sprite_set")

return M
