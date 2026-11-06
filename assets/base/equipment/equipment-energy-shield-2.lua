---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Base.Equipment

local _defines = require("api.defines")
local Equipment = require("api.equipment")

local FOLDER = _defines.assets_source.base_assets .. "/graphics/equipment/equipment-energy-shield-2"

---Provides methods for getting the sprite set of the energy shield MK2 equipment,
---`equipment-energy-shield-2/equipment-energy-shield-2-{role}.png`.
---
---#### Examples
---```lua
---local EquipmentEnergyShield2 = require("__reskins-assets-api__.assets.base.equipment.equipment-energy-shield-2")
---```
---@class EquipmentEnergyShield2
local M = {}

---Gets the sprite set for the energy shield MK2 equipment, in the tint given by `params`.
M.get_sprite_set = Equipment.tinted({
	folder = FOLDER,
	width = 128,
	height = 128,
}, "get_sprite_set")

return M
