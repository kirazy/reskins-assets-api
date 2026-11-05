---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons =
	IconBuilderFactory:create({ folder = _defines.assets_source.bobs_assets .. "/graphics/icons/bullet-projectiles" })

---Provides methods for getting the icons of the bullet-projectiles folder, such as
---`bullet-projectiles/acid-bullet-projectile.png`.
---
---#### Examples
---```lua
---local BulletProjectiles = require("__reskins-assets-api__.assets.bobs.items.bullet-projectiles")
---```
---@class BulletProjectiles
local M = {}

---Gets the icon for the acid bullet projectile as an `IconComposition`.
M.get_acid_bullet_projectile_icon_composition =
	icons:flat("acid-bullet-projectile"):build_composition("get_acid_bullet_projectile_icon_composition")

---Gets the icon for the armor-piercing bullet projectile as an `IconComposition`.
M.get_ap_bullet_projectile_icon_composition =
	icons:flat("ap-bullet-projectile"):build_composition("get_ap_bullet_projectile_icon_composition")

---Gets the icon for the bullet projectile as an `IconComposition`.
M.get_bullet_projectile_icon_composition =
	icons:flat("bullet-projectile"):build_composition("get_bullet_projectile_icon_composition")

---Gets the icon for the electric bullet projectile as an `IconComposition`.
M.get_electric_bullet_projectile_icon_composition =
	icons:flat("electric-bullet-projectile"):build_composition("get_electric_bullet_projectile_icon_composition")

---Gets the icon for the flame bullet projectile as an `IconComposition`.
M.get_flame_bullet_projectile_icon_composition =
	icons:flat("flame-bullet-projectile"):build_composition("get_flame_bullet_projectile_icon_composition")

---Gets the icon for the high-explosive bullet projectile as an `IconComposition`.
M.get_he_bullet_projectile_icon_composition =
	icons:flat("he-bullet-projectile"):build_composition("get_he_bullet_projectile_icon_composition")

---Gets the icon for the plasma bullet projectile as an `IconComposition`.
M.get_plasma_bullet_projectile_icon_composition =
	icons:flat("plasma-bullet-projectile"):build_composition("get_plasma_bullet_projectile_icon_composition")

---Gets the icon for the poison bullet projectile as an `IconComposition`.
M.get_poison_bullet_projectile_icon_composition =
	icons:flat("poison-bullet-projectile"):build_composition("get_poison_bullet_projectile_icon_composition")

---Gets the icon for the uranium bullet projectile as an `IconComposition`.
M.get_uranium_bullet_projectile_icon_composition =
	icons:flat("uranium-bullet-projectile"):build_composition("get_uranium_bullet_projectile_icon_composition")

return M
