---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Technologies

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local technologies = IconBuilderFactory:create({
	folder = _defines.assets_source.bobs_assets .. "/graphics/technology/artillery-shells",
	defaults_type = "technology",
})

---Provides methods for getting the technology icons in the `artillery-shells` folder, such as
---`artillery-shells/atomic-artillery-shell.png`.
---
---#### Examples
---```lua
---local ArtilleryShells = require("__reskins-assets-api__.assets.bobs.technologies.artillery-shells")
---```
---@class ArtilleryShells
local M = {}

local atomic_artillery_shell = technologies:flat("atomic-artillery-shell")

---Gets the technology icon for the atomic artillery shell.
M.get_atomic_artillery_shell_icon = atomic_artillery_shell:build("get_atomic_artillery_shell_icon")

---Gets the technology icon for the atomic artillery shell as an `IconComposition`.
M.get_atomic_artillery_shell_icon_composition =
	atomic_artillery_shell:build_composition("get_atomic_artillery_shell_icon_composition")

local distractor_artillery_shells = technologies:flat("distractor-artillery-shells")

---Gets the technology icon for distractor artillery shells.
M.get_distractor_artillery_shells_icon = distractor_artillery_shells:build("get_distractor_artillery_shells_icon")

---Gets the technology icon for distractor artillery shells as an `IconComposition`.
M.get_distractor_artillery_shells_icon_composition =
	distractor_artillery_shells:build_composition("get_distractor_artillery_shells_icon_composition")

local explosive_artillery_shells = technologies:flat("explosive-artillery-shells")

---Gets the technology icon for explosive artillery shells.
M.get_explosive_artillery_shells_icon = explosive_artillery_shells:build("get_explosive_artillery_shells_icon")

---Gets the technology icon for explosive artillery shells as an `IconComposition`.
M.get_explosive_artillery_shells_icon_composition =
	explosive_artillery_shells:build_composition("get_explosive_artillery_shells_icon_composition")

local fire_artillery_shells = technologies:flat("fire-artillery-shells")

---Gets the technology icon for fire artillery shells.
M.get_fire_artillery_shells_icon = fire_artillery_shells:build("get_fire_artillery_shells_icon")

---Gets the technology icon for fire artillery shells as an `IconComposition`.
M.get_fire_artillery_shells_icon_composition =
	fire_artillery_shells:build_composition("get_fire_artillery_shells_icon_composition")

local poison_artillery_shells = technologies:flat("poison-artillery-shells")

---Gets the technology icon for poison artillery shells.
M.get_poison_artillery_shells_icon = poison_artillery_shells:build("get_poison_artillery_shells_icon")

---Gets the technology icon for poison artillery shells as an `IconComposition`.
M.get_poison_artillery_shells_icon_composition =
	poison_artillery_shells:build_composition("get_poison_artillery_shells_icon_composition")

return M
