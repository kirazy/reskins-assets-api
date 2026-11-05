---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons =
	IconBuilderFactory:create({ folder = _defines.assets_source.bobs_assets .. "/graphics/icons/laser-rifle-batteries" })

---Provides methods for getting the icons of the laser-rifle-batteries folder, such as
---`laser-rifle-batteries/laser-rifle-battery.png`.
---
---#### Examples
---```lua
---local LaserRifleBatteries = require("__reskins-assets-api__.assets.bobs.items.laser-rifle-batteries")
---```
---@class LaserRifleBatteries
local M = {}

---Gets the icon for the laser rifle battery as an `IconComposition`.
M.get_laser_rifle_battery_icon_composition =
	icons:flat("laser-rifle-battery"):build_composition("get_laser_rifle_battery_icon_composition")

---Gets the icon for the amethyst laser rifle battery as an `IconComposition`.
M.get_laser_rifle_battery_amethyst_icon_composition =
	icons:flat("laser-rifle-battery-amethyst"):build_composition("get_laser_rifle_battery_amethyst_icon_composition")

---Gets the icon for the diamond laser rifle battery as an `IconComposition`.
M.get_laser_rifle_battery_diamond_icon_composition =
	icons:flat("laser-rifle-battery-diamond"):build_composition("get_laser_rifle_battery_diamond_icon_composition")

---Gets the icon for the emerald laser rifle battery as an `IconComposition`.
M.get_laser_rifle_battery_emerald_icon_composition =
	icons:flat("laser-rifle-battery-emerald"):build_composition("get_laser_rifle_battery_emerald_icon_composition")

---Gets the icon for the ruby laser rifle battery as an `IconComposition`.
M.get_laser_rifle_battery_ruby_icon_composition =
	icons:flat("laser-rifle-battery-ruby"):build_composition("get_laser_rifle_battery_ruby_icon_composition")

---Gets the icon for the sapphire laser rifle battery as an `IconComposition`.
M.get_laser_rifle_battery_sapphire_icon_composition =
	icons:flat("laser-rifle-battery-sapphire"):build_composition("get_laser_rifle_battery_sapphire_icon_composition")

---Gets the icon for the topaz laser rifle battery as an `IconComposition`.
M.get_laser_rifle_battery_topaz_icon_composition =
	icons:flat("laser-rifle-battery-topaz"):build_composition("get_laser_rifle_battery_topaz_icon_composition")

return M
