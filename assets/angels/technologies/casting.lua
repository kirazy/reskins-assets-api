---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Technologies

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local IconBuilderFactory = require("api.icon-builder-factory")

local MATERIALS = {
	"aluminium",
	"brass",
	"bronze",
	"chrome",
	"cobalt",
	"cobalt-steel",
	"concrete",
	"copper",
	"depleted-uranium",
	"glass",
	"gold",
	"gunmetal",
	"invar",
	"iron",
	"lead",
	"magnesium",
	"manganese",
	"nickel",
	"nitinol",
	"osmium",
	"platinum",
	"silicon",
	"silver",
	"solder",
	"steel",
	"tin",
	"titanium",
	"tungsten",
	"zinc",
}

local technologies = IconBuilderFactory:create({
	folder = _defines.assets_source.angels_assets .. "/graphics/technology/casting",
	defaults_type = "technology",
})

---Provides methods for getting the technology icons of the casting folder of Angel's technologies,
---`casting/casting-{material}.png`.
---
---#### Examples
---```lua
---local Casting = require("__reskins-assets-api__.assets.angels.technologies.casting")
---```
---@class Casting
local M = {}

local icon_builder = technologies:flat("casting"):keyed("material", V.one_of(MATERIALS))

---Gets the technology icon for the casting of the given `material`.
---
---#### Examples
---```lua
----- Get the technology icon for the casting of brass.
---local icon_data = Casting.get_icon({ material = "brass" })
----- The icon is casting/casting-brass.png.
---```
M.get_icon = icon_builder:build("get_icon")

---Gets the technology icon for the casting of the given `material` as an `IconComposition`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
