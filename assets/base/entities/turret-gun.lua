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
local GunTurretExplosion = require("assets.base.explosions.gun-turret")
local Remnants = require("assets.base.remnants")

local BASE_PATH = "__base__/graphics/entity/gun-turret/"
local ASSETS_PATH = "__reskins-assets-base__/graphics/entity/turret-gun/"

local M = {}

---Gets the animation of the gun turret as it raises and lowers the gun.
---@param tint? Color
---@param frame_count integer
---@param line_length integer
---@param run_mode AnimationRunMode
---@return RotatedAnimation
local function get_extension_animation(tint, frame_count, line_length, run_mode)
	local layers = {
		{
			filename = BASE_PATH .. "gun-turret-raising.png",
			priority = "medium",
			width = 130,
			height = 126,
			direction_count = 4,
			frame_count = frame_count,
			line_length = line_length,
			run_mode = run_mode,
			shift = util.by_pixel(0, -26.5),
			scale = 0.5,
		},
	}

	if tint then
		layers[#layers + 1] = {
			filename = ASSETS_PATH .. "turret-gun-raising-mask.png",
			priority = "medium",
			width = 130,
			height = 126,
			direction_count = 4,
			frame_count = frame_count,
			line_length = line_length,
			run_mode = run_mode,
			shift = util.by_pixel(0, -26.5),
			tint = tint,
			scale = 0.5,
		}
		layers[#layers + 1] = {
			filename = ASSETS_PATH .. "turret-gun-raising-highlights.png",
			priority = "medium",
			width = 130,
			height = 126,
			direction_count = 4,
			frame_count = frame_count,
			line_length = line_length,
			run_mode = run_mode,
			shift = util.by_pixel(0, -26.5),
			blend_mode = "additive",
			scale = 0.5,
		}
	end

	layers[#layers + 1] = {
		filename = BASE_PATH .. "gun-turret-raising-mask.png",
		flags = { "mask" },
		width = 48,
		height = 62,
		direction_count = 4,
		frame_count = frame_count,
		line_length = line_length,
		run_mode = run_mode,
		shift = util.by_pixel(0, -28),
		apply_runtime_tint = true,
		scale = 0.5,
	}
	layers[#layers + 1] = {
		filename = BASE_PATH .. "gun-turret-raising-shadow.png",
		width = 250,
		height = 124,
		direction_count = 4,
		frame_count = frame_count,
		line_length = line_length,
		run_mode = run_mode,
		shift = util.by_pixel(19, 2.5),
		draw_as_shadow = true,
		scale = 0.5,
	}

	return { layers = layers }
end

---Gets the four stripes of a shooting sheet, one for each quarter of the directions.
---
---The file name of each stripe is `prefix`, the index of the stripe, and `suffix`.
---@param prefix string
---@param suffix string
---@param frame_count integer
---@return Stripe[]
local function get_shooting_stripes(prefix, suffix, frame_count)
	local stripes = {}
	for index = 1, 4 do
		stripes[index] = {
			filename = prefix .. index .. suffix,
			width_in_frames = frame_count,
			height_in_frames = 16,
		}
	end

	return stripes
end

---Gets the animation of the gun turret as it shoots.
---@param tint? Color
---@param frame_count integer
---@return RotatedAnimation
local function get_shooting_animation(tint, frame_count)
	local layers = {
		{
			width = 132,
			height = 130,
			frame_count = frame_count,
			direction_count = 64,
			shift = util.by_pixel(0, -27.5),
			stripes = get_shooting_stripes(BASE_PATH .. "gun-turret-shooting-", ".png", frame_count),
			scale = 0.5,
		},
	}

	if tint then
		layers[#layers + 1] = {
			width = 132,
			height = 130,
			frame_count = frame_count,
			direction_count = 64,
			shift = util.by_pixel(0, -27.5),
			tint = tint,
			stripes = get_shooting_stripes(ASSETS_PATH .. "turret-gun-shooting-", "-mask.png", frame_count),
			scale = 0.5,
		}
		layers[#layers + 1] = {
			width = 132,
			height = 130,
			frame_count = frame_count,
			direction_count = 64,
			shift = util.by_pixel(0, -27.5),
			blend_mode = "additive",
			stripes = get_shooting_stripes(ASSETS_PATH .. "turret-gun-shooting-", "-highlights.png", frame_count),
			scale = 0.5,
		}
	end

	layers[#layers + 1] = {
		flags = { "mask" },
		line_length = frame_count,
		width = 58,
		height = 54,
		frame_count = frame_count,
		direction_count = 64,
		shift = util.by_pixel(0, -32.5),
		apply_runtime_tint = true,
		stripes = get_shooting_stripes(BASE_PATH .. "gun-turret-shooting-mask-", ".png", frame_count),
		scale = 0.5,
	}
	layers[#layers + 1] = {
		width = 250,
		height = 124,
		frame_count = frame_count,
		direction_count = 64,
		shift = util.by_pixel(22, 2.5),
		draw_as_shadow = true,
		stripes = get_shooting_stripes(BASE_PATH .. "gun-turret-shooting-shadow-", ".png", frame_count),
		scale = 0.5,
	}

	return { layers = layers }
end

---Gets the graphics set of the gun turret, which draws the base of the turret.
---@return TurretGraphicsSet
local function get_graphics_set()
	return {
		base_visualisation = {
			animation = {
				layers = {
					{
						filename = BASE_PATH .. "gun-turret-base.png",
						priority = "high",
						width = 150,
						height = 118,
						shift = util.by_pixel(0.5, -1),
						scale = 0.5,
					},
					{
						filename = BASE_PATH .. "gun-turret-base-mask.png",
						flags = { "mask", "low-object" },
						line_length = 1,
						width = 122,
						height = 102,
						shift = util.by_pixel(0, -4.5),
						apply_runtime_tint = true,
						scale = 0.5,
					},
				},
			},
		},
	}
end

---Gets the circuit connector of the gun turret.
---@return CircuitConnectorDefinition[]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 17,
			main_offset = util.by_pixel(-21, 1),
			shadow_offset = util.by_pixel(-12, 10),
			show_shadow = true,
		},
	})
end

---Gets the water reflection of the gun turret.
---@return WaterReflectionDefinition
local function get_water_reflection()
	return {
		pictures = {
			filename = BASE_PATH .. "gun-turret-reflection.png",
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

---Gets the animation of the gun turret remnants.
---@param tint? Color
---@return RotatedAnimationVariations
local function get_corpse_animation(tint)
	local layers = {
		{
			filename = BASE_PATH .. "remnants/gun-turret-remnants.png",
			line_length = 1,
			width = 252,
			height = 242,
			direction_count = 1,
			shift = util.by_pixel(3, -1.5),
			scale = 0.5,
		},
	}

	if tint then
		layers[#layers + 1] = {
			filename = ASSETS_PATH .. "remnants/turret-gun-remnants-mask.png",
			width = 252,
			height = 242,
			direction_count = 1,
			shift = util.by_pixel(3, -1.5),
			tint = tint,
			scale = 0.5,
		}
		layers[#layers + 1] = {
			filename = ASSETS_PATH .. "remnants/turret-gun-remnants-highlights.png",
			width = 252,
			height = 242,
			direction_count = 1,
			shift = util.by_pixel(3, -1.5),
			blend_mode = "additive",
			scale = 0.5,
		}
	end

	layers[#layers + 1] = {
		priority = "low",
		filename = BASE_PATH .. "remnants/mask/gun-turret-remnants-mask.png",
		width = 68,
		height = 64,
		apply_runtime_tint = true,
		direction_count = 1,
		shift = util.by_pixel(-1, -11),
		scale = 0.5,
	}

	return _sprites.make_rotated_animation_variations_from_spritesheet(3, { layers = layers })
end

---Defines the options for the vanilla gun turret sprite set.
---@class TurretGunSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("TurretGunSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for the vanilla gun turret.
---@param params TurretGunSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<TurretSpriteSet> # The sprite set definition for the vanilla gun turret.
---
---#### Examples
---```lua
---local turret_gun = require("__reskins-assets-api__.assets.base.entities.turret-gun")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = turret_gun.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@throws When `params` defines an unrecognized field.
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
			prepared_animation = get_shooting_animation(tint, 1),
			attacking_animation = get_shooting_animation(tint, 2),
			folding_animation = get_extension_animation(tint, 5, 0, "backward"),
			graphics_set = get_graphics_set(),
			circuit_connector = get_circuit_connector(),
			projectile_center = { 0, -0.0875 },
			projectile_creation_distance = 1.39375,
			shell_particle = { center = { -0.0625, 0 }, creation_distance = -1.925 },
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = GunTurretExplosion.get_explosion({
				tints = tint and { ["gun-turret-metal-particle-medium"] = tint },
			}),
			corpse = Remnants.get_corpse("gun-turret-remnants", { animation = get_corpse_animation(tint) }),
			water_reflection = get_water_reflection(),
			drawing_box_vertical_extension = 0.2,
			nominal_width = 2,
			nominal_height = 2,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-base__/graphics/icons" })

---Gets the icon for the vanilla gun turret, in the tints given by `params`.
M.get_icon = icons:tinted("turret-gun"):build("get_icon")

return M
