---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")
local V = require("__reskins-sprite-utils__.validation")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.bobs_assets .. "/graphics/icons" })

---Provides methods for getting the icon of the vehicle roboport antenna equipment,
---`equipment-vehicle-part-antenna/equipment-vehicle-part-antenna[-{tier}]-{role}.png`.
---
---#### Examples
---```lua
---local EquipmentVehiclePartAntenna =
---    require("__reskins-assets-api__.assets.bobs.items.equipment-vehicle-part-antenna")
---```
---@class EquipmentVehiclePartAntenna
local M = {}

---Gets the icon for the vehicle roboport antenna equipment of the given `tier` as an `IconComposition`, in the tints
---given by `params`.
M.get_icon_composition = icons
	:tinted("equipment-vehicle-part-antenna")
	:keyed("tier", V.one_of({ 1, 2, 3, 4 }), { IconBuilderFactory.role.base })
	:build_composition("get_icon_composition")

return M
