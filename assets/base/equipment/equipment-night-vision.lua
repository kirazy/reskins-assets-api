---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Base.Equipment

local _defines = require("api.defines")
local Equipment = require("api.equipment")

local FOLDER = _defines.assets_source.base_assets .. "/graphics/equipment/equipment-night-vision"

---Provides methods for getting the sprite set of the night vision equipment,
---`equipment-night-vision/equipment-night-vision-{role}.png`.
---
---#### Examples
---```lua
---local EquipmentNightVision = require("__reskins-assets-api__.assets.base.equipment.equipment-night-vision")
---```
---@class EquipmentNightVision
local M = {}

---Gets the sprite set for the night vision equipment, in the tint given by `params`.
M.get_sprite_set = Equipment.tinted({
	folder = FOLDER,
	width = 128,
	height = 128,
}, "get_sprite_set")

return M
