---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Technologies

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

local technologies = IconBuilderFactory:create({
	folder = _defines.assets_source.angels_assets .. "/graphics/technology/smelting",
	defaults_type = "technology",
})

---Provides methods for getting the technology icons of the smelting folder of Angel's technologies,
---`smelting/smelting-{material}.png`.
---
---#### Examples
---```lua
---local Smelting = require("__reskins-assets-api__.assets.angels.technologies.smelting")
---```
---@class Smelting
local M = {}

local icon_builder = technologies:flat("smelting"):keyed("material", V.one_of(MATERIALS))

---Gets the technology icon for the smelting of the given `material`.
---
---#### Examples
---```lua
----- Get the technology icon for the smelting of iron.
---local icon_data = Smelting.get_icon({ material = "iron" })
----- The icon is smelting/smelting-iron.png.
---```
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for the smelting of the given `material` as an `IconComposition`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
