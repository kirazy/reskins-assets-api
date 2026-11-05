---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local FOLDER = _defines.assets_source.bobs_assets .. "/graphics/icons/circuits-standard"

local BOARDS = {
	"basic-circuit-board",
	"basic-electronic-circuit-board",
	"circuit-board",
	"electronic-circuit-board",
	"electronic-logic-board",
	"electronic-processing-board",
	"multi-layer-circuit-board",
	"superior-circuit-board",
}

---Provides methods for getting the icons of the circuits-standard folder, `circuits-standard/{board}.png`.
---
---#### Examples
---```lua
---local CircuitsStandard = require("__reskins-assets-api__.assets.bobs.items.circuits-standard")
---```
---@class CircuitsStandard
local M = {}

---Gets the icon for the given `board` as an `IconComposition`.
---
---#### Examples
---```lua
----- Get the icon for the electronic logic board.
---local composition = CircuitsStandard.get_icon_composition({ board = "electronic-logic-board" })
----- The icon is circuits-standard/electronic-logic-board.png.
---```
M.get_icon_composition = IconBuilderFactory.dispatch_composition(
	"board",
	BOARDS,
	"get_icon_composition",
	function(board)
		return IconBuilderFactory:create({ folder = FOLDER }):flat(board)
	end
)

return M
