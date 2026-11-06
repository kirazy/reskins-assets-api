---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Bobs.Equipment

local _defines = require("api.defines")
local Equipment = require("api.equipment")

local FOLDER = _defines.assets_source.bobs_assets .. "/graphics/equipment/equipment-vehicle-roboport"

---Provides methods for getting the sprite set of the vehicle roboport equipment,
---`equipment-vehicle-roboport/equipment-vehicle-roboport-{tier}-base.png` with its mask and highlights.
---
---#### Examples
---```lua
---local EquipmentVehicleRoboport = require("__reskins-assets-api__.assets.bobs.equipment.equipment-vehicle-roboport")
---```
---@class EquipmentVehicleRoboport
local M = {}

---Gets the sprite set for the vehicle roboport equipment with the base of the given `params.tier`, in the tint given by
---`params`.
M.get_sprite_set = Equipment.tiered({
	folder = FOLDER,
	width = 128,
	height = 128,
}, "get_sprite_set")

return M
