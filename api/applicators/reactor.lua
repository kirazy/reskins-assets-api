---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")

---Applies a `set` of type `reactor_sprite_set` to `prototype`.
---@param prototype ReactorPrototype
---@param set ReactorSpriteSet
local function apply_sprite_set_to_reactor(prototype, set)
	local graphics_set = util.copy(set.graphics_set)

	prototype.connection_patches_connected = graphics_set.connection_patches_connected
	prototype.connection_patches_disconnected = graphics_set.connection_patches_disconnected
	prototype.heat_connection_patches_connected = graphics_set.heat_connection_patches_connected
	prototype.heat_connection_patches_disconnected = graphics_set.heat_connection_patches_disconnected
	prototype.heat_lower_layer_picture = graphics_set.heat_lower_layer_picture
	prototype.lower_layer_picture = graphics_set.lower_layer_picture
	prototype.picture = graphics_set.picture

	if set.use_fuel_glow_color then
		prototype.working_light_picture = graphics_set.fuel_glow_working_light_picture
		prototype.use_fuel_glow_color = true
	else
		prototype.working_light_picture = graphics_set.working_light_picture
		prototype.use_fuel_glow_color = nil
	end
end

---@param explosion ExplosionPrototype
---@param set ReactorSpriteSet
local function apply_sprite_set_to_explosion(explosion, set)
	error("The applicator does not support explosions.")
end

---@type ReactorSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.reactor_sprite_set,
	apply_to = apply_sprite_set_to_reactor,
	apply_to_explosion = apply_sprite_set_to_explosion,
}

---Defines the graphics set fields of a reactor.
---@class (exact) ReactorGraphicsSet
---@field connection_patches_connected SpriteVariations
---@field connection_patches_disconnected SpriteVariations
---@field heat_connection_patches_connected SpriteVariations
---@field heat_connection_patches_disconnected SpriteVariations
---@field heat_lower_layer_picture Sprite
---@field lower_layer_picture Sprite
---@field picture Sprite
---@field fuel_glow_working_light_picture Animation
---@field working_light_picture Animation

---Defines the sprite data of a `SpriteSetDefinition` of type `reactor_sprite_set`.
---@class (exact) ReactorSpriteSet : EntityWithHealthSpriteSet
---The sprites making up the reactor, spread across the prototype's own fields.
---@field graphics_set ReactorGraphicsSet
---When `true`, indicates that the working light glows in the color of the fuel, and the applicator uses the
---`fuel_glow_working_light_picture` from `graphics_set`.
---@field use_fuel_glow_color boolean

---Applies the `ReactorSpriteSet` to `ReactorPrototype` instances.
---@class (exact) ReactorSpriteSetApplicator : SpriteSetApplicator<ReactorPrototype, ReactorSpriteSet>
