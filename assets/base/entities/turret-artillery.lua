---@diagnostic disable: generic-constraint-mismatch

---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local IconBuilderFactory = require("api.icon-builder-factory")
local ArtilleryTurretExplosion = require("assets.base.explosions.artillery-turret")
local Remnants = require("assets.base.remnants")

local BASE_PATH = "__base__/graphics/entity/"
local ASSETS_PATH = "__reskins-assets-base__/graphics/entity/turret-artillery/"

local M = {}

---Gets the base picture of the artillery turret.
---@param tint? Color
---@return Animation4Way
local function get_base_picture(tint)
	local layers = {
		{
			filename = ASSETS_PATH .. "turret-artillery-base.png",
			priority = "high",
			line_length = 1,
			width = 207,
			height = 199,
			scale = 0.5,
		},
	}

	if tint then
		layers[#layers + 1] = {
			filename = ASSETS_PATH .. "turret-artillery-mask.png",
			priority = "high",
			line_length = 1,
			width = 207,
			height = 199,
			tint = tint,
			scale = 0.5,
		}
		layers[#layers + 1] = {
			filename = ASSETS_PATH .. "turret-artillery-highlights.png",
			priority = "high",
			line_length = 1,
			width = 207,
			height = 199,
			blend_mode = "additive",
			scale = 0.5,
		}
	end

	layers[#layers + 1] = {
		filename = BASE_PATH .. "artillery-turret/artillery-turret-base-shadow.png",
		priority = "high",
		line_length = 1,
		width = 277,
		height = 149,
		shift = util.by_pixel(18, 16),
		draw_as_shadow = true,
		scale = 0.5,
	}

	return { layers = layers }
end

---Gets the pictures of the cannon part with the given `name`, in each of its 256 orientations.
---@param name "cannon-base"|"cannon-barrel"
---@return RotatedSprite
local function get_cannon_pictures(name)
	local path = BASE_PATH .. "artillery-wagon/artillery-wagon-" .. name

	return {
		layers = {
			util.sprite_load(path, {
				dice = 4,
				priority = "very-low",
				allow_low_quality_rotation = true,
				direction_count = 256,
				scale = 0.5,
			}),
			util.sprite_load(path .. "-shadow", {
				dice = 4,
				priority = "very-low",
				allow_low_quality_rotation = true,
				draw_as_shadow = true,
				direction_count = 256,
				scale = 0.5,
			}),
		},
	}
end

---Gets the graphics set of the artillery turret.
---@param tint? Color
---@return ArtilleryTurretGraphicsSet
local function get_graphics_set(tint)
	---@type ArtilleryTurretGraphicsSet
	local graphics_set = {
		base_picture = get_base_picture(tint),
		base_picture_render_layer = "lower-object-above-shadow",
		cannon_base_shift = { 0.0, 0.0, 0.9722 },
		cannon_base_pictures = get_cannon_pictures("cannon-base"),
		cannon_barrel_pictures = get_cannon_pictures("cannon-barrel"),
		-- Each shifting is given as east, north, and up, when the cannon faces north.
		cannon_barrel_recoil_shiftings = {
			{ 0.0100, -0.0000, -0.0000 },
			{ 0.0093, -0.1973, -0.0878 },
			{ 0.0088, -0.3945, -0.1755 },
			{ 0.0083, -0.5918, -0.2635 },
			{ 0.0078, -0.7888, -0.3513 },
			{ 0.0070, -0.9860, -0.4390 },
			{ 0.0070, -0.9828, -0.4375 },
			{ 0.0070, -0.9753, -0.4343 },
			{ 0.0073, -0.9635, -0.4290 },
			{ 0.0073, -0.9475, -0.4220 },
			{ 0.0073, -0.9278, -0.4130 },
			{ 0.0073, -0.9043, -0.4025 },
			{ 0.0075, -0.8770, -0.3905 },
			{ 0.0075, -0.8463, -0.3768 },
			{ 0.0075, -0.8123, -0.3618 },
			{ 0.0078, -0.7755, -0.3453 },
			{ 0.0078, -0.7360, -0.3278 },
			{ 0.0080, -0.6940, -0.3090 },
			{ 0.0080, -0.6498, -0.2893 },
			{ 0.0083, -0.6040, -0.2690 },
			{ 0.0083, -0.5565, -0.2478 },
			{ 0.0085, -0.5080, -0.2263 },
			{ 0.0085, -0.4588, -0.2043 },
			{ 0.0088, -0.4088, -0.1820 },
			{ 0.0088, -0.3590, -0.1598 },
			{ 0.0090, -0.3095, -0.1378 },
			{ 0.0093, -0.2605, -0.1160 },
			{ 0.0093, -0.2128, -0.0948 },
			{ 0.0095, -0.1663, -0.0740 },
			{ 0.0095, -0.1213, -0.0540 },
			{ 0.0098, -0.0785, -0.0350 },
			{ 0.0098, -0.0380, -0.0170 },
		},
		cannon_barrel_light_direction = { 0.5976251, -0.0242053, -0.8014102 },
	}

	return graphics_set
end

---Gets the circuit connector of the artillery turret.
---@return CircuitConnectorDefinition
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_single(universal_connector_template, {
		variation = 25,
		main_offset = util.by_pixel(-28, 17),
		shadow_offset = util.by_pixel(-15, 35),
		show_shadow = false,
	})
end

---Gets the water reflection of the artillery turret.
---@return WaterReflectionDefinition
local function get_water_reflection()
	return {
		pictures = {
			filename = BASE_PATH .. "artillery-turret/artillery-turret-reflection.png",
			priority = "extra-high",
			width = 28,
			height = 32,
			shift = util.by_pixel(0, 75),
			variation_count = 1,
			scale = 5,
		},
		rotate = false,
		orientation_to_variation = false,
	}
end

---Gets the animation of the artillery turret remnants.
---@param tint? Color
---@return RotatedAnimationVariations
local function get_corpse_animation(tint)
	local remnants_path = ASSETS_PATH .. "remnants/"

	local layers = {
		{
			filename = remnants_path .. "turret-artillery-remnants-base.png",
			line_length = 1,
			width = 326,
			height = 290,
			direction_count = 1,
			shift = util.by_pixel(9.5, 1.5),
			scale = 0.5,
		},
	}

	if tint then
		layers[#layers + 1] = {
			filename = remnants_path .. "turret-artillery-remnants-mask.png",
			line_length = 1,
			width = 326,
			height = 290,
			direction_count = 1,
			shift = util.by_pixel(9.5, 1.5),
			tint = tint,
			scale = 0.5,
		}
		layers[#layers + 1] = {
			filename = remnants_path .. "turret-artillery-remnants-highlights.png",
			line_length = 1,
			width = 326,
			height = 290,
			direction_count = 1,
			shift = util.by_pixel(9.5, 1.5),
			blend_mode = "additive",
			scale = 0.5,
		}
	end

	return { { layers = layers } }
end

---Defines the options for the vanilla artillery turret sprite set.
---@class TurretArtillerySpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("TurretArtillerySpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for the vanilla artillery turret.
---@param params TurretArtillerySpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<ArtilleryTurretSpriteSet> # The sprite set definition for the vanilla artillery turret.
---
---#### Examples
---```lua
---local turret_artillery = require("__reskins-assets-api__.assets.base.entities.turret-artillery")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = turret_artillery.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@throws When `params.tint` is not a `Color`.
---@nodiscard
function M.get_sprite_set(params)
	check_get_sprite_set(params)

	---@type SpriteSetDefinition<ArtilleryTurretSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.artillery_turret_sprite_set,
		set = {
			graphics_set = get_graphics_set(params.tint),
			circuit_connector = get_circuit_connector(),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = ArtilleryTurretExplosion.get_explosion({
				tints = params.tint and { ["artillery-wagon-metal-particle-big-yellow"] = params.tint },
			}),
			corpse = Remnants.get_corpse("artillery-turret-remnants", { animation = get_corpse_animation(params.tint) }),
			water_reflection = get_water_reflection(),
			drawing_box_vertical_extension = 3.5,
			nominal_width = 3,
			nominal_height = 3,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-base__/graphics/icons" })

---Gets the icon for the vanilla artillery turret, in the tints given by `params`.
M.get_icon = icons:tinted("turret-artillery"):build("get_icon")

return M
