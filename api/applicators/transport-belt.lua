---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")

---Applies a `transport_belt_sprite_set`-shaped `set` to `prototype`.
---
---`set.belt_animation_set` is not applied by this applicator. Applies `structure` and
---`structure_patch` for a splitter, and `structure` for an underground belt.
---@param prototype TransportBeltConnectablePrototype
---@param set TransportBeltSpriteSet
local function apply_sprite_set_to_transport_belt_connectable(prototype, set)
	if prototype.type == "underground-belt" then
		---@cast prototype UndergroundBeltPrototype
		prototype.structure = util.copy(set.structure)
	elseif prototype.type == "splitter" then
		---@cast prototype SplitterPrototype
		prototype.structure = util.copy(set.structure)
		prototype.structure_patch = util.copy(set.structure_patch)
	end
end

---@param explosion ExplosionPrototype
---@param set TransportBeltSpriteSet
local function apply_sprite_set_to_explosion(explosion, set)
	error("Not implemented")
end

---@type TransportBeltSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.transport_belt_sprite_set,
	apply_to = apply_sprite_set_to_transport_belt_connectable,
	apply_to_explosion = apply_sprite_set_to_explosion,
}

---The sprite data of a `SpriteSetDefinition` of type `transport_belt_sprite_set`.
---@class (exact) TransportBeltSpriteSet : EntityWithHealthSpriteSet
---The prototype's `belt_animation_set`.
---@field belt_animation_set TransportBeltAnimationSet
---The prototype's `structure`, for a splitter or an underground belt.
---@field structure Animation4Way?
---The prototype's `structure_patch`, for a splitter.
---@field structure_patch Animation4Way?

---The applicator for transport-belt-connectable entities.
---@class (exact) TransportBeltSpriteSetApplicator : SpriteSetApplicator<TransportBeltConnectablePrototype, TransportBeltSpriteSet>
