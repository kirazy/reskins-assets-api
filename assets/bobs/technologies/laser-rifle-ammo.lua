---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Technologies

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local technologies = IconBuilderFactory:create({
	folder = _defines.assets_source.bobs_assets .. "/graphics/technology/laser-rifle-ammo",
	defaults_type = "technology",
})

---Provides methods for getting the technology icons in the `laser-rifle-ammo` folder, such as
---`laser-rifle-ammo/laser-rifle-ammo-1.png`.
---
---#### Examples
---```lua
---local LaserRifleAmmo = require("__reskins-assets-api__.assets.bobs.technologies.laser-rifle-ammo")
---```
---@class LaserRifleAmmo
local M = {}

local laser_rifle_ammo_1 = technologies:flat("laser-rifle-ammo-1")

---Gets the technology icon for laser rifle ammo 1.
M.get_laser_rifle_ammo_1_icon = laser_rifle_ammo_1:build("get_laser_rifle_ammo_1_icon")

---Gets the technology icon for laser rifle ammo 1 as an `IconComposition`.
M.get_laser_rifle_ammo_1_icon_composition =
	laser_rifle_ammo_1:build_composition("get_laser_rifle_ammo_1_icon_composition")

local laser_rifle_ammo_2 = technologies:flat("laser-rifle-ammo-2")

---Gets the technology icon for laser rifle ammo 2.
M.get_laser_rifle_ammo_2_icon = laser_rifle_ammo_2:build("get_laser_rifle_ammo_2_icon")

---Gets the technology icon for laser rifle ammo 2 as an `IconComposition`.
M.get_laser_rifle_ammo_2_icon_composition =
	laser_rifle_ammo_2:build_composition("get_laser_rifle_ammo_2_icon_composition")

local laser_rifle_ammo_3 = technologies:flat("laser-rifle-ammo-3")

---Gets the technology icon for laser rifle ammo 3.
M.get_laser_rifle_ammo_3_icon = laser_rifle_ammo_3:build("get_laser_rifle_ammo_3_icon")

---Gets the technology icon for laser rifle ammo 3 as an `IconComposition`.
M.get_laser_rifle_ammo_3_icon_composition =
	laser_rifle_ammo_3:build_composition("get_laser_rifle_ammo_3_icon_composition")

local laser_rifle_ammo_4 = technologies:flat("laser-rifle-ammo-4")

---Gets the technology icon for laser rifle ammo 4.
M.get_laser_rifle_ammo_4_icon = laser_rifle_ammo_4:build("get_laser_rifle_ammo_4_icon")

---Gets the technology icon for laser rifle ammo 4 as an `IconComposition`.
M.get_laser_rifle_ammo_4_icon_composition =
	laser_rifle_ammo_4:build_composition("get_laser_rifle_ammo_4_icon_composition")

local laser_rifle_ammo_5 = technologies:flat("laser-rifle-ammo-5")

---Gets the technology icon for laser rifle ammo 5.
M.get_laser_rifle_ammo_5_icon = laser_rifle_ammo_5:build("get_laser_rifle_ammo_5_icon")

---Gets the technology icon for laser rifle ammo 5 as an `IconComposition`.
M.get_laser_rifle_ammo_5_icon_composition =
	laser_rifle_ammo_5:build_composition("get_laser_rifle_ammo_5_icon_composition")

local laser_rifle_ammo_6 = technologies:flat("laser-rifle-ammo-6")

---Gets the technology icon for laser rifle ammo 6.
M.get_laser_rifle_ammo_6_icon = laser_rifle_ammo_6:build("get_laser_rifle_ammo_6_icon")

---Gets the technology icon for laser rifle ammo 6 as an `IconComposition`.
M.get_laser_rifle_ammo_6_icon_composition =
	laser_rifle_ammo_6:build_composition("get_laser_rifle_ammo_6_icon_composition")

return M
