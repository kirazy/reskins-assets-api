---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Entities

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local IconBuilderFactory = require("api.icon-builder-factory")

local ASSETS_PATH = "__reskins-assets-bobs__/graphics/entity/turret-plasma/"

-- The lights blink twice while the cannon raises or lowers.
local RAISING_FRAME_SEQUENCE = { 1, 2, 2, 2, 3, 4, 4, 4, 1, 2, 2, 2, 3, 4, 4, 4 }

local M = {}

---Gets the layers of the lowered plasma turret cannon, each repeated `repeat_count` times.
---@param tint? Color
---@param repeat_count integer
---@return RotatedAnimation[]
local function get_cannon_layers(tint, repeat_count)
	local layers = {
		{
			filename = ASSETS_PATH .. "turret-plasma-cannon-raising-base.png",
			priority = "medium",
			width = 176,
			height = 178,
			repeat_count = repeat_count,
			direction_count = 8,
			shift = util.by_pixel(-0.5, -35),
			scale = 0.5,
		},
		{
			filename = ASSETS_PATH .. "turret-plasma-cannon-raising-runtime-mask.png",
			priority = "medium",
			width = 176,
			height = 178,
			repeat_count = repeat_count,
			direction_count = 8,
			shift = util.by_pixel(-0.5, -35),
			apply_runtime_tint = true,
			scale = 0.5,
		},
	}

	if tint then
		layers[#layers + 1] = {
			filename = ASSETS_PATH .. "turret-plasma-cannon-raising-mask.png",
			priority = "medium",
			width = 176,
			height = 178,
			repeat_count = repeat_count,
			direction_count = 8,
			shift = util.by_pixel(-0.5, -35),
			tint = tint,
			scale = 0.5,
		}
		layers[#layers + 1] = {
			filename = ASSETS_PATH .. "turret-plasma-cannon-raising-highlights.png",
			priority = "medium",
			width = 176,
			height = 178,
			repeat_count = repeat_count,
			direction_count = 8,
			shift = util.by_pixel(-0.5, -35),
			blend_mode = "additive",
			scale = 0.5,
		}
	end

	return layers
end

---Gets the animation of the plasma turret as it raises or lowers the cannon.
---@param tint? Color
---@param run_mode AnimationRunMode
---@return RotatedAnimation
local function get_extension_animation(tint, run_mode)
	local layers = get_cannon_layers(tint, 16)

	if tint then
		layers[#layers + 1] = {
			filename = ASSETS_PATH .. "turret-plasma-cannon-raising-lights-mask.png",
			priority = "medium",
			width = 134,
			height = 178,
			frame_count = 4,
			line_length = 4,
			frame_sequence = RAISING_FRAME_SEQUENCE,
			run_mode = run_mode,
			direction_count = 8,
			shift = util.by_pixel(0, -35),
			tint = tint,
			draw_as_glow = true,
			scale = 0.5,
		}
		layers[#layers + 1] = {
			filename = ASSETS_PATH .. "turret-plasma-cannon-raising-lights-highlights.png",
			priority = "medium",
			width = 134,
			height = 178,
			frame_count = 4,
			line_length = 4,
			frame_sequence = RAISING_FRAME_SEQUENCE,
			run_mode = run_mode,
			direction_count = 8,
			shift = util.by_pixel(0, -35),
			blend_mode = "additive",
			draw_as_glow = true,
			scale = 0.5,
		}
	end

	return { layers = layers }
end

---Gets the animation of the plasma turret when the cannon is raised.
---@param tint? Color
---@return RotatedAnimation
local function get_shooting_animation(tint)
	local layers = {
		{
			filename = ASSETS_PATH .. "turret-plasma-cannon-shooting-base.png",
			line_length = 8,
			width = 176,
			height = 178,
			direction_count = 64,
			shift = util.by_pixel(-0.5, -35),
			scale = 0.5,
		},
		{
			filename = ASSETS_PATH .. "turret-plasma-cannon-shooting-runtime-mask.png",
			line_length = 8,
			width = 176,
			height = 178,
			direction_count = 64,
			shift = util.by_pixel(-0.5, -35),
			apply_runtime_tint = true,
			scale = 0.5,
		},
	}

	if tint then
		layers[#layers + 1] = {
			filename = ASSETS_PATH .. "turret-plasma-cannon-shooting-mask.png",
			line_length = 8,
			width = 176,
			height = 178,
			direction_count = 64,
			shift = util.by_pixel(-0.5, -35),
			tint = tint,
			scale = 0.5,
		}
		layers[#layers + 1] = {
			filename = ASSETS_PATH .. "turret-plasma-cannon-shooting-highlights.png",
			line_length = 8,
			width = 176,
			height = 178,
			direction_count = 64,
			shift = util.by_pixel(-0.5, -35),
			blend_mode = "additive",
			scale = 0.5,
		}
		layers[#layers + 1] = {
			filename = ASSETS_PATH .. "turret-plasma-cannon-shooting-light-mask.png",
			line_length = 8,
			width = 176,
			height = 178,
			direction_count = 64,
			shift = util.by_pixel(-0.5, -35),
			tint = tint,
			draw_as_glow = true,
			scale = 0.5,
		}
		layers[#layers + 1] = {
			filename = ASSETS_PATH .. "turret-plasma-cannon-shooting-light-highlights.png",
			line_length = 8,
			width = 176,
			height = 178,
			direction_count = 64,
			shift = util.by_pixel(-0.5, -35),
			blend_mode = "additive",
			draw_as_glow = true,
			scale = 0.5,
		}
	end

	return { layers = layers }
end

---Gets the graphics set of the plasma turret, which draws the base of the turret.
---@return TurretGraphicsSet
local function get_graphics_set()
	return {
		base_visualisation = {
			animation = {
				layers = {
					{
						filename = ASSETS_PATH .. "turret-plasma-base.png",
						priority = "high",
						width = 208,
						height = 178,
						scale = 0.5,
					},
					{
						filename = ASSETS_PATH .. "turret-plasma-runtime-mask.png",
						priority = "high",
						width = 208,
						height = 178,
						apply_runtime_tint = true,
						scale = 0.5,
					},
					{
						filename = ASSETS_PATH .. "turret-plasma-base-shadow.png",
						priority = "high",
						width = 244,
						height = 150,
						shift = util.by_pixel(18.5, 11),
						draw_as_shadow = true,
						scale = 0.5,
					},
				},
			},
			render_layer = "lower-object-above-shadow",
		},
	}
end

---Gets the circuit connector of the plasma turret for each of the 8 directions of its base.
---@return CircuitConnectorDefinition[]
local function get_circuit_connector()
	local definitions = {}
	for index = 1, 8 do
		definitions[index] = {
			variation = 17,
			main_offset = util.by_pixel(-31.5, 1.5),
			shadow_offset = util.by_pixel(-18, 15),
			show_shadow = true,
		}
	end

	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, definitions)
end

---Gets the water reflection of the plasma turret.
---@return WaterReflectionDefinition
local function get_water_reflection()
	return {
		pictures = {
			filename = ASSETS_PATH .. "turret-plasma-reflection.png",
			priority = "extra-high",
			width = 28,
			height = 29,
			shift = util.by_pixel(0, 65),
			variation_count = 1,
			scale = 5,
		},
		rotate = false,
		orientation_to_variation = false,
	}
end

---Defines the options for the plasma turret sprite set.
---@class TurretPlasmaSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("TurretPlasmaSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for the plasma turret.
---
---The artwork is drawn for a turret with a base that faces 8 directions.
---@param params TurretPlasmaSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<TurretSpriteSet> # The sprite set definition for the plasma turret.
---
---#### Examples
---```lua
---local turret_plasma = require("__reskins-assets-api__.assets.bobs.entities.turret-plasma")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = turret_plasma.get_sprite_set({ tint = tint })
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
			folded_animation = { layers = get_cannon_layers(tint, 1) },
			preparing_animation = get_extension_animation(tint, "forward"),
			prepared_animation = get_shooting_animation(tint),
			folding_animation = get_extension_animation(tint, "backward"),
			graphics_set = get_graphics_set(),
			circuit_connector = get_circuit_connector(),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = nil,
			water_reflection = get_water_reflection(),
			drawing_box_vertical_extension = 1.05,
			nominal_width = 3,
			nominal_height = 3,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-bobs__/graphics/icons" })

---Gets the icon for the plasma turret, in the tints given by `params`.
M.get_icon = icons:tinted("turret-plasma"):build("get_icon")

return M
