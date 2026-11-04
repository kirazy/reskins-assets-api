-- This file is generated from the source of the base game by reskins-workspace/tools/base_explosions/generate.py.

---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Base.Explosions

local explosion_animations = require("__base__.prototypes.entity.explosion-animations")
local sounds = require("__base__.prototypes.entity.sounds")
local Particles = require("assets.base.particles")

local M = {}

---Gets the dying explosion of the vanilla steam engine. Each particle named in `params.tints` is replaced by a copy in
---the given tint.
---
---The explosion creates these particles:
---- `steam-engine-metal-particle-big`
---- `steam-engine-metal-particle-medium`
---- `steam-engine-metal-particle-small`
---- `steam-engine-mechanical-component-particle-medium`
---@param params? BaseExplosionParams The options for the explosion.
---@return ExplosionSpriteSet # The dying explosion.
---@nodiscard
function M.get_explosion(params)
	local tints = params and params.tints

	return {
		flags = { "not-on-map" },
		hidden = true,
		subgroup = "energy-explosions",
		order = "a-b-a",
		height = 0,
		animations = explosion_animations.medium_explosion(),
		smoke = "smoke-fast",
		smoke_count = 2,
		smoke_slow_down_factor = 1,
		sound = sounds.large_explosion(0.8),
		created_effect = {
			type = "direct",
			action_delivery = {
				type = "instant",
				target_effects = {
					{
						type = "create-particle",
						repeat_count = 16,
						particle_name = "steam-engine-metal-particle-big",
						offset_deviation = { { -0.5, -0.6953 }, { 0.5, 0.6953 } },
						initial_height = 0.5,
						initial_height_deviation = 0.49,
						initial_vertical_speed = 0.063,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.05,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 40,
						particle_name = "steam-engine-metal-particle-medium",
						offset_deviation = { { -0.6953, -0.5 }, { 0.6953, 0.5 } },
						initial_height = 0.7,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.09,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.04,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 45,
						particle_name = "steam-engine-metal-particle-small",
						offset_deviation = { { -0.8945, -0.7969 }, { 0.8945, 0.7969 } },
						initial_height = 1,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.089,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.05,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 25,
						particle_name = "steam-engine-mechanical-component-particle-medium",
						offset_deviation = { { -0.5, -0.5 }, { 0.5, 0.5 } },
						initial_height = 0.5,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.037,
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
