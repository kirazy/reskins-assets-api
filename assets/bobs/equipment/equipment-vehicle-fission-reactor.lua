---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Bobs.Equipment

local _defines = require("api.defines")
local Equipment = require("api.equipment")

local FOLDER = _defines.assets_source.bobs_assets .. "/graphics/equipment/equipment-vehicle-fission-reactor"

---Provides methods for getting the sprite set of the vehicle fission reactor equipment,
---`equipment-vehicle-fission-reactor/equipment-vehicle-fission-reactor-{role}.png`.
---
---#### Examples
---```lua
---local EquipmentVehicleFissionReactor = require("__reskins-assets-api__.assets.bobs.equipment.equipment-vehicle-fission-reactor")
---```
---@class EquipmentVehicleFissionReactor
local M = {}

---Gets the sprite set for the vehicle fission reactor equipment, in the tint given by `params`.
M.get_sprite_set = Equipment.tinted({
	folder = FOLDER,
	width = 128,
	height = 256,
}, "get_sprite_set")

return M
