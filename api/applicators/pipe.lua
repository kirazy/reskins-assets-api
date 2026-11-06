---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")
local Assignment = require("api.assignment")
local meld = require("__core__.lualib.meld")

---Applies a `set` of type `pipe_sprite_set` to `prototype`.
---@param prototype PipePrototype
---@param set PipeSpriteSet
local function apply_sprite_set_to_pipe(prototype, set)
	local set_copy = util.copy(set)
	prototype.horizontal_window_bounding_box = set_copy.horizontal_window_bounding_box
	prototype.vertical_window_bounding_box = set_copy.vertical_window_bounding_box
	prototype.pictures = set_copy.pictures

	Assignment.safe_assign(prototype, set, { "circuit_connector" })
end

---@type PipeSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.pipe_sprite_set,
	apply_to = apply_sprite_set_to_pipe,
}

---Defines the sprite data in a `SpriteSetDefinition` of type `pipe_sprite_set`.
---@class (exact) PipeSpriteSet : EntityWithHealthSpriteSet
---The prototype's `horizontal_window_bounding_box`.
---@field horizontal_window_bounding_box BoundingBox
---The prototype's `vertical_window_bounding_box`.
---@field vertical_window_bounding_box BoundingBox
---The prototype's `pictures`.
---@field pictures PipePictures
---The circuit connectors of the pipe, one for each combination of connected neighbors.
---
---When `nil`, the circuit connector of the prototype is not modified.
---
---See [PipePrototype::circuit_connector](https://lua-api.factorio.com/latest/prototypes/PipePrototype.html#circuit_connector).
---@field circuit_connector? CircuitConnectorDefinition[]

---Applies the `PipeSpriteSet` to `PipePrototype` instances.
---@class (exact) PipeSpriteSetApplicator : SpriteSetApplicator<PipePrototype, PipeSpriteSet>
