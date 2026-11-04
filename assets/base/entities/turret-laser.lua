---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local _sprites = require("__reskins-sprite-utils__.sprites")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local IconBuilderFactory = require("api.icon-builder-factory")

local BASE_PATH = "__base__/graphics/entity/laser-turret/"
local ASSETS_PATH = "__reskins-assets-base__/graphics/entity/turret-laser/"
local LASER_BEAMS_PATH = "__reskins-assets-bobs__/graphics/entity/laser-beams/"

local M = {}

local LaserBeamLens = V.one_of({ "amethyst", "diamond", "emerald", "glass", "ruby", "sapphire", "topaz" })

---Gets the animation of the laser turret as it raises and lowers the laser.
---@param frame_count integer
---@param line_length integer
---@param run_mode AnimationRunMode
---@return RotatedAnimation
local function get_extension_animation(frame_count, line_length, run_mode)
	return {
		layers = {
			{
				filename = BASE_PATH .. "laser-turret-raising.png",
				priority = "medium",
				width = 130,
				height = 126,
				frame_count = frame_count,
				line_length = line_length,
				run_mode = run_mode,
				direction_count = 4,
				shift = util.by_pixel(0, -32.5),
				scale = 0.5,
			},
			{
				filename = BASE_PATH .. "laser-turret-raising-mask.png",
				flags = { "mask" },
				width = 86,
				height = 80,
				frame_count = frame_count,
				line_length = line_length,
				run_mode = run_mode,
				apply_runtime_tint = true,
				direction_count = 4,
				shift = util.by_pixel(0, -43),
				scale = 0.5,
			},
			{
				filename = BASE_PATH .. "laser-turret-raising-shadow.png",
				width = 182,
				height = 96,
				frame_count = frame_count,
				line_length = line_length,
				run_mode = run_mode,
				direction_count = 4,
				draw_as_shadow = true,
				shift = util.by_pixel(47, 2.5),
				scale = 0.5,
			},
		},
	}
end

---Gets the animation of the laser turret as it aims and shoots.
---@return RotatedAnimation
local function get_shooting_animation()
	return {
		layers = {
			{
				filename = BASE_PATH .. "laser-turret-shooting.png",
				line_length = 8,
				width = 126,
				height = 120,
				direction_count = 64,
				shift = util.by_pixel(0, -35),
				scale = 0.5,
			},
			{
				filename = BASE_PATH .. "laser-turret-shooting-mask.png",
				flags = { "mask" },
				line_length = 8,
				width = 92,
				height = 80,
				apply_runtime_tint = true,
				direction_count = 64,
				shift = util.by_pixel(0, -43.5),
				scale = 0.5,
			},
			{
				filename = BASE_PATH .. "laser-turret-shooting-shadow.png",
				line_length = 8,
				width = 170,
				height = 92,
				direction_count = 64,
				draw_as_shadow = true,
				shift = util.by_pixel(50.5, 2.5),
				scale = 0.5,
			},
		},
	}
end

---Gets the glow of the laser turret as it shoots.
---@param lens? LaserBeamLens When `nil`, the glow of the base game is drawn.
---@return RotatedAnimation
local function get_shooting_glow(lens)
	local filename = lens and LASER_BEAMS_PATH .. lens .. "/laser-" .. lens .. "-turret-shooting-light.png"
		or BASE_PATH .. "laser-turret-shooting-light.png"

	return {
		filename = filename,
		line_length = 8,
		width = 122,
		height = 116,
		direction_count = 64,
		shift = util.by_pixel(-0.5, -35),
		blend_mode = "additive",
		scale = 0.5,
	}
end

---Gets the graphics set of the laser turret, which draws the base of the turret.
---@param tint? Color
---@return TurretGraphicsSet
local function get_graphics_set(tint)
	local layers = {
		{
			filename = BASE_PATH .. "laser-turret-base.png",
			priority = "high",
			width = 138,
			height = 104,
			shift = util.by_pixel(-0.5, 2),
			scale = 0.5,
		},
	}

	if tint then
		layers[#layers + 1] = {
			filename = ASSETS_PATH .. "turret-laser-base-mask.png",
			priority = "high",
			width = 138,
			height = 104,
			shift = util.by_pixel(-0.5, 2),
			tint = tint,
			scale = 0.5,
		}
		layers[#layers + 1] = {
			filename = ASSETS_PATH .. "turret-laser-base-highlights.png",
			priority = "high",
			width = 138,
			height = 104,
			shift = util.by_pixel(-0.5, 2),
			blend_mode = "additive",
			scale = 0.5,
		}
	end

	layers[#layers + 1] = {
		filename = BASE_PATH .. "laser-turret-base-shadow.png",
		line_length = 1,
		width = 132,
		height = 82,
		draw_as_shadow = true,
		shift = util.by_pixel(6, 3),
		scale = 0.5,
	}

	return { base_visualisation = { animation = { layers = layers } } }
end

---Gets the circuit connector of the laser turret.
---@return CircuitConnectorDefinition[]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 17,
			main_offset = util.by_pixel(-11, -3),
			shadow_offset = util.by_pixel(-7, 10),
			show_shadow = true,
		},
	})
end

---Gets the water reflection of the laser turret.
---@return WaterReflectionDefinition
local function get_water_reflection()
	return {
		pictures = {
			filename = BASE_PATH .. "laser-turret-reflection.png",
			priority = "extra-high",
			width = 20,
			height = 32,
			shift = util.by_pixel(0, 40),
			variation_count = 1,
			scale = 5,
		},
		rotate = false,
		orientation_to_variation = false,
	}
end

---Gets the animation of the laser turret remnants.
---@param tint? Color
---@return RotatedAnimationVariations
local function get_corpse_animation(tint)
	local layers = {
		{
			filename = BASE_PATH .. "remnants/laser-turret-remnants.png",
			line_length = 1,
			width = 198,
			height = 194,
			direction_count = 1,
			shift = util.by_pixel(2.5, -2),
			scale = 0.5,
		},
	}

	if tint then
		layers[#layers + 1] = {
			filename = ASSETS_PATH .. "remnants/turret-laser-remnants-mask.png",
			width = 198,
			height = 194,
			direction_count = 1,
			shift = util.by_pixel(2.5, -2),
			tint = tint,
			scale = 0.5,
		}
		layers[#layers + 1] = {
			filename = ASSETS_PATH .. "remnants/turret-laser-remnants-highlights.png",
			width = 198,
			height = 194,
			direction_count = 1,
			shift = util.by_pixel(2.5, -2),
			blend_mode = "additive",
			scale = 0.5,
		}
	end

	layers[#layers + 1] = {
		priority = "low",
		filename = BASE_PATH .. "remnants/mask/laser-turret-remnants-mask.png",
		width = 114,
		height = 94,
		apply_runtime_tint = true,
		direction_count = 1,
		shift = util.by_pixel(4, -2.5),
		scale = 0.5,
	}

	return _sprites.make_rotated_animation_variations_from_spritesheet(3, { layers = layers })
end

---Defines the options for the vanilla laser turret sprite set.
---@class TurretLaserSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color
---The laser lens, which selects the color of the turret glow as it shoots. When `nil`, the base game's glow is
---drawn.
---@field lens? LaserBeamLens

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("TurretLaserSpriteSetParams", {
			tint = Common.color:optional(),
			lens = LaserBeamLens:optional(),
		}):strict(),
	},
})

---Gets the sprite set for the vanilla laser turret.
---@param params TurretLaserSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<TurretSpriteSet> # The sprite set definition for the vanilla laser turret.
---
---#### Examples
---```lua
---local turret_laser = require("__reskins-assets-api__.assets.base.entities.turret-laser")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = turret_laser.get_sprite_set({ tint = tint, lens = "sapphire" })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@throws When `params.tint` is not a `Color`.
---@throws When `params.lens` is not one of `"amethyst"`, `"diamond"`, `"emerald"`, `"glass"`, `"ruby"`, `"sapphire"`, or `"topaz"`.
---@nodiscard
function M.get_sprite_set(params)
	check_get_sprite_set(params)

	local tint = params.tint

	---@type SpriteSetDefinition<TurretSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.turret_sprite_set,
		set = {
			folded_animation = get_extension_animation(1, 1, "forward"),
			preparing_animation = get_extension_animation(15, 0, "forward"),
			prepared_animation = get_shooting_animation(),
			folding_animation = get_extension_animation(15, 0, "backward"),
			energy_glow_animation = get_shooting_glow(params.lens),
			glow_light_intensity = 0.5,
			graphics_set = get_graphics_set(tint),
			circuit_connector = get_circuit_connector(),
			source_offset = { 0, -3.423489 / 4 },
			source_direction_count = 64,
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = { animation = get_corpse_animation(tint) },
			water_reflection = get_water_reflection(),
			drawing_box_vertical_extension = 0.3,
			nominal_width = 2,
			nominal_height = 2,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-base__/graphics/icons" })

---Gets the icon for the vanilla laser turret, in the tints given by `params`.
M.get_icon = icons:tinted("turret-laser"):build("get_icon")

return M
