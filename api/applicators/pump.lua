---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")
local Assignment = require("api.assignment")

---Applies a `set` of type `pump_sprite_set` to `prototype`.
---@param prototype PumpPrototype
---@param set PumpSpriteSet
local function apply_sprite_set_to_pump(prototype, set)
	prototype.animations = util.copy(set.animations)

	Assignment.safe_assign(prototype, set, {
		"fluid_animation",
		"glass_pictures",
		"frozen_patch",
		"circuit_connector",
		"wagon_connection_graphics",
	})
end

---@type PumpSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.pump_sprite_set,
	apply_to = apply_sprite_set_to_pump,
}

---Defines the sprite data in a `SpriteSetDefinition` of type `pump_sprite_set`.
---@class (exact) PumpSpriteSet : EntityWithHealthSpriteSet
---The prototype's `animations`.
---@field animations Animation4Way
---When `nil`, the fluid animation of the prototype is not modified.
---@field fluid_animation? Animation4Way
---When `nil`, the glass pictures of the prototype are not modified.
---@field glass_pictures? Sprite4Way
---When `nil`, the frozen patch of the prototype is not modified.
---@field frozen_patch? Sprite4Way
---When `nil`, the circuit connector of the prototype is not modified.
---@field circuit_connector? [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
---When `nil`, the wagon connection graphics of the prototype are not modified.
---@field wagon_connection_graphics? PumpWagonConnectionGraphics

---Applies the `PumpSpriteSet` to `PumpPrototype` instances.
---@class (exact) PumpSpriteSetApplicator : SpriteSetApplicator<PumpPrototype, PumpSpriteSet>
