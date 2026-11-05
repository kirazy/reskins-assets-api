---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local FOLDER = _defines.assets_source.bobs_assets .. "/graphics/icons/circuits-colored"

local COLORS = {
	"black",
	"blue",
	"blue-green",
	"brown",
	"dark-gray",
	"gray",
	"green",
	"light-blue",
	"orange",
	"pale-red",
	"purple",
	"red",
	"sand",
	"yellow",
}

---Gets a function that returns the builder of the icon of the given `board` in a color.
---@param board string
---@return fun(color: string): FlatIconBuilder<{}>
local function get_icon_builder(board)
	return function(color)
		return IconBuilderFactory:create({ folder = FOLDER .. "/" .. color }):flat(board)
	end
end

---Provides methods for getting the icons of the circuits-colored folder, the complete sets of the circuits in each
---color, `circuits-colored/{color}/{board}.png`.
---
---#### Examples
---```lua
---local CircuitsColored = require("__reskins-assets-api__.assets.bobs.items.circuits-colored")
---```
---@class CircuitsColored
local M = {}

---Gets the icon for the basic circuit board in the `color` given by `params` as an `IconComposition`.
M.get_basic_circuit_board_icon_composition = IconBuilderFactory.dispatch_composition(
	"color",
	COLORS,
	"get_basic_circuit_board_icon_composition",
	get_icon_builder("basic-circuit-board")
)

---Gets the icon for the basic electronic circuit board in the `color` given by `params` as an `IconComposition`.
M.get_basic_electronic_circuit_board_icon_composition = IconBuilderFactory.dispatch_composition(
	"color",
	COLORS,
	"get_basic_electronic_circuit_board_icon_composition",
	get_icon_builder("basic-electronic-circuit-board")
)

---Gets the icon for the circuit board in the `color` given by `params` as an `IconComposition`.
M.get_circuit_board_icon_composition = IconBuilderFactory.dispatch_composition(
	"color",
	COLORS,
	"get_circuit_board_icon_composition",
	get_icon_builder("circuit-board")
)

---Gets the icon for the electronic circuit board in the `color` given by `params` as an `IconComposition`.
M.get_electronic_circuit_board_icon_composition = IconBuilderFactory.dispatch_composition(
	"color",
	COLORS,
	"get_electronic_circuit_board_icon_composition",
	get_icon_builder("electronic-circuit-board")
)

---Gets the icon for the electronic logic board in the `color` given by `params` as an `IconComposition`.
M.get_electronic_logic_board_icon_composition = IconBuilderFactory.dispatch_composition(
	"color",
	COLORS,
	"get_electronic_logic_board_icon_composition",
	get_icon_builder("electronic-logic-board")
)

---Gets the icon for the electronic processing board in the `color` given by `params` as an `IconComposition`.
M.get_electronic_processing_board_icon_composition = IconBuilderFactory.dispatch_composition(
	"color",
	COLORS,
	"get_electronic_processing_board_icon_composition",
	get_icon_builder("electronic-processing-board")
)

---Gets the icon for the fiberglass board in the `color` given by `params` as an `IconComposition`.
M.get_fiberglass_board_icon_composition = IconBuilderFactory.dispatch_composition(
	"color",
	COLORS,
	"get_fiberglass_board_icon_composition",
	get_icon_builder("fiberglass-board")
)

---Gets the icon for the multi layer circuit board in the `color` given by `params` as an `IconComposition`.
M.get_multi_layer_circuit_board_icon_composition = IconBuilderFactory.dispatch_composition(
	"color",
	COLORS,
	"get_multi_layer_circuit_board_icon_composition",
	get_icon_builder("multi-layer-circuit-board")
)

---Gets the icon for the phenolic board in the `color` given by `params` as an `IconComposition`.
M.get_phenolic_board_icon_composition = IconBuilderFactory.dispatch_composition(
	"color",
	COLORS,
	"get_phenolic_board_icon_composition",
	get_icon_builder("phenolic-board")
)

---Gets the icon for the sockets 1 in the `color` given by `params` as an `IconComposition`.
M.get_sockets_1_icon_composition = IconBuilderFactory.dispatch_composition(
	"color",
	COLORS,
	"get_sockets_1_icon_composition",
	get_icon_builder("sockets-1")
)

---Gets the icon for the sockets 2 in the `color` given by `params` as an `IconComposition`.
M.get_sockets_2_icon_composition = IconBuilderFactory.dispatch_composition(
	"color",
	COLORS,
	"get_sockets_2_icon_composition",
	get_icon_builder("sockets-2")
)

---Gets the icon for the superior circuit board in the `color` given by `params` as an `IconComposition`.
M.get_superior_circuit_board_icon_composition = IconBuilderFactory.dispatch_composition(
	"color",
	COLORS,
	"get_superior_circuit_board_icon_composition",
	get_icon_builder("superior-circuit-board")
)

---Gets the icon for the wooden board in the `color` given by `params` as an `IconComposition`.
M.get_wooden_board_icon_composition = IconBuilderFactory.dispatch_composition(
	"color",
	COLORS,
	"get_wooden_board_icon_composition",
	get_icon_builder("wooden-board")
)

return M
