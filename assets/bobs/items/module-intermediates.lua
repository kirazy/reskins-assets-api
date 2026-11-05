---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local IconBuilderFactory = require("api.icon-builder-factory")

local COLORS = {
	"blue",
	"brown",
	"gray",
	"green",
	"light-blue",
	"pine",
	"red",
	"soft-blue",
	"soft-brown",
	"soft-gray",
	"soft-green",
	"soft-pine",
	"soft-red",
	"yellow",
}

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.bobs_assets .. "/graphics/icons" })

---Provides methods for getting the icons of the module-intermediates folder,
---`module-intermediates/{color}/{color}-{level}.png`.
---
---#### Examples
---```lua
---local ModuleIntermediates = require("__reskins-assets-api__.assets.bobs.items.module-intermediates")
---```
---@class ModuleIntermediates
local M = {}

---Gets the icon for the module intermediate of the given `level` in the given `color` as an `IconComposition`.
---
---#### Examples
---```lua
----- Get the icon for the blue module intermediate of level 2.
---local icon_data = ModuleIntermediates.get_icon_composition({ color = "blue", level = 2 }):build()
----- The icon is module-intermediates/blue/blue-2.png.
---```
M.get_icon_composition = icons
	:collection("module-intermediates", "color", V.one_of(COLORS))
	:keyed("level", V.one_of({ 1, 2, 3, 4, 5, 6 }))
	:build_composition("get_icon_composition")

return M
