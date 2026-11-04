-- This file is generated from the source of the base game by reskins-workspace/tools/base_explosions/generate.py.

---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Base.Explosions

local explosion_animations = require("__base__.prototypes.entity.explosion-animations")
local sounds = require("__base__.prototypes.entity.sounds")
local Particles = require("assets.base.particles")

local M = {}

---Gets the dying explosion of the vanilla nuclear reactor. Each particle named in `params.tints` is replaced by a copy
---in the given tint.
---
---The explosion creates these particles:
---- `nuclear-reactor-metal-particle-big`
---- `nuclear-reactor-metal-particle-medium`
---- `nuclear-reactor-glass-particle-small`
---- `nuclear-reactor-metal-particle-small`
---- `cable-and-electronics-particle-small-medium`
---- `nuclear-reactor-mechanical-component-particle-medium`
---@param params? BaseExplosionParams The options for the explosion.
---@return ExplosionSpriteSet # The dying explosion.
---@nodiscard
function M.get_explosion(params)
	local tints = params and params.tints

	return {
		flags = { "not-on-map" },
		hidden = true,
		subgroup = "energy-explosions",
		order = "a-d-a",
		height = 0,
		animations = explosion_animations.massive_explosion(),
		smoke = "smoke-fast",
		smoke_count = 2,
		smoke_slow_down_factor = 1,
		sound = sounds.large_explosion(0.7, 1.0),
		created_effect = {
			type = "direct",
			action_delivery = {
				type = "instant",
				target_effects = {
					{
						type = "create-particle",
						repeat_count = 39,
						particle_name = "nuclear-reactor-metal-particle-big",
						offset_deviation = { { -0.6914, -0.793 }, { 0.6914, 0.793 } },
						initial_height = 1,
						initial_height_deviation = 0.49,
						initial_vertical_speed = 0.083,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.05,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 31,
						particle_name = "nuclear-reactor-metal-particle-medium",
						offsets = { { -0.2891, 0.2344 } },
						offset_deviation = { { -0.6914, -0.5 }, { 0.6914, 0.5 } },
						initial_height = 0.4,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.096,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.05,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 48,
						particle_name = "nuclear-reactor-glass-particle-small",
						offsets = { { -0.6641, 0.6406 } },
						offset_deviation = { { -0.8945, -0.7969 }, { 0.8945, 0.7969 } },
						initial_height = 0.3,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.099,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.03,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 41,
						particle_name = "nuclear-reactor-metal-particle-small",
						offset_deviation = { { -0.8945, -0.7969 }, { 0.8945, 0.7969 } },
						initial_height = 0.3,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.089,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.05,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 25,
						particle_name = "cable-and-electronics-particle-small-medium",
						offsets = { { 0.5234, -0.4609 } },
						offset_deviation = { { -0.5, -0.5 }, { 0.5, 0.5 } },
						initial_height = 0.3,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.093,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.05,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 12,
						particle_name = "nuclear-reactor-mechanical-component-particle-medium",
						offsets = { { -0.6641, 0.6406 } },
						offset_deviation = { { -0.8906, -0.7969 }, { 0.8906, 0.7969 } },
						initial_height = 0.3,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.099,
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
