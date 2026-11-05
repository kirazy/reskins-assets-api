---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons =
	IconBuilderFactory:create({ folder = _defines.assets_source.bobs_assets .. "/graphics/icons/alien-artifacts" })

---Provides methods for getting the icons of the alien-artifacts folder, such as `alien-artifacts/alien-artifact.png`.
---
---#### Examples
---```lua
---local AlienArtifacts = require("__reskins-assets-api__.assets.bobs.items.alien-artifacts")
---```
---@class AlienArtifacts
local M = {}

---Gets the icon for the alien artifact as an `IconComposition`.
M.get_alien_artifact_icon_composition =
	icons:flat("alien-artifact"):build_composition("get_alien_artifact_icon_composition")

---Gets the icon for the blue alien artifact as an `IconComposition`.
M.get_alien_artifact_blue_icon_composition =
	icons:flat("alien-artifact-blue"):build_composition("get_alien_artifact_blue_icon_composition")

---Gets the icon for the green alien artifact as an `IconComposition`.
M.get_alien_artifact_green_icon_composition =
	icons:flat("alien-artifact-green"):build_composition("get_alien_artifact_green_icon_composition")

---Gets the icon for the orange alien artifact as an `IconComposition`.
M.get_alien_artifact_orange_icon_composition =
	icons:flat("alien-artifact-orange"):build_composition("get_alien_artifact_orange_icon_composition")

---Gets the icon for the purple alien artifact as an `IconComposition`.
M.get_alien_artifact_purple_icon_composition =
	icons:flat("alien-artifact-purple"):build_composition("get_alien_artifact_purple_icon_composition")

---Gets the icon for the red alien artifact as an `IconComposition`.
M.get_alien_artifact_red_icon_composition =
	icons:flat("alien-artifact-red"):build_composition("get_alien_artifact_red_icon_composition")

---Gets the icon for the yellow alien artifact as an `IconComposition`.
M.get_alien_artifact_yellow_icon_composition =
	icons:flat("alien-artifact-yellow"):build_composition("get_alien_artifact_yellow_icon_composition")

return M
