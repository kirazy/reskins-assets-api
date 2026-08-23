---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Defines

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")

---Applies a `beacon_sprite_set`-shaped `set` to `prototype`.
---
---Merges `animation_list` into `prototype.graphics_set` rather than replacing it, since
---a beacon's `graphics_set` carries other fields (`module_tint_mode`, `module_visualisations`,
---...) this shape doesn't produce.
---@param prototype BeaconPrototype
---@param set BeaconSpriteSet
local function apply_sprite_set_to_beacon(prototype, set)
	prototype.graphics_set = prototype.graphics_set or {}
	local graphics_set = util.copy(prototype.graphics_set)
	graphics_set.animation_list = util.copy(set.animation_list)
	prototype.graphics_set = graphics_set
end

---@param explosion ExplosionPrototype
---@param set BeaconSpriteSet
local function apply_sprite_set_to_explosion(explosion, set)
	error("Not implemented")
end

---@type BeaconSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.beacon_sprite_set,
	apply_to = apply_sprite_set_to_beacon,
	apply_to_explosion = apply_sprite_set_to_explosion,
}

---The sprite data a `beacon_sprite_set`-tagged `SpriteSetDefinition` carries.
---@class (exact) BeaconSpriteSet : EntityWithHealthSpriteSet
---The `animation_list` of the prototype's `graphics_set`.
---@field animation_list AnimationElement[]

---The applicator for beacons.
---@class (exact) BeaconSpriteSetApplicator : SpriteSetApplicator<BeaconPrototype, BeaconSpriteSet>
