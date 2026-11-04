---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")

---Applies the fields of a `set` of type `turret_sprite_set` that belong to `FluidTurretPrototype` to `prototype`.
---@param prototype FluidTurretPrototype
---@param set TurretSpriteSet
local function apply_sprite_set_to_fluid_turret(prototype, set)
	prototype.muzzle_animation = util.copy(set.muzzle_animation)
	prototype.muzzle_light = util.copy(set.muzzle_light)
	prototype.enough_fuel_indicator_picture = util.copy(set.enough_fuel_indicator_picture)
	prototype.enough_fuel_indicator_light = util.copy(set.enough_fuel_indicator_light)
	prototype.not_enough_fuel_indicator_picture = util.copy(set.not_enough_fuel_indicator_picture)
	prototype.not_enough_fuel_indicator_light = util.copy(set.not_enough_fuel_indicator_light)
	prototype.out_of_ammo_alert_icon = util.copy(set.out_of_ammo_alert_icon)

	prototype.folded_muzzle_animation_shift = util.copy(set.folded_muzzle_animation_shift)
	prototype.preparing_muzzle_animation_shift = util.copy(set.preparing_muzzle_animation_shift)
	prototype.prepared_muzzle_animation_shift = util.copy(set.prepared_muzzle_animation_shift)
	prototype.starting_attack_muzzle_animation_shift = util.copy(set.starting_attack_muzzle_animation_shift)
	prototype.attacking_muzzle_animation_shift = util.copy(set.attacking_muzzle_animation_shift)
	prototype.ending_attack_muzzle_animation_shift = util.copy(set.ending_attack_muzzle_animation_shift)
	prototype.folding_muzzle_animation_shift = util.copy(set.folding_muzzle_animation_shift)
end

-- Each of these fields of a `TurretSpriteSet` is applied to the field of the same name of the `attack_parameters` of
-- the prototype.
local attack_parameter_fields = {
	"source_offset",
	"source_direction_count",
	"projectile_center",
	"projectile_creation_distance",
}

---Applies the fields of a `set` of type `turret_sprite_set` that belong to the `attack_parameters` of `prototype`.
---@param prototype TurretPrototype
---@param set TurretSpriteSet
local function apply_attack_parameters(prototype, set)
	local is_defined = set.shell_particle ~= nil
	for _, field in pairs(attack_parameter_fields) do
		is_defined = is_defined or set[field] ~= nil
	end

	if not is_defined then
		return
	end

	local attack_parameters = prototype.attack_parameters
	assert(attack_parameters, "The prototype has no attack_parameters to which the sprite set can be applied.")

	for _, field in pairs(attack_parameter_fields) do
		if set[field] ~= nil then
			attack_parameters[field] = util.copy(set[field])
		end
	end

	if set.shell_particle then
		assert(
			attack_parameters.shell_particle,
			"The prototype has no shell_particle to which the sprite set can be applied."
		)
		attack_parameters.shell_particle = util.merge({ attack_parameters.shell_particle, set.shell_particle })
	end
end

---Applies a `set` of type `turret_sprite_set` to `prototype`.
---@param prototype TurretPrototype
---@param set TurretSpriteSet
local function apply_sprite_set_to_turret(prototype, set)
	prototype.folded_animation = util.copy(set.folded_animation)
	prototype.preparing_animation = util.copy(set.preparing_animation)
	prototype.prepared_animation = util.copy(set.prepared_animation)
	prototype.prepared_alternative_animation = util.copy(set.prepared_alternative_animation)
	prototype.starting_attack_animation = util.copy(set.starting_attack_animation)
	prototype.attacking_animation = util.copy(set.attacking_animation)
	prototype.ending_attack_animation = util.copy(set.ending_attack_animation)
	prototype.folding_animation = util.copy(set.folding_animation)

	prototype.energy_glow_animation = util.copy(set.energy_glow_animation)
	prototype.energy_glow_animation_flicker_strength = set.energy_glow_animation_flicker_strength
	prototype.glow_light_intensity = set.glow_light_intensity
	prototype.resource_indicator_animation = util.copy(set.resource_indicator_animation)

	prototype.gun_animation_render_layer = set.gun_animation_render_layer
	prototype.gun_animation_secondary_draw_order = set.gun_animation_secondary_draw_order

	prototype.graphics_set = util.copy(set.graphics_set)
	prototype.integration = util.copy(set.integration)
	prototype.special_effect = util.copy(set.special_effect)

	if set.circuit_connector then
		prototype.circuit_connector = util.copy(set.circuit_connector)
	end

	apply_attack_parameters(prototype, set)

	if prototype.type == "fluid-turret" then
		---@cast prototype FluidTurretPrototype
		apply_sprite_set_to_fluid_turret(prototype, set)
	end
end

---@type TurretSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.turret_sprite_set,
	apply_to = apply_sprite_set_to_turret,
}

---Applies the `TurretSpriteSet` to `AmmoTurretPrototype`, `ElectricTurretPrototype`, and `FluidTurretPrototype`
---instances.
---@class (exact) TurretSpriteSetApplicator : SpriteSetApplicator<TurretPrototype, TurretSpriteSet>
