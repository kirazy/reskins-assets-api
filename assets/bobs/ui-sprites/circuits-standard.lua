---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Bobs.UiSprites

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")

local FOLDER = _defines.assets_source.bobs_assets .. "/graphics/ui-sprites/circuits-standard/"

---A board that has a GUI sprite.
---@alias GuiSpriteBoard "basic-circuit-board"|"basic-electronic-circuit-board"|"electronic-circuit-board"|"electronic-logic-board"|"electronic-processing-board"

---@type GuiSpriteBoard[]
local BOARDS = {
	"basic-circuit-board",
	"basic-electronic-circuit-board",
	"electronic-circuit-board",
	"electronic-logic-board",
	"electronic-processing-board",
}

---Provides methods for getting the GUI sprites of the circuits-standard folder, `circuits-standard/{board}.png`.
---
---#### Examples
---```lua
---local CircuitsStandard = require("__reskins-assets-api__.assets.bobs.ui-sprites.circuits-standard")
---```
---@class CircuitsStandard
local M = {}

---Defines the options for a GUI sprite of the circuits-standard folder.
---@class CircuitsStandardSpriteParams
---The board drawn by the sprite.
---@field board GuiSpriteBoard

local check_get_sprite = V.signature("get_sprite", {
	{
		"params",
		V.struct({ board = V.one_of(BOARDS) }):strict():describe_as("a CircuitsStandardSpriteParams"),
	},
})

---Gets the GUI sprite for the given `params.board`, in the default color of its tier.
---@param params CircuitsStandardSpriteParams The options for the sprite.
---@return data.Sprite # The sprite.
---@throws When `params.board` is not a `GuiSpriteBoard`.
---@nodiscard
function M.get_sprite(params)
	check_get_sprite(params)

	---@type data.Sprite
	local sprite = {
		filename = FOLDER .. params.board .. ".png",
		flags = { "gui-icon" },
		size = 40,
		mipmap_count = 2,
	}

	return sprite
end

return M
