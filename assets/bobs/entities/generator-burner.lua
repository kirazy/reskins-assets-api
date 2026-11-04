---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Entities

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local IconBuilderFactory = require("api.icon-builder-factory")
local SteamEngineExplosion = require("assets.base.explosions.steam-engine")

local ASSETS_BOBS_PATH = "__reskins-assets-bobs__/graphics/entity/generator-burner/"

local M = {}

---The tint of the big and medium metal particles in the dying explosion of the burner generator.
---@type Color
local particle_tint = util.color("#26262660")

---Gets the base layer of the burner generator.
---@return Animation
local function get_base_layer()
	return {
		filename = ASSETS_BOBS_PATH .. "generator-burner.png",
		width = 212,
		height = 272,
		frame_count = 32,
		line_length = 8,
		repeat_count = 3,
		shift = util.by_pixel(0, -12.5),
		scale = 0.5,
	}
end

---Gets the shadow layer of the burner generator.
---@return Animation
local function get_shadow_layer()
	return {
		filename = ASSETS_BOBS_PATH .. "generator-burner-shadow.png",
		width = 288,
		height = 170,
		frame_count = 32,
		line_length = 8,
		repeat_count = 3,
		draw_as_shadow = true,
		shift = util.by_pixel(30, 12),
		scale = 0.5,
	}
end

---Gets the animation of the burner generator while it is active.
---@return Animation
local function get_animation()
	return {
		layers = {
			get_base_layer(),
			{
				filename = ASSETS_BOBS_PATH .. "generator-burner-fire.png",
				priority = "high",
				width = 58,
				height = 82,
				frame_count = 48,
				line_length = 8,
				repeat_count = 2,
				blend_mode = "additive",
				draw_as_glow = true,
				shift = util.by_pixel(-1, 9.5),
				scale = 0.5,
			},
			{
				filename = ASSETS_BOBS_PATH .. "generator-burner-working-light-animated.png",
				width = 212,
				height = 272,
				frame_count = 32,
				line_length = 8,
				repeat_count = 3,
				blend_mode = "additive",
				draw_as_glow = true,
				shift = util.by_pixel(0, -12.5),
				scale = 0.5,
			},
			get_shadow_layer(),
		},
	}
end

---Gets the animation of the burner generator while it is inactive.
---@return Animation
local function get_idle_animation()
	return {
		layers = {
			get_base_layer(),
			get_shadow_layer(),
		},
	}
end

---Gets the light flicker of the burner generator, which shows no light.
---@return LightFlickeringDefinition
local function get_light_flicker()
	return { color = { 0, 0, 0 } }
end

---Gets the water reflection of the burner generator.
---@return WaterReflectionDefinition
local function get_water_reflection()
	return {
		pictures = {
			filename = ASSETS_BOBS_PATH .. "generator-burner-reflection.png",
			priority = "extra-high",
			width = 28,
			height = 36,
			shift = util.by_pixel(5, 60),
			variation_count = 1,
			scale = 5,
		},
		rotate = false,
		orientation_to_variation = false,
	}
end

---Gets the sprite set for the burner generator.
---@return SpriteSetDefinition<BurnerGeneratorSpriteSet> # The sprite set definition for the burner generator.
---
---#### Examples
---```lua
---local generator_burner = require("__reskins-assets-api__.assets.bobs.entities.generator-burner")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = generator_burner.get_sprite_set()
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set()
	---@type SpriteSetDefinition<BurnerGeneratorSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.burner_generator_sprite_set,
		set = {
			animation = get_animation(),
			idle_animation = get_idle_animation(),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = SteamEngineExplosion.get_explosion({
				tints = {
					["steam-engine-metal-particle-big"] = util.copy(particle_tint),
					["steam-engine-metal-particle-medium"] = util.copy(particle_tint),
				},
			}),
			corpse = _defines.generic_remnants,
			water_reflection = get_water_reflection(),
			drawing_box_vertical_extension = 0.8,
			light_flicker = get_light_flicker(),
			nominal_width = 3,
			nominal_height = 3,
		},
	}

	return definition
end

---Defines the options for the burner generator smoke.
---@class GeneratorBurnerSmokeParams
---The name of the `TrivialSmokePrototype` of the smoke. Default `"smoke"`.
---@field name? string
---The `frequency` of the smoke. Default `15`.
---@field frequency? double

local check_get_smoke = V.signature("get_smoke", {
	{
		"params",
		V.class("GeneratorBurnerSmokeParams", {
			name = Common.prototype_name:optional(),
			frequency = Common.non_negative_number:optional(),
		}):strict(),
	},
})

---Gets the smoke of the burner generator.
---@param params GeneratorBurnerSmokeParams The options for the smoke.
---@return SmokeSource[] # The smoke of the burner generator.
---
---#### Examples
---```lua
----- Set the standard smoke on the burner of a burner generator.
---local generator_burner = require("__reskins-assets-api__.assets.bobs.entities.generator-burner")
---
---entity.burner = util.copy(entity.burner)
---entity.burner.smoke = generator_burner.get_smoke({})
---```
---@throws When `params.name` is not a string, or is an empty string.
---@throws When `params.frequency` is not a non-negative number.
---@nodiscard
function M.get_smoke(params)
	check_get_smoke(params)

	return {
		{
			name = params.name or "smoke",
			north_position = util.by_pixel(36, -70.5),
			east_position = util.by_pixel(36, -70.5),
			south_position = util.by_pixel(36, -70.5),
			west_position = util.by_pixel(36, -70.5),
			frequency = params.frequency or 15,
			starting_vertical_speed = 0.08,
			starting_frame_deviation = 60,
		},
	}
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-bobs__/graphics/icons" })

---Gets the icon for the burner generator.
M.get_icon = icons:flat("generator-burner"):build("get_icon")

return M
