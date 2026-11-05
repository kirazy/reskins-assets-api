---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local IconBuilderFactory = require("api.icon-builder-factory")

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

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.bobs_assets .. "/graphics/icons" })

---Provides methods for getting the icons of the circuits-tintable collection,
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
M.get_icon_composition = icons
	:collection("circuits-tintable", "board", V.one_of(BOARDS))
	:mask()
	:highlights()
	:layer("traces")
	:build_composition("get_icon_composition")

return M
