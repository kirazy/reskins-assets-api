---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Base.Equipment

local _defines = require("api.defines")
local Equipment = require("api.equipment")

local FOLDER = _defines.assets_source.base_assets .. "/graphics/equipment/equipment-exoskeleton"

---Provides methods for getting the sprite set of the exoskeleton equipment,
---`equipment-exoskeleton/equipment-exoskeleton-{role}.png`.
---
---#### Examples
---```lua
---local EquipmentExoskeleton = require("__reskins-assets-api__.assets.base.equipment.equipment-exoskeleton")
---```
---@class EquipmentExoskeleton
local M = {}

---Gets the sprite set for the exoskeleton equipment, in the tint given by `params`.
M.get_sprite_set = Equipment.tinted({
	folder = FOLDER,
	width = 128,
	height = 256,
}, "get_sprite_set")

return M
