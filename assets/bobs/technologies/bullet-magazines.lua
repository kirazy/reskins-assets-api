---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Technologies

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local technologies = IconBuilderFactory:create({
	folder = _defines.assets_source.bobs_assets .. "/graphics/technology/bullet-magazines",
	defaults_type = "technology",
})

---Provides methods for getting the technology icons in the `bullet-magazines` folder, such as
---`bullet-magazines/acid-bullet-magazines.png`.
---
---#### Examples
---```lua
---local BulletMagazines = require("__reskins-assets-api__.assets.bobs.technologies.bullet-magazines")
---```
---@class BulletMagazines
local M = {}

local acid_bullet_magazines = technologies:flat("acid-bullet-magazines")

---Gets the technology icon for acid bullet magazines.
M.get_acid_bullet_magazines_icon = acid_bullet_magazines:build("get_acid_bullet_magazines_icon")

---Gets the technology icon for acid bullet magazines as an `IconComposition`.
M.get_acid_bullet_magazines_icon_composition =
	acid_bullet_magazines:build_composition("get_acid_bullet_magazines_icon_composition")

local ap_bullet_magazines = technologies:flat("ap-bullet-magazines")

---Gets the technology icon for armor-piercing bullet magazines.
M.get_ap_bullet_magazines_icon = ap_bullet_magazines:build("get_ap_bullet_magazines_icon")

---Gets the technology icon for armor-piercing bullet magazines as an `IconComposition`.
M.get_ap_bullet_magazines_icon_composition =
	ap_bullet_magazines:build_composition("get_ap_bullet_magazines_icon_composition")

local bullet_magazines = technologies:flat("bullet-magazines")

---Gets the technology icon for bullet magazines.
M.get_bullet_magazines_icon = bullet_magazines:build("get_bullet_magazines_icon")

---Gets the technology icon for bullet magazines as an `IconComposition`.
M.get_bullet_magazines_icon_composition = bullet_magazines:build_composition("get_bullet_magazines_icon_composition")

local electric_bullet_magazines = technologies:flat("electric-bullet-magazines")

---Gets the technology icon for electric bullet magazines.
M.get_electric_bullet_magazines_icon = electric_bullet_magazines:build("get_electric_bullet_magazines_icon")

---Gets the technology icon for electric bullet magazines as an `IconComposition`.
M.get_electric_bullet_magazines_icon_composition =
	electric_bullet_magazines:build_composition("get_electric_bullet_magazines_icon_composition")

local flame_bullet_magazines = technologies:flat("flame-bullet-magazines")

---Gets the technology icon for flame bullet magazines.
M.get_flame_bullet_magazines_icon = flame_bullet_magazines:build("get_flame_bullet_magazines_icon")

---Gets the technology icon for flame bullet magazines as an `IconComposition`.
M.get_flame_bullet_magazines_icon_composition =
	flame_bullet_magazines:build_composition("get_flame_bullet_magazines_icon_composition")

local he_bullet_magazines = technologies:flat("he-bullet-magazines")

---Gets the technology icon for high-explosive bullet magazines.
M.get_he_bullet_magazines_icon = he_bullet_magazines:build("get_he_bullet_magazines_icon")

---Gets the technology icon for high-explosive bullet magazines as an `IconComposition`.
M.get_he_bullet_magazines_icon_composition =
	he_bullet_magazines:build_composition("get_he_bullet_magazines_icon_composition")

local plasma_bullet_magazines = technologies:flat("plasma-bullet-magazines")

---Gets the technology icon for plasma bullet magazines.
M.get_plasma_bullet_magazines_icon = plasma_bullet_magazines:build("get_plasma_bullet_magazines_icon")

---Gets the technology icon for plasma bullet magazines as an `IconComposition`.
M.get_plasma_bullet_magazines_icon_composition =
	plasma_bullet_magazines:build_composition("get_plasma_bullet_magazines_icon_composition")

local poison_bullet_magazines = technologies:flat("poison-bullet-magazines")

---Gets the technology icon for poison bullet magazines.
M.get_poison_bullet_magazines_icon = poison_bullet_magazines:build("get_poison_bullet_magazines_icon")

---Gets the technology icon for poison bullet magazines as an `IconComposition`.
M.get_poison_bullet_magazines_icon_composition =
	poison_bullet_magazines:build_composition("get_poison_bullet_magazines_icon_composition")

local uranium_ammo = technologies:flat("uranium-ammo")

---Gets the technology icon for uranium ammo.
M.get_uranium_ammo_icon = uranium_ammo:build("get_uranium_ammo_icon")

---Gets the technology icon for uranium ammo as an `IconComposition`.
M.get_uranium_ammo_icon_composition = uranium_ammo:build_composition("get_uranium_ammo_icon_composition")

return M
