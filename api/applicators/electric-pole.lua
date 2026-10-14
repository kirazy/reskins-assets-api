---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")

---Applies a `set` of type `electric_pole_sprite_set` to `prototype`.
---@param prototype ElectricPolePrototype
---@param set ElectricPoleSpriteSet
local function apply_sprite_set_to_electric_pole(prototype, set)
	prototype.pictures = util.copy(set.pictures)
end

---@param explosion ExplosionPrototype
---@param set ElectricPoleSpriteSet
local function apply_sprite_set_to_explosion(explosion, set)
	error("The applicator does not support explosions.")
end

---@type ElectricPoleSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.electric_pole_sprite_set,
	apply_to = apply_sprite_set_to_electric_pole,
	apply_to_explosion = apply_sprite_set_to_explosion,
}

---Defines the sprite data of a `SpriteSetDefinition` of type `electric_pole_sprite_set`.
---@class (exact) ElectricPoleSpriteSet : EntityWithHealthSpriteSet
---The prototype's `pictures`.
---@field pictures RotatedSprite

---Applies the `ElectricPoleSpriteSet` to `ElectricPolePrototype` instances.
---@class (exact) ElectricPoleSpriteSetApplicator : SpriteSetApplicator<ElectricPolePrototype, ElectricPoleSpriteSet>
