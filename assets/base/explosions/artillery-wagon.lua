-- This file is generated from the source of the base game by reskins-workspace/tools/base_explosions/generate.py.

---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Base.Explosions

local explosion_animations = require("__base__.prototypes.entity.explosion-animations")
local sounds = require("__base__.prototypes.entity.sounds")
local Particles = require("assets.base.particles")

local M = {}

---Gets the dying explosion of the vanilla artillery wagon. Each particle named in `params.tints` is replaced by a copy
---in the given tint.
---
---The explosion creates these particles:
---- `artillery-wagon-metal-particle-big`
---- `artillery-wagon-metal-particle-medium`
---- `artillery-wagon-metal-particle-small`
---- `artillery-wagon-metal-particle-big-yellow`
---- `artillery-wagon-mechanical-component-particle-medium`
---@param params? BaseExplosionParams The options for the explosion.
---@return ExplosionSpriteSet # The dying explosion.
---@nodiscard
function M.get_explosion(params)
	local tints = params and params.tints

	return {
		flags = { "not-on-map" },
		hidden = true,
		subgroup = "train-transport-explosions",
		order = "e-h-a",
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
						repeat_count = 20,
						particle_name = "artillery-wagon-metal-particle-big",
						offset_deviation = { { -0.2969, -0.1953 }, { 0.2969, 0.1953 } },
						initial_height = 0.7,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.11,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.03,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 30,
						particle_name = "artillery-wagon-metal-particle-medium",
						offset_deviation = { { -0.5977, -0.5977 }, { 0.5977, 0.5977 } },
						initial_height = 1,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.109,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.05,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 30,
						particle_name = "artillery-wagon-metal-particle-small",
						offset_deviation = { { -0.5977, -0.5977 }, { 0.5977, 0.5977 } },
						initial_height = 1,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.114,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.05,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 20,
						particle_name = "artillery-wagon-metal-particle-big-yellow",
						offset_deviation = { { -0.5, -0.5 }, { 0.5, 0.5 } },
						initial_height = 0.6,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.088,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.05,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 16,
						particle_name = "artillery-wagon-mechanical-component-particle-medium",
						offset_deviation = { { -0.5, -0.5 }, { 0.5, 0.5 } },
						initial_height = 1,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.101,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.03,
						speed_from_center_deviation = 0.05,
					},
				},
			},
		},
		particles = Particles.get_particles(tints),
	}
end

return M
