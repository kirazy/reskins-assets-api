---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")

---Applies an `accumulator_sprite_set`-shaped `set` to `prototype`.
---@param prototype AccumulatorPrototype
---@param set AccumulatorSpriteSet
local function apply_sprite_set_to_accumulator(prototype, set)
	prototype.chargable_graphics = util.copy(set.chargable_graphics)
end

---@param explosion ExplosionPrototype
---@param set AccumulatorSpriteSet
local function apply_sprite_set_to_explosion(explosion, set)
	error("Not implemented")
end

---@type AccumulatorSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.accumulator_sprite_set,
	apply_to = apply_sprite_set_to_accumulator,
	apply_to_explosion = apply_sprite_set_to_explosion,
}

---The sprite data an `accumulator_sprite_set`-tagged `SpriteSetDefinition` carries.
---@class (exact) AccumulatorSpriteSet : EntityWithHealthSpriteSet
---The prototype's `chargable_graphics`.
---@field chargable_graphics ChargableGraphics

---The applicator for accumulators.
---@class (exact) AccumulatorSpriteSetApplicator : SpriteSetApplicator<AccumulatorPrototype, AccumulatorSpriteSet>
