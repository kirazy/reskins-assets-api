---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local IconBuilderFactory = require("api.icon-builder-factory")

local ORES = {
	"bauxite-ore",
	"cobalt-ore",
	"gold-ore",
	"lead-ore",
	"nickel-ore",
	"quartz",
	"rutile-ore",
	"silver-ore",
	"tin-ore",
	"tungsten-ore",
	"zinc-ore",
}

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.bobs_assets .. "/graphics/icons" })

---Provides methods for getting the icons of the ores collection, `ores/{ore}/{ore}.png`, with their picture variations,
---and of the fluid resources at the root of the ores folder, such as `ores/lithia-water.png`.
---
---#### Examples
---```lua
---local Ores = require("__reskins-assets-api__.assets.bobs.items.ores")
---```
---@class Ores
local M = {}

---Gets the icon for the given `ore` as an `IconComposition`, with 4 picture variations, or 8 for bauxite ore, tin ore,
---and tungsten ore.
---
---The icon is the first picture.
---
---#### Examples
---```lua
----- Get the icon for the bauxite ore, with its pictures.
---local icon_data, pictures = Ores.get_icon_composition({ ore = "bauxite-ore" }):build()
----- The icon is ores/bauxite-ore/bauxite-ore.png, and the pictures are that file and bauxite-ore-{i}.png for i
----- between 1 and 7.
---```
M.get_icon_composition = icons
	:collection("ores", "ore", V.one_of(ORES))
	:variations(4, { ["bauxite-ore"] = 8, ["tin-ore"] = 8, ["tungsten-ore"] = 8 })
	:build_composition("get_icon_composition")

---Gets the icon for thorium ore as an `IconComposition`, with 4 picture variations that draw the ore a second time as a
---light.
M.get_thorium_ore_icon_composition = icons
	:flat("thorium-ore")
	:folder(_defines.assets_source.bobs_assets .. "/graphics/icons/ores/thorium-ore")
	:variations(4)
	:glow()
	:build_composition("get_thorium_ore_icon_composition")

---Gets the icon for the ground water resource as an `IconComposition`.
M.get_ground_water_icon_composition = icons
	:flat("ground-water")
	:folder(_defines.assets_source.bobs_assets .. "/graphics/icons/ores")
	:build_composition("get_ground_water_icon_composition")

---Gets the icon for the lithia water resource as an `IconComposition`.
M.get_lithia_water_icon_composition = icons
	:flat("lithia-water")
	:folder(_defines.assets_source.bobs_assets .. "/graphics/icons/ores")
	:build_composition("get_lithia_water_icon_composition")

return M
