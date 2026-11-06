---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Bobs.UiSprites

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")

local FOLDER = _defines.assets_source.bobs_assets .. "/graphics/ui-sprites/circuits-tintable/"

---@type GuiSpriteBoard[]
local BOARDS = {
	"basic-circuit-board",
	"basic-electronic-circuit-board",
	"electronic-circuit-board",
	"electronic-logic-board",
	"electronic-processing-board",
}

---Provides methods for getting the GUI sprites of the circuits-tintable folder,
---`circuits-tintable/{board}/{board}-{role}.png`.
---
---#### Examples
---```lua
---local CircuitsTintable = require("__reskins-assets-api__.assets.bobs.ui-sprites.circuits-tintable")
---```
---@class CircuitsTintable
local M = {}

---Defines the options for a GUI sprite of the circuits-tintable folder.
---@class CircuitsTintableSpriteParams
---The board drawn by the sprite.
---@field board GuiSpriteBoard
---The color to tint the base of the board.
---@field tint Color

local check_get_sprite = V.signature("get_sprite", {
	{
		"params",
		V.struct({ board = V.one_of(BOARDS), tint = Common.color }):strict():describe_as("a CircuitsTintableSpriteParams"),
	},
})

---Gets a layer of the GUI sprite for the given `board`.
---@param board GuiSpriteBoard
---@param role string
---@return data.Sprite
local function get_layer(board, role)
	---@type data.Sprite
	return {
		filename = FOLDER .. board .. "/" .. board .. "-" .. role .. ".png",
		flags = { "gui-icon" },
		size = 40,
		mipmap_count = 2,
	}
end

---Gets the GUI sprite for the given `params.board`, in the tint given by `params`.
---
---The tint is applied to the base of the board. The highlights and the traces are drawn above the base.
---@param params CircuitsTintableSpriteParams The options for the sprite.
---@return data.Sprite # The sprite.
---@throws When `params.board` is not a `GuiSpriteBoard`.
---@throws When `params.tint` is not a `Color`.
---@nodiscard
function M.get_sprite(params)
	check_get_sprite(params)

	local base = get_layer(params.board, "base")
	base.tint = params.tint

	local highlights = get_layer(params.board, "highlights")
	highlights.blend_mode = "additive"

	---@type data.Sprite
	local sprite = { layers = { base, highlights, get_layer(params.board, "traces") } }

	return sprite
end

return M
