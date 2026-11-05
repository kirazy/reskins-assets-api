---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.bobs_assets .. "/graphics/icons/fluids" })

---Provides methods for getting the icons of the fluids folder, such as `fluids/alien-acid.png`.
---
---#### Examples
---```lua
---local Fluids = require("__reskins-assets-api__.assets.bobs.items.fluids")
---```
---@class Fluids
local M = {}

---Gets the icon for alien acid as an `IconComposition`.
M.get_alien_acid_icon_composition = icons:flat("alien-acid"):build_composition("get_alien_acid_icon_composition")

---Gets the icon for alien explosive as an `IconComposition`.
M.get_alien_explosive_icon_composition =
	icons:flat("alien-explosive"):build_composition("get_alien_explosive_icon_composition")

---Gets the icon for alien fire as an `IconComposition`.
M.get_alien_fire_icon_composition = icons:flat("alien-fire"):build_composition("get_alien_fire_icon_composition")

---Gets the icon for alien poison as an `IconComposition`.
M.get_alien_poison_icon_composition = icons:flat("alien-poison"):build_composition("get_alien_poison_icon_composition")

---Gets the icon for ammoniated brine as an `IconComposition`.
M.get_ammoniated_brine_icon_composition =
	icons:flat("ammoniated-brine"):build_composition("get_ammoniated_brine_icon_composition")

---Gets the icon for brine as an `IconComposition`.
M.get_brine_icon_composition = icons:flat("brine"):build_composition("get_brine_icon_composition")

---Gets the icon for ferric chloride solution as an `IconComposition`.
M.get_ferric_chloride_solution_icon_composition =
	icons:flat("ferric-chloride-solution"):build_composition("get_ferric_chloride_solution_icon_composition")

---Gets the icon for liquid fuel as an `IconComposition`.
M.get_liquid_fuel_icon_composition = icons:flat("liquid-fuel"):build_composition("get_liquid_fuel_icon_composition")

---Gets the icon for lithia water as an `IconComposition`.
M.get_lithia_water_icon_composition = icons:flat("lithia-water"):build_composition("get_lithia_water_icon_composition")

return M
