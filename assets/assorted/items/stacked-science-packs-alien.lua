---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Assorted.Items

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({
	folder = _defines.assets_source.assorted_assets .. "/graphics/icons/stacked-science-packs-alien",
})

---Provides methods for getting the icons of the stacked-science-packs-alien folder,
---`stacked-science-packs-alien/stacked-alien-science-pack[-{color}].png`.
---
---#### Examples
---```lua
---local StackedSciencePacksAlien =
---    require("__reskins-assets-api__.assets.assorted.items.stacked-science-packs-alien")
---```
---@class StackedSciencePacksAlien
local M = {}

---Gets the icon for a stack of alien science packs as an `IconComposition`.
M.get_icon_composition = icons:flat("stacked-alien-science-pack"):build_composition("get_icon_composition")

---Gets the icon for a stack of alien science packs in the given `color` as an `IconComposition`.
---
---#### Examples
---```lua
----- Get the icon for a stack of blue alien science packs.
---local icon_data = StackedSciencePacksAlien.get_colored_icon_composition({ color = "blue" }):build()
----- The icon is stacked-science-packs-alien/stacked-alien-science-pack-blue.png.
---```
M.get_colored_icon_composition = icons
	:flat("stacked-alien-science-pack")
	:keyed("color", V.one_of({ "blue", "green", "orange", "purple", "red", "yellow" }))
	:build_composition("get_colored_icon_composition")

return M
