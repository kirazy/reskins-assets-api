---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")

---Applies a `radar_sprite_set`-shaped `set` to `prototype`.
---@param prototype RadarPrototype
---@param set RadarSpriteSet
local function apply_sprite_set_to_radar(prototype, set)
	prototype.pictures = util.copy(set.pictures)
end

---@param explosion ExplosionPrototype
---@param set RadarSpriteSet
local function apply_sprite_set_to_explosion(explosion, set)
	error("Not implemented")
end

---@type RadarSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.radar_sprite_set,
	apply_to = apply_sprite_set_to_radar,
	apply_to_explosion = apply_sprite_set_to_explosion,
}

---The sprite data of a `SpriteSetDefinition` of type `radar_sprite_set`.
---@class (exact) RadarSpriteSet : EntityWithHealthSpriteSet
---The prototype's `pictures`.
---@field pictures RotatedSprite

---The applicator for radars.
---@class (exact) RadarSpriteSetApplicator : SpriteSetApplicator<RadarPrototype, RadarSpriteSet>
