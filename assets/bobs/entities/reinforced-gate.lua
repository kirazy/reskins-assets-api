---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Entities

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")
local GateExplosion = require("assets.base.explosions.gate")
local Remnants = require("assets.base.remnants")

local ASSETS_BOBS_PATH = "__reskins-assets-bobs__/graphics/entity/reinforced-gate/"

---The tint of the big and medium metal particles in the dying explosion, by the name of the particle.
---@type table<ParticleID, Color>
local particle_tints = {
	["gate-metal-particle-big"] = util.color("#6f647d") --[[@as Color]],
	["gate-metal-particle-medium"] = util.color("#a695ba") --[[@as Color]],
}

local M = {}

---Gets the animation of the gate from the sheet of the given `name`.
---@param name string The name of the sheet in the file name, such as `"rail-base-vertical"`.
---@param width integer The width of one frame, in pixels.
---@param height integer The height of one frame, in pixels.
---@param shift Vector The shift of the animation.
---@return Animation
local function get_animation(name, width, height, shift)
	return {
		filename = ASSETS_BOBS_PATH .. "reinforced-gate-" .. name .. ".png",
		line_length = 8,
		width = width,
		height = height,
		frame_count = 16,
		shift = shift,
		scale = 0.5,
	}
end

---Gets the gate shadow animation from the sheet with the given `name`.
---@param name string The name of the sheet in the file name, such as `"rail-vertical-shadow-left"`.
---@param width integer The width of one frame, in pixels.
---@param height integer The height of one frame, in pixels.
---@param shift Vector The shift of the animation.
---@return Animation
local function get_shadow(name, width, height, shift)
	return {
		filename = ASSETS_BOBS_PATH .. "shadows/reinforced-gate-" .. name .. ".png",
		line_length = 8,
		width = width,
		height = height,
		frame_count = 16,
		shift = shift,
		draw_as_shadow = true,
		scale = 0.5,
	}
end

---Gets the animation of the gate remnants.
---@return RotatedAnimationVariations
local function get_corpse_animation()
	return {
		{
			filename = ASSETS_BOBS_PATH .. "remnants/reinforced-gate-remnants-var-1.png",
			line_length = 1,
			width = 86,
			height = 82,
			direction_count = 4,
			shift = util.by_pixel(0, 1),
			scale = 0.5,
		},
		{
			filename = ASSETS_BOBS_PATH .. "remnants/reinforced-gate-remnants-var-2.png",
			line_length = 1,
			width = 84,
			height = 82,
			direction_count = 4,
			shift = util.by_pixel(-0.5, 0),
			scale = 0.5,
		},
		{
			filename = ASSETS_BOBS_PATH .. "remnants/reinforced-gate-remnants-var-3.png",
			line_length = 1,
			width = 82,
			height = 84,
			direction_count = 4,
			shift = util.by_pixel(0, 0.5),
			scale = 0.5,
		},
	}
end

---Gets the sprite set for the reinforced gate.
---@return SpriteSetDefinition<GateSpriteSet> # The sprite set definition for the reinforced gate.
---
---#### Examples
---```lua
---local reinforced_gate = require("__reskins-assets-api__.assets.bobs.entities.reinforced-gate")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = reinforced_gate.get_sprite_set()
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set()
	---@type SpriteSetDefinition<GateSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.gate_sprite_set,
		set = {
			vertical_animation = {
				layers = {
					get_animation("vertical", 78, 120, util.by_pixel(-1, -13)),
					get_shadow("vertical-shadow", 82, 104, util.by_pixel(9, 9)),
				},
			},
			horizontal_animation = {
				layers = {
					get_animation("horizontal", 66, 90, util.by_pixel(0, -3)),
					get_shadow("horizontal-shadow", 122, 60, util.by_pixel(12, 10)),
				},
			},
			vertical_rail_animation_left = {
				layers = {
					get_animation("rail-vertical-left", 42, 118, util.by_pixel(0, -13)),
					get_shadow("rail-vertical-shadow-left", 82, 104, util.by_pixel(9, 9)),
				},
			},
			vertical_rail_animation_right = {
				layers = {
					get_animation("rail-vertical-right", 42, 118, util.by_pixel(0, -13)),
					get_shadow("rail-vertical-shadow-right", 82, 104, util.by_pixel(9, 9)),
				},
			},
			horizontal_rail_animation_left = {
				layers = {
					get_animation("rail-horizontal-left", 66, 74, util.by_pixel(0, -7)),
					get_shadow("rail-horizontal-shadow-left", 122, 60, util.by_pixel(12, 10)),
				},
			},
			horizontal_rail_animation_right = {
				layers = {
					get_animation("rail-horizontal-right", 66, 74, util.by_pixel(0, -7)),
					get_shadow("rail-horizontal-shadow-right", 122, 58, util.by_pixel(12, 11)),
				},
			},
			vertical_rail_base = get_animation("rail-base-vertical", 138, 130, util.by_pixel(-1, 0)),
			horizontal_rail_base = get_animation("rail-base-horizontal", 130, 104, util.by_pixel(0, 3)),
			wall_patch = {
				layers = {
					get_animation("wall-patch", 70, 94, util.by_pixel(-1, 13)),
					get_shadow("wall-patch-shadow", 82, 72, util.by_pixel(9, 33)),
				},
			},
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = GateExplosion.get_explosion({ tints = util.copy(particle_tints) }),
			corpse = Remnants.get_corpse("gate-remnants", { animation = get_corpse_animation() }),
			water_reflection = nil,
			nominal_width = 1,
			nominal_height = 1,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-bobs__/graphics/icons" })

local icon_builder = icons:flat("reinforced-gate")

---Gets the icon for the reinforced gate.
M.get_icon = icon_builder:build("get_icon")

---Gets the icon for the reinforced gate as an `IconComposition`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
