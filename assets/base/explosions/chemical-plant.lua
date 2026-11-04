-- This file is generated from the source of the base game by reskins-workspace/tools/base_explosions/generate.py.

---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Base.Explosions

local explosion_animations = require("__base__.prototypes.entity.explosion-animations")
local sounds = require("__base__.prototypes.entity.sounds")
local Particles = require("assets.base.particles")

local M = {}

---Gets the dying explosion of the vanilla chemical plant. Each particle named in `params.tints` is replaced by a copy
---in the given tint.
---
---The explosion creates these particles:
---- `chemical-plant-metal-particle-big`
---- `chemical-plant-metal-particle-medium`
---- `chemical-plant-metal-particle-small`
---- `chemical-plant-glass-particle-small`
---- `chemical-plant-mechanical-component-particle-medium`
---@param params? BaseExplosionParams The options for the explosion.
---@return ExplosionSpriteSet # The dying explosion.
---@nodiscard
function M.get_explosion(params)
	local tints = params and params.tints

	return {
		flags = { "not-on-map" },
		hidden = true,
		subgroup = "production-machine-explosions",
		order = "d-e-a",
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
						repeat_count = 18,
						particle_name = "chemical-plant-metal-particle-big",
						offset_deviation = { { -0.6875, -0.6875 }, { 0.6875, 0.6875 } },
						initial_height = 0.2,
						initial_height_deviation = 0.49,
						initial_vertical_speed = 0.08,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.04,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 31,
						particle_name = "chemical-plant-metal-particle-medium",
						offset_deviation = { { -0.9805, -0.8945 }, { 0.9805, 0.8945 } },
						initial_height = 0.4,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.101,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.05,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 26,
						particle_name = "chemical-plant-metal-particle-small",
						offset_deviation = { { -0.9961, -0.5938 }, { 0.9961, 0.5938 } },
						initial_height = 0.4,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.072,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.04,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 43,
						particle_name = "chemical-plant-glass-particle-small",
						offsets = { { 0.7109, 0.7578 } },
						offset_deviation = { { -0.5, -0.2969 }, { 0.5, 0.2969 } },
						initial_height = 0.4,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.096,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.05,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 40,
						particle_name = "chemical-plant-mechanical-component-particle-medium",
						offset_deviation = { { -0.5, -0.5 }, { 0.5, 0.5 } },
						initial_height = 0.5,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.085,
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
