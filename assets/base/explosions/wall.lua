-- This file is generated from the source of the base game by reskins-workspace/tools/base_explosions/generate.py.

---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Base.Explosions

local explosion_animations = require("__base__.prototypes.entity.explosion-animations")
local sounds = require("__base__.prototypes.entity.sounds")
local Particles = require("assets.base.particles")

local M = {}

---Gets the dying explosion of the vanilla wall. Each particle named in `params.tints` is replaced by a copy in the
---given tint.
---
---The explosion creates these particles:
---- `wall-stone-particle-medium`
---- `wall-stone-particle-small`
---- `wall-stone-particle-tiny`
---@param params? BaseExplosionParams The options for the explosion.
---@return ExplosionSpriteSet # The dying explosion.
---@nodiscard
function M.get_explosion(params)
	local tints = params and params.tints

	return {
		flags = { "not-on-map" },
		hidden = true,
		subgroup = "defensive-structure-explosions",
		order = "b-a-a",
		height = 0,
		animations = util.empty_sprite(),
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
						repeat_count = 16,
						particle_name = "wall-stone-particle-medium",
						offset_deviation = { { -0.1953, -0.1953 }, { 0.1953, 0.1953 } },
						initial_height = 0.3,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.078,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.03,
						speed_from_center_deviation = 0.048,
					},
					{
						type = "create-particle",
						repeat_count = 28,
						particle_name = "wall-stone-particle-small",
						offset_deviation = { { -0.1953, -0.1992 }, { 0.1953, 0.1992 } },
						initial_height = 0.9,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.077,
						initial_vertical_speed_deviation = 0.049,
						speed_from_center = 0.03,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 46,
						particle_name = "wall-stone-particle-tiny",
						offset_deviation = { { -0.3906, -0.4883 }, { 0.3906, 0.4883 } },
						initial_height = 1,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.076,
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
