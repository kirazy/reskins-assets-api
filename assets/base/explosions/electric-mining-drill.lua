-- This file is generated from the source of the base game by reskins-workspace/tools/base_explosions/generate.py.

---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Base.Explosions

local explosion_animations = require("__base__.prototypes.entity.explosion-animations")
local sounds = require("__base__.prototypes.entity.sounds")
local Particles = require("assets.base.particles")

local M = {}

---Gets the dying explosion of the vanilla electric mining drill. Each particle named in `params.tints` is replaced by a
---copy in the given tint.
---
---The explosion creates these particles:
---- `electric-mining-drill-metal-particle-big`
---- `electric-mining-drill-metal-particle-medium`
---- `electric-mining-drill-long-metal-particle-medium`
---- `electric-mining-drill-mechanical-component-particle-medium`
---- `cable-and-electronics-particle-small-medium`
---@param params? BaseExplosionParams The options for the explosion.
---@return ExplosionSpriteSet # The dying explosion.
---@nodiscard
function M.get_explosion(params)
	local tints = params and params.tints

	return {
		flags = { "not-on-map" },
		hidden = true,
		subgroup = "extraction-machine-explosions",
		order = "b-b-a",
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
						repeat_count = 10,
						repeat_count_deviation = 0,
						probability = 1,
						affects_target = false,
						show_in_tooltip = false,
						particle_name = "electric-mining-drill-metal-particle-big",
						offsets = {
							{ 0, 0 },
						},
						offset_deviation = {
							left_top = { -0.09375, -0.1875 },
							right_bottom = { 0.09375, 0.1875 },
						},
						initial_height = 1.7,
						initial_height_deviation = 0.31,
						initial_vertical_speed = 0.086,
						initial_vertical_speed_deviation = 0.049,
						speed_from_center = 0.03,
						speed_from_center_deviation = 0.001,
						frame_speed = 1,
						frame_speed_deviation = 0,
					},
					{
						type = "create-particle",
						repeat_count = 20,
						repeat_count_deviation = 0,
						probability = 1,
						affects_target = false,
						show_in_tooltip = false,
						particle_name = "electric-mining-drill-metal-particle-medium",
						offsets = {
							{ 0, 0 },
						},
						offset_deviation = {
							left_top = { -0.1875, -0.1875 },
							right_bottom = { 0.1875, 0.1875 },
						},
						initial_height = 1.1,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.106,
						initial_vertical_speed_deviation = 0.051,
						speed_from_center = 0.03,
						speed_from_center_deviation = 0.007,
						frame_speed = 1,
						frame_speed_deviation = 0,
					},
					{
						type = "create-particle",
						repeat_count = 10,
						repeat_count_deviation = 0,
						probability = 1,
						affects_target = false,
						show_in_tooltip = false,
						particle_name = "electric-mining-drill-long-metal-particle-medium",
						offsets = {
							{ 0, 0 },
						},
						offset_deviation = {
							left_top = { -0.8867, -0.8828 },
							right_bottom = { 0.8867, 0.8828 },
						},
						initial_height = 0.4,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.156,
						initial_vertical_speed_deviation = 0.046,
						speed_from_center = 0.03,
						speed_from_center_deviation = 0.012,
						frame_speed = 1,
						frame_speed_deviation = 0,
					},
					{
						type = "create-particle",
						repeat_count = 23,
						repeat_count_deviation = 0,
						probability = 1,
						affects_target = false,
						show_in_tooltip = false,
						particle_name = "electric-mining-drill-mechanical-component-particle-medium",
						offsets = {
							{ 0, 0 },
						},
						offset_deviation = {
							left_top = { -0.5, -0.5 },
							right_bottom = { 0.5, 0.5 },
						},
						initial_height = 2.2,
						initial_height_deviation = 0.48,
						initial_vertical_speed = 0.074,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.04,
						speed_from_center_deviation = 0,
						frame_speed = 1,
						frame_speed_deviation = 0,
					},
					{
						type = "create-particle",
						repeat_count = 5,
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
						initial_height = 0.3,
						initial_height_deviation = 0,
						initial_vertical_speed = 0.085,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.05,
						speed_from_center_deviation = 0.019,
						frame_speed = 1,
						frame_speed_deviation = 0,
					},
				},
			},
		},
		particles = Particles.get_particles(tints),
	}
end

return M
