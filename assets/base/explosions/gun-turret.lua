-- This file is generated from the source of the base game by reskins-workspace/tools/base_explosions/generate.py.

---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Base.Explosions

local explosion_animations = require("__base__.prototypes.entity.explosion-animations")
local sounds = require("__base__.prototypes.entity.sounds")
local Particles = require("assets.base.particles")

local M = {}

---Gets the dying explosion of the vanilla gun turret. Each particle named in `params.tints` is replaced by a copy in
---the given tint.
---
---The explosion creates these particles:
---- `gun-turret-metal-particle-big`
---- `gun-turret-metal-particle-medium`
---- `gun-turret-metal-particle-small`
---@param params? BaseExplosionParams The options for the explosion.
---@return ExplosionSpriteSet # The dying explosion.
---@nodiscard
function M.get_explosion(params)
	local tints = params and params.tints

	return {
		flags = { "not-on-map" },
		hidden = true,
		subgroup = "defensive-structure-explosions",
		order = "b-c-a",
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
						repeat_count = 12,
						particle_name = "gun-turret-metal-particle-big",
						offset_deviation = { { -0.5, -0.5 }, { 0.5, 0.5 } },
						initial_height = 0.5,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.068,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.04,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 20,
						particle_name = "gun-turret-metal-particle-medium",
						offset_deviation = { { -0.5, -0.5 }, { 0.5, 0.5 } },
						initial_height = 0.5,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.055,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.05,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 25,
						particle_name = "gun-turret-metal-particle-small",
						offset_deviation = { { -0.5, -0.5 }, { 0.5, 0.5 } },
						initial_height = 0.4,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.071,
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
