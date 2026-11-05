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

local PETROCHEM_GRAPHICS_PATH = "__angelspetrochemgraphics__/graphics/entity/separator/"
local ASSETS_ANGELS_PATH = "__reskins-assets-angels__/graphics/entity/separator/"

local M = {}

---Gets the animation of Angel's separator.
---@param tint? Color
---@return Animation
local function get_animation(tint)
	local layers = {
		{
			filename = PETROCHEM_GRAPHICS_PATH .. "separator.png",
			priority = "extra-high",
			width = 224,
			height = 224,
			shift = { 0, 0 },
		},
	}

	if tint then
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "separator-mask.png",
			priority = "extra-high",
			width = 224,
			height = 224,
			shift = { 0, 0 },
			tint = tint,
		}
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "separator-highlights.png",
			priority = "extra-high",
			width = 224,
			height = 224,
			shift = { 0, 0 },
			blend_mode = "additive",
		}
	end

	return { layers = layers }
end

---Gets the pipe pictures of Angel's separator that draw the given `pipe` at a connection facing north.
---@param pipe "pipe-north1"|"pipe-north2"
---@param shift Vector
---@return Sprite4Way
local function get_pipe_pictures(pipe, shift)
	return {
		north = {
			filename = PETROCHEM_GRAPHICS_PATH .. pipe .. ".png",
			priority = "extra-high",
			width = 96,
			height = 96,
			scale = 0.5,
			shift = shift,
		},
		east = util.empty_sprite(),
		south = util.empty_sprite(),
		west = util.empty_sprite(),
	}
end

---Gets the pipe pictures that draw nothing in each direction.
---@return Sprite4Way
local function get_empty_pipe_pictures()
	return {
		north = util.empty_sprite(),
		east = util.empty_sprite(),
		south = util.empty_sprite(),
		west = util.empty_sprite(),
	}
end

---Gets the graphics of the fluid boxes of Angel's separator.
---@return FluidBoxGraphics[]
local function get_fluid_box_graphics()
	-- The pipe at the north corners is drawn at the left corner only. When the separator is flipped, the fluid box at
	-- the right corner moves to the left corner and draws the pipe.
	return {
		{
			pipe_connections = {
				{ direction = defines.direction.south, position = { 0, 2 } },
				{ direction = defines.direction.north, position = { 0, -2 } },
			},
			pipe_picture = get_pipe_pictures("pipe-north2", util.by_pixel(4, 36)),
		},
		{
			pipe_connections = {
				{ direction = defines.direction.north, position = { -2, -2 } },
			},
			pipe_picture = get_pipe_pictures("pipe-north1", util.by_pixel(3, 36)),
			mirrored_pipe_picture = get_empty_pipe_pictures(),
		},
		{
			pipe_connections = {
				{ direction = defines.direction.north, position = { 2, -2 } },
			},
			mirrored_pipe_picture = get_pipe_pictures("pipe-north1", util.by_pixel(3, 36)),
		},
	}
end

---Gets the circuit connector of Angel's separator for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 25,
			main_offset = util.by_pixel(30, 27.875),
			shadow_offset = util.by_pixel(30, 27.875),
			show_shadow = true,
		},
		{
			variation = 25,
			main_offset = util.by_pixel(30, 27.875),
			shadow_offset = util.by_pixel(30, 27.875),
			show_shadow = true,
		},
		{
			variation = 25,
			main_offset = util.by_pixel(30, 27.875),
			shadow_offset = util.by_pixel(30, 27.875),
			show_shadow = true,
		},
		{
			variation = 25,
			main_offset = util.by_pixel(30, 27.875),
			shadow_offset = util.by_pixel(30, 27.875),
			show_shadow = true,
		},
	})
end

---Defines the options for the Angel's separator sprite set.
---@class SeparatorSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("SeparatorSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for Angel's separator.
---@param params SeparatorSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's separator.
---
---#### Examples
---```lua
---local separator = require("__reskins-assets-api__.assets.angels.entities.petrochem.separator")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = separator.get_sprite_set({ tint = tint })
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
			fluid_boxes = get_fluid_box_graphics(),
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

local icon_builder = icons:tinted("separator")

---Gets the icon for Angel's separator, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the icon for Angel's separator as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
