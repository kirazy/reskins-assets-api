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

local REFINING_GRAPHICS_PATH = "__angelsrefininggraphics__/graphics/entity/ore-leaching-plant/"
local ASSETS_ANGELS_PATH = "__reskins-assets-angels__/graphics/entity/ore-leaching-plant/"

local M = {}

---Gets the animation of Angel's ore leaching plant.
---@param tint? Color
---@return Animation
local function get_animation(tint)
	local layers = {
		{
			filename = REFINING_GRAPHICS_PATH .. "1ore-leaching-plant.png",
			priority = "extra-high",
			width = 192,
			height = 192,
			shift = { 0.4, -0.14 },
		},
	}

	if tint then
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "ore-leaching-plant-mask.png",
			priority = "extra-high",
			width = 192,
			height = 192,
			shift = { 0.4, -0.14 },
			tint = tint,
		}
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "ore-leaching-plant-highlights.png",
			priority = "extra-high",
			width = 192,
			height = 192,
			shift = { 0.4, -0.14 },
			blend_mode = "additive",
		}
	end

	return { layers = layers }
end

---Gets the graphics of the fluid boxes of Angel's ore leaching plant.
---@return FluidBoxGraphics
local function get_fluid_box_graphics()
	return {
		pipe_picture = {
			north = util.empty_sprite(),
			east = {
				filename = REFINING_GRAPHICS_PATH .. "pipe-east1.png",
				priority = "extra-high",
				width = 64,
				height = 64,
				scale = 0.5,
				shift = { -1, 0 },
			},
			south = {
				filename = REFINING_GRAPHICS_PATH .. "pipe-south.png",
				priority = "extra-high",
				width = 41,
				height = 40,
				shift = { 0.05, -0.375 },
			},
			west = util.empty_sprite(),
		},
		mirrored_pipe_picture = {
			north = {
				filename = REFINING_GRAPHICS_PATH .. "pipe-north2.png",
				priority = "extra-high",
				width = 64,
				height = 64,
				scale = 0.5,
				shift = { 0, 1 },
			},
			east = {
				filename = REFINING_GRAPHICS_PATH .. "pipe-east2.png",
				priority = "extra-high",
				width = 64,
				height = 64,
				scale = 0.5,
				shift = { -1, 0 },
			},
			south = {
				filename = REFINING_GRAPHICS_PATH .. "pipe-south.png",
				priority = "extra-high",
				width = 41,
				height = 40,
				shift = { 0.05, -0.375 },
			},
			west = {
				filename = REFINING_GRAPHICS_PATH .. "pipe-west2.png",
				priority = "extra-high",
				width = 64,
				height = 64,
				scale = 0.5,
				shift = { 1, 0 },
			},
		},
	}
end

---Gets the circuit connector of Angel's ore leaching plant for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 4,
			main_offset = util.by_pixel(26.875, 23.75),
			shadow_offset = util.by_pixel(26.875, 23.75),
			show_shadow = true,
		},
		{
			variation = 4,
			main_offset = util.by_pixel(26.875, 23.75),
			shadow_offset = util.by_pixel(26.875, 23.75),
			show_shadow = true,
		},
		{
			variation = 4,
			main_offset = util.by_pixel(26.875, 23.75),
			shadow_offset = util.by_pixel(26.875, 23.75),
			show_shadow = true,
		},
		{
			variation = 4,
			main_offset = util.by_pixel(26.875, 23.75),
			shadow_offset = util.by_pixel(26.875, 23.75),
			show_shadow = true,
		},
	})
end

---Defines the options for the Angel's ore leaching plant sprite set.
---@class OreLeachingPlantSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("OreLeachingPlantSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for Angel's ore leaching plant.
---@param params OreLeachingPlantSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's ore leaching plant.
---
---#### Examples
---```lua
---local ore_leaching_plant = require("__reskins-assets-api__.assets.angels.entities.refining.ore-leaching-plant")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = ore_leaching_plant.get_sprite_set({ tint = tint })
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
			nominal_width = 5,
			nominal_height = 5,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-angels__/graphics/icons" })

local icon_builder = icons:tinted("ore-leaching-plant")

---Gets the icon for Angel's ore leaching plant, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the icon for Angel's ore leaching plant as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
