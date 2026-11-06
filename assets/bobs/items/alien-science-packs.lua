---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({
	folder = _defines.assets_source.bobs_assets .. "/graphics/icons/alien-science-packs",
})

---Provides methods for getting the icons of the alien-science-packs folder,
---`alien-science-packs/alien-science-pack-{color}.png`.
---
---#### Examples
---```lua
---local AlienSciencePacks = require("__reskins-assets-api__.assets.bobs.items.alien-science-packs")
---```
---@class AlienSciencePacks
local M = {}

---Gets the icon for the alien science pack in the given `color` as an `IconComposition`.
---
---#### Examples
---```lua
----- Get the icon for the blue alien science pack.
---local icon_data = AlienSciencePacks.get_icon_composition({ color = "blue" }):build()
----- The icon is alien-science-packs/alien-science-pack-blue.png.
---```
M.get_icon_composition = icons
	:flat("alien-science-pack")
	:keyed("color", V.one_of({ "blue", "green", "orange", "pink", "purple", "red", "yellow" }))
	:build_composition("get_icon_composition")

return M
