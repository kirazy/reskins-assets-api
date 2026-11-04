-- This file is generated from the source of the base game by reskins-workspace/tools/base_explosions/generate.py.

---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Base.Explosions

local explosion_animations = require("__base__.prototypes.entity.explosion-animations")
local sounds = require("__base__.prototypes.entity.sounds")
local Particles = require("assets.base.particles")

local M = {}

---Gets the dying explosion of the vanilla roboport. Each particle named in `params.tints` is replaced by a copy in the
---given tint.
---
---The explosion creates these particles:
---- `roboport-metal-particle-big`
---- `roboport-metal-particle-medium`
---- `roboport-metal-particle-small`
---- `cable-and-electronics-particle-small-medium`
---@param params? BaseExplosionParams The options for the explosion.
---@return ExplosionSpriteSet # The dying explosion.
---@nodiscard
function M.get_explosion(params)
	local tints = params and params.tints

	return {
		flags = { "not-on-map" },
		hidden = true,
		subgroup = "logistic-network-explosions",
		order = "f-g-a",
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
						repeat_count = 17,
						particle_name = "roboport-metal-particle-big",
						offset_deviation = { { -0.5, -0.2969 }, { 0.5, 0.2969 } },
						initial_height = 0.6,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.045,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.06,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 30,
						particle_name = "roboport-metal-particle-medium",
						offset_deviation = { { -0.5, -0.7969 }, { 0.5, 0.7969 } },
						initial_height = 0.7,
						initial_height_deviation = 0.44,
						initial_vertical_speed = 0.071,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.05,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 33,
						particle_name = "roboport-metal-particle-small",
						offset_deviation = { { -0.5977, -0.2969 }, { 0.5977, 0.2969 } },
						initial_height = 0.7,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.03,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.03,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 25,
						particle_name = "cable-and-electronics-particle-small-medium",
						offset_deviation = { { -0.5, -0.5 }, { 0.5, 0.5 } },
						initial_height = 0.4,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.027,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.02,
						speed_from_center_deviation = 0.05,
					},
				},
			},
		},
		particles = Particles.get_particles(tints),
	}
end

return M
