---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Bobs.Equipment

local _defines = require("api.defines")
local Equipment = require("api.equipment")

local FOLDER = _defines.assets_source.bobs_assets .. "/graphics/equipment/equipment-vehicle-plasma-turret"

---Provides methods for getting the sprite set of the vehicle plasma turret equipment,
---`equipment-vehicle-plasma-turret/equipment-vehicle-plasma-turret-{role}.png`.
---
---#### Examples
---```lua
---local EquipmentVehiclePlasmaTurret = require("__reskins-assets-api__.assets.bobs.equipment.equipment-vehicle-plasma-turret")
---```
---@class EquipmentVehiclePlasmaTurret
local M = {}

---Gets the sprite set for the vehicle plasma turret equipment, in the tint given by `params`.
M.get_sprite_set = Equipment.tinted({
	folder = FOLDER,
	width = 256,
	height = 256,
}, "get_sprite_set")

return M
