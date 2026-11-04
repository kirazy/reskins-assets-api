-- This file is generated from the source of the base game by reskins-workspace/tools/base_explosions/generate.py.

---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Base.Explosions

local explosion_animations = require("__base__.prototypes.entity.explosion-animations")
local sounds = require("__base__.prototypes.entity.sounds")
local Particles = require("assets.base.particles")

local M = {}

---Gets the dying explosion of the vanilla substation. Each particle named in `params.tints` is replaced by a copy in
---the given tint.
---
---The explosion creates these particles:
---- `substation-metal-particle-big`
---- `substation-long-metal-particle-medium`
---- `cable-and-electronics-particle-small-medium`
---@param params? BaseExplosionParams The options for the explosion.
---@return ExplosionSpriteSet # The dying explosion.
---@nodiscard
function M.get_explosion(params)
	local tints = params and params.tints

	return {
		flags = { "not-on-map" },
		hidden = true,
		subgroup = "energy-pipe-distribution-explosions",
		order = "d-d-a",
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
						repeat_count = 7,
						particle_name = "substation-metal-particle-big",
						offset_deviation = { { -0.5, -0.6953 }, { 0.5, 0.6953 } },
						initial_height = 0.5,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.08,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.05,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 9,
						particle_name = "substation-metal-particle-big",
						offset_deviation = { { -0.6914, -0.2969 }, { 0.6914, 0.2969 } },
						initial_height = 0.2,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.08,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.02,
						speed_from_center_deviation = 0.05,
						frame_speed = 1,
						frame_speed_deviation = 0.463,
					},
					{
						type = "create-particle",
						repeat_count = 12,
						particle_name = "substation-long-metal-particle-medium",
						offset_deviation = { { -0.6953, -0.2969 }, { 0.6953, 0.2969 } },
						initial_height = 0.5,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.087,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.05,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 12,
						particle_name = "substation-long-metal-particle-medium",
						offset_deviation = { { -0.5977, -0.7891 }, { 0.5977, 0.7891 } },
						initial_height = 0.5,
						initial_height_deviation = 0.44,
						initial_vertical_speed = 0.047,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.06,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 15,
						particle_name = "cable-and-electronics-particle-small-medium",
						offset_deviation = { { -0.5977, -0.7891 }, { 0.5977, 0.7891 } },
						initial_height = 0.5,
						initial_height_deviation = 0.44,
						initial_vertical_speed = 0.011,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.06,
						speed_from_center_deviation = 0.05,
					},
				},
			},
		},
		particles = Particles.get_particles(tints),
	}
end

return M
