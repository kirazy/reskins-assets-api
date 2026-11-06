---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")

---Applies a `set` of type `unit_sprite_set` to `prototype`.
---@param prototype UnitPrototype
---@param set UnitSpriteSet
local function apply_sprite_set_to_unit(prototype, set)
	prototype.run_animation = util.copy(set.run_animation)

	assert(
		prototype.attack_parameters,
		"The prototype has no attack_parameters to which the attack animation can be applied."
	)
	prototype.attack_parameters.animation = util.copy(set.attack_animation)
end

---@type UnitSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.unit_sprite_set,
	apply_to = apply_sprite_set_to_unit,
}

---Defines the sprite data in a `SpriteSetDefinition` of type `unit_sprite_set`.
---@class (exact) UnitSpriteSet : EntityWithHealthSpriteSet
---@field run_animation RotatedAnimation
---The animation of the unit when it attacks. The animation is set on the `attack_parameters` of the prototype.
---
---See [BaseAttackParameters::animation](https://lua-api.factorio.com/latest/types/BaseAttackParameters.html#animation).
---@field attack_animation RotatedAnimation

---Applies the `UnitSpriteSet` to `UnitPrototype` instances.
---@class (exact) UnitSpriteSetApplicator : SpriteSetApplicator<UnitPrototype, UnitSpriteSet>
