---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Items

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.angels_assets .. "/graphics/icons/rolls" })

---Provides the icons of the rolls folder of Angel's items, `rolls/roll-{material}.png`.
---
---#### Examples
---```lua
---local Rolls = require("__reskins-assets-api__.assets.angels.items.rolls")
---```
---@class Rolls
local M = {}

---Gets the icon for the sheet coil of the given `material` as an `IconComposition`.
---
---#### Examples
---```lua
----- Get the icon for the brass roll.
---local composition = Rolls.get_icon_composition({ material = "brass" })
----- The icon is rolls/roll-brass.png.
---```
M.get_icon_composition = icons
	:flat("roll")
	:keyed(
		"material",
		V.one_of({
			"brass",
			"bronze",
			"cobalt-steel",
			"gunmetal",
			"invar",
			"nitinol",
			"tungsten",
		})
	)
	:build_composition("get_icon_composition")

return M
