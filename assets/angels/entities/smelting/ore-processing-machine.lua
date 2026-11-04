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

local SMELTING_GRAPHICS_PATH = "__angelssmeltinggraphics__/graphics/entity/ore-processing-machine/"
local ASSETS_ANGELS_PATH = "__reskins-assets-angels__/graphics/entity/ore-processing-machine/"

local M = {}

---Gets the animation of Angel's ore processing machine.
---@param tint? Color
---@return Animation
local function get_animation(tint)
	local layers = {
		{
			filename = SMELTING_GRAPHICS_PATH .. "ore-processing-machine-base.png",
			priority = "extra-high",
			width = 196,
			height = 206,
			line_length = 5,
			frame_count = 25,
			animation_speed = 0.5,
			shift = util.by_pixel(-0.5, -2),
			scale = 0.5,
		},
		{
			filename = SMELTING_GRAPHICS_PATH .. "ore-processing-machine-shadow.png",
			priority = "extra-high",
			width = 243,
			height = 137,
			repeat_count = 25,
			animation_speed = 0.5,
			draw_as_shadow = true,
			shift = util.by_pixel(12.5, 16),
			scale = 0.5,
		},
	}

	if tint then
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "ore-processing-machine-mask.png",
			priority = "extra-high",
			width = 196,
			height = 206,
			line_length = 5,
			frame_count = 25,
			animation_speed = 0.5,
			shift = util.by_pixel(-0.5, -2),
			tint = tint,
			scale = 0.5,
		}
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "ore-processing-machine-highlights.png",
			priority = "extra-high",
			width = 196,
			height = 206,
			line_length = 5,
			frame_count = 25,
			animation_speed = 0.5,
			shift = util.by_pixel(-0.5, -2),
			blend_mode = "additive",
			scale = 0.5,
		}
	end

	return { layers = layers }
end

---Gets the dust animation of Angel's ore processing machine.
---@return Animation
local function get_dust_animation()
	return {
		filename = SMELTING_GRAPHICS_PATH .. "ore-processing-machine-dust.png",
		priority = "high",
		width = 107,
		height = 170,
		line_length = 5,
		frame_count = 20,
		animation_speed = 0.40,
		shift = util.by_pixel(0, -21.5),
		scale = 0.5,
	}
end

---Gets the working visualisations of Angel's ore processing machine.
---@return WorkingVisualisation[]
local function get_working_visualisations()
	return {
		{
			fadeout = true,
			constant_speed = true,
			animation = get_dust_animation(),
		},
		{
			apply_recipe_tint = "primary",
			fadeout = true,
			constant_speed = true,
			animation = get_dust_animation(),
		},
		{
			always_draw = true,
			animation = {
				filename = SMELTING_GRAPHICS_PATH .. "ore-processing-machine-top.png",
				priority = "high",
				width = 192,
				height = 139,
				shift = util.by_pixel(0, -22.5),
				scale = 0.5,
			},
		},
	}
end

---Gets the circuit connector of Angel's ore processing machine for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 4,
			main_offset = util.by_pixel(-5.125, 28.125),
			shadow_offset = util.by_pixel(-5.125, 28.125),
			show_shadow = true,
		},
		{
			variation = 4,
			main_offset = util.by_pixel(-5.125, 28.125),
			shadow_offset = util.by_pixel(-5.125, 28.125),
			show_shadow = true,
		},
		{
			variation = 4,
			main_offset = util.by_pixel(-5.125, 28.125),
			shadow_offset = util.by_pixel(-5.125, 28.125),
			show_shadow = true,
		},
		{
			variation = 4,
			main_offset = util.by_pixel(-5.125, 28.125),
			shadow_offset = util.by_pixel(-5.125, 28.125),
			show_shadow = true,
		},
	})
end

---Defines the options for the Angel's ore processing machine sprite set.
---@class OreProcessingMachineSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("OreProcessingMachineSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for Angel's ore processing machine.
---@param params OreProcessingMachineSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's ore processing machine.
---
---#### Examples
---```lua
---local ore_processing_machine = require("__reskins-assets-api__.assets.angels.entities.smelting.ore-processing-machine")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = ore_processing_machine.get_sprite_set({ tint = tint })
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
			dying_explosion = AssemblingMachine1Explosion.get_explosion({
				tints = params.tint and {
					["assembling-machine-1-metal-particle-big"] = params.tint,
					["assembling-machine-1-metal-particle-medium"] = params.tint,
				},
			}),
			corpse = _defines.generic_remnants,
			water_reflection = nil,
			drawing_box_vertical_extension = 0.333,
			nominal_width = 3,
			nominal_height = 3,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-angels__/graphics/icons" })

---Gets the icon for Angel's ore processing machine, in the tints given by `params`.
M.get_icon = icons:tinted("ore-processing-machine"):build("get_icon")

return M
