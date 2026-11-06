---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({
	folder = _defines.assets_source.bobs_assets .. "/graphics/icons/alien-artifacts",
})

---Provides methods for getting the icons of the alien-artifacts folder, `alien-artifacts/alien-artifact-{color}.png`.
---
---#### Examples
---```lua
---local AlienArtifacts = require("__reskins-assets-api__.assets.bobs.items.alien-artifacts")
---```
---@class AlienArtifacts
local M = {}

---Gets the icon for the alien artifact in the given `color` as an `IconComposition`.
---
---#### Examples
---```lua
----- Get the icon for the blue alien artifact.
---local icon_data = AlienArtifacts.get_icon_composition({ color = "blue" }):build()
----- The icon is alien-artifacts/alien-artifact-blue.png.
---```
M.get_icon_composition = icons
	:flat("alien-artifact")
	:keyed("color", V.one_of({ "blue", "green", "orange", "pink", "purple", "red", "yellow" }))
	:build_composition("get_icon_composition")

return M
