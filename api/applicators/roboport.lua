---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")

---Applies a `set` of type `roboport_sprite_set` to `prototype`.
---@param prototype RoboportPrototype
---@param set RoboportSpriteSet
local function apply_sprite_set_to_roboport(prototype, set)
	local graphics_set = util.copy(set.graphics_set)

	prototype.base = graphics_set.base
	prototype.base_patch = graphics_set.base_patch
	prototype.base_animation = graphics_set.base_animation
	prototype.frozen_patch = graphics_set.frozen_patch
	prototype.door_animation_up = graphics_set.door_animation_up
	prototype.door_animation_down = graphics_set.door_animation_down
	prototype.recharging_animation = graphics_set.recharging_animation
	prototype.recharging_light = graphics_set.recharging_light

	prototype.spawn_and_station_height = graphics_set.spawn_and_station_height
	prototype.spawn_and_station_shadow_height_offset = graphics_set.spawn_and_station_shadow_height_offset
	prototype.stationing_render_layer_swap_height = graphics_set.stationing_render_layer_swap_height
	prototype.stationing_offset = graphics_set.stationing_offset
	prototype.charging_offsets = graphics_set.charging_offsets

	if set.circuit_connector then
		prototype.circuit_connector = util.copy(set.circuit_connector)
	end
end

---@param explosion ExplosionPrototype
---@param set RoboportSpriteSet
local function apply_sprite_set_to_explosion(explosion, set)
	error("The applicator does not support explosions.")
end

---@type RoboportSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.roboport_sprite_set,
	apply_to = apply_sprite_set_to_roboport,
	apply_to_explosion = apply_sprite_set_to_explosion,
}

---Defines the graphics set fields of a roboport.
---@class (exact) RoboportGraphicsSet
---@field base? Sprite
---@field base_patch? Sprite
---@field frozen_patch? Sprite
---The animation played when the roboport is idle.
---@field base_animation? Animation
---The animation played to open/close the upper half of the door, rendered beneath the robot.
---@field door_animation_up? Animation
---The animation played to open/close the lower half of the door, rendered above the robot.
---@field door_animation_down? Animation
---The animation played at each charging point when a robot is charging there.
---@field recharging_animation? Animation
---Presumably states the height of the charging stations and thus an additive offset for the charging_offsets.
---@field spawn_and_station_height float
---@field spawn_and_station_shadow_height_offset? float
---When robot ascends or descends to this roboport, at which height is should switch between `"air-object"` and
---`"object"` render layer.
---@field stationing_render_layer_swap_height? float
---The light emitted when charging a robot.
---@field recharging_light? LightDefinition
---The offset from the center of the roboport at which robots will enter and exit.
---@field stationing_offset? Vector
---@field charging_offsets? Vector[]

---Defines the sprite data of a `SpriteSetDefinition` of type `roboport_sprite_set`.
---@class (exact) RoboportSpriteSet : EntityWithHealthSpriteSet
---@field circuit_connector? CircuitConnectorDefinition
---The sprites making up the roboport, spread across the prototype's own fields.
---@field graphics_set RoboportGraphicsSet

---Applies the `RoboportSpriteSet` to `RoboportPrototype` instances.
---@class (exact) RoboportSpriteSetApplicator : SpriteSetApplicator<RoboportPrototype, RoboportSpriteSet>
