---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Bobs.Equipment

local _defines = require("api.defines")
local Equipment = require("api.equipment")

local FOLDER = _defines.assets_source.bobs_assets .. "/graphics/equipment/equipment-vehicle-engine"

---Provides methods for getting the sprite set of the vehicle engine equipment,
---`equipment-vehicle-engine/equipment-vehicle-engine.png`.
---
---#### Examples
---```lua
---local EquipmentVehicleEngine = require("__reskins-assets-api__.assets.bobs.equipment.equipment-vehicle-engine")
---```
---@class EquipmentVehicleEngine
local M = {}

---Gets the sprite set for the vehicle engine equipment.
M.get_sprite_set = Equipment.flat({
	filename = FOLDER .. "/equipment-vehicle-engine.png",
	width = 128,
	height = 128,
}, "get_sprite_set")

return M
