-- This file is generated from the source of the base game by reskins-workspace/tools/base_explosions/generate.py.

---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Base.Explosions

local explosion_animations = require("__base__.prototypes.entity.explosion-animations")
local sounds = require("__base__.prototypes.entity.sounds")
local Particles = require("assets.base.particles")

local M = {}

---Gets the dying explosion of the vanilla pump. Each particle named in `params.tints` is replaced by a copy in the
---given tint.
---
---The explosion creates these particles:
---- `pump-metal-particle-big`
---- `pump-metal-particle-medium`
---- `pump-metal-particle-small`
---- `pump-glass-particle-small`
---@param params? BaseExplosionParams The options for the explosion.
---@return ExplosionSpriteSet # The dying explosion.
---@nodiscard
function M.get_explosion(params)
	local tints = params and params.tints

	return {
		flags = { "not-on-map" },
		hidden = true,
		subgroup = "energy-pipe-distribution-explosions",
		order = "d-h-a",
		height = 0,
		animations = explosion_animations.small_explosion(),
		smoke = "smoke-fast",
		smoke_count = 2,
		smoke_slow_down_factor = 1,
		sound = sounds.small_explosion,
		created_effect = {
			type = "direct",
			action_delivery = {
				type = "instant",
				target_effects = {
					{
						type = "create-particle",
						repeat_count = 9,
						particle_name = "pump-metal-particle-big",
						offset_deviation = { { -0.6953, -0.2969 }, { 0.6953, 0.2969 } },
						initial_height = 0.2,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.08,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.04,
						speed_from_center_deviation = 0.05,
						frame_speed = 1,
						frame_speed_deviation = 0.463,
					},
					{
						type = "create-particle",
						repeat_count = 9,
						particle_name = "pump-metal-particle-medium",
						offset_deviation = { { -0.6953, -0.2969 }, { 0.6953, 0.2969 } },
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
						particle_name = "pump-metal-particle-small",
						offset_deviation = { { -0.6953, -0.6953 }, { 0.6953, 0.6953 } },
						initial_height = 0.2,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.136,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.03,
						speed_from_center_deviation = 0.05,
						frame_speed = 1,
						frame_speed_deviation = 0.463,
					},
					{
						type = "create-particle",
						repeat_count = 30,
						particle_name = "pump-glass-particle-small",
						offset_deviation = { { -0.6914, -0.6914 }, { 0.6914, 0.6914 } },
						initial_height = 0.2,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.113,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.03,
						speed_from_center_deviation = 0.05,
						frame_speed = 1,
						frame_speed_deviation = 0.463,
					},
				},
			},
		},
		particles = Particles.get_particles(tints),
	}
end

return M
