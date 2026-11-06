---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Bobs.Equipment

local _defines = require("api.defines")
local Equipment = require("api.equipment")

local FOLDER = _defines.assets_source.bobs_assets .. "/graphics/equipment/equipment-vehicle-motor"

---Provides methods for getting the sprite set of the vehicle motor equipment,
---`equipment-vehicle-motor/equipment-vehicle-motor.png`.
---
---#### Examples
---```lua
---local EquipmentVehicleMotor = require("__reskins-assets-api__.assets.bobs.equipment.equipment-vehicle-motor")
---```
---@class EquipmentVehicleMotor
local M = {}

---Gets the sprite set for the vehicle motor equipment.
M.get_sprite_set = Equipment.flat({
	filename = FOLDER .. "/equipment-vehicle-motor.png",
	width = 128,
	height = 128,
}, "get_sprite_set")

return M
