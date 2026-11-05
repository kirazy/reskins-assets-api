---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local MATERIALS = {
	"brass",
	"ceramic",
	"cobalt-steel",
	"nitinol",
	"titanium",
}

---Provides the icons of the bearing-balls folder of Angel's items, `bearing-balls/{material}-bearing-ball.png`.
---
---#### Examples
---```lua
---local BearingBalls = require("__reskins-assets-api__.assets.angels.items.bearing-balls")
---```
---@class BearingBalls
local M = {}

---Gets the icon for the bearing ball of the given `material` as an `IconComposition`.
---
---#### Examples
---```lua
----- Get the icon for the nitinol bearing ball.
---local composition = BearingBalls.get_icon_composition({ material = "nitinol" })
----- The icon is bearing-balls/nitinol-bearing-ball.png.
---```
M.get_icon_composition = IconBuilderFactory.dispatch_composition(
	"material",
	MATERIALS,
	"get_icon_composition",
	function(material)
		return IconBuilderFactory
			:create({ folder = _defines.assets_source.angels_assets .. "/graphics/icons/bearing-balls" })
			:flat(material .. "-bearing-ball")
	end
)

return M
