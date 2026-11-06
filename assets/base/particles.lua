-- This file is generated from the source of the base game by reskins-workspace/tools/base_explosions/generate.py.

---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Base.Explosions

local particle_animations = require("__base__.prototypes.particle-animations")
local sounds = require("__base__.prototypes.entity.sounds")

local M = {}

---Gets the smoke that a particle leaves in the air.
---@return TriggerEffect
local function default_smoke_trigger_effect()
	return {
		type = "create-trivial-smoke",
		smoke_name = "smoke-explosion-particle",
		starting_frame_deviation = 5,
		offset_deviation = { { -0.06, -0.06 }, { 0.06, 0.06 } },
		speed_from_center = 0.007,
	}
end

---Gets the tiny smoke that a particle leaves in the air.
---@return TriggerEffect
local function tiny_smoke_trigger_effect()
	return {
		type = "create-trivial-smoke",
		smoke_name = "smoke-explosion-particle-tiny",
		starting_frame_deviation = 0,
		offset_deviation = { { -0.03, -0.03 }, { 0.03, 0.03 } },
		speed_from_center = nil,
	}
end

---Gets the small smoke that a particle leaves in the air.
---@return TriggerEffect
local function small_smoke_trigger_effect()
	return {
		type = "create-trivial-smoke",
		smoke_name = "smoke-explosion-particle-small",
		starting_frame_deviation = 0,
		offset_deviation = { { -0.03, -0.03 }, { 0.03, 0.03 } },
		speed_from_center = nil,
	}
end

---Gets the small grey dust that a particle leaves in the air.
---@return TriggerEffect
local function small_grey_dust_smoke_trigger_effect()
	return {
		type = "create-trivial-smoke",
		smoke_name = "small-dust-particle-smoke",
		starting_frame_deviation = 0.5,
		offset_deviation = { { -0.03, -0.03 }, { 0.03, 0.03 } },
		speed_from_center = 0.01,
		speed_from_center_deviation = 0.02,
	}
end

---Gets the splash of a particle that lands in water.
---@return TriggerEffect
local function default_ended_in_water_trigger_effect()
	return {

		{
			type = "create-particle",
			probability = 1,
			affects_target = false,
			show_in_tooltip = false,
			particle_name = "tintable-water-particle",
			apply_tile_tint = "secondary",
			offset_deviation = { { -0.05, -0.05 }, { 0.05, 0.05 } },
			initial_height = 0,
			initial_height_deviation = 0.02,
			initial_vertical_speed = 0.05,
			initial_vertical_speed_deviation = 0.05,
			speed_from_center = 0.01,
			speed_from_center_deviation = 0.006,
			frame_speed = 1,
			frame_speed_deviation = 0,
			tail_length = 2,
			tail_length_deviation = 1,
			tail_width = 3,
		},
		{
			type = "create-particle",
			repeat_count = 10,
			repeat_count_deviation = 6,
			probability = 0.03,
			affects_target = false,
			show_in_tooltip = false,
			particle_name = "tintable-water-particle",
			apply_tile_tint = "primary",
			offsets = {
				{ 0, 0 },
				{ 0.01563, -0.09375 },
				{ 0.0625, 0.09375 },
				{ -0.1094, 0.0625 },
			},
			offset_deviation = { { -0.2969, -0.1992 }, { 0.2969, 0.1992 } },
			initial_height = 0,
			initial_height_deviation = 0.02,
			initial_vertical_speed = 0.053,
			initial_vertical_speed_deviation = 0.005,
			speed_from_center = 0.02,
			speed_from_center_deviation = 0.006,
			frame_speed = 1,
			frame_speed_deviation = 0,
			tail_length = 9,
			tail_length_deviation = 0,
			tail_width = 1,
		},
		{
			type = "play-sound",
			sound = sounds.small_splash,
			probability = 0.05,
		},
	}
end

---Gets the tint for the shadow of a particle.
---@return Color
local function shadowtint()
	return { r = 0, g = 0, b = 0 }
end

---Gets a particle with the defaults of the base game for the fields that the given `params` do not define.
---@param params table The fields of the particle.
---@return ParticleSpriteSet
local function make_particle(params)
	local ended_in_water_trigger_effect = params.ended_in_water_trigger_effect or default_ended_in_water_trigger_effect()
	if params.ended_in_water_trigger_effect == false then
		ended_in_water_trigger_effect = nil
	end

	return {
		life_time = params.life_time or (60 * 15),
		fade_away_duration = params.fade_away_duration,
		render_layer = params.render_layer or "projectile",
		render_layer_when_on_ground = params.render_layer_when_on_ground or "corpse",
		regular_trigger_effect_frequency = params.regular_trigger_effect_frequency or 2,
		regular_trigger_effect = params.regular_trigger_effect,
		ended_in_water_trigger_effect = ended_in_water_trigger_effect,
		pictures = params.pictures,
		shadows = params.shadows,
		draw_shadow_when_on_ground = params.draw_shadow_when_on_ground,
		movement_modifier_when_on_ground = params.movement_modifier_when_on_ground,
		movement_modifier = params.movement_modifier,
		vertical_acceleration = params.vertical_acceleration,
		mining_particle_frame_speed = params.mining_particle_frame_speed,
	}
end

---Each particle of the base game that a dying explosion in `assets.base.explosions` creates, as a function of the tint
---for the particle. When the tint is `nil`, the tint of the base game is used.
---@type table<ParticleID, fun(tint?: Color): ParticleSpriteSet>
local definitions = {
	["accumulator-metal-particle-big"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_big_pictures({ tint = tint or { 0.663, 0.663, 0.663, 1 } }),
			shadows = particle_animations.get_metal_particle_big_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = default_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["accumulator-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.643, 0.698, 0.780, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["accumulator-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.643, 0.698, 0.780, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["active-provider-chest-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.564, 0.564, 0.564, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["active-provider-chest-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.634, 0.537, 0.657, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["artillery-wagon-mechanical-component-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_mechanical_component_particle_medium_pictures({
				tint = tint or { 0.859, 0.766, 0.680, 1 },
			}),
			shadows = particle_animations.get_mechanical_component_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["artillery-wagon-metal-particle-big"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_big_pictures({ tint = tint or { 0.408, 0.408, 0.341, 1 } }),
			shadows = particle_animations.get_metal_particle_big_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = default_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["artillery-wagon-metal-particle-big-yellow"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_big_pictures({ tint = tint or { 0.706, 0.608, 0.024, 1 } }),
			shadows = particle_animations.get_metal_particle_big_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = default_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["artillery-wagon-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.594, 0.594, 0.594, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["artillery-wagon-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.547, 0.547, 0.547, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["assembling-machine-1-metal-particle-big"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_big_pictures({ tint = tint or { 0.349, 0.369, 0.333, 1 } }),
			shadows = particle_animations.get_metal_particle_big_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["assembling-machine-1-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.350, 0.369, 0.332, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["assembling-machine-1-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.859, 0.766, 0.680, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["assembling-machine-mechanical-component-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_mechanical_component_particle_medium_pictures({
				tint = tint or { 0.859, 0.766, 0.680, 1 },
			}),
			shadows = particle_animations.get_mechanical_component_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["beacon-metal-particle-big"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_big_pictures({ tint = tint or { 0.859, 0.808, 0.741, 1 } }),
			shadows = particle_animations.get_metal_particle_big_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = default_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["beacon-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.761, 0.699, 0.612, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["beacon-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.678, 0.447, 0.314, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["big-electric-pole-long-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_long_pictures({
				tint = tint or { 0.353, 0.498, 0.553, 1 },
			}),
			shadows = particle_animations.get_metal_particle_medium_long_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["big-electric-pole-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.353, 0.498, 0.553, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["boiler-metal-particle-big"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_big_pictures({ tint = tint or { 0.577, 0.577, 0.577, 1 } }),
			shadows = particle_animations.get_metal_particle_big_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = default_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["boiler-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.553, 0.581, 0.428, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["boiler-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.787, 0.723, 0.556, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["buffer-chest-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.809, 0.809, 0.809, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["buffer-chest-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.455, 0.649, 0.404, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["bulk-inserter-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.762, 0.937, 0.495, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["bulk-inserter-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.508, 0.508, 0.508, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["cargo-wagon-metal-particle-big"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_big_pictures({ tint = tint or { 0.491, 0.460, 0.419, 1 } }),
			shadows = particle_animations.get_metal_particle_big_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = default_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["cargo-wagon-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.549, 0.447, 0.322, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["cargo-wagon-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.549, 0.447, 0.322, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["centrifuge-long-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_long_pictures({
				tint = tint or { 0.631, 0.514, 0.086, 1 },
			}),
			shadows = particle_animations.get_metal_particle_medium_long_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["centrifuge-mechanical-component-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_mechanical_component_particle_medium_pictures({
				tint = tint or { 0.715, 0.715, 0.715, 1 },
			}),
			shadows = particle_animations.get_mechanical_component_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["centrifuge-metal-particle-big"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_big_pictures({ tint = tint or { 0.761, 0.757, 0.671, 1 } }),
			shadows = particle_animations.get_metal_particle_big_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = default_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["centrifuge-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.761, 0.757, 0.671, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["centrifuge-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.582, 0.582, 0.582, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["chemical-plant-mechanical-component-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_mechanical_component_particle_medium_pictures({
				tint = tint or { 0.715, 0.715, 0.715, 1 },
			}),
			shadows = particle_animations.get_mechanical_component_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["chemical-plant-metal-particle-big"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_big_pictures({ tint = tint or { 0.675, 0.522, 0.204, 1 } }),
			shadows = particle_animations.get_metal_particle_big_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = default_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["chemical-plant-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.675, 0.522, 0.204, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["chemical-plant-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.617, 0.617, 0.617, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["concrete-stone-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_stone_particle_small_pictures({ tint = tint or { 0.829, 0.829, 0.835, 1 } }),
			shadows = particle_animations.get_stone_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = tiny_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["construction-robot-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.846, 0.788, 0.657, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["construction-robot-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.847, 0.788, 0.655, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["defender-robot-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.772, 0.772, 0.772, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["defender-robot-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.793, 0.611, 0.449, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["electric-furnace-metal-particle-big"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_big_pictures({ tint = tint or { 0.447, 0.490, 0.545, 1 } }),
			shadows = particle_animations.get_metal_particle_big_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = default_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["electric-furnace-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.431, 0.490, 0.463, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["electric-furnace-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.396, 0.251, 0.063, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["electric-mining-drill-long-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_long_pictures({
				tint = tint or { 0.824, 0.783, 0.839, 1 },
			}),
			shadows = particle_animations.get_metal_particle_medium_long_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["electric-mining-drill-mechanical-component-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_mechanical_component_particle_medium_pictures({
				tint = tint or { 0.859, 0.766, 0.680, 1 },
			}),
			shadows = particle_animations.get_mechanical_component_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
		})
	end,
	["electric-mining-drill-metal-particle-big"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_big_pictures({ tint = tint or { 0.737, 0.812, 0.812, 1 } }),
			shadows = particle_animations.get_metal_particle_big_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = default_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["electric-mining-drill-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 1, 0.755, 0.369, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["fluid-wagon-long-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_long_pictures({
				tint = tint or { 0.459, 0.427, 0.396, 1 },
			}),
			shadows = particle_animations.get_metal_particle_medium_long_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["fluid-wagon-metal-particle-big"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_big_pictures({ tint = tint or { 0.561, 0.561, 0.541, 1 } }),
			shadows = particle_animations.get_metal_particle_big_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = default_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["fluid-wagon-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.633, 0.534, 0.459, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["fluid-wagon-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.780, 0.769, 0.753, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["gate-metal-particle-big"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_big_pictures({ tint = tint or { 0.496, 0.496, 0.496, 1 } }),
			shadows = particle_animations.get_metal_particle_big_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = default_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["gate-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.735, 0.735, 0.735, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["gate-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.806, 0.734, 0.301, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["gate-stone-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_stone_particle_small_pictures({ tint = tint or { 0.667, 0.636, 0.515, 1 } }),
			shadows = particle_animations.get_stone_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["gun-turret-metal-particle-big"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_big_pictures({ tint = tint or { 0.541, 0.494, 0.459, 1 } }),
			shadows = particle_animations.get_metal_particle_big_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = default_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["gun-turret-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.800, 0.753, 0.694, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			ender_layer = "object",
		})
	end,
	["gun-turret-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.490, 0.447, 0.416, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["heat-exchanger-copper-particle-big"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_big_pictures({ tint = tint or { 0.859, 0.471, 0.353, 1 } }),
			shadows = particle_animations.get_metal_particle_big_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["heat-exchanger-copper-particle-long"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_long_pictures({
				tint = tint or { 0.859, 0.471, 0.353, 1 },
				scale = 0.3,
			}),
			shadows = particle_animations.get_metal_particle_medium_long_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
				scale = 0.3,
			}),
			regular_trigger_effect = default_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["heat-exchanger-copper-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.859, 0.471, 0.353, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["heat-exchanger-copper-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.859, 0.471, 0.353, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["heat-exchanger-metal-particle-big"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_big_pictures({ tint = tint or { 0.614, 0.644, 0.585, 1 } }),
			shadows = particle_animations.get_metal_particle_big_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = default_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["heat-exchanger-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.946, 1, 0.895, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["heat-exchanger-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.743, 0.663, 0.543, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["heat-pipe-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.788, 0.586, 0.464, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["heat-pipe-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.702, 0.702, 0.702, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["inserter-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.749, 0.491, 0.224, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["inserter-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.508, 0.423, 0.337, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["lab-long-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_long_pictures({
				tint = tint or { 0.828, 0.821, 0.742, 1 },
			}),
			shadows = particle_animations.get_metal_particle_medium_long_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["lab-mechanical-component-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_mechanical_component_particle_medium_pictures({
				tint = tint or { 0.715, 0.715, 0.715, 1 },
			}),
			shadows = particle_animations.get_mechanical_component_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["lab-metal-particle-big"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_big_pictures({ tint = tint or { 0.828, 0.821, 0.742, 1 } }),
			shadows = particle_animations.get_metal_particle_big_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = default_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["lab-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.612, 0.612, 0.612, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["laser-turret-metal-particle-big"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_big_pictures({ tint = tint or { 0.541, 0.494, 0.459, 1 } }),
			shadows = particle_animations.get_metal_particle_big_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = default_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["laser-turret-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.800, 0.753, 0.694, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["laser-turret-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.490, 0.447, 0.416, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["locomotive-mechanical-component-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_mechanical_component_particle_medium_pictures({
				tint = tint or { 0.631, 0.582, 0.536, 1 },
			}),
			shadows = particle_animations.get_mechanical_component_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["locomotive-metal-particle-big"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_big_pictures({ tint = tint or { 0.515, 0.515, 0.515, 1 } }),
			shadows = particle_animations.get_metal_particle_big_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = default_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["locomotive-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.701, 0.598, 0.556, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["locomotive-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.811, 0.811, 0.811, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["logistic-robot-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.753, 0.727, 0.687, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["logistic-robot-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.469, 0.469, 0.469, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["medium-electric-pole-long-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_long_pictures({
				tint = tint or { 0.910, 0.651, 0.398, 1 },
			}),
			shadows = particle_animations.get_metal_particle_medium_long_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["medium-electric-pole-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.583, 0.424, 0.269, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["nuclear-reactor-glass-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_glass_particle_small_pictures({ tint = tint or { 0.621, 1, 0.570, 1 } }),
			shadows = particle_animations.get_glass_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["nuclear-reactor-mechanical-component-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_mechanical_component_particle_medium_pictures({
				tint = tint or { 0.859, 0.766, 0.680, 1 },
			}),
			shadows = particle_animations.get_mechanical_component_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["nuclear-reactor-metal-particle-big"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_big_pictures({ tint = tint or { 0.898, 0.902, 0.780, 1 } }),
			shadows = particle_animations.get_metal_particle_big_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = default_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["nuclear-reactor-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.705, 0.705, 0.705, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["nuclear-reactor-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.898, 0.902, 0.780, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["oil-refinery-long-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_long_pictures({
				tint = tint or { 0.651, 0.620, 0.506, 1 },
			}),
			shadows = particle_animations.get_metal_particle_medium_long_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["oil-refinery-metal-particle-big"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_big_pictures({ tint = tint or { 0.388, 0.380, 0.306, 1 } }),
			shadows = particle_animations.get_metal_particle_big_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = default_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["oil-refinery-metal-particle-big-tint"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_big_pictures({ tint = tint or { 0.455, 0.349, 0.204, 1 } }),
			shadows = particle_animations.get_metal_particle_big_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = default_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["oil-refinery-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.658, 0.659, 0.586, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["oil-refinery-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.388, 0.380, 0.306, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["passive-provider-chest-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.631, 0.631, 0.631, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["passive-provider-chest-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.813, 0.424, 0.424, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["pipe-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.648, 0.555, 0.447, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_grey_dust_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["pipe-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.810, 0.739, 0.651, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["pipe-to-ground-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.648, 0.555, 0.447, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_grey_dust_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["pipe-to-ground-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.810, 0.739, 0.651, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["pump-metal-particle-big"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_big_pictures({ tint = tint or { 0.539, 0.458, 0.367, 1 } }),
			shadows = particle_animations.get_metal_particle_big_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = default_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["pump-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.720, 0.720, 0.720, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["pump-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.720, 0.626, 0.569, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["pumpjack-mechanical-component-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_mechanical_component_particle_medium_pictures({
				tint = tint or { 0.859, 0.766, 0.680, 1 },
			}),
			shadows = particle_animations.get_mechanical_component_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["pumpjack-metal-particle-big"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_big_pictures({ tint = tint or { 0.380, 0.576, 0.353, 1 } }),
			shadows = particle_animations.get_metal_particle_big_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = default_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["pumpjack-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.380, 0.576, 0.353, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["pumpjack-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.715, 0.586, 0.454, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["radar-long-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_long_pictures({
				tint = tint or { 0.834, 0.860, 0.682, 1 },
			}),
			shadows = particle_animations.get_metal_particle_medium_long_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["radar-metal-particle-big"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_big_pictures({ tint = tint or { 0.835, 0.859, 0.682, 1 } }),
			shadows = particle_animations.get_metal_particle_big_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = default_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["radar-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.835, 0.859, 0.682, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["radar-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.806, 0.703, 0.401, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["requester-chest-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.726, 0.726, 0.726, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["requester-chest-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.569, 0.816, 0.973, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["roboport-metal-particle-big"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_big_pictures({ tint = tint or { 0.699, 0.699, 0.699, 1 } }),
			shadows = particle_animations.get_metal_particle_big_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = default_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["roboport-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.456, 0.622, 0.776, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["roboport-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.892, 0.807, 0.591, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["solar-panel-glass-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_glass_particle_small_pictures({ tint = tint or { 0.583, 0.887, 1, 1 } }),
			shadows = particle_animations.get_glass_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["solar-panel-long-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_long_pictures({
				tint = tint or { 0.709, 0.709, 0.709, 1 },
			}),
			shadows = particle_animations.get_metal_particle_medium_long_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["solar-panel-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.709, 0.709, 0.709, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["splitter-long-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_long_pictures({
				tint = tint or { 0.764, 0.764, 0.764, 1 },
			}),
			shadows = particle_animations.get_metal_particle_medium_long_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["splitter-mechanical-component-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_mechanical_component_particle_medium_pictures({
				tint = tint or { 0.859, 0.766, 0.680, 1 },
			}),
			shadows = particle_animations.get_mechanical_component_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["splitter-metal-particle-big"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_big_pictures({ tint = tint or { 0.827, 0.655, 0.357, 1 } }),
			shadows = particle_animations.get_metal_particle_big_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = default_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["splitter-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 1, 0.863, 0.474, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["splitter-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.766, 0.635, 0.541, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["steam-engine-mechanical-component-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_mechanical_component_particle_medium_pictures({
				tint = tint or { 0.715, 0.715, 0.715, 1 },
			}),
			shadows = particle_animations.get_mechanical_component_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["steam-engine-metal-particle-big"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_big_pictures({ tint = tint or { 0.798, 0.786, 0.695, 1 } }),
			shadows = particle_animations.get_metal_particle_big_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = default_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["steam-engine-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.888, 0.878, 0.788, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["steam-engine-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.871, 0.746, 0.514, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["steam-turbine-mechanical-component-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_mechanical_component_particle_medium_pictures({
				tint = tint or { 0.715, 0.715, 0.715, 1 },
			}),
			shadows = particle_animations.get_mechanical_component_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["steam-turbine-metal-particle-big"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_big_pictures({ tint = tint or { 0.503, 0.479, 0.377, 1 } }),
			shadows = particle_animations.get_metal_particle_big_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = default_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["steam-turbine-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.933, 0.875, 0.635, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["steam-turbine-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.747, 0.596, 0.387, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["steel-furnace-metal-particle-big"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_big_pictures({ tint = tint or { 0.509, 0.509, 0.509, 1 } }),
			shadows = particle_animations.get_metal_particle_big_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = default_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["steel-furnace-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.938, 0.860, 0.680, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["steel-furnace-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.365, 0.365, 0.365, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["stone-furnace-stone-particle-big"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_stone_particle_big_pictures({ tint = tint or { 0.583, 0.583, 0.583, 1 } }),
			shadows = particle_animations.get_stone_particle_big_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = default_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["stone-furnace-stone-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_stone_particle_medium_pictures({ tint = tint or { 1, 0.815, 0.000, 1 } }),
			shadows = particle_animations.get_stone_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["stone-furnace-stone-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_stone_particle_small_pictures({ tint = tint or { 0.614, 0.614, 0.614, 1 } }),
			shadows = particle_animations.get_stone_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["storage-chest-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.793, 0.793, 0.793, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["storage-chest-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.924, 0.874, 0.556, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["storage-tank-metal-particle-big"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_big_pictures({ tint = tint or { 0.500, 0.458, 0.420, 1 } }),
			shadows = particle_animations.get_metal_particle_big_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = default_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["storage-tank-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.800, 0.709, 0.624, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["substation-long-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_long_pictures({
				tint = tint or { 0.651, 0.533, 0.514, 1 },
			}),
			shadows = particle_animations.get_metal_particle_medium_long_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["substation-metal-particle-big"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_big_pictures({ tint = tint or { 0.345, 0.420, 0.490, 1 } }),
			shadows = particle_animations.get_metal_particle_big_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = default_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["tank-metal-particle-big"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_big_pictures({ tint = tint or { 0.510, 0.510, 0.510, 1 } }),
			shadows = particle_animations.get_metal_particle_big_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = default_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["tank-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.769, 0.630, 0.619, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["tank-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.695, 0.695, 0.695, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["transport-belt-mechanical-component-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_mechanical_component_particle_medium_pictures({
				tint = tint or { 0.715, 0.715, 0.715, 1 },
			}),
			shadows = particle_animations.get_mechanical_component_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_grey_dust_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["transport-belt-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.898, 0.659, 0.031, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_grey_dust_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["transport-belt-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.898, 0.659, 0.031, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["transport-belt-wooden-splinter-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_wooden_splinter_particle_medium_pictures({
				tint = tint or { 0.416, 0.378, 0.341, 1 },
			}),
			shadows = particle_animations.get_wooden_splinter_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_grey_dust_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["underground-belt-metal-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.844, 0.844, 0.844, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_grey_dust_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["underground-belt-metal-particle-medium-yellow"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_medium_pictures({ tint = tint or { 0.855, 0.710, 0.362, 1 } }),
			shadows = particle_animations.get_metal_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_grey_dust_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["underground-belt-metal-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_metal_particle_small_pictures({ tint = tint or { 0.855, 0.710, 0.362, 1 } }),
			shadows = particle_animations.get_metal_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["wall-stone-particle-medium"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_stone_particle_medium_pictures({ tint = tint or { 0.667, 0.636, 0.515, 1 } }),
			shadows = particle_animations.get_stone_particle_medium_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = small_smoke_trigger_effect(),
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
			render_layer = "object",
		})
	end,
	["wall-stone-particle-small"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_stone_particle_small_pictures({ tint = tint or { 0.753, 0.719, 0.582, 1 } }),
			shadows = particle_animations.get_stone_particle_small_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
	["wall-stone-particle-tiny"] = function(tint)
		return make_particle({
			pictures = particle_animations.get_stone_particle_tiny_pictures({ tint = tint or { 0.753, 0.718, 0.580, 1 } }),
			shadows = particle_animations.get_stone_particle_tiny_pictures({
				tint = shadowtint(),
				shift = util.by_pixel(1, 0),
			}),
			regular_trigger_effect = nil,
			ended_in_water_trigger_effect = default_ended_in_water_trigger_effect(),
		})
	end,
}

---Defines the options for the dying explosion of a vanilla entity.
---@class (exact) BaseExplosionParams
---The tint of each particle in the explosion that is replaced by a copy in that tint, by the name of the particle. A
---particle with a `nil` tint is not replaced.
---@field tints? table<ParticleID, Color?>

---Indicates whether the given `tints` name any particle.
---@param tints? table<ParticleID, Color?> The tint of each particle, by the name of the particle.
---@return boolean # `true` when `tints` names a particle; otherwise, `false`.
---@nodiscard
function M.has_tints(tints)
	return tints ~= nil and next(tints) ~= nil
end

---Gets the vanilla particle with the given `name`, in the given `tint`.
---@param name ParticleID The name of the particle.
---@param tint? Color The tint of the particle. When `nil`, the tint of the base game is used.
---@return ParticleSpriteSet # The particle.
---@throws When `name` is not the name of a particle that a dying explosion in `assets.base.explosions` creates.
---@nodiscard
function M.get_particle(name, tint)
	local definition = definitions[name]
	if definition == nil then
		error(string.format("The particle '%s' is not created by any dying explosion in 'assets.base.explosions'.", name))
	end

	return definition(tint)
end

---Gets the vanilla particle with each name in the given `tints`, in the tint given for it.
---@param tints? table<ParticleID, Color?> The tint of each particle, by the name of the particle.
---@return table<ParticleID, ParticleSpriteSet>? # Each particle, by its name, or `nil` when `tints` names no particle.
---@throws When a name in `tints` is not the name of a particle that a dying explosion in `assets.base.explosions` creates.
---@nodiscard
function M.get_particles(tints)
	if not M.has_tints(tints) then
		return nil
	end
	---@cast tints -?

	local particles = {}
	for name, tint in pairs(tints) do
		particles[name] = M.get_particle(name, tint)
	end

	return particles
end

return M
