---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Items

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.angels_assets .. "/graphics/icons/pellets" })

---Provides methods for getting the icons in the pellets folder of Angel's items, `pellets/pellet-{material}.png`.
---
---#### Examples
---```lua
---local Pellets = require("__reskins-assets-api__.assets.angels.items.pellets")
---```
---@class Pellets
local M = {}

---Gets the icon for the pellet of the given `material` as an `IconComposition`.
---
---#### Examples
---```lua
----- Get the icon for the coke pellet.
---local composition = Pellets.get_icon_composition({ material = "coke" })
----- The icon is pellets/pellet-coke.png.
---```
M.get_icon_composition = icons
	:flat("pellet")
	:keyed(
		"material",
		V.one_of({
			"coke",
			"depleted-uranium",
			"magnesium",
			"osmium",
		})
	)
	:build_composition("get_icon_composition")

return M
