-- This file is generated from the source of the base game by reskins-workspace/tools/base_explosions/generate.py.

---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Base.Explosions

local explosion_animations = require("__base__.prototypes.entity.explosion-animations")
local sounds = require("__base__.prototypes.entity.sounds")
local Particles = require("assets.base.particles")

local M = {}

---Gets the dying explosion of the vanilla electric furnace. Each particle named in `params.tints` is replaced by a copy
---in the given tint.
---
---The explosion creates these particles:
---- `electric-furnace-metal-particle-big`
---- `electric-furnace-metal-particle-medium`
---- `electric-furnace-metal-particle-small`
---@param params? BaseExplosionParams The options for the explosion.
---@return ExplosionSpriteSet # The dying explosion.
---@nodiscard
function M.get_explosion(params)
	local tints = params and params.tints

	return {
		flags = { "not-on-map" },
		hidden = true,
		subgroup = "smelting-machine-explosions",
		order = "c-c-a",
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
						repeat_count = 14,
						particle_name = "electric-furnace-metal-particle-big",
						offset_deviation = { { -0.6875, -0.6875 }, { 0.6875, 0.6875 } },
						initial_height = 0.3,
						initial_height_deviation = 0.49,
						initial_vertical_speed = 0.088,
						initial_vertical_speed_deviation = 0,
						speed_from_center = 0.04,
						speed_from_center_deviation = 0.02,
					},
					{
						type = "create-particle",
						repeat_count = 30,
						particle_name = "electric-furnace-metal-particle-medium",
						offset_deviation = { { -0.582, -0.5938 }, { 0.582, 0.5938 } },
						initial_height = 0.5,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.078,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.04,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 17,
						particle_name = "electric-furnace-metal-particle-small",
						offsets = { { 0.2891, 0.01563 }, { -0.2109, -0.01563 } },
						offset_deviation = { { -0.8945, -0.8906 }, { 0.8945, 0.8906 } },
						initial_height = 0.2,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.083,
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
