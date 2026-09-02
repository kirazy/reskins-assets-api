---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")

---Applies a `reactor_sprite_set`-shaped `set` to `prototype`.
---@param prototype ReactorPrototype
---@param set NuclearReactorSpriteSet
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
---@param set NuclearReactorSpriteSet
local function apply_sprite_set_to_explosion(explosion, set)
	error("Not implemented")
end

---@type NuclearReactorSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.reactor_sprite_set,
	apply_to = apply_sprite_set_to_reactor,
	apply_to_explosion = apply_sprite_set_to_explosion,
}

---@class (exact) NuclearReactorGraphicsSet
---@field connection_patches_connected SpriteVariations
---@field connection_patches_disconnected SpriteVariations
---@field heat_connection_patches_connected SpriteVariations
---@field heat_connection_patches_disconnected SpriteVariations
---@field heat_lower_layer_picture Sprite
---@field lower_layer_picture Sprite
---@field picture Sprite
---@field fuel_glow_working_light_picture Animation
---@field working_light_picture Animation

---The sprite data of a `SpriteSetDefinition` of type `reactor_sprite_set`.
---@class (exact) NuclearReactorSpriteSet : EntityWithHealthSpriteSet
---The sprites making up the reactor, spread across the prototype's own fields.
---@field graphics_set NuclearReactorGraphicsSet
---Sets the prototype's `use_fuel_glow_color`, selecting which working light the
---applicator takes from `graphics_set`.
---@field use_fuel_glow_color boolean

---The applicator for nuclear reactors.
---@class (exact) NuclearReactorSpriteSetApplicator : SpriteSetApplicator<ReactorPrototype, NuclearReactorSpriteSet>
