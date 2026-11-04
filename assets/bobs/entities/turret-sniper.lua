---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Entities

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local IconBuilderFactory = require("api.icon-builder-factory")

local ASSETS_PATH = "__reskins-assets-bobs__/graphics/entity/turret-sniper/"

local M = {}

---Gets the animation of the sniper turret as it raises and lowers the gun.
---@param tint? Color
---@param frame_count integer
---@param line_length integer
---@param run_mode AnimationRunMode
---@return RotatedAnimation
local function get_extension_animation(tint, frame_count, line_length, run_mode)
	local layers = {
		{
			filename = ASSETS_PATH .. "turret-sniper-raising.png",
			priority = "medium",
			width = 238,
			height = 178,
			direction_count = 4,
			frame_count = frame_count,
			line_length = line_length,
			run_mode = run_mode,
			shift = util.by_pixel(0, -30.5),
			scale = 0.5,
		},
		{
			filename = ASSETS_PATH .. "turret-sniper-raising-tint.png",
			priority = "medium",
			flags = { "mask" },
			width = 238,
			height = 178,
			direction_count = 4,
			frame_count = frame_count,
			line_length = line_length,
			run_mode = run_mode,
			shift = util.by_pixel(0, -30.5),
			apply_runtime_tint = true,
			scale = 0.5,
		},
	}

	if tint then
		layers[#layers + 1] = {
			filename = ASSETS_PATH .. "turret-sniper-raising-mask.png",
			priority = "medium",
			width = 238,
			height = 178,
			direction_count = 4,
			frame_count = frame_count,
			line_length = line_length,
			run_mode = run_mode,
			shift = util.by_pixel(0, -30.5),
			tint = tint,
			scale = 0.5,
		}
		layers[#layers + 1] = {
			filename = ASSETS_PATH .. "turret-sniper-raising-highlights.png",
			priority = "medium",
			width = 238,
			height = 178,
			direction_count = 4,
			frame_count = frame_count,
			line_length = line_length,
			run_mode = run_mode,
			shift = util.by_pixel(0, -30.5),
			blend_mode = "additive",
			scale = 0.5,
		}
	end

	layers[#layers + 1] = {
		filename = ASSETS_PATH .. "turret-sniper-raising-shadow.png",
		width = 246,
		height = 178,
		direction_count = 4,
		frame_count = frame_count,
		line_length = line_length,
		run_mode = run_mode,
		shift = util.by_pixel(21.5, 2),
		draw_as_shadow = true,
		scale = 0.5,
	}

	return { layers = layers }
end

---Gets the animation of the sniper turret as it aims and shoots.
---@param tint? Color
---@return RotatedAnimation
local function get_shooting_animation(tint)
	local layers = {
		{
			filename = ASSETS_PATH .. "turret-sniper-shooting.png",
			line_length = 8,
			width = 238,
			height = 178,
			direction_count = 64,
			shift = util.by_pixel(0, -30.5),
			scale = 0.5,
		},
		{
			filename = ASSETS_PATH .. "turret-sniper-shooting-tint.png",
			flags = { "mask" },
			line_length = 8,
			width = 238,
			height = 178,
			direction_count = 64,
			shift = util.by_pixel(0, -30.5),
			apply_runtime_tint = true,
			scale = 0.5,
		},
	}

	if tint then
		layers[#layers + 1] = {
			filename = ASSETS_PATH .. "turret-sniper-shooting-mask.png",
			line_length = 8,
			width = 238,
			height = 178,
			direction_count = 64,
			shift = util.by_pixel(0, -30.5),
			tint = tint,
			scale = 0.5,
		}
		layers[#layers + 1] = {
			filename = ASSETS_PATH .. "turret-sniper-shooting-highlights.png",
			line_length = 8,
			width = 238,
			height = 178,
			direction_count = 64,
			shift = util.by_pixel(0, -30.5),
			blend_mode = "additive",
			scale = 0.5,
		}
	end

	layers[#layers + 1] = {
		filename = ASSETS_PATH .. "turret-sniper-shooting-shadow.png",
		line_length = 8,
		width = 246,
		height = 178,
		direction_count = 64,
		shift = util.by_pixel(21.5, 2),
		draw_as_shadow = true,
		scale = 0.5,
	}

	return { layers = layers }
end

---Gets the graphics set of the sniper turret, which draws the base of the turret.
---@return TurretGraphicsSet
local function get_graphics_set()
	return {
		base_visualisation = {
			animation = {
				layers = {
					{
						filename = ASSETS_PATH .. "turret-sniper-base.png",
						priority = "high",
						width = 150,
						height = 118,
						shift = util.by_pixel(2, 0),
						scale = 0.5,
					},
					{
						filename = ASSETS_PATH .. "turret-sniper-base-runtime-mask.png",
						priority = "high",
						width = 150,
						height = 118,
						shift = util.by_pixel(2, 0),
						apply_runtime_tint = true,
						scale = 0.5,
					},
					{
						filename = ASSETS_PATH .. "turret-sniper-base-shadow.png",
						priority = "high",
						width = 150,
						height = 118,
						shift = util.by_pixel(2, 0),
						draw_as_shadow = true,
						scale = 0.5,
					},
				},
			},
		},
	}
end

---Gets the circuit connector of the sniper turret.
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

---Gets the water reflection of the sniper turret.
---@return WaterReflectionDefinition
local function get_water_reflection()
	return {
		pictures = {
			filename = "__base__/graphics/entity/gun-turret/gun-turret-reflection.png",
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

---Defines the options for the sniper turret sprite set.
---@class TurretSniperSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("TurretSniperSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for the sniper turret.
---@param params TurretSniperSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<TurretSpriteSet> # The sprite set definition for the sniper turret.
---
---#### Examples
---```lua
---local turret_sniper = require("__reskins-assets-api__.assets.bobs.entities.turret-sniper")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = turret_sniper.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@throws When `params.tint` is not a `Color`.
---@nodiscard
function M.get_sprite_set(params)
	check_get_sprite_set(params)

	local tint = params.tint

	---@type SpriteSetDefinition<TurretSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.turret_sprite_set,
		set = {
			folded_animation = get_extension_animation(tint, 1, 1, "forward"),
			preparing_animation = get_extension_animation(tint, 5, 0, "forward"),
			prepared_animation = get_shooting_animation(tint),
			attacking_animation = get_shooting_animation(tint),
			folding_animation = get_extension_animation(tint, 5, 0, "backward"),
			graphics_set = get_graphics_set(),
			circuit_connector = get_circuit_connector(),
			projectile_center = { 0, 0 },
			projectile_creation_distance = 2.3,
			shell_particle = { center = util.by_pixel(4, 0), creation_distance = -2.85, direction = -0.25 },
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = nil,
			water_reflection = get_water_reflection(),
			nominal_width = 2,
			nominal_height = 2,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-bobs__/graphics/icons" })

---Gets the icon for the sniper turret, in the tints given by `params`.
M.get_icon = icons:tinted("turret-sniper"):build("get_icon")

return M
