---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Assorted.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")
local V = require("__reskins-sprite-utils__.validation")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.assorted_assets .. "/graphics/icons" })

---Provides methods for getting the icon of the miniature assembling machine,
---`mini-assembling-machine/mini-assembling-machine[-{machine_tier}]-{role}.png`.
---
---#### Examples
---```lua
---local MiniAssemblingMachine = require("__reskins-assets-api__.assets.assorted.items.mini-assembling-machine")
---```
---@class MiniAssemblingMachine
local M = {}

---Gets the icon for the miniature assembling machine with the gear of the given `machine_tier` as an `IconComposition`,
---in the tints given by `params`.
M.get_icon_composition = icons
	:tinted("mini-assembling-machine")
	:keyed("machine_tier", V.one_of({ 1, 2, 3, 4, 5, 6 }), { "gear" })
	:layer("gear")
	:build_composition("get_icon_composition")

return M
