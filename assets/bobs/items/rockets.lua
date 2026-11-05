---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.bobs_assets .. "/graphics/icons/rockets" })

---Provides methods for getting the icons of the rockets folder, such as `rockets/acid-rocket.png`.
---
---#### Examples
---```lua
---local Rockets = require("__reskins-assets-api__.assets.bobs.items.rockets")
---```
---@class Rockets
local M = {}

---Gets the icon for the acid rocket as an `IconComposition`.
M.get_acid_rocket_icon_composition = icons:flat("acid-rocket"):build_composition("get_acid_rocket_icon_composition")

---Gets the icon for the electric rocket as an `IconComposition`.
M.get_electric_rocket_icon_composition =
	icons:flat("electric-rocket"):build_composition("get_electric_rocket_icon_composition")

---Gets the icon for the explosive rocket as an `IconComposition`.
M.get_explosive_rocket_icon_composition =
	icons:flat("explosive-rocket"):build_composition("get_explosive_rocket_icon_composition")

---Gets the icon for the flame rocket as an `IconComposition`.
M.get_flame_rocket_icon_composition = icons:flat("flame-rocket"):build_composition("get_flame_rocket_icon_composition")

---Gets the icon for the piercing rocket as an `IconComposition`.
M.get_piercing_rocket_icon_composition =
	icons:flat("piercing-rocket"):build_composition("get_piercing_rocket_icon_composition")

---Gets the icon for the plasma rocket as an `IconComposition`.
M.get_plasma_rocket_icon_composition =
	icons:flat("plasma-rocket"):build_composition("get_plasma_rocket_icon_composition")

---Gets the icon for the poison rocket as an `IconComposition`.
M.get_poison_rocket_icon_composition =
	icons:flat("poison-rocket"):build_composition("get_poison_rocket_icon_composition")

---Gets the icon for the rocket as an `IconComposition`.
M.get_rocket_icon_composition = icons:flat("rocket"):build_composition("get_rocket_icon_composition")

return M
