---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local IconBuilderFactory = require("api.icon-builder-factory")
local OilRefineryExplosion = require("assets.base.explosions.oil-refinery")

local SMELTING_GRAPHICS_PATH = "__angelssmeltinggraphics__/graphics/entity/blast-furnace/"
local ASSETS_ANGELS_PATH = "__reskins-assets-angels__/graphics/entity/blast-furnace/"

local M = {}

---Gets the animation of Angel's blast furnace.
---@param tint? Color
---@return Animation
local function get_animation(tint)
	local layers = {
		{
			filename = SMELTING_GRAPHICS_PATH .. "blast-furnace-base.png",
			priority = "extra-high",
			width = 328,
			height = 376,
			shift = util.by_pixel(0, -13.5),
			scale = 0.5,
		},
		{
			filename = SMELTING_GRAPHICS_PATH .. "blast-furnace-shadow.png",
			priority = "extra-high",
			width = 445,
			height = 245,
			shift = util.by_pixel(29, 19.5),
			draw_as_shadow = true,
			scale = 0.5,
		},
	}

	if tint then
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "blast-furnace-mask.png",
			priority = "extra-high",
			width = 328,
			height = 376,
			shift = util.by_pixel(0, -13.5),
			tint = tint,
			scale = 0.5,
		}
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "blast-furnace-highlights.png",
			priority = "extra-high",
			width = 328,
			height = 376,
			shift = util.by_pixel(0, -13.5),
			blend_mode = "additive",
			scale = 0.5,
		}
	end

	return { layers = layers }
end

---Gets the working visualisations of Angel's blast furnace.
---@return WorkingVisualisation[]
local function get_working_visualisations()
	return {
		{
			fadeout = true,
			north_position = { 0, 0 },
			east_position = { 0, 0 },
			south_position = { 0, 0 },
			west_position = { 0, 0 },
			animation = {
				filename = SMELTING_GRAPHICS_PATH .. "blast-furnace-fire.png",
				priority = "high",
				width = 23,
				height = 50,
				line_length = 8,
				frame_count = 48,
				animation_speed = 0.5,
				shift = util.by_pixel(3, 29),
				draw_as_glow = true,
				scale = 0.5,
			},
		},
		{
			fadeout = true,
			north_position = { 0, 0 },
			east_position = { 0, 0 },
			south_position = { 0, 0 },
			west_position = { 0, 0 },
			effect = "flicker",
			animation = {
				filename = SMELTING_GRAPHICS_PATH .. "blast-furnace-glow.png",
				priority = "high",
				width = 60,
				height = 43,
				blend_mode = "additive",
				shift = util.by_pixel(5, 39),
				draw_as_glow = true,
				scale = 0.75,
			},
		},
		{
			fadeout = true,
			north_position = { 0, 0 },
			east_position = { 0, 0 },
			south_position = { 0, 0 },
			west_position = { 0, 0 },
			effect = "flicker",
			animation = {
				filename = SMELTING_GRAPHICS_PATH .. "blast-furnace-working-light.png",
				priority = "high",
				width = 328,
				height = 376,
				blend_mode = "additive",
				shift = util.by_pixel(0, -13.5),
				draw_as_glow = true,
				scale = 0.5,
			},
		},
	}
end

---Gets the light flicker of Angel's blast furnace energy source, which shows no light.
---@return LightFlickeringDefinition
local function get_light_flicker()
	return {
		color = { 0, 0, 0 },
		minimum_light_size = 0,
		light_intensity_to_size_coefficient = 0,
	}
end

---Gets the circuit connector of Angel's blast furnace for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 4,
			main_offset = util.by_pixel(8.875, 58.625),
			shadow_offset = util.by_pixel(8.875, 58.625),
			show_shadow = true,
		},
		{
			variation = 4,
			main_offset = util.by_pixel(8.875, 58.625),
			shadow_offset = util.by_pixel(8.875, 58.625),
			show_shadow = true,
		},
		{
			variation = 4,
			main_offset = util.by_pixel(8.875, 58.625),
			shadow_offset = util.by_pixel(8.875, 58.625),
			show_shadow = true,
		},
		{
			variation = 4,
			main_offset = util.by_pixel(8.875, 58.625),
			shadow_offset = util.by_pixel(8.875, 58.625),
			show_shadow = true,
		},
	})
end

---Defines the options for the Angel's blast furnace sprite set.
---@class BlastFurnaceSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("BlastFurnaceSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for Angel's blast furnace.
---@param params BlastFurnaceSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's blast furnace.
---
---#### Examples
---```lua
---local blast_furnace = require("__reskins-assets-api__.assets.angels.entities.smelting.blast-furnace")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = blast_furnace.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@throws When `params` defines an unrecognized field.
---@throws When `params.tint` is not a `Color`.
---@nodiscard
function M.get_sprite_set(params)
	check_get_sprite_set(params)

	---@type SpriteSetDefinition<CraftingMachineSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.crafting_machine_sprite_set,
		set = {
			graphics_set = {
				animation = get_animation(params.tint),
				working_visualisations = get_working_visualisations(),
			},
			circuit_connector = get_circuit_connector(),
			light_flicker = get_light_flicker(),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = OilRefineryExplosion.get_explosion({
				tints = params.tint and {
					["oil-refinery-metal-particle-big-tint"] = params.tint,
					["oil-refinery-metal-particle-medium"] = params.tint,
				},
			}),
			corpse = _defines.generic_remnants,
			water_reflection = nil,
			drawing_box_vertical_extension = 1,
			nominal_width = 5,
			nominal_height = 5,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-angels__/graphics/icons" })

local icon_builder = icons:tinted("blast-furnace")

---Gets the icon for Angel's blast furnace, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the icon for Angel's blast furnace as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
