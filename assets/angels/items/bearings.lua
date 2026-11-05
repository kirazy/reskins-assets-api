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

---Provides the icons of the bearings folder of Angel's items, `bearings/{material}-bearing.png`.
---
---#### Examples
---```lua
---local Bearings = require("__reskins-assets-api__.assets.angels.items.bearings")
---```
---@class Bearings
local M = {}

---Gets the icon for the bearing of the given `material` as an `IconComposition`.
---
---#### Examples
---```lua
----- Get the icon for the nitinol bearing.
---local composition = Bearings.get_icon_composition({ material = "nitinol" })
----- The icon is bearings/nitinol-bearing.png.
---```
M.get_icon_composition = IconBuilderFactory.dispatch_composition(
	"material",
	MATERIALS,
	"get_icon_composition",
	function(material)
		return IconBuilderFactory:create({ folder = _defines.assets_source.angels_assets .. "/graphics/icons/bearings" })
			:flat(material .. "-bearing")
	end
)

return M
