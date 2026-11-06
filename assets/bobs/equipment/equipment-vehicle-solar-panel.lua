---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Bobs.Equipment

local _defines = require("api.defines")
local Equipment = require("api.equipment")

local FOLDER = _defines.assets_source.bobs_assets .. "/graphics/equipment/equipment-vehicle-solar-panel"

---Provides methods for getting the sprite set of the vehicle solar panel equipment,
---`equipment-vehicle-solar-panel/equipment-vehicle-solar-panel-{role}.png`.
---
---#### Examples
---```lua
---local EquipmentVehicleSolarPanel = require("__reskins-assets-api__.assets.bobs.equipment.equipment-vehicle-solar-panel")
---```
---@class EquipmentVehicleSolarPanel
local M = {}

---Gets the sprite set for the vehicle solar panel equipment, in the tint given by `params`.
M.get_sprite_set = Equipment.tinted({
	folder = FOLDER,
	width = 128,
	height = 64,
}, "get_sprite_set")

return M
