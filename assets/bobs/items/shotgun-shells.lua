---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons =
	IconBuilderFactory:create({ folder = _defines.assets_source.bobs_assets .. "/graphics/icons/shotgun-shells" })

---Provides methods for getting the icons of the shotgun-shells folder, such as
---`shotgun-shells/better-shotgun-shell.png`.
---
---#### Examples
---```lua
---local ShotgunShells = require("__reskins-assets-api__.assets.bobs.items.shotgun-shells")
---```
---@class ShotgunShells
local M = {}

---Gets the icon for the better shotgun shell as an `IconComposition`.
M.get_better_shotgun_shell_icon_composition =
	icons:flat("better-shotgun-shell"):build_composition("get_better_shotgun_shell_icon_composition")

---Gets the icon for the acid shotgun shell as an `IconComposition`.
M.get_shotgun_acid_shell_icon_composition =
	icons:flat("shotgun-acid-shell"):build_composition("get_shotgun_acid_shell_icon_composition")

---Gets the icon for the armor-piercing shotgun shell as an `IconComposition`.
M.get_shotgun_ap_shell_icon_composition =
	icons:flat("shotgun-ap-shell"):build_composition("get_shotgun_ap_shell_icon_composition")

---Gets the icon for the electric shotgun shell as an `IconComposition`.
M.get_shotgun_electric_shell_icon_composition =
	icons:flat("shotgun-electric-shell"):build_composition("get_shotgun_electric_shell_icon_composition")

---Gets the icon for the explosive shotgun shell as an `IconComposition`.
M.get_shotgun_explosive_shell_icon_composition =
	icons:flat("shotgun-explosive-shell"):build_composition("get_shotgun_explosive_shell_icon_composition")

---Gets the icon for the flame shotgun shell as an `IconComposition`.
M.get_shotgun_flame_shell_icon_composition =
	icons:flat("shotgun-flame-shell"):build_composition("get_shotgun_flame_shell_icon_composition")

---Gets the icon for the plasma shotgun shell as an `IconComposition`.
M.get_shotgun_plasma_shell_icon_composition =
	icons:flat("shotgun-plasma-shell"):build_composition("get_shotgun_plasma_shell_icon_composition")

---Gets the icon for the poison shotgun shell as an `IconComposition`.
M.get_shotgun_poison_shell_icon_composition =
	icons:flat("shotgun-poison-shell"):build_composition("get_shotgun_poison_shell_icon_composition")

---Gets the icon for the uranium shotgun shell as an `IconComposition`.
M.get_shotgun_uranium_shell_icon_composition =
	icons:flat("shotgun-uranium-shell"):build_composition("get_shotgun_uranium_shell_icon_composition")

return M
