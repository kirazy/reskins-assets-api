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
	folder = _defines.assets_source.assorted_assets .. "/graphics/icons/underground-junction",
})

---Provides methods for getting the icons of the underground-junction folder,
---`underground-junction/{material}-underground-junction.png`.
---
---#### Examples
---```lua
---local UndergroundJunction = require("__reskins-assets-api__.assets.assorted.items.underground-junction")
---```
---@class UndergroundJunction
local M = {}

---Gets the icon for an underground junction built from the `material` given by `params`, as an `IconComposition`.
M.get_icon_composition = IconBuilderFactory.dispatch_composition(
	"material",
	MATERIALS,
	"get_icon_composition",
	function(material)
		return icons:flat(material .. "-underground-junction")
	end
)

return M
