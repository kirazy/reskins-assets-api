---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local IconBuilderFactory = require("api.icon-builder-factory")

---The boards with traces, which are drawn above the highlights.
local BOARDS_WITH_TRACES = {
	"basic-circuit-board",
	"basic-electronic-circuit-board",
	"circuit-board",
	"electronic-circuit-board",
	"electronic-logic-board",
	"electronic-processing-board",
	"multi-layer-circuit-board",
	"sockets-1",
	"sockets-2",
	"superior-circuit-board",
}

---The bare boards, which have no traces.
local BOARDS_WITHOUT_TRACES = {
	"fiberglass-board",
	"phenolic-board",
	"wooden-board",
}

local BOARDS = {}
local has_traces = {}
for _, board in pairs(BOARDS_WITH_TRACES) do
	BOARDS[#BOARDS + 1] = board
	has_traces[board] = true
end
for _, board in pairs(BOARDS_WITHOUT_TRACES) do
	BOARDS[#BOARDS + 1] = board
end

local icons =
	IconBuilderFactory:create({ folder = _defines.assets_source.bobs_assets .. "/graphics/icons/circuits-tintable" })

---Provides methods for getting the icons of the circuits-tintable folder,
---`circuits-tintable/{board}/{board}-{role}.png`.
---
---#### Examples
---```lua
---local CircuitsTintable = require("__reskins-assets-api__.assets.bobs.items.circuits-tintable")
---```
---@class CircuitsTintable
local M = {}

---Gets the icon for the given `board` as an `IconComposition`, in the tint given by `params`.
---
---The traces of a board are drawn above the highlights. The fiberglass, phenolic, and wooden boards have no traces.
---
---#### Examples
---```lua
----- Get the icon for the electronic logic board in purple.
---local composition = CircuitsTintable.get_icon_composition({
---    board = "electronic-logic-board",
---    tint = util.color("#b459ff"),
---})
----- The layers are electronic-logic-board-mask.png in the tint, electronic-logic-board-highlights.png, and
----- electronic-logic-board-traces.png, in circuits-tintable/electronic-logic-board.
---```
M.get_icon_composition = IconBuilderFactory.dispatch_composition(
	"board",
	BOARDS,
	"get_icon_composition",
	function(board)
		local builder = icons:layers(board):mask():highlights()

		return has_traces[board] and builder:layer("traces") or builder
	end
)

return M
