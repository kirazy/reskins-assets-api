---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Base.Equipment

local _defines = require("api.defines")
local Equipment = require("api.equipment")

local FOLDER = _defines.assets_source.base_assets .. "/graphics/equipment/equipment-personal-roboport-2"

---Provides methods for getting the sprite set of the personal roboport MK2 equipment,
---`equipment-personal-roboport-2/equipment-personal-roboport-2-{role}.png`.
---
---#### Examples
---```lua
---local EquipmentPersonalRoboport2 = require("__reskins-assets-api__.assets.base.equipment.equipment-personal-roboport-2")
---```
---@class EquipmentPersonalRoboport2
local M = {}

---Gets the sprite set for the personal roboport MK2 equipment, in the tint given by `params`.
M.get_sprite_set = Equipment.tinted({
	folder = FOLDER,
	width = 128,
	height = 128,
}, "get_sprite_set")

return M
