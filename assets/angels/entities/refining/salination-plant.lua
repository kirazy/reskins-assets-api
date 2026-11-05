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

local REFINING_GRAPHICS_PATH = "__angelsrefininggraphics__/graphics/entity/salination-plant/"
local ASSETS_ANGELS_PATH = "__reskins-assets-angels__/graphics/entity/salination-plant/"

local M = {}

---Gets the animation of Angel's salination plant.
---@param tint? Color
---@return Animation
local function get_animation(tint)
	local layers = {
		{
			filename = REFINING_GRAPHICS_PATH .. "salination-plant-base.png",
			priority = "extra-high",
			width = 484,
			height = 540,
			frame_count = 36,
			line_length = 6,
			shift = util.by_pixel(-2.5, -12),
			animation_speed = 0.5,
			scale = 0.5,
		},
		{
			filename = REFINING_GRAPHICS_PATH .. "salination-plant-shadow.png",
			priority = "extra-high",
			width = 509,
			height = 467,
			repeat_count = 36,
			shift = util.by_pixel(10, 6.5),
			draw_as_shadow = true,
			animation_speed = 0.5,
			scale = 0.5,
		},
	}

	if tint then
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "salination-plant-mask.png",
			priority = "extra-high",
			width = 484,
			height = 540,
			repeat_count = 36,
			shift = util.by_pixel(-2.5, -12),
			tint = tint,
			animation_speed = 0.5,
			scale = 0.5,
		}
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "salination-plant-highlights.png",
			priority = "extra-high",
			width = 484,
			height = 540,
			repeat_count = 36,
			shift = util.by_pixel(-2.5, -12),
			blend_mode = "additive",
			animation_speed = 0.5,
			scale = 0.5,
		}
	end

	return { layers = layers }
end

---Gets the graphics of the fluid boxes of Angel's salination plant.
---@return FluidBoxGraphics
local function get_fluid_box_graphics()
	return {
		pipe_picture = {
			north = util.empty_sprite(),
			east = util.empty_sprite(),
			south = util.empty_sprite(),
			west = util.empty_sprite(),
		},
		mirrored_pipe_picture = {
			north = util.empty_sprite(),
			east = {
				filename = REFINING_GRAPHICS_PATH .. "pipe-east2.png",
				priority = "extra-high",
				width = 128,
				height = 128,
				scale = 0.5,
				shift = { -1, 0 },
			},
			south = util.empty_sprite(),
			west = util.empty_sprite(),
		},
	}
end

---Gets the circuit connector of Angel's salination plant for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 4,
			main_offset = util.by_pixel(-11, -52.25),
			shadow_offset = util.by_pixel(-11, -52.25),
			show_shadow = true,
		},
		{
			variation = 4,
			main_offset = util.by_pixel(-11, -52.25),
			shadow_offset = util.by_pixel(-11, -52.25),
			show_shadow = true,
		},
		{
			variation = 4,
			main_offset = util.by_pixel(-11, -52.25),
			shadow_offset = util.by_pixel(-11, -52.25),
			show_shadow = true,
		},
		{
			variation = 4,
			main_offset = util.by_pixel(-11, -52.25),
			shadow_offset = util.by_pixel(-11, -52.25),
			show_shadow = true,
		},
	})
end

---Defines the options for the Angel's salination plant sprite set.
---@class SalinationPlantSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("SalinationPlantSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for Angel's salination plant.
---@param params SalinationPlantSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's salination plant.
---
---#### Examples
---```lua
---local salination_plant = require("__reskins-assets-api__.assets.angels.entities.refining.salination-plant")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = salination_plant.get_sprite_set({ tint = tint })
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
			nominal_width = 7,
			nominal_height = 7,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-angels__/graphics/icons" })

local icon_builder = icons:tinted("salination-plant")

---Gets the icon for Angel's salination plant, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the icon for Angel's salination plant as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
