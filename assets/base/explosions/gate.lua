-- This file is generated from the source of the base game by reskins-workspace/tools/base_explosions/generate.py.

---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Base.Explosions

local explosion_animations = require("__base__.prototypes.entity.explosion-animations")
local sounds = require("__base__.prototypes.entity.sounds")
local Particles = require("assets.base.particles")

local M = {}

---Gets the dying explosion of the vanilla gate. Each particle named in `params.tints` is replaced by a copy in the
---given tint.
---
---The explosion creates these particles:
---- `gate-metal-particle-big`
---- `gate-metal-particle-medium`
---- `gate-metal-particle-small`
---- `gate-stone-particle-small`
---@param params? BaseExplosionParams The options for the explosion.
---@return ExplosionSpriteSet # The dying explosion.
---@nodiscard
function M.get_explosion(params)
	local tints = params and params.tints

	return {
		flags = { "not-on-map" },
		hidden = true,
		subgroup = "defensive-structure-explosions",
		order = "b-b-a",
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
						repeat_count = 4,
						particle_name = "gate-metal-particle-big",
						offset_deviation = { { -0.1953, -0.1953 }, { 0.1953, 0.1953 } },
						initial_height = 0.3,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.078,
						initial_vertical_speed_deviation = 0.056,
						speed_from_center = 0.03,
						speed_from_center_deviation = 0.048,
					},
					{
						type = "create-particle",
						repeat_count = 7,
						particle_name = "gate-metal-particle-medium",
						offset_deviation = { { -0.4883, -0.5977 }, { 0.4883, 0.5977 } },
						initial_height = 0.9,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.077,
						initial_vertical_speed_deviation = 0.056,
						speed_from_center = 0.03,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 17,
						particle_name = "gate-metal-particle-small",
						offset_deviation = { { -0.3906, -0.4883 }, { 0.3906, 0.4883 } },
						initial_height = 1,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.076,
						initial_vertical_speed_deviation = 0.055,
						speed_from_center = 0.02,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 39,
						particle_name = "gate-stone-particle-small",
						offset_deviation = { { -0.5, -0.5 }, { 0.5, 0.5 } },
						initial_height = 0.1,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.093,
						initial_vertical_speed_deviation = 0.052,
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
