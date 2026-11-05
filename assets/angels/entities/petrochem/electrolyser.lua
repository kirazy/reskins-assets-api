---cspell: words Electrolyser
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

local PETROCHEM_GRAPHICS_PATH = "__angelspetrochemgraphics__/graphics/entity/electrolyser/"
local ASSETS_ANGELS_PATH = "__reskins-assets-angels__/graphics/entity/electrolyser/"

local M = {}

---Gets the animation of Angel's electrolyser for the given `direction`.
---@param direction "north"|"east"
---@param tint? Color
---@return Animation
local function get_direction_animation(direction, tint)
	local layers = {
		{
			filename = PETROCHEM_GRAPHICS_PATH .. "electrolyser-" .. direction .. ".png",
			width = 224,
			height = 224,
			frame_count = 36,
			line_length = 6,
			shift = { 0, 0 },
			animation_speed = 0.5,
		},
	}

	if tint then
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "electrolyser-mask.png",
			priority = "extra-high",
			width = 224,
			height = 224,
			frame_count = 36,
			line_length = 6,
			shift = { 0, 0 },
			animation_speed = 0.5,
			tint = tint,
		}
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "electrolyser-highlights.png",
			priority = "extra-high",
			width = 224,
			height = 224,
			frame_count = 36,
			line_length = 6,
			shift = { 0, 0 },
			animation_speed = 0.5,
			blend_mode = "additive",
		}
	end

	return { layers = layers }
end

---Gets the animation of Angel's electrolyser.
---@param tint? Color
---@return Animation4Way
local function get_animation(tint)
	-- The south and west directions draw the artwork of the north and east directions.
	return {
		north = get_direction_animation("north", tint),
		east = get_direction_animation("east", tint),
		south = get_direction_animation("north", tint),
		west = get_direction_animation("east", tint),
	}
end

---Gets the graphics of the fluid boxes of Angel's electrolyser.
---@return FluidBoxGraphics
local function get_fluid_box_graphics()
	return {
		pipe_picture = {
			north = util.empty_sprite(),
			east = util.empty_sprite(),
			south = {
				filename = PETROCHEM_GRAPHICS_PATH .. "pipe-south.png",
				priority = "extra-high",
				width = 41,
				height = 40,
				shift = util.by_pixel(5, -8),
			},
			west = util.empty_sprite(),
		},
	}
end

---Gets the circuit connector of Angel's electrolyser for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 4,
			main_offset = util.by_pixel(20.875, 62),
			shadow_offset = util.by_pixel(20.875, 62),
			show_shadow = true,
		},
		{
			variation = 4,
			main_offset = util.by_pixel(20.875, 62),
			shadow_offset = util.by_pixel(20.875, 62),
			show_shadow = true,
		},
		{
			variation = 4,
			main_offset = util.by_pixel(20.875, 62),
			shadow_offset = util.by_pixel(20.875, 62),
			show_shadow = true,
		},
		{
			variation = 4,
			main_offset = util.by_pixel(20.875, 62),
			shadow_offset = util.by_pixel(20.875, 62),
			show_shadow = true,
		},
	})
end

---Defines the options for the Angel's electrolyser sprite set.
---@class ElectrolyserSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("ElectrolyserSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for Angel's electrolyser.
---@param params ElectrolyserSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's electrolyser.
---
---#### Examples
---```lua
---local electrolyser = require("__reskins-assets-api__.assets.angels.entities.petrochem.electrolyser")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = electrolyser.get_sprite_set({ tint = tint })
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
			use_mirroring = true,
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

local icon_builder = icons:tinted("electrolyser")

---Gets the icon for Angel's electrolyser, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the icon for Angel's electrolyser as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
