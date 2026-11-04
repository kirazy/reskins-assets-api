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

local REFINING_GRAPHICS_PATH = "__angelsrefininggraphics__/graphics/entity/ore-refinery/"
local ASSETS_ANGELS_PATH = "__reskins-assets-angels__/graphics/entity/ore-refinery/"

local M = {}

---Gets the animation of Angel's ore refinery.
---@param tint? Color
---@return Animation
local function get_animation(tint)
	local layers = {
		{
			filename = REFINING_GRAPHICS_PATH .. "ore-refinery-base.png",
			priority = "extra-high",
			width = 440,
			height = 509,
			shift = util.by_pixel(0.5, -16),
			scale = 0.5,
		},
		{
			filename = REFINING_GRAPHICS_PATH .. "ore-refinery-shadow.png",
			priority = "extra-high",
			width = 522,
			height = 340,
			shift = util.by_pixel(21.5, 29),
			draw_as_shadow = true,
			scale = 0.5,
		},
	}

	if tint then
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "ore-refinery-mask.png",
			priority = "extra-high",
			width = 440,
			height = 509,
			shift = util.by_pixel(0.5, -16),
			tint = tint,
			scale = 0.5,
		}
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "ore-refinery-highlights.png",
			priority = "extra-high",
			width = 440,
			height = 509,
			shift = util.by_pixel(0.5, -16),
			blend_mode = "additive",
			scale = 0.5,
		}
	end

	return { layers = layers }
end

---Gets the working visualisations of Angel's ore refinery.
---@return WorkingVisualisation[]
local function get_working_visualisations()
	return {
		{
			fadeout = true,
			effect = "uranium-glow",
			animation = {
				filename = REFINING_GRAPHICS_PATH .. "ore-refinery-lights.png",
				priority = "extra-high",
				width = 440,
				height = 509,
				shift = util.by_pixel(0.5, -16),
				draw_as_glow = true,
				blend_mode = "additive-soft",
				scale = 0.5,
			},
		},
		{
			fadeout = true,
			constant_speed = true,
			apply_recipe_tint = "primary",
			north_position = util.by_pixel_hr(-63, -255),
			east_position = util.by_pixel_hr(-63, -255),
			south_position = util.by_pixel_hr(-63, -255),
			west_position = util.by_pixel_hr(-63, -255),
			render_layer = "wires",
			animation = {
				filename = "__base__/graphics/entity/chemical-plant/chemical-plant-smoke-outer.png",
				frame_count = 47,
				line_length = 16,
				width = 90,
				height = 188,
				animation_speed = 0.5,
				shift = util.by_pixel(-2, -40),
				tint = util.color("808080"),
				scale = 0.5,
			},
		},
		{
			fadeout = true,
			constant_speed = true,
			--apply_recipe_tint = "primary",
			north_position = util.by_pixel_hr(-63, -255),
			east_position = util.by_pixel_hr(-63, -255),
			south_position = util.by_pixel_hr(-63, -255),
			west_position = util.by_pixel_hr(-63, -255),
			render_layer = "wires",
			animation = {
				filename = "__base__/graphics/entity/chemical-plant/chemical-plant-smoke-inner.png",
				frame_count = 47,
				line_length = 16,
				width = 40,
				height = 84,
				animation_speed = 0.5,
				shift = util.by_pixel(0, -14),
				tint = util.color("b3b3b3"),
				scale = 0.5 * 1.2,
			},
		},
		{
			always_draw = true,
			apply_recipe_tint = "primary",
			render_layer = "wires",
			animation = {
				filename = REFINING_GRAPHICS_PATH .. "stack-patch-overlay.png",
				priority = "extra-high",
				width = 46,
				height = 25,
				shift = util.by_pixel_hr(-61, -246),
				scale = 0.5,
			},
		},
	}
end

---Gets the circuit connector of Angel's ore refinery for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 5,
			main_offset = util.by_pixel(31.25, 49.875),
			shadow_offset = util.by_pixel(31.25, 49.875),
			show_shadow = true,
		},
		{
			variation = 5,
			main_offset = util.by_pixel(31.25, 49.875),
			shadow_offset = util.by_pixel(31.25, 49.875),
			show_shadow = true,
		},
		{
			variation = 5,
			main_offset = util.by_pixel(31.25, 49.875),
			shadow_offset = util.by_pixel(31.25, 49.875),
			show_shadow = true,
		},
		{
			variation = 5,
			main_offset = util.by_pixel(31.25, 49.875),
			shadow_offset = util.by_pixel(31.25, 49.875),
			show_shadow = true,
		},
	})
end

---Defines the options for the Angel's ore refinery sprite set.
---@class OreRefinerySpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("OreRefinerySpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for Angel's ore refinery.
---@param params OreRefinerySpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's ore refinery.
---
---#### Examples
---```lua
---local ore_refinery = require("__reskins-assets-api__.assets.angels.entities.refining.ore-refinery")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = ore_refinery.get_sprite_set({ tint = tint })
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
			nominal_width = 7,
			nominal_height = 7,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-angels__/graphics/icons" })

---Gets the icon for Angel's ore refinery, in the tints given by `params`.
M.get_icon = icons:tinted("ore-refinery"):build("get_icon")

return M
