---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Entities

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local IconBuilderFactory = require("api.icon-builder-factory")
local SteamTurbineExplosion = require("assets.base.explosions.steam-turbine")

local ASSETS_BOBS_PATH = "__reskins-assets-bobs__/graphics/entity/generator-fluid/"

local M = {}

---Gets the animation of the fluid generator.
---@param tint? Color
---@return Animation
local function get_animation(tint)
	---@type Animation
	local animation = {
		layers = {
			{
				filename = ASSETS_BOBS_PATH .. "generator-fluid-base.png",
				width = 202,
				height = 260,
				frame_count = 8,
				line_length = 4,
				shift = util.by_pixel(2.5, -11),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = ASSETS_BOBS_PATH .. "generator-fluid-mask.png",
			width = 202,
			height = 260,
			repeat_count = 8,
			tint = tint,
			shift = util.by_pixel(2.5, -11),
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = ASSETS_BOBS_PATH .. "generator-fluid-highlights.png",
			width = 202,
			height = 260,
			repeat_count = 8,
			blend_mode = "additive",
			shift = util.by_pixel(2.5, -11),
			scale = 0.5,
		})
	end

	table.insert(animation.layers--[[@cast -?]], {
		filename = ASSETS_BOBS_PATH .. "generator-fluid-shadow.png",
		width = 324,
		height = 260,
		repeat_count = 8,
		draw_as_shadow = true,
		shift = util.by_pixel(33, -11),
		scale = 0.5,
	})

	return animation
end

---Gets the pictures of the fluid generator, which draw the same animation in the `north` and `east` directions.
---@param tint? Color
---@return GeneratorPictureSet
local function get_generator_pictures(tint)
	return {
		north = { animation = get_animation(tint) },
		east = { animation = get_animation(tint) },
	}
end

---Gets the water reflection of the fluid generator.
---@return WaterReflectionDefinition
local function get_water_reflection()
	return {
		pictures = {
			filename = ASSETS_BOBS_PATH .. "generator-fluid-reflection.png",
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

---Defines the options for the fluid generator sprite set.
---@class GeneratorFluidSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("GeneratorFluidSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for the fluid generator.
---@param params GeneratorFluidSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<GeneratorSpriteSet> # The sprite set definition for the fluid generator.
---
---#### Examples
---```lua
---local generator_fluid = require("__reskins-assets-api__.assets.bobs.entities.generator-fluid")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = generator_fluid.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@throws When `params` defines an unrecognized field.
---@throws When `params.tint` is not a `Color`.
---@nodiscard
function M.get_sprite_set(params)
	check_get_sprite_set(params)

	---@type SpriteSetDefinition<GeneratorSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.generator_sprite_set,
		set = {
			two_direction_only = true,
			pictures = get_generator_pictures(params.tint),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = SteamTurbineExplosion.get_explosion({
				tints = params.tint and {
					["steam-turbine-metal-particle-big"] = params.tint,
					["steam-turbine-metal-particle-medium"] = params.tint,
				},
			}),
			corpse = _defines.generic_remnants,
			water_reflection = get_water_reflection(),
			nominal_width = 3,
			nominal_height = 3,
		},
	}

	return definition
end

---Defines the options for the fluid generator smoke.
---@class GeneratorFluidSmokeParams
---The name of the `TrivialSmokePrototype` for the smoke. Default `"smoke"`.
---@field name? string
---The `frequency` of the smoke. Default `0.125`.
---@field frequency? double

local check_get_smoke = V.signature("get_smoke", {
	{
		"params",
		V.class("GeneratorFluidSmokeParams", {
			name = Common.prototype_name:optional(),
			frequency = Common.non_negative_number:optional(),
		}):strict(),
	},
})

---Gets the smoke of the fluid generator.
---@param params GeneratorFluidSmokeParams The options for the smoke.
---@return SmokeSource[] # The smoke of the fluid generator.
---
---#### Examples
---```lua
----- Set light smoke on a fluid generator.
---local generator_fluid = require("__reskins-assets-api__.assets.bobs.entities.generator-fluid")
---
---entity.smoke = generator_fluid.get_smoke({ name = "light-smoke", frequency = 5 / 16 })
---```
---@throws When `params` defines an unrecognized field.
---@throws When `params.name` is not a string, or is an empty string.
---@throws When `params.frequency` is not a non-negative number.
---@nodiscard
function M.get_smoke(params)
	check_get_smoke(params)

	return {
		{
			name = params.name or "smoke",
			north_position = util.by_pixel(-30, -44),
			east_position = util.by_pixel(-30, -44),
			frequency = params.frequency or 2 / 16,
			starting_vertical_speed = 0.08,
			starting_frame_deviation = 60,
		},
	}
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-bobs__/graphics/icons" })

local icon_builder = icons:tinted("generator-fluid")

---Gets the icon for the fluid generator, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the icon for the fluid generator as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
