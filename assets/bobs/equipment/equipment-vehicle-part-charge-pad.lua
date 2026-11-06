---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Bobs.Equipment

local _defines = require("api.defines")
local Equipment = require("api.equipment")

local FOLDER = _defines.assets_source.bobs_assets .. "/graphics/equipment/equipment-vehicle-part-charge-pad"

---Provides methods for getting the sprite set of the vehicle roboport charge pad equipment,
---`equipment-vehicle-part-charge-pad/equipment-vehicle-part-charge-pad-{tier}-base.png` with its mask and highlights.
---
---#### Examples
---```lua
---local EquipmentVehiclePartChargePad = require("__reskins-assets-api__.assets.bobs.equipment.equipment-vehicle-part-charge-pad")
---```
---@class EquipmentVehiclePartChargePad
local M = {}

---Gets the sprite set for the vehicle roboport charge pad equipment with the base of the given `params.tier`, in the
---tint given by `params`.
M.get_sprite_set = Equipment.tiered({
	folder = FOLDER,
	width = 64,
	height = 64,
}, "get_sprite_set")

return M
