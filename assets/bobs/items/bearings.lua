---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local FOLDER = _defines.assets_source.bobs_assets .. "/graphics/icons/bearings"

local MATERIALS = {
	"brass",
	"ceramic",
	"cobalt-steel",
	"nitinol",
	"steel",
	"titanium",
}

---The files of the bearings in the colors of the materials of Angel's mods, by material.
local ANGELS_FILES = {
	["brass"] = "brass-bearing",
	["ceramic"] = "ceramic-bearing-white",
	["cobalt-steel"] = "cobalt-steel-bearing-pale-blue",
	["nitinol"] = "nitinol-bearing-purple",
	["titanium"] = "titanium-bearing-pink",
}

---Provides the icons of the bearings folder, `bearings/{material}-bearing[-{color}].png`.
---
---#### Examples
---```lua
---local Bearings = require("__reskins-assets-api__.assets.bobs.items.bearings")
---```
---@class Bearings
local M = {}

---Gets the icon for the bearing of the given `material` as an `IconComposition`.
---
---#### Examples
---```lua
----- Get the icon for the titanium bearing.
---local composition = Bearings.get_icon_composition({ material = "titanium" })
----- The icon is bearings/titanium-bearing.png.
---```
M.get_icon_composition = IconBuilderFactory.dispatch_composition(
	"material",
	MATERIALS,
	"get_icon_composition",
	function(material)
		return IconBuilderFactory:create({ folder = FOLDER }):flat(material .. "-bearing")
	end
)

---Gets the icon for the bearing of the given `material`, in the colors of the materials of Angel's mods, as an
---`IconComposition`.
---
---#### Examples
---```lua
----- Get the icon for the titanium bearing in the colors of Angel's mods.
---local composition = Bearings.get_angels_icon_composition({ material = "titanium" })
----- The icon is bearings/titanium-bearing-pink.png.
---```
M.get_angels_icon_composition = IconBuilderFactory.dispatch_composition(
	"material",
	{ "brass", "ceramic", "cobalt-steel", "nitinol", "titanium" },
	"get_angels_icon_composition",
	function(material)
		return IconBuilderFactory:create({ folder = FOLDER }):flat(ANGELS_FILES[material])
	end
)

return M
