---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Technologies

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")
local V = require("__reskins-sprite-utils__.validation")

local technologies = IconBuilderFactory:create({
	folder = _defines.assets_source.base_assets .. "/graphics/technology",
	defaults_type = "technology",
})

---Provides methods for getting the technology icons of nuclear power,
---`nuclear-power/nuclear-power[-{value}...]-{role}.png`.
---
---#### Examples
---```lua
---local NuclearPower = require("__reskins-assets-api__.assets.base.technologies.nuclear-power")
---```
---@class NuclearPower
local M = {}

-- The materials in which the reactor of each fuel has artwork.
local FUEL_MATERIALS = {
	["uranium"] = {
		["base"] = true,
		["aluminum-invar"] = true,
		["gold-copper"] = true,
		["silver-aluminum"] = true,
		["silver-titanium"] = true,
	},
	["thorium"] = { ["aluminum-invar"] = true, ["silver-aluminum"] = true, ["silver-titanium"] = true },
	["deuterium-blue"] = { ["gold-copper"] = true },
	["deuterium-pink"] = { ["gold-copper"] = true },
}

local FUEL = V.one_of({ "uranium", "thorium", "deuterium-blue", "deuterium-pink" })
local MATERIAL = V.one_of({ "base", "aluminum-invar", "gold-copper", "silver-aluminum", "silver-titanium" })
local GLOW_COLOR = V.one_of({ "blue", "cyan" })

---@type IconParamsRule[]
local FUEL_RULES = {
	{
		field = "material",
		fields = { "fuel", "material" },
		check = function(fuel, material)
			return FUEL_MATERIALS[fuel][material] == true
		end,
		message = "a material for which the reactor of the given fuel has artwork",
	},
}

-- Every icon shares one mask and one highlights layer, so only the base has a key.
local BASE_LAYER = { IconBuilderFactory.role.base }

local icon_builder = technologies:tinted("nuclear-power")

---Gets the technology icon for nuclear power, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for nuclear power as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

local fuel_icon_builder =
	technologies:tinted("nuclear-power"):keyed("fuel", FUEL, BASE_LAYER):keyed("material", MATERIAL, BASE_LAYER)

---Gets the technology icon for a reactor burning the `fuel`, built from the `material`, and in the tints given by
---`params`.
---
---Not every fuel has artwork in every material.
M.get_fuel_icon = fuel_icon_builder:build("get_fuel_icon", FUEL_RULES)

---Gets the technology icon for a reactor burning the `fuel` as an `IconComposition`, built from the `material`, and in
---the tints given by `params`.
---
---Not every fuel has artwork in every material.
M.get_fuel_icon_composition = fuel_icon_builder:build_composition("get_fuel_icon_composition", FUEL_RULES)

local realistic_icon_builder = technologies
	:tinted("nuclear-power")
	:keyed("glow_color", GLOW_COLOR, BASE_LAYER)
	:keyed("material", MATERIAL, BASE_LAYER)

---Gets the technology icon for a reactor glowing in the `glow_color`, built from the `material`, and in the tints given
---by `params`.
M.get_realistic_icon = realistic_icon_builder:build("get_realistic_icon")

---Gets the technology icon for a reactor glowing in the `glow_color` as an `IconComposition`, built from the
---`material`, and in the tints given by `params`.
M.get_realistic_icon_composition = realistic_icon_builder:build_composition("get_realistic_icon_composition")

return M
