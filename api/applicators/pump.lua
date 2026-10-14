---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")

---Applies a `set` of type `pump_sprite_set` to `prototype`.
---@param prototype PumpPrototype
---@param set PumpSpriteSet
local function apply_sprite_set_to_pump(prototype, set)
	prototype.animations = util.copy(set.animations)
end

---@param explosion ExplosionPrototype
---@param set PumpSpriteSet
local function apply_sprite_set_to_explosion(explosion, set)
	error("The applicator does not support explosions.")
end

---@type PumpSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.pump_sprite_set,
	apply_to = apply_sprite_set_to_pump,
	apply_to_explosion = apply_sprite_set_to_explosion,
}

---Defines the sprite data of a `SpriteSetDefinition` of type `pump_sprite_set`.
---@class (exact) PumpSpriteSet : EntityWithHealthSpriteSet
---The prototype's `animations`.
---@field animations Animation4Way

---Applies the `PumpSpriteSet` to `PumpPrototype` instances.
---@class (exact) PumpSpriteSetApplicator : SpriteSetApplicator<PumpPrototype, PumpSpriteSet>
