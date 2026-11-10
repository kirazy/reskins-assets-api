---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")
local Assignment = require("api.assignment")

---Applies a `set` of type `offshore_pump_sprite_set` to `prototype`.
---@param prototype OffshorePumpPrototype
---@param set OffshorePumpSpriteSet
local function apply_sprite_set_to_offshore_pump(prototype, set)
	prototype.graphics_set = util.copy(set.graphics_set)

	Assignment.safe_assign(prototype, set, { "circuit_connector" })
end

---@type OffshorePumpSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.offshore_pump_sprite_set,
	apply_to = apply_sprite_set_to_offshore_pump,
}

---Defines the sprite data in a `SpriteSetDefinition` of type `offshore_pump_sprite_set`.
---@class (exact) OffshorePumpSpriteSet : EntityWithHealthSpriteSet
---The prototype's `graphics_set`.
---@field graphics_set OffshorePumpGraphicsSet
---When `nil`, the circuit connector of the prototype is not modified.
---@field circuit_connector? [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]

---Applies the `OffshorePumpSpriteSet` to `OffshorePumpPrototype` instances.
---@class (exact) OffshorePumpSpriteSetApplicator : SpriteSetApplicator<OffshorePumpPrototype, OffshorePumpSpriteSet>
