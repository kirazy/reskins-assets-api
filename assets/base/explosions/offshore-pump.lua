-- This file is generated from the source of the base game by reskins-workspace/tools/base_explosions/generate.py.

---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Base.Explosions

local explosion_animations = require("__base__.prototypes.entity.explosion-animations")
local sounds = require("__base__.prototypes.entity.sounds")
local Particles = require("assets.base.particles")

local M = {}

---Gets the dying explosion of the vanilla offshore pump. Each particle named in `params.tints` is replaced by a copy in
---the given tint.
---
---The explosion creates these particles:
---- `offshore-pump-metal-particle-big`
---- `offshore-pump-metal-particle-medium`
---- `offshore-pump-metal-particle-small`
---- `offshore-pump-glass-particle-small`
---- `offshore-pump-mechanical-component-particle-medium`
---@param params? BaseExplosionParams The options for the explosion.
---@return ExplosionSpriteSet # The dying explosion.
---@nodiscard
function M.get_explosion(params)
	local tints = params and params.tints

	return {
		flags = { "not-on-map" },
		hidden = true,
		subgroup = "extraction-machine-explosions",
		order = "b-c-a",
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
						particle_name = "offshore-pump-metal-particle-big",
						offset_deviation = { { -0.6875, -0.6875 }, { 0.6875, 0.6875 } },
						initial_height = 0.1,
						initial_height_deviation = 0.49,
						initial_vertical_speed = 0.074,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.03,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 14,
						particle_name = "offshore-pump-metal-particle-medium",
						offset_deviation = { { -0.582, -0.8945 }, { 0.582, 0.8945 } },
						initial_height = 0.2,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.091,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.03,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 21,
						particle_name = "offshore-pump-metal-particle-small",
						offset_deviation = { { -0.8945, -0.8906 }, { 0.8945, 0.8906 } },
						initial_height = 0.1,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.066,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.03,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 23,
						particle_name = "offshore-pump-glass-particle-small",
						offset_deviation = { { -0.5, -0.5 }, { 0.5, 0.5 } },
						initial_height = 0.3,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.092,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.05,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 14,
						particle_name = "offshore-pump-mechanical-component-particle-medium",
						offset_deviation = { { -0.5, -0.5 }, { 0.5, 0.5 } },
						initial_height = 0.4,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.061,
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
