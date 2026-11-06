---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Items

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

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.base_assets .. "/graphics/icons/modules" })

---Provides methods for getting the icons of the modules folder, `modules/{n}-lights/{color}/{color}-{tier}.png`, in
---which the number of lit lights on a module is its tier.
---
---#### Examples
---```lua
---local Modules = require("__reskins-assets-api__.assets.base.items.modules")
---```
---@class Modules
local M = {}

---Gets the icon for the module with 5 lights in the given `color`, with the lights of the given `tier` lit, as an
---`IconComposition`.
---
---#### Examples
---```lua
----- Get the icon for the blue module of tier 3.
---local icon_data = Modules.get_5_lights_icon_composition({ color = "blue", tier = 3 }):build()
----- The icon is modules/5-lights/blue/blue-3.png.
---```
M.get_5_lights_icon_composition = icons
	:collection("5-lights", "color", V.one_of(FIVE_LIGHTS_COLORS))
	:keyed("tier", V.one_of({ 1, 2, 3, 4, 5 }))
	:build_composition("get_5_lights_icon_composition")

---Gets the icon for the module with 8 lights in the given `color`, with the lights of the given `tier` lit, as an
---`IconComposition`.
---
---#### Examples
---```lua
----- Get the icon for the blue module of tier 6.
---local icon_data = Modules.get_8_lights_icon_composition({ color = "blue", tier = 6 }):build()
----- The icon is modules/8-lights/blue/blue-6.png.
---```
M.get_8_lights_icon_composition = icons
	:collection("8-lights", "color", V.one_of(EIGHT_LIGHTS_COLORS))
	:keyed("tier", V.one_of({ 1, 2, 3, 4, 5, 6, 7, 8 }))
	:build_composition("get_8_lights_icon_composition")

return M
