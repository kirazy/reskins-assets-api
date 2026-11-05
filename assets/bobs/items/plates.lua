---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local FOLDER = _defines.assets_source.bobs_assets .. "/graphics/icons/plates"

local MATERIALS = {
	"aluminium",
	"cobalt",
	"gold",
	"lead",
	"lithium",
	"nickel",
	"silver",
	"tin",
	"titanium",
	"tungsten",
	"tungsten-carbide",
	"zinc",
}

local ALLOYS = {
	"alien-blue",
	"alien-orange",
	"brass",
	"bronze",
	"cobalt-steel",
	"copper-tungsten",
	"gunmetal",
	"invar",
	"nitinol",
	"solder",
}

---Provides methods for getting the icons of the plates folder, `plates/{material}-plate.png` and
---`plates/{alloy}-alloy.png`.
---
---#### Examples
---```lua
---local Plates = require("__reskins-assets-api__.assets.bobs.items.plates")
---```
---@class Plates
local M = {}

---Gets the icon for the plate of the given `material` as an `IconComposition`.
---
---#### Examples
---```lua
----- Get the icon for the tungsten carbide plate.
---local composition = Plates.get_icon_composition({ material = "tungsten-carbide" })
----- The icon is plates/tungsten-carbide-plate.png.
---```
M.get_icon_composition = IconBuilderFactory.dispatch_composition(
	"material",
	MATERIALS,
	"get_icon_composition",
	function(material)
		return IconBuilderFactory:create({ folder = FOLDER }):flat(material .. "-plate")
	end
)

---Gets the icon for the alloy of the given `alloy` as an `IconComposition`.
---
---#### Examples
---```lua
----- Get the icon for the blue alien alloy.
---local composition = Plates.get_alloy_icon_composition({ alloy = "alien-blue" })
----- The icon is plates/alien-blue-alloy.png.
---```
M.get_alloy_icon_composition = IconBuilderFactory.dispatch_composition(
	"alloy",
	ALLOYS,
	"get_alloy_icon_composition",
	function(alloy)
		return IconBuilderFactory:create({ folder = FOLDER }):flat(alloy .. "-alloy")
	end
)

return M
