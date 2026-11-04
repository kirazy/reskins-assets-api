---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")

---Applies a `set` of type `transport_belt_sprite_set` to `prototype`.
---@param prototype TransportBeltPrototype
---@param set TransportBeltSpriteSet
local function apply_sprite_set_to_transport_belt(prototype, set)
	prototype.belt_animation_set = util.copy(set.belt_animation_set)
end

---@type TransportBeltSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.transport_belt_sprite_set,
	apply_to = apply_sprite_set_to_transport_belt,
}

---Defines the sprite data of a `SpriteSetDefinition` of type `transport_belt_sprite_set`.
---@class (exact) TransportBeltSpriteSet : TransportBeltConnectableSpriteSet
---@field belt_animation_set TransportBeltAnimationSetWithCorners

---Applies the `TransportBeltSpriteSet` to `TransportBeltPrototype` instances.
---@class (exact) TransportBeltSpriteSetApplicator : SpriteSetApplicator<TransportBeltPrototype, TransportBeltSpriteSet>
