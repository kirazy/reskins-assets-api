---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Bobs.Equipment

local _defines = require("api.defines")
local Equipment = require("api.equipment")

local FOLDER = _defines.assets_source.bobs_assets .. "/graphics/equipment/equipment-part-robot"

---Provides methods for getting the sprite set of the roboport robot equipment,
---`equipment-part-robot/equipment-part-robot-{role}.png`.
---
---#### Examples
---```lua
---local EquipmentPartRobot = require("__reskins-assets-api__.assets.bobs.equipment.equipment-part-robot")
---```
---@class EquipmentPartRobot
local M = {}

---Gets the sprite set for the roboport robot equipment, in the tint given by `params`.
M.get_sprite_set = Equipment.tinted({
	folder = FOLDER,
	width = 64,
	height = 64,
}, "get_sprite_set")

return M
