-- This file is generated from the source of the base game by reskins-workspace/tools/base_explosions/generate.py.

---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Base.Explosions

local explosion_animations = require("__base__.prototypes.entity.explosion-animations")
local sounds = require("__base__.prototypes.entity.sounds")
local Particles = require("assets.base.particles")

local M = {}

---Gets the explosion `pipe-explosion-base` that the dying explosion creates. Each particle named in `tints` is replaced
---by a copy in the given tint.
---@param tints? table<ParticleID, Color?>
---@return ExplosionSpriteSet
local function get_pipe_explosion_base(tints)
	return {
		flags = { "not-on-map" },
		hidden = true,
		height = 0,
		animations = explosion_animations.small_dust_explosion(),
		sound = sounds.small_explosion,
		created_effect = {
			type = "direct",
			action_delivery = {
				type = "instant",
				target_effects = {
					{
						type = "create-trivial-smoke",
						repeat_count = 10,
						smoke_name = "small-dusty-explosion-smoke",
						offset_deviation = { { -0.4, -0.4 }, { 0.4, 0.4 } },
						initial_height = 0,
						speed_from_center = 0.005,
						speed_from_center_deviation = 0.02,
					},
					{
						type = "create-particle",
						repeat_count = 10,
						particle_name = "pipe-metal-particle-medium",
						offset_deviation = { { -0.3945, -0.3867 }, { 0.3945, 0.3867 } },
						initial_height = 0.2,
						initial_height_deviation = 0.44,
						initial_vertical_speed = 0.078,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.04,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 12,
						particle_name = "pipe-metal-particle-small",
						offset_deviation = { { -0.3984, -0.2969 }, { 0.3984, 0.2969 } },
						initial_height = 0.2,
						initial_height_deviation = 0.48,
						initial_vertical_speed = 0.099,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.03,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 25,
						particle_name = "pipe-glass-particle-small",
						offset_deviation = { { -0.5, -0.6992 }, { 0.5, 0.6992 } },
						initial_height = 0.2,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.09,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.03,
						speed_from_center_deviation = 0.05,
						frame_speed = 1,
						frame_speed_deviation = 0.05,
					},
				},
			},
		},
		particles = Particles.get_particles(tints),
	}
end

---Gets the dying explosion of the vanilla pipe. Each particle named in `params.tints` is replaced by a copy in the
---given tint.
---
---The explosion creates `pipe-explosion-base`, which creates these particles:
---- `pipe-metal-particle-medium`
---- `pipe-metal-particle-small`
---- `pipe-glass-particle-small`
---@param params? BaseExplosionParams The options for the explosion.
---@return ExplosionSpriteSet # The dying explosion.
---@nodiscard
function M.get_explosion(params)
	local tints = params and params.tints

	return {
		flags = { "not-on-map" },
		hidden = true,
		subgroup = "energy-pipe-distribution-explosions",
		order = "d-f-a",
		animations = util.empty_sprite(),
		created_effect = {
			type = "direct",
			action_delivery = {
				type = "instant",
				target_effects = {
					{
						type = "create-explosion",
						entity_name = "pipe-explosion-base",
						offsets = { { 0, 0.3 } },
						offset_deviation = { { -0.15, -0.15 }, { 0.15, 0.15 } },
					},
				},
			},
		},
		explosions = Particles.has_tints(tints) and { ["pipe-explosion-base"] = get_pipe_explosion_base(tints) } or nil,
	}
end

return M
