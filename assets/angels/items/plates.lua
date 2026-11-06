---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local MATERIALS = {
	"aluminium",
	"chrome",
	"cobalt",
	"depleted-uranium",
	"gold",
	"hot-iron",
	"iron",
	"lead",
	"magnesium",
	"manganese",
	"nickel",
	"osmium",
	"platinum",
	"silver",
	"tin",
	"titanium",
	"tungsten",
	"zinc",
}

---Provides methods for getting the icons in the plates folder of Angel's items, `plates/{material}-plate.png`.
---
---#### Examples
---```lua
---local Plates = require("__reskins-assets-api__.assets.angels.items.plates")
---```
---@class Plates
local M = {}

---Gets the icon for the plate of the given `material` as an `IconComposition`.
---
---#### Examples
---```lua
----- Get the icon for the aluminium plate.
---local composition = Plates.get_icon_composition({ material = "aluminium" })
----- The icon is plates/aluminium-plate.png.
---```
M.get_icon_composition = IconBuilderFactory.dispatch_composition(
	"material",
	MATERIALS,
	"get_icon_composition",
	function(material)
		return IconBuilderFactory:create({ folder = _defines.assets_source.angels_assets .. "/graphics/icons/plates" })
			:flat(material .. "-plate")
	end
)

local ALLOYS = {
	"brass",
	"bronze",
	"cobalt-steel",
	"copper-tungsten",
	"gunmetal",
	"invar",
	"nitinol",
}

---Gets the icon for the alloy of the given `alloy` as an `IconComposition`.
---
---#### Examples
---```lua
----- Get the icon for the brass alloy.
---local composition = Plates.get_alloy_icon_composition({ alloy = "brass" })
----- The icon is plates/brass-alloy.png.
---```
M.get_alloy_icon_composition = IconBuilderFactory.dispatch_composition(
	"alloy",
	ALLOYS,
	"get_alloy_icon_composition",
	function(alloy)
		return IconBuilderFactory:create({ folder = _defines.assets_source.angels_assets .. "/graphics/icons/plates" })
			:flat(alloy .. "-alloy")
	end
)

return M
