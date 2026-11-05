---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.angels_assets .. "/graphics/icons/armor" })

---Provides methods for getting the icons of the armor folder of Angel's items, in the colors of Angel's materials.
---
---#### Examples
---```lua
---local Armor = require("__reskins-assets-api__.assets.angels.items.armor")
---```
---@class Armor
local M = {}

---Gets the icon for the heavy armor mk2 as an `IconComposition`.
M.get_heavy_armor_2_icon_composition =
	icons:flat("heavy-armor-2"):build_composition("get_heavy_armor_2_icon_composition")

---Gets the icon for the heavy armor mk3 as an `IconComposition`.
M.get_heavy_armor_3_icon_composition =
	icons:flat("heavy-armor-3"):build_composition("get_heavy_armor_3_icon_composition")

---Gets the icon for the power armor mk4 as an `IconComposition`.
M.get_power_armor_mk4_icon_composition =
	icons:flat("power-armor-mk4"):build_composition("get_power_armor_mk4_icon_composition")

---Gets the icon for the power armor mk5 as an `IconComposition`.
M.get_power_armor_mk5_icon_composition =
	icons:flat("power-armor-mk5"):build_composition("get_power_armor_mk5_icon_composition")

return M
