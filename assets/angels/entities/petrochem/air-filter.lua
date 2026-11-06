---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local IconBuilderFactory = require("api.icon-builder-factory")
local AssemblingMachine1Explosion = require("assets.base.explosions.assembling-machine-1")

local ELECTROLYSER_GRAPHICS_PATH = "__angelspetrochemgraphics__/graphics/entity/electrolyser/"
local ASSETS_ANGELS_PATH = "__reskins-assets-angels__/graphics/entity/air-filter/"

local M = {}

---Gets the animation of Angel's air filter.
---@param tint? Color
---@return Animation
local function get_animation(tint)
	local layers = {
		{
			filename = ASSETS_ANGELS_PATH .. "air-filter-base.png",
			priority = "extra-high",
			width = 256,
			height = 256,
			frame_count = 36,
			line_length = 6,
			shift = { 0.5, -0.5 },
			animation_speed = 0.5,
		},
	}

	if tint then
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "air-filter-mask.png",
			priority = "extra-high",
			width = 256,
			height = 256,
			frame_count = 36,
			line_length = 6,
			shift = { 0.5, -0.5 },
			animation_speed = 0.5,
			tint = tint,
		}
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "air-filter-highlights.png",
			priority = "extra-high",
			width = 256,
			height = 256,
			frame_count = 36,
			line_length = 6,
			shift = { 0.5, -0.5 },
			animation_speed = 0.5,
			blend_mode = "additive",
		}
	end

	return { layers = layers }
end

---Gets the graphics for the fluid boxes of Angel's air filter.
---@return FluidBoxGraphics
local function get_fluid_box_graphics()
	return {
		pipe_picture = {
			north = util.empty_sprite(),
			east = util.empty_sprite(),
			south = {
				filename = ELECTROLYSER_GRAPHICS_PATH .. "pipe-south.png",
				priority = "extra-high",
				width = 41,
				height = 40,
				shift = util.by_pixel(5, -8),
			},
			west = util.empty_sprite(),
		},
	}
end

---Gets the circuit connector of Angel's air filter for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 4,
			main_offset = util.by_pixel(-4.375, 62.625),
			shadow_offset = util.by_pixel(-4.375, 62.625),
			show_shadow = true,
		},
		{
			variation = 4,
			main_offset = util.by_pixel(-4.375, 62.625),
			shadow_offset = util.by_pixel(-4.375, 62.625),
			show_shadow = true,
		},
		{
			variation = 4,
			main_offset = util.by_pixel(-4.375, 62.625),
			shadow_offset = util.by_pixel(-4.375, 62.625),
			show_shadow = true,
		},
		{
			variation = 4,
			main_offset = util.by_pixel(-4.375, 62.625),
			shadow_offset = util.by_pixel(-4.375, 62.625),
			show_shadow = true,
		},
	})
end

---Defines the options for the Angel's air filter sprite set.
---@class AirFilterSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("AirFilterSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for Angel's air filter.
---@param params AirFilterSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's air filter.
---
---#### Examples
---```lua
---local air_filter = require("__reskins-assets-api__.assets.angels.entities.petrochem.air-filter")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = air_filter.get_sprite_set({ tint = tint })
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
			graphics_set = { animation = get_animation(params.tint) },
			circuit_connector = get_circuit_connector(),
			fluid_boxes = { get_fluid_box_graphics() },
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = AssemblingMachine1Explosion.get_explosion({
				tints = params.tint and {
					["assembling-machine-1-metal-particle-big"] = params.tint,
					["assembling-machine-1-metal-particle-medium"] = params.tint,
				},
			}),
			corpse = _defines.generic_remnants,
			water_reflection = nil,
			drawing_box_vertical_extension = 0.3,
			nominal_width = 5,
			nominal_height = 5,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-angels__/graphics/icons" })

local icon_builder = icons:tinted("air-filter")

---Gets the icon for Angel's air filter, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the icon for Angel's air filter as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
