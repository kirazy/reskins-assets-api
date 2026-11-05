---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Technologies

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local IconBuilderFactory = require("api.icon-builder-factory")

---The colors of the modules with 5 lights.
local FIVE_LIGHTS_COLORS = {
	"blue",
	"brown",
	"cyan",
	"deep-red",
	"gray",
	"gray-red",
	"green",
	"orange",
	"pine",
	"pink",
	"purple",
	"quality",
	"red",
	"red-yellow",
	"yellow",
}

---The colors of the modules with 8 lights.
local EIGHT_LIGHTS_COLORS = {
	"blue",
	"brown",
	"cyan",
	"deep-red",
	"gray",
	"green",
	"orange",
	"pine",
	"pink",
	"purple",
	"red",
	"vanilla-red",
	"yellow",
}

local technologies = IconBuilderFactory:create({
	folder = _defines.assets_source.base_assets .. "/graphics/technology/modules",
	defaults_type = "technology",
})

---Provides methods for getting the technology icons of the modules folder,
---`modules/{n}-lights/{color}/{color}-{tier}.png`, in which the number of lit lights of a module is its tier.
---
---#### Examples
---```lua
---local Modules = require("__reskins-assets-api__.assets.base.technologies.modules")
---```
---@class Modules
local M = {}

local five_lights =
	technologies:collection("5-lights", "color", V.one_of(FIVE_LIGHTS_COLORS)):keyed("tier", V.one_of({ 1, 2, 3, 4, 5 }))

---Gets the technology icon for the module with 5 lights in the given `color`, with the lights of the given `tier` lit.
---
---The `quality` color draws a light gray module with red lights.
---
---#### Examples
---```lua
----- Get the technology icon for the blue module of tier 3.
---local icon_data = Modules.get_5_lights_icon({ color = "blue", tier = 3 })
----- The icon is modules/5-lights/blue/blue-3.png.
---```
M.get_5_lights_icon = five_lights:build("get_5_lights_icon")

---Gets the technology icon for the module with 5 lights in the given `color`, with the lights of the given `tier` lit,
---as an `IconComposition`.
M.get_5_lights_icon_composition = five_lights:build_composition("get_5_lights_icon_composition")

local eight_lights = technologies
	:collection("8-lights", "color", V.one_of(EIGHT_LIGHTS_COLORS))
	:keyed("tier", V.one_of({ 1, 2, 3, 4, 5, 6, 7, 8 }))

---Gets the technology icon for the module with 8 lights in the given `color`, with the lights of the given `tier` lit.
---
---#### Examples
---```lua
----- Get the technology icon for the blue module of tier 6.
---local icon_data = Modules.get_8_lights_icon({ color = "blue", tier = 6 })
----- The icon is modules/8-lights/blue/blue-6.png.
---```
M.get_8_lights_icon = eight_lights:build("get_8_lights_icon")

---Gets the technology icon for the module with 8 lights in the given `color`, with the lights of the given `tier` lit,
---as an `IconComposition`.
M.get_8_lights_icon_composition = eight_lights:build_composition("get_8_lights_icon_composition")

return M
