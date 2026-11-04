-- This file is generated from the source of the base game by reskins-workspace/tools/base_explosions/generate.py.

---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Base.Explosions

local explosion_animations = require("__base__.prototypes.entity.explosion-animations")
local sounds = require("__base__.prototypes.entity.sounds")
local Particles = require("assets.base.particles")

local M = {}

---Gets the dying explosion of the vanilla defender robot. Each particle named in `params.tints` is replaced by a copy
---in the given tint.
---
---The explosion creates these particles:
---- `cable-and-electronics-particle-small-medium`
---- `defender-robot-metal-particle-medium`
---- `defender-robot-metal-particle-small`
---@param params? BaseExplosionParams The options for the explosion.
---@return ExplosionSpriteSet # The dying explosion.
---@nodiscard
function M.get_explosion(params)
	local tints = params and params.tints

	return {
		flags = { "not-on-map" },
		hidden = true,
		subgroup = "capsule-explosions",
		order = "c-a-a",
		height = 1.4,
		animations = explosion_animations.explosion(),
		smoke = "smoke-fast",
		smoke_count = 2,
		smoke_slow_down_factor = 1,
		sound = sounds.robot_explosion,
		created_effect = {
			type = "direct",
			action_delivery = {
				type = "instant",
				target_effects = {
					{
						type = "create-particle",
						repeat_count = 8,
						particle_name = "cable-and-electronics-particle-small-medium",
						offset_deviation = { { -0.5977, -0.5977 }, { 0.5977, 0.5977 } },
						initial_height = 1.3,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.091,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.03,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 5,
						particle_name = "defender-robot-metal-particle-medium",
						offset_deviation = { { -0.6953, -0.2969 }, { 0.6953, 0.2969 } },
						initial_height = 1.4,
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
						repeat_count = 10,
						particle_name = "defender-robot-metal-particle-small",
						offset_deviation = { { -0.5938, -0.5977 }, { 0.5938, 0.5977 } },
						initial_height = 1.4,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.082,
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
