-- This file is generated from the source of the base game by reskins-workspace/tools/base_explosions/generate.py.

---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Base.Explosions

local explosion_animations = require("__base__.prototypes.entity.explosion-animations")
local sounds = require("__base__.prototypes.entity.sounds")
local Particles = require("assets.base.particles")

local M = {}

---Gets the dying explosion of the vanilla centrifuge. Each particle named in `params.tints` is replaced by a copy in
---the given tint.
---
---The explosion creates these particles:
---- `centrifuge-metal-particle-big`
---- `centrifuge-metal-particle-medium`
---- `centrifuge-metal-particle-small`
---- `centrifuge-long-metal-particle-medium`
---- `centrifuge-mechanical-component-particle-medium`
---@param params? BaseExplosionParams The options for the explosion.
---@return ExplosionSpriteSet # The dying explosion.
---@nodiscard
function M.get_explosion(params)
	local tints = params and params.tints

	return {
		flags = { "not-on-map" },
		hidden = true,
		subgroup = "production-machine-explosions",
		order = "d-f-a",
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
						particle_name = "centrifuge-metal-particle-big",
						offset_deviation = { { -0.6875, -0.6875 }, { 0.6875, 0.6875 } },
						initial_height = 0.2,
						initial_height_deviation = 0.49,
						initial_vertical_speed = 0.087,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.03,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 38,
						particle_name = "centrifuge-metal-particle-medium",
						offset_deviation = { { -0.9805, -0.8945 }, { 0.9805, 0.8945 } },
						initial_height = 0.4,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.095,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.04,
						speed_from_center_deviation = 0.053,
					},
					{
						type = "create-particle",
						repeat_count = 34,
						particle_name = "centrifuge-metal-particle-small",
						offset_deviation = { { -0.9961, -0.5938 }, { 0.9961, 0.5938 } },
						initial_height = 0.4,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.06,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.03,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 15,
						particle_name = "centrifuge-long-metal-particle-medium",
						offsets = { { 0.2734, 0.1484 } },
						offset_deviation = { { -0.5, -0.2969 }, { 0.5, 0.2969 } },
						initial_height = 0.4,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.101,
						initial_vertical_speed_deviation = 0.049,
						speed_from_center = 0.05,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 18,
						particle_name = "centrifuge-mechanical-component-particle-medium",
						offset_deviation = { { -0.5, -0.5 }, { 0.5, 0.5 } },
						initial_height = 0.3,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.085,
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
