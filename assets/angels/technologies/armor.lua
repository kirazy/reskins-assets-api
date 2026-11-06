---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Technologies

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local technologies = IconBuilderFactory:create({
	folder = _defines.assets_source.angels_assets .. "/graphics/technology/armor",
	defaults_type = "technology",
})

---Provides methods for getting the technology icons in the armor folder of Angel's technologies, in the colors of
---Angel's materials.
---
---#### Examples
---```lua
---local Armor = require("__reskins-assets-api__.assets.angels.technologies.armor")
---```
---@class Armor
local M = {}

local armor_making_3 = technologies:flat("armor-making-3")

---Gets the technology icon for armor making 3.
M.get_armor_making_3_icon = armor_making_3:build("get_armor_making_3_icon")

---Gets the technology icon for armor making 3 as an `IconComposition`.
M.get_armor_making_3_icon_composition = armor_making_3:build_composition("get_armor_making_3_icon_composition")

local armor_making_4 = technologies:flat("armor-making-4")

---Gets the technology icon for armor making 4.
M.get_armor_making_4_icon = armor_making_4:build("get_armor_making_4_icon")

---Gets the technology icon for armor making 4 as an `IconComposition`.
M.get_armor_making_4_icon_composition = armor_making_4:build_composition("get_armor_making_4_icon_composition")

local power_armor_4 = technologies:flat("power-armor-4")

---Gets the technology icon for the power armor mk4.
M.get_power_armor_4_icon = power_armor_4:build("get_power_armor_4_icon")

---Gets the technology icon for the power armor mk4 as an `IconComposition`.
M.get_power_armor_4_icon_composition = power_armor_4:build_composition("get_power_armor_4_icon_composition")

local power_armor_5 = technologies:flat("power-armor-5")

---Gets the technology icon for the power armor mk5.
M.get_power_armor_5_icon = power_armor_5:build("get_power_armor_5_icon")

---Gets the technology icon for the power armor mk5 as an `IconComposition`.
M.get_power_armor_5_icon_composition = power_armor_5:build_composition("get_power_armor_5_icon_composition")

return M
