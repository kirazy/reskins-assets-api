---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Base.Equipment

local _defines = require("api.defines")
local Equipment = require("api.equipment")

local FOLDER = _defines.assets_source.base_assets .. "/graphics/equipment/equipment-solar-panel"

---Provides methods for getting the sprite set of the portable solar panel equipment,
---`equipment-solar-panel/equipment-solar-panel-{role}.png`.
---
---#### Examples
---```lua
---local EquipmentSolarPanel = require("__reskins-assets-api__.assets.base.equipment.equipment-solar-panel")
---```
---@class EquipmentSolarPanel
local M = {}

---Gets the sprite set for the portable solar panel equipment, in the tint given by `params`.
M.get_sprite_set = Equipment.tinted({
	folder = FOLDER,
	width = 64,
	height = 64,
}, "get_sprite_set")

return M
