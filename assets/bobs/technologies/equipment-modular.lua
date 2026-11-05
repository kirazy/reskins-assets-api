---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Technologies

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")
local V = require("__reskins-sprite-utils__.validation")

local technologies = IconBuilderFactory:create({
	folder = _defines.assets_source.bobs_assets .. "/graphics/technology",
	defaults_type = "technology",
})

---Provides methods for getting the technology icon of the modular roboport equipment,
---`equipment-modular/equipment-modular[-{tier}]-{role}.png`.
---
---#### Examples
---```lua
---local EquipmentModular = require("__reskins-assets-api__.assets.bobs.technologies.equipment-modular")
---```
---@class EquipmentModular
local M = {}

local icon_builder =
	technologies:tinted("equipment-modular"):keyed("tier", V.one_of({ 1, 2, 3, 4 }), { IconBuilderFactory.role.base })

---Gets the technology icon for the modular roboport equipment of the given `tier`, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for the modular roboport equipment of the given `tier` as an `IconComposition`, in the tints
---given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
