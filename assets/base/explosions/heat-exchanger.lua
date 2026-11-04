-- This file is generated from the source of the base game by reskins-workspace/tools/base_explosions/generate.py.

---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Base.Explosions

local explosion_animations = require("__base__.prototypes.entity.explosion-animations")
local sounds = require("__base__.prototypes.entity.sounds")
local Particles = require("assets.base.particles")

local M = {}

---Gets the dying explosion of the vanilla heat exchanger. Each particle named in `params.tints` is replaced by a copy
---in the given tint.
---
---The explosion creates these particles:
---- `heat-exchanger-metal-particle-medium`
---- `heat-exchanger-metal-particle-small`
---- `heat-exchanger-metal-particle-big`
---- `heat-exchanger-copper-particle-medium`
---- `heat-exchanger-copper-particle-small`
---- `heat-exchanger-copper-particle-big`
---- `heat-exchanger-copper-particle-long`
---@param params? BaseExplosionParams The options for the explosion.
---@return ExplosionSpriteSet # The dying explosion.
---@nodiscard
function M.get_explosion(params)
	local tints = params and params.tints

	return {
		flags = { "not-on-map" },
		hidden = true,
		subgroup = "energy-explosions",
		order = "a-f-a",
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
						repeat_count = 25,
						particle_name = "heat-exchanger-metal-particle-medium",
						offset_deviation = { { -0.8867, -0.3867 }, { 0.8867, 0.3867 } },
						initial_height = 0.3,
						initial_height_deviation = 0.44,
						initial_vertical_speed = 0.07,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.03,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 23,
						particle_name = "heat-exchanger-metal-particle-small",
						offset_deviation = { { -0.3906, -0.5977 }, { 0.3906, 0.5977 } },
						initial_height = 0.3,
						initial_height_deviation = 0.44,
						initial_vertical_speed = 0.08,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.03,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 12,
						particle_name = "heat-exchanger-metal-particle-big",
						offset_deviation = { { -0.582, -0.5859 }, { 0.582, 0.5859 } },
						initial_height = 0.3,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.07,
						initial_vertical_speed_deviation = 0.049,
						speed_from_center = 0.04,
						speed_from_center_deviation = 0.05,
					},

					{
						type = "create-particle",
						repeat_count = 20,
						particle_name = "heat-exchanger-copper-particle-medium",
						offset_deviation = { { -0.8867, -0.3867 }, { 0.8867, 0.3867 } },
						initial_height = 0.3,
						initial_height_deviation = 0.44,
						initial_vertical_speed = 0.07,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.03,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 10,
						particle_name = "heat-exchanger-copper-particle-small",
						offset_deviation = { { -0.3906, -0.5977 }, { 0.3906, 0.5977 } },
						initial_height = 0.3,
						initial_height_deviation = 0.44,
						initial_vertical_speed = 0.08,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.03,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 6,
						particle_name = "heat-exchanger-copper-particle-big",
						offset_deviation = { { -0.582, -0.5859 }, { 0.582, 0.5859 } },
						initial_height = 0.3,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.07,
						initial_vertical_speed_deviation = 0.049,
						speed_from_center = 0.04,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 8,
						particle_name = "heat-exchanger-copper-particle-long",
						offset_deviation = { { -0.582, -0.5859 }, { 0.582, 0.5859 } },
						initial_height = 0.3,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.07,
						initial_vertical_speed_deviation = 0.049,
						speed_from_center = 0.04,
						speed_from_center_deviation = 0.05,
					},
				},
			},
		},
		particles = Particles.get_particles(tints),
	}
end

return M
