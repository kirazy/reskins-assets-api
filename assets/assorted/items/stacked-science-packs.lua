---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Assorted.Items

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local IconBuilderFactory = require("api.icon-builder-factory")

local SCIENCE_PACKS = {
	"advanced-logistic-science-pack",
	"automation-science-pack",
	"chemical-science-pack",
	"logistic-science-pack",
	"military-science-pack",
	"production-science-pack",
	"science-pack-gold",
	"space-science-pack",
	"steam-science-pack",
	"utility-science-pack",
}

local icons = IconBuilderFactory:create({
	folder = _defines.assets_source.assorted_assets .. "/graphics/icons/stacked-science-packs",
})

---Provides methods for getting the icons of the stacked-science-packs folder,
---`stacked-science-packs/stacked-{science_pack}.png`.
---
---#### Examples
---```lua
---local StackedSciencePacks = require("__reskins-assets-api__.assets.assorted.items.stacked-science-packs")
---```
---@class StackedSciencePacks
local M = {}

---Gets the icon for a stack of the given `science_pack` as an `IconComposition`.
---
---#### Examples
---```lua
----- Get the icon for a stack of automation science packs.
---local icon_data = StackedSciencePacks.get_icon_composition({ science_pack = "automation-science-pack" }):build()
----- The icon is stacked-science-packs/stacked-automation-science-pack.png.
---```
M.get_icon_composition =
	icons:flat("stacked"):keyed("science_pack", V.one_of(SCIENCE_PACKS)):build_composition("get_icon_composition")

return M
