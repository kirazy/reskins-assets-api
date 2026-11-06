---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Items

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local IconBuilderFactory = require("api.icon-builder-factory")

local MATERIALS = {
	"aluminium",
	"chrome",
	"cobalt",
	"copper",
	"depleted-uranium",
	"gold",
	"iron",
	"lead",
	"magnesium",
	"manganese",
	"nickel",
	"osmium",
	"platinum",
	"silicon",
	"silver",
	"steel",
	"tin",
	"titanium",
	"tungsten",
	"zinc",
}

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.angels_assets .. "/graphics/icons" })

---Provides methods for getting the icons in the ingots collection of Angel's items,
---`ingots/{material}/ingot-{material}.png`, with their picture variations.
---
---#### Examples
---```lua
---local Ingots = require("__reskins-assets-api__.assets.angels.items.ingots")
---```
---@class Ingots
local M = {}

---Gets the icon for the ingot of the given `material` as an `IconComposition`, with 9 picture variations.
---
---The icon is the first picture.
---
---#### Examples
---```lua
----- Get the icon for the iron ingot, with its pictures.
---local icon_data, pictures = Ingots.get_icon_composition({ material = "iron" }):build()
----- The icon is ingots/iron/ingot-iron.png, and the pictures are that file and
----- ingot-iron-{i}.png for i between 1 and 8.
---```
M.get_icon_composition = icons
	:collection("ingots", "material", V.one_of(MATERIALS))
	:stem("ingot")
	:variations(9)
	:build_composition("get_icon_composition")

return M
