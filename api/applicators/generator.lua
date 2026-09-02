---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")

---Applies a `generator_sprite_set`-shaped `set` to `prototype`.
---@param prototype GeneratorPrototype
---@param set GeneratorSpriteSet
local function apply_sprite_set_to_generator(prototype, set)
	prototype.horizontal_animation = util.copy(set.horizontal_animation)
	prototype.vertical_animation = util.copy(set.vertical_animation)
end

---@param explosion ExplosionPrototype
---@param set GeneratorSpriteSet
local function apply_sprite_set_to_explosion(explosion, set)
	error("Not implemented")
end

---@type GeneratorSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.generator_sprite_set,
	apply_to = apply_sprite_set_to_generator,
	apply_to_explosion = apply_sprite_set_to_explosion,
}

---The sprite data of a `SpriteSetDefinition` of type `generator_sprite_set`.
---
---Note: this shape is Factorio 2.0 specific and changes significantly with Factorio 2.1.
---@class (exact) GeneratorSpriteSet : EntityWithHealthSpriteSet
---The prototype's `horizontal_animation`.
---@field horizontal_animation Animation
---The prototype's `vertical_animation`.
---@field vertical_animation Animation

---The applicator for generators.
---@class (exact) GeneratorSpriteSetApplicator : SpriteSetApplicator<GeneratorPrototype, GeneratorSpriteSet>
