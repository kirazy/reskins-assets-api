---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")

---Applies a `set` of type `generator_sprite_set` to `prototype`.
---@param prototype GeneratorPrototype
---@param set GeneratorSpriteSet
local function apply_sprite_set_to_generator(prototype, set)
	prototype.two_direction_only = set.two_direction_only
	prototype.pictures = util.copy(set.pictures)
end

---@type GeneratorSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.generator_sprite_set,
	apply_to = apply_sprite_set_to_generator,
}

---Defines the sprite data of a `SpriteSetDefinition` of type `generator_sprite_set`.
---@class (exact) GeneratorSpriteSet : EntityWithHealthSpriteSet
---When `true`, the sprite set uses only the `north` and `east` directions of the `pictures` field.
---@field two_direction_only boolean
---The prototype's `pictures`.
---@field pictures GeneratorPictureSet

---Applies the `GeneratorSpriteSet` to `GeneratorPrototype` instances.
---@class (exact) GeneratorSpriteSetApplicator : SpriteSetApplicator<GeneratorPrototype, GeneratorSpriteSet>
