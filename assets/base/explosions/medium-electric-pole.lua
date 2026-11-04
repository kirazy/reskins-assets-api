-- This file is generated from the source of the base game by reskins-workspace/tools/base_explosions/generate.py.

---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Base.Explosions

local explosion_animations = require("__base__.prototypes.entity.explosion-animations")
local sounds = require("__base__.prototypes.entity.sounds")
local Particles = require("assets.base.particles")

local M = {}

---Gets the dying explosion of the vanilla medium electric pole. Each particle named in `params.tints` is replaced by a
---copy in the given tint.
---
---The explosion creates these particles:
---- `medium-electric-pole-long-metal-particle-medium`
---- `medium-electric-pole-metal-particle-small`
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
		order = "d-b-a",
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
						repeat_count = 20,
						particle_name = "medium-electric-pole-long-metal-particle-medium",
						offset_deviation = { { -0.5, -0.6953 }, { 0.5, 0.6953 } },
						initial_height = 0.8,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.041,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.05,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 25,
						particle_name = "medium-electric-pole-metal-particle-small",
						offset_deviation = { { -0.5977, -0.7891 }, { 0.5977, 0.7891 } },
						initial_height = 0.8,
						initial_height_deviation = 0.44,
						initial_vertical_speed = 0.07,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.06,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 11,
						particle_name = "cable-and-electronics-particle-small-medium",
						offset_deviation = { { -0.5, -0.5 }, { 0.5, 0.5 } },
						initial_height = 0.6,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.028,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.05,
						speed_from_center_deviation = 0.047,
					},
				},
			},
		},
		particles = Particles.get_particles(tints),
	}
end

return M
