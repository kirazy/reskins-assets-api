---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Entities

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")
local DefenderRobotExplosion = require("assets.base.explosions.defender-robot")
local Remnants = require("assets.base.remnants")

local ASSETS_BOBS_PATH = "__reskins-assets-bobs__/graphics/entity/robot-laser/"

---The tint of the small metal particles of the dying explosion, by the name of the particle.
---@type table<ParticleID, Color>
local particle_tints = {
	["defender-robot-metal-particle-small"] = util.color("#7f4eca") --[[@as Color]],
}

local M = {}

---Gets the animation of the laser robot.
---@return RotatedAnimation
local function get_animation()
	return {
		filename = ASSETS_BOBS_PATH .. "laser-robot.png",
		priority = "high",
		width = 64,
		height = 64,
		direction_count = 1,
		scale = 0.5,
	}
end

---Gets the shadow of the laser robot.
---@return RotatedAnimation
local function get_shadow()
	return {
		filename = ASSETS_BOBS_PATH .. "laser-robot-shadow.png",
		priority = "high",
		width = 64,
		height = 64,
		direction_count = 1,
		draw_as_shadow = true,
		scale = 0.5,
	}
end

---Gets the animation of the laser robot remnants.
---@return RotatedAnimationVariations
local function get_corpse_animation()
	return {
		filename = ASSETS_BOBS_PATH .. "remnants/laser-robot-remnants.png",
		width = 98,
		height = 94,
		direction_count = 1,
		scale = 0.5,
	}
end

---Gets the water reflection of the laser robot.
---@return WaterReflectionDefinition
local function get_water_reflection()
	return {
		pictures = {
			filename = "__base__/graphics/entity/construction-robot/construction-robot-reflection.png",
			priority = "extra-high",
			width = 12,
			height = 12,
			shift = util.by_pixel(0, 105),
			variation_count = 1,
			scale = 6,
		},
		rotate = false,
		orientation_to_variation = false,
	}
end

---Gets the sprite set for the laser robot.
---@return SpriteSetDefinition<CombatRobotSpriteSet> # The sprite set definition for the laser robot.
---
---#### Examples
---```lua
---local robot_laser = require("__reskins-assets-api__.assets.bobs.entities.robot-laser")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = robot_laser.get_sprite_set()
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set()
	---@type SpriteSetDefinition<CombatRobotSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.combat_robot_sprite_set,
		set = {
			idle = get_animation(),
			in_motion = get_animation(),
			shadow_idle = get_shadow(),
			shadow_in_motion = get_shadow(),
			light = nil,

			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = DefenderRobotExplosion.get_explosion({ tints = util.copy(particle_tints) }),
			corpse = Remnants.get_corpse("defender-remnants", { animation = get_corpse_animation() }),
			water_reflection = get_water_reflection(),
			nominal_width = 1,
			nominal_height = 1,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-bobs__/graphics/icons" })

---Gets the icon for the laser robot.
M.get_icon = icons:flat("laser-robot"):build("get_icon")

return M
