-- This file is generated from the source of the base game by reskins-workspace/tools/base_explosions/generate.py.

---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Base.Explosions

local explosion_animations = require("__base__.prototypes.entity.explosion-animations")
local sounds = require("__base__.prototypes.entity.sounds")
local Particles = require("assets.base.particles")

local M = {}

---Gets the explosion `transport-belt-explosion-base` that the dying explosion creates. Each particle named in `tints`
---is replaced by a copy in the given tint.
---@param tints? table<ParticleID, Color?>
---@return ExplosionSpriteSet
local function get_transport_belt_explosion_base(tints)
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
						speed_from_center = 0.008,
						speed_from_center_deviation = 0.03,
					},
					{
						type = "create-particle",
						repeat_count = 1,
						particle_name = "transport-belt-metal-particle-medium",
						offset_deviation = { { -0.5, -0.5 }, { 0.5, 0.5 } },
						initial_height = 0.1,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.09,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.04,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 4,
						particle_name = "transport-belt-metal-particle-small",
						offset_deviation = { { -0.5, -0.5 }, { 0.5, 0.5 } },
						initial_height = 0.1,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.071,
						initial_vertical_speed_deviation = 0.05,
						speed_from_center = 0.03,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 20,
						particle_name = "transport-belt-wooden-splinter-particle-medium",
						offset_deviation = { { -0.5, -0.5 }, { 0.5, 0.5 } },
						initial_height = 0.1,
						initial_height_deviation = 0.5,
						initial_vertical_speed = 0.08,
						initial_vertical_speed_deviation = 0.016,
						speed_from_center = 0.04,
						speed_from_center_deviation = 0.05,
					},
					{
						type = "create-particle",
						repeat_count = 5,
						particle_name = "transport-belt-mechanical-component-particle-medium",
						offset_deviation = { { -0.5, -0.5 }, { 0.5, 0.5 } },
						initial_height = 0.1,
						initial_height_deviation = 0.32,
						initial_vertical_speed = 0.041,
						initial_vertical_speed_deviation = 0.042,
						speed_from_center = 0.01,
						speed_from_center_deviation = 0.05,
					},
				},
			},
		},
		particles = Particles.get_particles(tints),
	}
end

---Gets the dying explosion of the vanilla transport belt. Each particle named in `params.tints` is replaced by a copy
---in the given tint.
---
---The explosion creates `transport-belt-explosion-base`, which creates these particles:
---- `transport-belt-metal-particle-medium`
---- `transport-belt-metal-particle-small`
---- `transport-belt-wooden-splinter-particle-medium`
---- `transport-belt-mechanical-component-particle-medium`
---@param params? BaseExplosionParams The options for the explosion.
---@return ExplosionSpriteSet # The dying explosion.
---@nodiscard
function M.get_explosion(params)
	local tints = params and params.tints

	return {
		flags = { "not-on-map" },
		hidden = true,
		subgroup = "belt-explosions",
		order = "b-a-a",
		animations = util.empty_sprite(),
		created_effect = {
			type = "direct",
			action_delivery = {
				type = "instant",
				target_effects = {
					{
						type = "create-explosion",
						entity_name = "transport-belt-explosion-base",
						offsets = { { 0, 0.3 } },
						offset_deviation = { { -0.25, -0.25 }, { 0.25, 0.25 } },
					},
				},
			},
		},
		explosions = Particles.has_tints(tints) and {
			["transport-belt-explosion-base"] = get_transport_belt_explosion_base(tints),
		} or nil,
	}
end

return M
