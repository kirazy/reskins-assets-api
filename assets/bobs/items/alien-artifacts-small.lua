---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({
	folder = _defines.assets_source.bobs_assets .. "/graphics/icons/alien-artifacts-small",
})

---Provides methods for getting the icons of the alien-artifacts-small folder,
---`alien-artifacts-small/alien-artifact-small-{color}.png`.
---
---#### Examples
---```lua
---local AlienArtifactsSmall = require("__reskins-assets-api__.assets.bobs.items.alien-artifacts-small")
---```
---@class AlienArtifactsSmall
local M = {}

---Gets the icon for the small alien artifact in the given `color` as an `IconComposition`.
---
---#### Examples
---```lua
----- Get the icon for the small blue alien artifact.
---local icon_data = AlienArtifactsSmall.get_icon_composition({ color = "blue" }):build()
----- The icon is alien-artifacts-small/alien-artifact-small-blue.png.
---```
M.get_icon_composition = icons
	:flat("alien-artifact-small")
	:keyed("color", V.one_of({ "blue", "green", "orange", "pink", "purple", "red", "yellow" }))
	:build_composition("get_icon_composition")

return M
