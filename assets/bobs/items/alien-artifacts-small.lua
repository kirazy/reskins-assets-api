---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons =
	IconBuilderFactory:create({ folder = _defines.assets_source.bobs_assets .. "/graphics/icons/alien-artifacts-small" })

---Provides methods for getting the icons of the alien-artifacts-small folder, such as
---`alien-artifacts-small/alien-artifact-small.png`.
---
---#### Examples
---```lua
---local AlienArtifactsSmall = require("__reskins-assets-api__.assets.bobs.items.alien-artifacts-small")
---```
---@class AlienArtifactsSmall
local M = {}

---Gets the icon for the small alien artifact as an `IconComposition`.
M.get_alien_artifact_small_icon_composition =
	icons:flat("alien-artifact-small"):build_composition("get_alien_artifact_small_icon_composition")

---Gets the icon for the small blue alien artifact as an `IconComposition`.
M.get_alien_artifact_small_blue_icon_composition =
	icons:flat("alien-artifact-small-blue"):build_composition("get_alien_artifact_small_blue_icon_composition")

---Gets the icon for the small green alien artifact as an `IconComposition`.
M.get_alien_artifact_small_green_icon_composition =
	icons:flat("alien-artifact-small-green"):build_composition("get_alien_artifact_small_green_icon_composition")

---Gets the icon for the small orange alien artifact as an `IconComposition`.
M.get_alien_artifact_small_orange_icon_composition =
	icons:flat("alien-artifact-small-orange"):build_composition("get_alien_artifact_small_orange_icon_composition")

---Gets the icon for the small purple alien artifact as an `IconComposition`.
M.get_alien_artifact_small_purple_icon_composition =
	icons:flat("alien-artifact-small-purple"):build_composition("get_alien_artifact_small_purple_icon_composition")

---Gets the icon for the small red alien artifact as an `IconComposition`.
M.get_alien_artifact_small_red_icon_composition =
	icons:flat("alien-artifact-small-red"):build_composition("get_alien_artifact_small_red_icon_composition")

---Gets the icon for the small yellow alien artifact as an `IconComposition`.
M.get_alien_artifact_small_yellow_icon_composition =
	icons:flat("alien-artifact-small-yellow"):build_composition("get_alien_artifact_small_yellow_icon_composition")

return M
