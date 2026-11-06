---@using data

---@namespace Reskins.Assets

local Assignment = require("api.assignment")

---Provides methods for creating the dying explosion of an entity, with its particles, from the `dying_explosion` of a
---sprite set.
---
---#### Examples
---```lua
---local Explosions = require("__reskins-assets-api__.api.explosions")
---```
---@class Explosions
local _explosions = {}

-- Each of these fields in an `ExplosionSpriteSet` is applied to the field of the same name on the explosion prototype.
local explosion_fields = {
	"animations",
	"beam",
	"correct_rotation",
	"delay",
	"delay_deviation",
	"explosion_effect",
	"fade_in_duration",
	"fade_out_duration",
	"height",
	"light",
	"light_intensity_factor_final",
	"light_intensity_factor_initial",
	"light_intensity_peak_end_progress",
	"light_intensity_peak_start_progress",
	"light_size_factor_final",
	"light_size_factor_initial",
	"light_size_peak_end_progress",
	"light_size_peak_start_progress",
	"render_layer",
	"rotate",
	"scale",
	"scale_animation_speed",
	"scale_deviation",
	"scale_end",
	"scale_in_duration",
	"scale_increment_per_tick",
	"scale_initial",
	"scale_initial_deviation",
	"scale_out_duration",
	"smoke",
	"smoke_count",
	"smoke_slow_down_factor",
	"sound",
	"created_effect",
	"flags",
	"hidden",
	"subgroup",
	"order",
}

-- Each of these fields in a `ParticleSpriteSet` is applied to the field of the same name on the particle prototype.
local particle_fields = {
	"draw_shadow_when_on_ground",
	"ended_in_water_trigger_effect",
	"ended_on_ground_trigger_effect",
	"fade_away_duration",
	"life_time",
	"mining_particle_frame_speed",
	"movement_modifier",
	"movement_modifier_when_on_ground",
	"pictures",
	"regular_trigger_effect",
	"regular_trigger_effect_frequency",
	"render_layer",
	"render_layer_when_on_ground",
	"shadows",
	"vertical_acceleration",
}

---Gets the localised name of the given `prototype`.
---@param prototype EntityWithHealthPrototype
---@return LocalisedString
local function get_entity_localised_name(prototype)
	return prototype.localised_name and util.copy(prototype.localised_name) or { "entity-name." .. prototype.name }
end

---Sets the icon of the given `prototype` on the given `target`, in place, and does not modify `target` when `prototype`
---has no icon.
---@param target table
---@param prototype EntityWithHealthPrototype
local function copy_icon(target, prototype)
	if prototype.icons then
		target.icons = util.copy(prototype.icons)
		target.icon = nil
		target.icon_size = nil
	elseif prototype.icon then
		target.icons = nil
		target.icon = prototype.icon
		target.icon_size = prototype.icon_size
	end
end

---Renames each particle and explosion that the trigger effects in the given `value` create, in place, and records each
---replaced name that is found.
---@param value any A trigger, or a part of a trigger.
---@param particle_names table<ParticleID, ParticleID> The name of each created particle, by the name it replaces.
---@param explosion_names table<EntityID, EntityID> The name of each created explosion, by the name it replaces.
---@param found table<string, true> The replaced names that are found, which is modified in place.
local function rename_created_prototypes(value, particle_names, explosion_names, found)
	if type(value) ~= "table" then
		return
	end

	if value.type == "create-particle" and particle_names[value.particle_name] then
		found[value.particle_name] = true
		value.particle_name = particle_names[value.particle_name]
	elseif value.type == "create-explosion" and explosion_names[value.entity_name] then
		found[value.entity_name] = true
		value.entity_name = explosion_names[value.entity_name]
	end

	for _, child in pairs(value) do
		rename_created_prototypes(child, particle_names, explosion_names, found)
	end
end

---Creates the explosion with the given `name` from the given `definition`, for the given `prototype`, with the
---particles in `definition.particles` and the explosions in `definition.explosions`.
---@param prototype EntityWithHealthPrototype The entity for which the explosion is created.
---@param name EntityID The name of the explosion.
---@param definition ExplosionSpriteSet The definition of the explosion.
local function create_explosion(prototype, name, definition)
	---@type table<ParticleID, ParticleID>
	local particle_names = {}
	for particle_name, particle_definition in pairs(definition.particles or {}) do
		local particle = { type = "optimized-particle", name = "ar-" .. prototype.name .. "-" .. particle_name }
		Assignment.safe_assign(particle, particle_definition, particle_fields)
		data:extend({ particle })

		particle_names[particle_name] = particle.name
	end

	---@type table<EntityID, EntityID>
	local explosion_names = {}
	for explosion_name, explosion_definition in pairs(definition.explosions or {}) do
		local created_name = "ar-" .. prototype.name .. "-" .. explosion_name
		create_explosion(prototype, created_name, explosion_definition)

		explosion_names[explosion_name] = created_name
	end

	local explosion = { type = "explosion", name = name }
	Assignment.safe_assign(explosion, definition, explosion_fields)

	local found = {}
	rename_created_prototypes(explosion.created_effect, particle_names, explosion_names, found)

	for replaced_name in pairs(particle_names) do
		if not found[replaced_name] then
			error(string.format("The explosion '%s' creates no particle named '%s'.", name, replaced_name))
		end
	end

	for replaced_name in pairs(explosion_names) do
		if not found[replaced_name] then
			error(string.format("The explosion '%s' creates no explosion named '%s'.", name, replaced_name))
		end
	end

	explosion.localised_name = { "dying-explosion-name", get_entity_localised_name(prototype) }
	copy_icon(explosion, prototype)

	data:extend({ explosion })
end

---Creates the dying explosion of the given `prototype` from the given `dying_explosion` of a sprite set, and sets it as
---the `dying_explosion` of `prototype`, in place.
---
---An `ExplosionSpriteSet` is created as the explosion `ar-<entity name>-explosion`, which replaces an explosion of that
---name. The explosion uses the fields of `dying_explosion`, the localised name `{"dying-explosion-name", ...}`, and a
---copy of the icon from `prototype`. Each particle in `dying_explosion.particles` is created as
---`ar-<entity name>-<particle name>`, and each explosion in `dying_explosion.explosions` is created as
---`ar-<entity name>-<explosion name>` in the same way, and each effect that creates the replaced particle or explosion
---creates the created one instead. An `EntityID` is set as given.
---@param prototype EntityWithHealthPrototype The entity to which the sprite set is applied.
---@param dying_explosion? ExplosionSpriteSet|EntityID The `dying_explosion` of the sprite set. When `nil`, `prototype` is not modified.
---@throws When an explosion in `dying_explosion` replaces a particle or explosion that its `created_effect` does not create.
function _explosions.apply(prototype, dying_explosion)
	if dying_explosion == nil then
		return
	end

	if type(dying_explosion) == "string" then
		prototype.dying_explosion = dying_explosion
		return
	end

	local name = "ar-" .. prototype.name .. "-explosion"
	create_explosion(prototype, name, dying_explosion)

	prototype.dying_explosion = name
end

return _explosions
