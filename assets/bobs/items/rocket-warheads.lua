---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons =
	IconBuilderFactory:create({ folder = _defines.assets_source.bobs_assets .. "/graphics/icons/rocket-warheads" })

---Provides methods for getting the icons of the rocket-warheads folder, such as
---`rocket-warheads/acid-rocket-warhead.png`.
---
---#### Examples
---```lua
---local RocketWarheads = require("__reskins-assets-api__.assets.bobs.items.rocket-warheads")
---```
---@class RocketWarheads
local M = {}

---Gets the icon for the acid rocket warhead as an `IconComposition`.
M.get_acid_rocket_warhead_icon_composition =
	icons:flat("acid-rocket-warhead"):build_composition("get_acid_rocket_warhead_icon_composition")

---Gets the icon for the electric rocket warhead as an `IconComposition`.
M.get_electric_rocket_warhead_icon_composition =
	icons:flat("electric-rocket-warhead"):build_composition("get_electric_rocket_warhead_icon_composition")

---Gets the icon for the explosive rocket warhead as an `IconComposition`.
M.get_explosive_rocket_warhead_icon_composition =
	icons:flat("explosive-rocket-warhead"):build_composition("get_explosive_rocket_warhead_icon_composition")

---Gets the icon for the flame rocket warhead as an `IconComposition`.
M.get_flame_rocket_warhead_icon_composition =
	icons:flat("flame-rocket-warhead"):build_composition("get_flame_rocket_warhead_icon_composition")

---Gets the icon for the piercing rocket warhead as an `IconComposition`.
M.get_piercing_rocket_warhead_icon_composition =
	icons:flat("piercing-rocket-warhead"):build_composition("get_piercing_rocket_warhead_icon_composition")

---Gets the icon for the plasma rocket warhead as an `IconComposition`.
M.get_plasma_rocket_warhead_icon_composition =
	icons:flat("plasma-rocket-warhead"):build_composition("get_plasma_rocket_warhead_icon_composition")

---Gets the icon for the poison rocket warhead as an `IconComposition`.
M.get_poison_rocket_warhead_icon_composition =
	icons:flat("poison-rocket-warhead"):build_composition("get_poison_rocket_warhead_icon_composition")

---Gets the icon for the rocket warhead as an `IconComposition`.
M.get_rocket_warhead_icon_composition =
	icons:flat("rocket-warhead"):build_composition("get_rocket_warhead_icon_composition")

---Gets the icon for the uranium rocket warhead as an `IconComposition`.
M.get_uranium_rocket_warhead_icon_composition =
	icons:flat("uranium-rocket-warhead"):build_composition("get_uranium_rocket_warhead_icon_composition")

return M
