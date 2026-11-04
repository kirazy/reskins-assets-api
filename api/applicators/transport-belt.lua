---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")
local Assignment = require("api.assignment")

---Applies a `set` of type `transport_belt_sprite_set` to `prototype`.
---@param prototype TransportBeltPrototype
---@param set TransportBeltSpriteSet
local function apply_sprite_set_to_transport_belt(prototype, set)
	prototype.belt_animation_set = util.copy(set.belt_animation_set)

	Assignment.safe_assign(prototype, set, { "circuit_connector", "connector_frame_sprites" })
end

---@type TransportBeltSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.transport_belt_sprite_set,
	apply_to = apply_sprite_set_to_transport_belt,
}

---Defines the sprite data of a `SpriteSetDefinition` of type `transport_belt_sprite_set`.
---@class (exact) TransportBeltSpriteSet : TransportBeltConnectableSpriteSet
---@field belt_animation_set TransportBeltAnimationSetWithCorners
---Set of 7 circuit connector definitions in order: X, H, V, SE, SW, NE and NW.
---
---When `nil`, the circuit connector of the prototype is not modified.
---
---See [TransportBeltPrototype::circuit_connector](https://lua-api.factorio.com/latest/prototypes/TransportBeltPrototype.html#circuit_connector).
---@field circuit_connector? CircuitConnectorDefinition[]
---When `nil`, the connector frame sprites of the prototype are not modified.
---@field connector_frame_sprites? TransportBeltConnectorFrame

---Applies the `TransportBeltSpriteSet` to `TransportBeltPrototype` instances.
---@class (exact) TransportBeltSpriteSetApplicator : SpriteSetApplicator<TransportBeltPrototype, TransportBeltSpriteSet>
