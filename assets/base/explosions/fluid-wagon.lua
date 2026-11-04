-- This file is generated from the source of the base game by reskins-workspace/tools/base_explosions/generate.py.

---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Base.Explosions

local explosion_animations = require("__base__.prototypes.entity.explosion-animations")
local sounds = require("__base__.prototypes.entity.sounds")
local Particles = require("assets.base.particles")

local M = {}

---Gets the dying explosion of the vanilla fluid wagon. Each particle named in `params.tints` is replaced by a copy in
---the given tint.
---
---The explosion creates these particles:
---- `fluid-wagon-metal-particle-big`
---- `fluid-wagon-metal-particle-medium`
---- `fluid-wagon-metal-particle-small`
---- `fluid-wagon-long-metal-particle-medium`
---@param params? BaseExplosionParams The options for the explosion.
---@return ExplosionSpriteSet # The dying explosion.
---@nodiscard
function M.get_explosion(params)
	local tints = params and params.tints

	return {
		flags = { "not-on-map" },
		hidden = true,
		subgroup = "train-transport-explosions",
		order = "e-f-a",
		height = 0,
		animations = explosion_animations.medium_explosion(),
		smoke = "smoke-fast",
		smoke_count = 2,
		smoke_slow_down_factor = 1,
		sound = sounds.large_metal_explosion(0.7, 1.0),
		created_effect = {
			type = "direct",
			action_delivery = {
				type = "instant",
				target_effects = {
					{
						type = "create-particle",
						repeat_count = 31,
						particle_name = "fluid-wagon-metal-particle-big",
						offset_deviation = { { -0.2969, -0.1953 }, { 0.2969, 0.1953 } },
						initial_height = 0.7,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.091,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.03,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 31,
						particle_name = "fluid-wagon-metal-particle-medium",
						offset_deviation = { { -0.5977, -0.5977 }, { 0.5977, 0.5977 } },
						initial_height = 0.4,
						initial_height_deviation = 0.47,
						initial_vertical_speed = 0.094,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.05,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 34,
						particle_name = "fluid-wagon-metal-particle-small",
						offset_deviation = { { -0.5977, -0.5977 }, { 0.5977, 0.5977 } },
						initial_height = 0.8,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.079,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.05,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 19,
						particle_name = "fluid-wagon-long-metal-particle-medium",
						offset_deviation = { { -0.5, -0.5 }, { 0.5, 0.5 } },
						initial_height = 0.8,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.087,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.05,
						speed_from_center_deviation = 0.05,
					},
				},
			},
		},
		particles = Particles.get_particles(tints),
	}
end

return M
