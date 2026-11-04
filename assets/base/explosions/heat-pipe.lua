-- This file is generated from the source of the base game by reskins-workspace/tools/base_explosions/generate.py.

---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Base.Explosions

local explosion_animations = require("__base__.prototypes.entity.explosion-animations")
local sounds = require("__base__.prototypes.entity.sounds")
local Particles = require("assets.base.particles")

local M = {}

---Gets the dying explosion of the vanilla heat pipe. Each particle named in `params.tints` is replaced by a copy in the
---given tint.
---
---The explosion creates these particles:
---- `heat-pipe-metal-particle-small`
---- `heat-pipe-metal-particle-medium`
---@param params? BaseExplosionParams The options for the explosion.
---@return ExplosionSpriteSet # The dying explosion.
---@nodiscard
function M.get_explosion(params)
	local tints = params and params.tints

	return {
		flags = { "not-on-map" },
		hidden = true,
		subgroup = "energy-explosions",
		order = "a-e-a",
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
						repeat_count = 15,
						particle_name = "heat-pipe-metal-particle-small",
						offsets = { { 0, 0 } },
						offset_deviation = { { -0.3906, -0.2969 }, { 0.3906, 0.2969 } },
						initial_height = 0.1,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.028,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.03,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 9,
						particle_name = "heat-pipe-metal-particle-medium",
						offsets = { { 0, 0 } },
						offset_deviation = { { -0.09375, -0.1875 }, { 0.09375, 0.1875 } },
						initial_height = 0.1,
						initial_height_deviation = 0.49,
						initial_vertical_speed = 0.046,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.04,
						speed_from_center_deviation = 0.016,
					},
				},
			},
		},
		particles = Particles.get_particles(tints),
	}
end

return M
