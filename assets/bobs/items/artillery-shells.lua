---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons =
	IconBuilderFactory:create({ folder = _defines.assets_source.bobs_assets .. "/graphics/icons/artillery-shells" })

---Provides methods for getting the icons of the artillery-shells folder, such as
---`artillery-shells/atomic-artillery-shell.png`.
---
---#### Examples
---```lua
---local ArtilleryShells = require("__reskins-assets-api__.assets.bobs.items.artillery-shells")
---```
---@class ArtilleryShells
local M = {}

---Gets the icon for the atomic artillery shell as an `IconComposition`.
M.get_atomic_artillery_shell_icon_composition =
	icons:flat("atomic-artillery-shell"):build_composition("get_atomic_artillery_shell_icon_composition")

---Gets the icon for the distractor artillery shell as an `IconComposition`.
M.get_distractor_artillery_shell_icon_composition =
	icons:flat("distractor-artillery-shell"):build_composition("get_distractor_artillery_shell_icon_composition")

---Gets the icon for the explosive artillery shell as an `IconComposition`.
M.get_explosive_artillery_shell_icon_composition =
	icons:flat("explosive-artillery-shell"):build_composition("get_explosive_artillery_shell_icon_composition")

---Gets the icon for the fire artillery shell as an `IconComposition`.
M.get_fire_artillery_shell_icon_composition =
	icons:flat("fire-artillery-shell"):build_composition("get_fire_artillery_shell_icon_composition")

---Gets the icon for the poison artillery shell as an `IconComposition`.
M.get_poison_artillery_shell_icon_composition =
	icons:flat("poison-artillery-shell"):build_composition("get_poison_artillery_shell_icon_composition")

return M
