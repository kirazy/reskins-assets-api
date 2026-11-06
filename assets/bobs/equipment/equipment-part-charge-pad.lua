---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Bobs.Equipment

local _defines = require("api.defines")
local Equipment = require("api.equipment")

local FOLDER = _defines.assets_source.bobs_assets .. "/graphics/equipment/equipment-part-charge-pad"

---Provides methods for getting the sprite set of the roboport charge pad equipment,
---`equipment-part-charge-pad/equipment-part-charge-pad-{tier}-base.png` with its mask and highlights.
---
---#### Examples
---```lua
---local EquipmentPartChargePad = require("__reskins-assets-api__.assets.bobs.equipment.equipment-part-charge-pad")
---```
---@class EquipmentPartChargePad
local M = {}

---Gets the sprite set for the roboport charge pad equipment with the base of the given `params.tier`, in the tint given
---by `params`.
M.get_sprite_set = Equipment.tiered({
	folder = FOLDER,
	width = 64,
	height = 64,
}, "get_sprite_set")

return M
