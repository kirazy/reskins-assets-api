---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")

---Applies a `set` of type `burner_generator_sprite_set` to `prototype`.
---@param prototype BurnerGeneratorPrototype
---@param set BurnerGeneratorSpriteSet
local function apply_sprite_set_to_burner_generator(prototype, set)
	prototype.animation = util.copy(set.animation)
	prototype.idle_animation = util.copy(set.idle_animation)
end

---@type BurnerGeneratorSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.burner_generator_sprite_set,
	apply_to = apply_sprite_set_to_burner_generator,
}

---Defines the sprite data of a `SpriteSetDefinition` of type `burner_generator_sprite_set`.
---@class (exact) BurnerGeneratorSpriteSet : EntityWithHealthSpriteSet
---Plays when the generator is active. `idle_animation` must have the same frame count as animation.
---
---See [BurnerGeneratorPrototype::animation](https://lua-api.factorio.com/latest/prototypes/BurnerGeneratorPrototype.html#animation).
---@field animation Animation4Way
---Plays when the generator is inactive. Idle animation must have the same frame count as `animation`.
---
---When `nil`, the idle animation of the prototype is removed.
---
---See [BurnerGeneratorPrototype::idle_animation](https://lua-api.factorio.com/latest/prototypes/BurnerGeneratorPrototype.html#idle_animation).
---@field idle_animation? Animation4Way

---Applies the `BurnerGeneratorSpriteSet` to `BurnerGeneratorPrototype` instances.
---@class (exact) BurnerGeneratorSpriteSetApplicator : SpriteSetApplicator<BurnerGeneratorPrototype, BurnerGeneratorSpriteSet>
