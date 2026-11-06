---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Base.Equipment

local _defines = require("api.defines")
local Equipment = require("api.equipment")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.base .. "/graphics/icons" })

---Provides methods for getting the sprite set and the icon for the belt immunity equipment of the base game,
---`__base__/graphics/equipment/belt-immunity-equipment.png`.
---
---#### Examples
---```lua
---local EquipmentBeltImmunity = require("__reskins-assets-api__.assets.base.equipment.equipment-belt-immunity")
---```
---@class EquipmentBeltImmunity
local M = {}

---Gets the sprite set for the belt immunity equipment of the base game.
M.get_sprite_set = Equipment.flat({
	filename = _defines.assets_source.base .. "/graphics/equipment/belt-immunity-equipment.png",
	width = 64,
	height = 64,
}, "get_sprite_set")

---Gets the icon for the belt immunity equipment of the base game as an `IconComposition`.
M.get_icon_composition = icons:flat("belt-immunity-equipment"):build_composition("get_icon_composition")

return M
