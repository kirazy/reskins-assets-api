---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")

---Applies a `set` of type `radar_sprite_set` to `prototype`.
---@param prototype RadarPrototype
---@param set RadarSpriteSet
local function apply_sprite_set_to_radar(prototype, set)
	prototype.pictures = util.copy(set.pictures)
end

---@param explosion ExplosionPrototype
---@param set RadarSpriteSet
local function apply_sprite_set_to_explosion(explosion, set)
	error("The applicator does not support explosions.")
end

---@type RadarSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.radar_sprite_set,
	apply_to = apply_sprite_set_to_radar,
	apply_to_explosion = apply_sprite_set_to_explosion,
}

---Defines the sprite data of a `SpriteSetDefinition` of type `radar_sprite_set`.
---@class (exact) RadarSpriteSet : EntityWithHealthSpriteSet
---The prototype's `pictures`.
---@field pictures RotatedSprite

---Applies the `RadarSpriteSet` to `RadarPrototype` instances.
---@class (exact) RadarSpriteSetApplicator : SpriteSetApplicator<RadarPrototype, RadarSpriteSet>
