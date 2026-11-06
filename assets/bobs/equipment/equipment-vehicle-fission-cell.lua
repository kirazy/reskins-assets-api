---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Bobs.Equipment

local _defines = require("api.defines")
local Equipment = require("api.equipment")

local FOLDER = _defines.assets_source.bobs_assets .. "/graphics/equipment/equipment-vehicle-fission-cell"

---Provides methods for getting the sprite set of the vehicle fission cell equipment,
---`equipment-vehicle-fission-cell/equipment-vehicle-fission-cell-{role}.png`.
---
---#### Examples
---```lua
---local EquipmentVehicleFissionCell = require("__reskins-assets-api__.assets.bobs.equipment.equipment-vehicle-fission-cell")
---```
---@class EquipmentVehicleFissionCell
local M = {}

---Gets the sprite set for the vehicle fission cell equipment, in the tint given by `params`.
M.get_sprite_set = Equipment.tinted({
	folder = FOLDER,
	width = 128,
	height = 128,
}, "get_sprite_set")

return M
