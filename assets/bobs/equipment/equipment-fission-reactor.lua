---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Bobs.Equipment

local _defines = require("api.defines")
local Equipment = require("api.equipment")

local FOLDER = _defines.assets_source.bobs_assets .. "/graphics/equipment/equipment-fission-reactor"

---Provides methods for getting the sprite set of the portable fission reactor equipment,
---`equipment-fission-reactor/equipment-fission-reactor-{role}.png`.
---
---#### Examples
---```lua
---local EquipmentFissionReactor = require("__reskins-assets-api__.assets.bobs.equipment.equipment-fission-reactor")
---```
---@class EquipmentFissionReactor
local M = {}

---Gets the sprite set for the portable fission reactor equipment, in the tint given by `params`.
M.get_sprite_set = Equipment.tinted({
	folder = FOLDER,
	width = 256,
	height = 256,
}, "get_sprite_set")

return M
