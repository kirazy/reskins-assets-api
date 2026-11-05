---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons =
	IconBuilderFactory:create({ folder = _defines.assets_source.bobs_assets .. "/graphics/icons/bullet-magazines" })

---Provides methods for getting the icons of the bullet-magazines folder, such as
---`bullet-magazines/acid-bullet-magazine.png`.
---
---#### Examples
---```lua
---local BulletMagazines = require("__reskins-assets-api__.assets.bobs.items.bullet-magazines")
---```
---@class BulletMagazines
local M = {}

---Gets the icon for the acid bullet magazine as an `IconComposition`.
M.get_acid_bullet_magazine_icon_composition =
	icons:flat("acid-bullet-magazine"):build_composition("get_acid_bullet_magazine_icon_composition")

---Gets the icon for the armor-piercing bullet magazine as an `IconComposition`.
M.get_ap_bullet_magazine_icon_composition =
	icons:flat("ap-bullet-magazine"):build_composition("get_ap_bullet_magazine_icon_composition")

---Gets the icon for the blank magazine as an `IconComposition`.
M.get_blank_magazine_icon_composition =
	icons:flat("blank-magazine"):build_composition("get_blank_magazine_icon_composition")

---Gets the icon for the bullet magazine as an `IconComposition`.
M.get_bullet_magazine_icon_composition =
	icons:flat("bullet-magazine"):build_composition("get_bullet_magazine_icon_composition")

---Gets the icon for the electric bullet magazine as an `IconComposition`.
M.get_electric_bullet_magazine_icon_composition =
	icons:flat("electric-bullet-magazine"):build_composition("get_electric_bullet_magazine_icon_composition")

---Gets the icon for the flame bullet magazine as an `IconComposition`.
M.get_flame_bullet_magazine_icon_composition =
	icons:flat("flame-bullet-magazine"):build_composition("get_flame_bullet_magazine_icon_composition")

---Gets the icon for the high-explosive bullet magazine as an `IconComposition`.
M.get_he_bullet_magazine_icon_composition =
	icons:flat("he-bullet-magazine"):build_composition("get_he_bullet_magazine_icon_composition")

---Gets the icon for the plasma bullet magazine as an `IconComposition`.
M.get_plasma_bullet_magazine_icon_composition =
	icons:flat("plasma-bullet-magazine"):build_composition("get_plasma_bullet_magazine_icon_composition")

---Gets the icon for the poison bullet magazine as an `IconComposition`.
M.get_poison_bullet_magazine_icon_composition =
	icons:flat("poison-bullet-magazine"):build_composition("get_poison_bullet_magazine_icon_composition")

---Gets the icon for the uranium rounds magazine as an `IconComposition`.
M.get_uranium_rounds_magazine_icon_composition =
	icons:flat("uranium-rounds-magazine"):build_composition("get_uranium_rounds_magazine_icon_composition")

return M
