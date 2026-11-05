---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local FOLDER = _defines.assets_source.bobs_assets .. "/graphics/icons/bearing-balls"

local MATERIALS = {
	"brass",
	"ceramic",
	"cobalt-steel",
	"nitinol",
	"steel",
	"titanium",
}

---The files of the bearing balls in the colors of the materials of Angel's mods, by material.
local ANGELS_FILES = {
	["brass"] = "brass-bearing-ball",
	["ceramic"] = "ceramic-bearing-ball-white",
	["cobalt-steel"] = "cobalt-steel-bearing-ball-pale-blue",
	["nitinol"] = "nitinol-bearing-ball-purple",
	["titanium"] = "titanium-bearing-ball-pink",
}

---Provides the icons of the bearing-balls folder, `bearing-balls/{material}-bearing-ball[-{color}].png`.
---
---#### Examples
---```lua
---local BearingBalls = require("__reskins-assets-api__.assets.bobs.items.bearing-balls")
---```
---@class BearingBalls
local M = {}

---Gets the icon for the bearing ball of the given `material` as an `IconComposition`.
---
---#### Examples
---```lua
----- Get the icon for the titanium bearing ball.
---local composition = BearingBalls.get_icon_composition({ material = "titanium" })
----- The icon is bearing-balls/titanium-bearing-ball.png.
---```
M.get_icon_composition = IconBuilderFactory.dispatch_composition(
	"material",
	MATERIALS,
	"get_icon_composition",
	function(material)
		return IconBuilderFactory:create({ folder = FOLDER }):flat(material .. "-bearing-ball")
	end
)

---Gets the icon for the bearing ball of the given `material`, in the colors of the materials of Angel's mods, as an
---`IconComposition`.
---
---#### Examples
---```lua
----- Get the icon for the titanium bearing ball in the colors of Angel's mods.
---local composition = BearingBalls.get_angels_icon_composition({ material = "titanium" })
----- The icon is bearing-balls/titanium-bearing-ball-pink.png.
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
