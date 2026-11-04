-- This file is generated from the source of the base game by reskins-workspace/tools/base_explosions/generate.py.

---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Base.Explosions

local explosion_animations = require("__base__.prototypes.entity.explosion-animations")
local sounds = require("__base__.prototypes.entity.sounds")
local Particles = require("assets.base.particles")

local M = {}

---Gets the dying explosion of the vanilla radar. Each particle named in `params.tints` is replaced by a copy in the
---given tint.
---
---The explosion creates these particles:
---- `radar-metal-particle-big`
---- `radar-metal-particle-medium`
---- `radar-metal-particle-small`
---- `radar-long-metal-particle-medium`
---- `cable-and-electronics-particle-small-medium`
---@param params? BaseExplosionParams The options for the explosion.
---@return ExplosionSpriteSet # The dying explosion.
---@nodiscard
function M.get_explosion(params)
	local tints = params and params.tints

	return {
		flags = { "not-on-map" },
		hidden = true,
		subgroup = "defensive-structure-explosions",
		order = "b-g-a",
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
						repeat_count = 15,
						particle_name = "radar-metal-particle-big",
						offset_deviation = { { -0.5, -0.5977 }, { 0.5, 0.5977 } },
						initial_height = 0.3,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.071,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.05,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 22,
						particle_name = "radar-metal-particle-medium",
						offset_deviation = { { -0.5938, -0.5 }, { 0.5938, 0.5 } },
						initial_height = 0.3,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.082,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.05,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 20,
						particle_name = "radar-metal-particle-small",
						offset_deviation = { { -0.5, -0.5977 }, { 0.5, 0.5977 } },
						initial_height = 0.3,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.07,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.05,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 18,
						particle_name = "radar-long-metal-particle-medium",
						offset_deviation = { { -0.5, -0.5 }, { 0.5, 0.5 } },
						initial_height = 0.2,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.095,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.03,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 21,
						particle_name = "cable-and-electronics-particle-small-medium",
						offset_deviation = { { -0.5, -0.5 }, { 0.5, 0.5 } },
						initial_height = 0.3,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.082,
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
