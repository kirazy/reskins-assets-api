---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local MATERIALS = {
	"cobalt-steel",
	"nitinol",
	"titanium",
	"tungsten",
}

---Provides methods for getting the icons in the gears folder of Angel's items, `gears/{material}-gear-wheel.png`.
---
---#### Examples
---```lua
---local Gears = require("__reskins-assets-api__.assets.angels.items.gears")
---```
---@class Gears
local M = {}

---Gets the icon for the gear wheel of the given `material` as an `IconComposition`.
---
---#### Examples
---```lua
----- Get the icon for the titanium gear wheel.
---local composition = Gears.get_icon_composition({ material = "titanium" })
----- The icon is gears/titanium-gear-wheel.png.
---```
M.get_icon_composition = IconBuilderFactory.dispatch_composition(
	"material",
	MATERIALS,
	"get_icon_composition",
	function(material)
		return IconBuilderFactory:create({ folder = _defines.assets_source.angels_assets .. "/graphics/icons/gears" })
			:flat(material .. "-gear-wheel")
	end
)

return M
