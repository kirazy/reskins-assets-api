---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Assorted.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local MATERIALS = {
	_defines.pipe_material.aluminum,
	_defines.pipe_material.nitinol,
	_defines.pipe_material.plastic,
}

local icons = IconBuilderFactory:create({
	folder = _defines.assets_source.assorted_assets .. "/graphics/icons/pipe-to-ground-flipped",
})

---Provides methods for getting the icons of the pipe-to-ground-flipped folder,
---`pipe-to-ground-flipped/{material}-pipe-to-ground-flipped.png`.
---
---#### Examples
---```lua
---local PipeToGroundFlipped = require("__reskins-assets-api__.assets.assorted.items.pipe-to-ground-flipped")
---```
---@class PipeToGroundFlipped
local M = {}

---Gets the icon for a flipped pipe to ground built from the `material` given by `params`, as an `IconComposition`.
M.get_icon_composition = IconBuilderFactory.dispatch_composition(
	"material",
	MATERIALS,
	"get_icon_composition",
	function(material)
		return icons:flat(material .. "-pipe-to-ground-flipped")
	end
)

return M
