---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.bobs_assets .. "/graphics/icons/capsules" })

---Provides methods for getting the icons of the capsules folder, such as `capsules/defender-capsule.png`.
---
---#### Examples
---```lua
---local Capsules = require("__reskins-assets-api__.assets.bobs.items.capsules")
---```
---@class Capsules
local M = {}

---Gets the icon for the defender capsule as an `IconComposition`.
M.get_defender_capsule_icon_composition =
	icons:flat("defender-capsule"):build_composition("get_defender_capsule_icon_composition")

---Gets the icon for the destroyer capsule as an `IconComposition`.
M.get_destroyer_capsule_icon_composition =
	icons:flat("destroyer-capsule"):build_composition("get_destroyer_capsule_icon_composition")

---Gets the icon for the distractor capsule as an `IconComposition`.
M.get_distractor_capsule_icon_composition =
	icons:flat("distractor-capsule"):build_composition("get_distractor_capsule_icon_composition")

---Gets the icon for the fire capsule as an `IconComposition`.
M.get_fire_capsule_icon_composition = icons:flat("fire-capsule"):build_composition("get_fire_capsule_icon_composition")

---Gets the icon for the laser robot capsule as an `IconComposition`.
M.get_laser_robot_capsule_icon_composition =
	icons:flat("laser-robot-capsule"):build_composition("get_laser_robot_capsule_icon_composition")

return M
