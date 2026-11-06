---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Bobs.Equipment

local _defines = require("api.defines")
local Equipment = require("api.equipment")

local FOLDER = _defines.assets_source.bobs_assets .. "/graphics/equipment/equipment-vehicle-part-antenna"

---Provides methods for getting the sprite set of the vehicle roboport antenna equipment,
---`equipment-vehicle-part-antenna/equipment-vehicle-part-antenna-{tier}-base.png` with its mask and highlights.
---
---#### Examples
---```lua
---local EquipmentVehiclePartAntenna = require("__reskins-assets-api__.assets.bobs.equipment.equipment-vehicle-part-antenna")
---```
---@class EquipmentVehiclePartAntenna
local M = {}

---Gets the sprite set for the vehicle roboport antenna equipment with the base of the given `params.tier`, in the tint
---given by `params`.
M.get_sprite_set = Equipment.tiered({
	folder = FOLDER,
	width = 64,
	height = 64,
}, "get_sprite_set")

return M
