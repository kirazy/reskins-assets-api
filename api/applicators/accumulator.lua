---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")
local Assignment = require("api.assignment")

---Applies a `set` of type `accumulator_sprite_set` to `prototype`.
---@param prototype AccumulatorPrototype
---@param set AccumulatorSpriteSet
local function apply_sprite_set_to_accumulator(prototype, set)
	prototype.chargable_graphics = util.copy(set.chargable_graphics)

	Assignment.safe_assign(prototype, set, { "circuit_connector" })
end

---@type AccumulatorSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.accumulator_sprite_set,
	apply_to = apply_sprite_set_to_accumulator,
}

---Defines the sprite data in a `SpriteSetDefinition` of type `accumulator_sprite_set`.
---@class (exact) AccumulatorSpriteSet : EntityWithHealthSpriteSet
---The prototype's `chargable_graphics`.
---@field chargable_graphics ChargableGraphics
---When `nil`, the circuit connector of the prototype is not modified.
---@field circuit_connector? CircuitConnectorDefinition

---Applies the `AccumulatorSpriteSet` to `AccumulatorPrototype` instances.
---@class (exact) AccumulatorSpriteSetApplicator : SpriteSetApplicator<AccumulatorPrototype, AccumulatorSpriteSet>
