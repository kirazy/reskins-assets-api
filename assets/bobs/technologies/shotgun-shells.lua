---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Technologies

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local technologies = IconBuilderFactory:create({
	folder = _defines.assets_source.bobs_assets .. "/graphics/technology/shotgun-shells",
	defaults_type = "technology",
})

---Provides methods for getting the technology icons in the `shotgun-shells` folder, such as
---`shotgun-shells/acid-shotgun-shells.png`.
---
---#### Examples
---```lua
---local ShotgunShells = require("__reskins-assets-api__.assets.bobs.technologies.shotgun-shells")
---```
---@class ShotgunShells
local M = {}

local acid_shotgun_shells = technologies:flat("acid-shotgun-shells")

---Gets the technology icon for acid shotgun shells.
M.get_acid_shotgun_shells_icon = acid_shotgun_shells:build("get_acid_shotgun_shells_icon")

---Gets the technology icon for acid shotgun shells as an `IconComposition`.
M.get_acid_shotgun_shells_icon_composition =
	acid_shotgun_shells:build_composition("get_acid_shotgun_shells_icon_composition")

local ap_shotgun_shells = technologies:flat("ap-shotgun-shells")

---Gets the technology icon for armor-piercing shotgun shells.
M.get_ap_shotgun_shells_icon = ap_shotgun_shells:build("get_ap_shotgun_shells_icon")

---Gets the technology icon for armor-piercing shotgun shells as an `IconComposition`.
M.get_ap_shotgun_shells_icon_composition = ap_shotgun_shells:build_composition("get_ap_shotgun_shells_icon_composition")

local electric_shotgun_shells = technologies:flat("electric-shotgun-shells")

---Gets the technology icon for electric shotgun shells.
M.get_electric_shotgun_shells_icon = electric_shotgun_shells:build("get_electric_shotgun_shells_icon")

---Gets the technology icon for electric shotgun shells as an `IconComposition`.
M.get_electric_shotgun_shells_icon_composition =
	electric_shotgun_shells:build_composition("get_electric_shotgun_shells_icon_composition")

local explosive_shotgun_shells = technologies:flat("explosive-shotgun-shells")

---Gets the technology icon for explosive shotgun shells.
M.get_explosive_shotgun_shells_icon = explosive_shotgun_shells:build("get_explosive_shotgun_shells_icon")

---Gets the technology icon for explosive shotgun shells as an `IconComposition`.
M.get_explosive_shotgun_shells_icon_composition =
	explosive_shotgun_shells:build_composition("get_explosive_shotgun_shells_icon_composition")

local flame_shotgun_shells = technologies:flat("flame-shotgun-shells")

---Gets the technology icon for flame shotgun shells.
M.get_flame_shotgun_shells_icon = flame_shotgun_shells:build("get_flame_shotgun_shells_icon")

---Gets the technology icon for flame shotgun shells as an `IconComposition`.
M.get_flame_shotgun_shells_icon_composition =
	flame_shotgun_shells:build_composition("get_flame_shotgun_shells_icon_composition")

local plasma_shotgun_shells = technologies:flat("plasma-shotgun-shells")

---Gets the technology icon for plasma shotgun shells.
M.get_plasma_shotgun_shells_icon = plasma_shotgun_shells:build("get_plasma_shotgun_shells_icon")

---Gets the technology icon for plasma shotgun shells as an `IconComposition`.
M.get_plasma_shotgun_shells_icon_composition =
	plasma_shotgun_shells:build_composition("get_plasma_shotgun_shells_icon_composition")

local poison_shotgun_shells = technologies:flat("poison-shotgun-shells")

---Gets the technology icon for poison shotgun shells.
M.get_poison_shotgun_shells_icon = poison_shotgun_shells:build("get_poison_shotgun_shells_icon")

---Gets the technology icon for poison shotgun shells as an `IconComposition`.
M.get_poison_shotgun_shells_icon_composition =
	poison_shotgun_shells:build_composition("get_poison_shotgun_shells_icon_composition")

local shotgun_shells = technologies:flat("shotgun-shells")

---Gets the technology icon for shotgun shells.
M.get_shotgun_shells_icon = shotgun_shells:build("get_shotgun_shells_icon")

---Gets the technology icon for shotgun shells as an `IconComposition`.
M.get_shotgun_shells_icon_composition = shotgun_shells:build_composition("get_shotgun_shells_icon_composition")

local uranium_shotgun_shells = technologies:flat("uranium-shotgun-shells")

---Gets the technology icon for uranium shotgun shells.
M.get_uranium_shotgun_shells_icon = uranium_shotgun_shells:build("get_uranium_shotgun_shells_icon")

---Gets the technology icon for uranium shotgun shells as an `IconComposition`.
M.get_uranium_shotgun_shells_icon_composition =
	uranium_shotgun_shells:build_composition("get_uranium_shotgun_shells_icon_composition")

return M
