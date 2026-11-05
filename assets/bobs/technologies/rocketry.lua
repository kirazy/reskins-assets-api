---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Technologies

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local technologies = IconBuilderFactory:create({
	folder = _defines.assets_source.bobs_assets .. "/graphics/technology/rocketry",
	defaults_type = "technology",
})

---Provides methods for getting the technology icons in the `rocketry` folder, such as `rocketry/acid-rocket.png`.
---
---#### Examples
---```lua
---local Rocketry = require("__reskins-assets-api__.assets.bobs.technologies.rocketry")
---```
---@class Rocketry
local M = {}

local acid_rocket = technologies:flat("acid-rocket")

---Gets the technology icon for acid rockets.
M.get_acid_rocket_icon = acid_rocket:build("get_acid_rocket_icon")

---Gets the technology icon for acid rockets as an `IconComposition`.
M.get_acid_rocket_icon_composition = acid_rocket:build_composition("get_acid_rocket_icon_composition")

local electric_rocket = technologies:flat("electric-rocket")

---Gets the technology icon for electric rockets.
M.get_electric_rocket_icon = electric_rocket:build("get_electric_rocket_icon")

---Gets the technology icon for electric rockets as an `IconComposition`.
M.get_electric_rocket_icon_composition = electric_rocket:build_composition("get_electric_rocket_icon_composition")

local explosive_rocket = technologies:flat("explosive-rocket")

---Gets the technology icon for explosive rockets.
M.get_explosive_rocket_icon = explosive_rocket:build("get_explosive_rocket_icon")

---Gets the technology icon for explosive rockets as an `IconComposition`.
M.get_explosive_rocket_icon_composition = explosive_rocket:build_composition("get_explosive_rocket_icon_composition")

local flame_rocket = technologies:flat("flame-rocket")

---Gets the technology icon for flame rockets.
M.get_flame_rocket_icon = flame_rocket:build("get_flame_rocket_icon")

---Gets the technology icon for flame rockets as an `IconComposition`.
M.get_flame_rocket_icon_composition = flame_rocket:build_composition("get_flame_rocket_icon_composition")

local piercing_rocket = technologies:flat("piercing-rocket")

---Gets the technology icon for piercing rockets.
M.get_piercing_rocket_icon = piercing_rocket:build("get_piercing_rocket_icon")

---Gets the technology icon for piercing rockets as an `IconComposition`.
M.get_piercing_rocket_icon_composition = piercing_rocket:build_composition("get_piercing_rocket_icon_composition")

local plasma_rocket = technologies:flat("plasma-rocket")

---Gets the technology icon for plasma rockets.
M.get_plasma_rocket_icon = plasma_rocket:build("get_plasma_rocket_icon")

---Gets the technology icon for plasma rockets as an `IconComposition`.
M.get_plasma_rocket_icon_composition = plasma_rocket:build_composition("get_plasma_rocket_icon_composition")

local poison_rocket = technologies:flat("poison-rocket")

---Gets the technology icon for poison rockets.
M.get_poison_rocket_icon = poison_rocket:build("get_poison_rocket_icon")

---Gets the technology icon for poison rockets as an `IconComposition`.
M.get_poison_rocket_icon_composition = poison_rocket:build_composition("get_poison_rocket_icon_composition")

local rocket = technologies:flat("rocket")

---Gets the technology icon for rockets.
M.get_rocket_icon = rocket:build("get_rocket_icon")

---Gets the technology icon for rockets as an `IconComposition`.
M.get_rocket_icon_composition = rocket:build_composition("get_rocket_icon_composition")

local rocketry = technologies:flat("rocketry")

---Gets the technology icon for rocketry.
M.get_rocketry_icon = rocketry:build("get_rocketry_icon")

---Gets the technology icon for rocketry as an `IconComposition`.
M.get_rocketry_icon_composition = rocketry:build_composition("get_rocketry_icon_composition")

return M
