---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")

---Applies a `set` of type `generator_sprite_set` to `prototype`.
---@param prototype GeneratorPrototype
---@param set GeneratorSpriteSet
local function apply_sprite_set_to_generator(prototype, set)
	prototype.horizontal_animation = util.copy(set.horizontal_animation)
	prototype.vertical_animation = util.copy(set.vertical_animation)
end

---@param explosion ExplosionPrototype
---@param set GeneratorSpriteSet
local function apply_sprite_set_to_explosion(explosion, set)
	error("The applicator does not support explosions.")
end

---@type GeneratorSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.generator_sprite_set,
	apply_to = apply_sprite_set_to_generator,
	apply_to_explosion = apply_sprite_set_to_explosion,
}

---Defines the sprite data of a `SpriteSetDefinition` of type `generator_sprite_set`.
---
---The structure is specific to Factorio 2.0 and changes with Factorio 2.1.
---@class (exact) GeneratorSpriteSet : EntityWithHealthSpriteSet
---The prototype's `horizontal_animation`.
---@field horizontal_animation Animation
---The prototype's `vertical_animation`.
---@field vertical_animation Animation

---Applies the `GeneratorSpriteSet` to `GeneratorPrototype` instances.
---@class (exact) GeneratorSpriteSetApplicator : SpriteSetApplicator<GeneratorPrototype, GeneratorSpriteSet>
