---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Items

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.angels_assets .. "/graphics/icons/wires" })

---Provides methods for getting the icons of the wires folder of Angel's items, `wires/wire-{material}.png`.
---
---#### Examples
---```lua
---local Wires = require("__reskins-assets-api__.assets.angels.items.wires")
---```
---@class Wires
local M = {}

---Gets the icon for the wire of the given `material` as an `IconComposition`.
---
---#### Examples
---```lua
----- Get the icon for the tin wire.
---local composition = Wires.get_icon_composition({ material = "tin" })
----- The icon is wires/wire-tin.png.
---```
M.get_icon_composition = icons
	:flat("wire")
	:keyed(
		"material",
		V.one_of({
			"gilded-copper",
			"platinum",
			"silver",
			"tin",
		})
	)
	:build_composition("get_icon_composition")

return M
