---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Items

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local IconBuilderFactory = require("api.icon-builder-factory")

local ORES = {
	"lead-ore",
	"rutile-ore",
	"tin-ore",
}

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.angels_assets .. "/graphics/icons" })

---Provides methods for getting the icons in the ores collection of Angel's items, `ores/{ore}/{ore}.png`, with their
---picture variations.
---
---#### Examples
---```lua
---local Ores = require("__reskins-assets-api__.assets.angels.items.ores")
---```
---@class Ores
local M = {}

---Gets the icon for the given `ore` as an `IconComposition`, with 4 picture variations, or 8 for tin ore.
---
---The icon is the first picture.
---
---#### Examples
---```lua
----- Get the icon for the tin ore, with its pictures.
---local icon_data, pictures = Ores.get_icon_composition({ ore = "tin-ore" }):build()
----- The icon is ores/tin-ore/tin-ore.png, and the pictures are that file and tin-ore-{i}.png for i between 1 and 7.
---```
M.get_icon_composition = icons
	:collection("ores", "ore", V.one_of(ORES))
	:variations(4, { ["tin-ore"] = 8 })
	:build_composition("get_icon_composition")

---Gets the icon for thorium ore as an `IconComposition`, with 4 picture variations that draw the ore a second time as a
---light.
M.get_thorium_ore_icon_composition = icons
	:flat("thorium-ore")
	:folder(_defines.assets_source.angels_assets .. "/graphics/icons/ores/thorium-ore")
	:variations(4)
	:glow()
	:build_composition("get_thorium_ore_icon_composition")

return M
