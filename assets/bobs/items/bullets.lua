---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.bobs_assets .. "/graphics/icons/bullets" })

---Provides methods for getting the icons of the bullets folder, such as `bullets/acid-bullet.png`.
---
---#### Examples
---```lua
---local Bullets = require("__reskins-assets-api__.assets.bobs.items.bullets")
---```
---@class Bullets
local M = {}

---Gets the icon for the acid bullet as an `IconComposition`.
M.get_acid_bullet_icon_composition = icons:flat("acid-bullet"):build_composition("get_acid_bullet_icon_composition")

---Gets the icon for the armor-piercing bullet as an `IconComposition`.
M.get_ap_bullet_icon_composition = icons:flat("ap-bullet"):build_composition("get_ap_bullet_icon_composition")

---Gets the icon for the bullet as an `IconComposition`.
M.get_bullet_icon_composition = icons:flat("bullet"):build_composition("get_bullet_icon_composition")

---Gets the icon for the electric bullet as an `IconComposition`.
M.get_electric_bullet_icon_composition =
	icons:flat("electric-bullet"):build_composition("get_electric_bullet_icon_composition")

---Gets the icon for the flame bullet as an `IconComposition`.
M.get_flame_bullet_icon_composition = icons:flat("flame-bullet"):build_composition("get_flame_bullet_icon_composition")

---Gets the icon for the high-explosive bullet as an `IconComposition`.
M.get_he_bullet_icon_composition = icons:flat("he-bullet"):build_composition("get_he_bullet_icon_composition")

---Gets the icon for the plasma bullet as an `IconComposition`.
M.get_plasma_bullet_icon_composition =
	icons:flat("plasma-bullet"):build_composition("get_plasma_bullet_icon_composition")

---Gets the icon for the poison bullet as an `IconComposition`.
M.get_poison_bullet_icon_composition =
	icons:flat("poison-bullet"):build_composition("get_poison_bullet_icon_composition")

---Gets the icon for the uranium bullet as an `IconComposition`.
M.get_uranium_bullet_icon_composition =
	icons:flat("uranium-bullet"):build_composition("get_uranium_bullet_icon_composition")

return M
