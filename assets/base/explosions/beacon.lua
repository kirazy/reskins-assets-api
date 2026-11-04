-- This file is generated from the source of the base game by reskins-workspace/tools/base_explosions/generate.py.

---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Base.Explosions

local explosion_animations = require("__base__.prototypes.entity.explosion-animations")
local sounds = require("__base__.prototypes.entity.sounds")
local Particles = require("assets.base.particles")

local M = {}

---Gets the dying explosion of the vanilla beacon. Each particle named in `params.tints` is replaced by a copy in the
---given tint.
---
---The explosion creates these particles:
---- `beacon-metal-particle-big`
---- `beacon-metal-particle-medium`
---- `beacon-metal-particle-small`
---- `cable-and-electronics-particle-small-medium`
---- `concrete-stone-particle-small`
---@param params? BaseExplosionParams The options for the explosion.
---@return ExplosionSpriteSet # The dying explosion.
---@nodiscard
function M.get_explosion(params)
	local tints = params and params.tints

	return {
		flags = { "not-on-map" },
		hidden = true,
		subgroup = "module-explosions",
		order = "e-a-a",
		height = 0,
		animations = explosion_animations.medium_explosion(),
		smoke = "smoke-fast",
		smoke_count = 2,
		smoke_slow_down_factor = 1,
		sound = sounds.medium_explosion,
		created_effect = {
			type = "direct",
			action_delivery = {
				type = "instant",
				target_effects = {
					{
						type = "create-particle",
						repeat_count = 5,
						repeat_count_deviation = 0,
						probability = 1,
						affects_target = false,
						show_in_tooltip = false,
						particle_name = "beacon-metal-particle-big",
						offsets = {
							{ 0, 0 },
						},
						offset_deviation = {
							left_top = { -0.4961, -0.5938 },
							right_bottom = { 0.4961, 0.5938 },
						},
						initial_height = 0.45,
						initial_height_deviation = 0.46,
						initial_vertical_speed = 0.106,
						initial_vertical_speed_deviation = 0.036,
						speed_from_center = 0.03,
						speed_from_center_deviation = 0.007,
						frame_speed = 1,
						frame_speed_deviation = 0,
						rotate_offsets = false,
					},
					{
						type = "create-particle",
						repeat_count = 15,
						repeat_count_deviation = 0,
						probability = 1,
						affects_target = false,
						show_in_tooltip = false,
						particle_name = "beacon-metal-particle-medium",
						offsets = {
							{ 0, 0 },
						},
						offset_deviation = {
							left_top = { -0.4961, -0.5 },
							right_bottom = { 0.4961, 0.5 },
						},
						initial_height = 0.4,
						initial_height_deviation = 0,
						initial_vertical_speed = 0.092,
						initial_vertical_speed_deviation = 0.038,
						speed_from_center = 0.04,
						speed_from_center_deviation = 0.006,
						frame_speed = 1,
						frame_speed_deviation = 0,
						rotate_offsets = false,
					},
					{
						type = "create-particle",
						repeat_count = 29,
						repeat_count_deviation = 0,
						probability = 1,
						affects_target = false,
						show_in_tooltip = false,
						particle_name = "beacon-metal-particle-small",
						offsets = {
							{ 0, 0 },
						},
						offset_deviation = {
							left_top = { -0.5938, -0.5938 },
							right_bottom = { 0.5938, 0.5938 },
						},
						initial_height = 0.5,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.063,
						initial_vertical_speed_deviation = 0.035,
						speed_from_center = 0.04,
						speed_from_center_deviation = 0,
						frame_speed = 1,
						frame_speed_deviation = 0,
						rotate_offsets = false,
					},
					{
						type = "create-particle",
						repeat_count = 15,
						repeat_count_deviation = 0,
						probability = 1,
						affects_target = false,
						show_in_tooltip = false,
						particle_name = "cable-and-electronics-particle-small-medium",
						offsets = {
							{ 0, 0 },
						},
						offset_deviation = {
							left_top = { -0.5, -0.5 },
							right_bottom = { 0.5, 0.5 },
						},
						initial_height = 0.2,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.082,
						initial_vertical_speed_deviation = 0.031,
						speed_from_center = 0.05,
						speed_from_center_deviation = 0,
						frame_speed = 1,
						frame_speed_deviation = 0,
						rotate_offsets = false,
					},
					{
						type = "create-particle",
						repeat_count = 12,
						repeat_count_deviation = 0,
						probability = 1,
						affects_target = false,
						show_in_tooltip = false,
						particle_name = "concrete-stone-particle-small",
						offsets = {
							{ 0, 0 },
						},
						offset_deviation = {
							left_top = { -0.5, -0.5 },
							right_bottom = { 0.5, 0.5 },
						},
						initial_height = 0.3,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.087,
						initial_vertical_speed_deviation = 0.034,
						speed_from_center = 0.04,
						speed_from_center_deviation = 0.012,
						frame_speed = 1,
						frame_speed_deviation = 0,
						rotate_offsets = false,
					},
				},
			},
		},
		particles = Particles.get_particles(tints),
	}
end

return M
