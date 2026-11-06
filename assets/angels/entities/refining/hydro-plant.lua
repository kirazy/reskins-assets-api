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

local REFINING_GRAPHICS_PATH = "__angelsrefininggraphics__/graphics/entity/hydro-plant/"
local ASSETS_ANGELS_PATH = "__reskins-assets-angels__/graphics/entity/hydro-plant/"

local M = {}

---Gets the animation of Angel's hydro plant.
---@param tint? Color
---@return Animation
local function get_animation(tint)
	local layers = {
		{
			filename = REFINING_GRAPHICS_PATH .. "hydro-plant-base.png",
			priority = "extra-high",
			width = 459,
			height = 491,
			shift = util.by_pixel(0, 0),
			scale = 0.5,
		},
	}

	if tint then
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "hydro-plant-mask.png",
			priority = "extra-high",
			width = 459,
			height = 491,
			shift = util.by_pixel(0, 0),
			tint = tint,
			scale = 0.5,
		}
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "hydro-plant-highlights.png",
			priority = "extra-high",
			width = 459,
			height = 491,
			shift = util.by_pixel(0, 0),
			blend_mode = "additive",
			scale = 0.5,
		}
	end

	return { layers = layers }
end

---Gets the graphics set of Angel's hydro plant.
---@param tint? Color
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint)
	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = get_animation(tint),
		working_visualisations = {
			{
				always_draw = true,
				north_position = util.by_pixel(-52.5, -43),
				east_position = util.by_pixel(-52.5, -43),
				south_position = util.by_pixel(-52.5, -43),
				west_position = util.by_pixel(-52.5, -43),
				animation = {
					layers = {
						{
							filename = REFINING_GRAPHICS_PATH .. "hydro-plant-fan.png",
							priority = "extra-high",
							width = 107,
							height = 77,
							frame_count = 24,
							line_length = 6,
							animation_speed = 0.5,
							shift = util.by_pixel(0, -47.75),
							scale = 0.5,
						},
						{
							filename = REFINING_GRAPHICS_PATH .. "hydro-plant-fan.png",
							priority = "extra-high",
							width = 107,
							height = 77,
							frame_count = 24,
							line_length = 6,
							animation_speed = 0.5,
							shift = util.by_pixel(0, 0.125),
							scale = 0.5,
						},
						{
							filename = REFINING_GRAPHICS_PATH .. "hydro-plant-fan.png",
							priority = "extra-high",
							width = 107,
							height = 77,
							frame_count = 24,
							line_length = 6,
							animation_speed = 0.5,
							shift = util.by_pixel(0, 48),
							scale = 0.5,
						},
					},
				},
			},
			{
				always_draw = true,
				north_position = util.by_pixel(14.5, -21.5),
				east_position = util.by_pixel(14.5, -21.5),
				south_position = util.by_pixel(14.5, -21.5),
				west_position = util.by_pixel(14.5, -21.5),
				animation = {
					layers = {
						{
							filename = REFINING_GRAPHICS_PATH .. "hydro-plant-dynamo.png",
							priority = "extra-high",
							width = 40,
							height = 36,
							frame_count = 24,
							line_length = 6,
							animation_speed = 0.5,
							shift = util.by_pixel(0, -47.75),
							scale = 0.5,
						},
						{
							filename = REFINING_GRAPHICS_PATH .. "hydro-plant-dynamo.png",
							priority = "extra-high",
							width = 40,
							height = 36,
							frame_count = 24,
							line_length = 6,
							animation_speed = 0.5,
							shift = util.by_pixel(0, 0.125),
							scale = 0.5,
						},
						{
							filename = REFINING_GRAPHICS_PATH .. "hydro-plant-dynamo.png",
							priority = "extra-high",
							width = 40,
							height = 36,
							frame_count = 24,
							line_length = 6,
							animation_speed = 0.5,
							shift = util.by_pixel(0, 48),
							scale = 0.5,
						},
					},
				},
			},
			{
				always_draw = true,
				north_animation = {
					draw_as_shadow = true,
					filename = REFINING_GRAPHICS_PATH .. "hydro-plant-shadow.png",
					priority = "extra-high",
					width = 538,
					height = 454,
					shift = util.by_pixel(20, 10.5),
					x = 0,
					y = 0,
					frame_count = 1,
					scale = 0.5,
				},
				east_animation = {
					draw_as_shadow = true,
					filename = REFINING_GRAPHICS_PATH .. "hydro-plant-shadow.png",
					priority = "extra-high",
					width = 538,
					height = 454,
					x = 538,
					y = 0,
					frame_count = 1,
					shift = util.by_pixel(20, 10.5),
					scale = 0.5,
				},
				south_animation = {
					draw_as_shadow = true,
					filename = REFINING_GRAPHICS_PATH .. "hydro-plant-shadow.png",
					priority = "extra-high",
					width = 538,
					x = 1076,
					y = 0,
					height = 454,
					frame_count = 1,
					shift = util.by_pixel(20, 10.5),
					scale = 0.5,
				},
				west_animation = {
					draw_as_shadow = true,
					filename = REFINING_GRAPHICS_PATH .. "hydro-plant-shadow.png",
					priority = "extra-high",
					width = 538,
					height = 454,
					x = 1614,
					y = 0,
					frame_count = 1,
					shift = util.by_pixel(20, 10.5),
					scale = 0.5,
				},
			},
			{
				always_draw = true,
				north_animation = {
					filename = REFINING_GRAPHICS_PATH .. "hydro-plant-pipe-connections.png",
					priority = "extra-high",
					width = 459,
					height = 491,
					x = 0,
					y = 0,
					frame_count = 1,
					scale = 0.5,
				},
				east_animation = {
					filename = REFINING_GRAPHICS_PATH .. "hydro-plant-pipe-connections.png",
					priority = "extra-high",
					frame_count = 1,
					width = 459,
					height = 491,
					x = 459,
					y = 0,
					scale = 0.5,
				},
				south_animation = {
					filename = REFINING_GRAPHICS_PATH .. "hydro-plant-pipe-connections.png",
					priority = "extra-high",
					width = 459,
					height = 491,
					x = 918,
					y = 0,
					frame_count = 1,
					scale = 0.5,
				},
				west_animation = {
					filename = REFINING_GRAPHICS_PATH .. "hydro-plant-pipe-connections.png",
					priority = "extra-high",
					width = 459,
					height = 491,
					x = 1377,
					y = 0,
					frame_count = 1,
					scale = 0.5,
				},
			},
			{
				always_draw = true,
				north_animation = {
					draw_as_shadow = true,
					filename = REFINING_GRAPHICS_PATH .. "vertical-pipe-shadow-patch.png",
					priority = "high",
					width = 128,
					height = 128,
					repeat_count = 36,
					scale = 0.5,
					shift = { -2, -3 },
				},
				south_animation = {
					layers = {
						{
							draw_as_shadow = true,
							filename = REFINING_GRAPHICS_PATH .. "vertical-pipe-shadow-patch.png",
							priority = "high",
							width = 128,
							height = 128,
							repeat_count = 36,
							scale = 0.5,
							shift = { -2, -3 },
						},
						{
							draw_as_shadow = true,
							filename = REFINING_GRAPHICS_PATH .. "vertical-pipe-shadow-patch.png",
							priority = "high",
							width = 128,
							height = 128,
							repeat_count = 36,
							scale = 0.5,
							shift = { 2, -3 },
						},
					},
				},
			},
		},
	}

	return graphics_set
end

---Gets the graphics set of Angel's hydro plant when it is flipped.
---@param tint? Color
---@return CraftingMachineGraphicsSet
local function get_graphics_set_flipped(tint)
	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = get_animation(tint),
		working_visualisations = {
			{
				always_draw = true,
				north_position = util.by_pixel(-52.5, -43),
				east_position = util.by_pixel(-52.5, -43),
				south_position = util.by_pixel(-52.5, -43),
				west_position = util.by_pixel(-52.5, -43),
				animation = {
					layers = {
						{
							filename = REFINING_GRAPHICS_PATH .. "hydro-plant-fan.png",
							priority = "extra-high",
							width = 107,
							height = 77,
							frame_count = 24,
							line_length = 6,
							animation_speed = 0.5,
							shift = util.by_pixel(0, -47.75),
							scale = 0.5,
						},
						{
							filename = REFINING_GRAPHICS_PATH .. "hydro-plant-fan.png",
							priority = "extra-high",
							width = 107,
							height = 77,
							frame_count = 24,
							line_length = 6,
							animation_speed = 0.5,
							shift = util.by_pixel(0, 0.125),
							scale = 0.5,
						},
						{
							filename = REFINING_GRAPHICS_PATH .. "hydro-plant-fan.png",
							priority = "extra-high",
							width = 107,
							height = 77,
							frame_count = 24,
							line_length = 6,
							animation_speed = 0.5,
							shift = util.by_pixel(0, 48),
							scale = 0.5,
						},
					},
				},
			},
			{
				always_draw = true,
				north_position = util.by_pixel(14.5, -21.5),
				east_position = util.by_pixel(14.5, -21.5),
				south_position = util.by_pixel(14.5, -21.5),
				west_position = util.by_pixel(14.5, -21.5),
				animation = {
					layers = {
						{
							filename = REFINING_GRAPHICS_PATH .. "hydro-plant-dynamo.png",
							priority = "extra-high",
							width = 40,
							height = 36,
							frame_count = 24,
							line_length = 6,
							animation_speed = 0.5,
							shift = util.by_pixel(0, -47.75),
							scale = 0.5,
						},
						{
							filename = REFINING_GRAPHICS_PATH .. "hydro-plant-dynamo.png",
							priority = "extra-high",
							width = 40,
							height = 36,
							frame_count = 24,
							line_length = 6,
							animation_speed = 0.5,
							shift = util.by_pixel(0, 0.125),
							scale = 0.5,
						},
						{
							filename = REFINING_GRAPHICS_PATH .. "hydro-plant-dynamo.png",
							priority = "extra-high",
							width = 40,
							height = 36,
							frame_count = 24,
							line_length = 6,
							animation_speed = 0.5,
							shift = util.by_pixel(0, 48),
							scale = 0.5,
						},
					},
				},
			},
			{
				always_draw = true,
				north_animation = {
					draw_as_shadow = true,
					filename = REFINING_GRAPHICS_PATH .. "hydro-plant-shadow-flipped.png",
					priority = "extra-high",
					width = 538,
					height = 454,
					shift = util.by_pixel(20, 10.5),
					x = 0,
					y = 0,
					frame_count = 1,
					scale = 0.5,
				},
				east_animation = {
					draw_as_shadow = true,
					filename = REFINING_GRAPHICS_PATH .. "hydro-plant-shadow-flipped.png",
					priority = "extra-high",
					width = 538,
					height = 454,
					x = 538,
					y = 0,
					frame_count = 1,
					shift = util.by_pixel(20, 10.5),
					scale = 0.5,
				},
				south_animation = {
					draw_as_shadow = true,
					filename = REFINING_GRAPHICS_PATH .. "hydro-plant-shadow-flipped.png",
					priority = "extra-high",
					width = 538,
					x = 1076,
					y = 0,
					height = 454,
					frame_count = 1,
					shift = util.by_pixel(20, 10.5),
					scale = 0.5,
				},
				west_animation = {
					draw_as_shadow = true,
					filename = REFINING_GRAPHICS_PATH .. "hydro-plant-shadow-flipped.png",
					priority = "extra-high",
					width = 538,
					height = 454,
					x = 1614,
					y = 0,
					frame_count = 1,
					shift = util.by_pixel(20, 10.5),
					scale = 0.5,
				},
			},
			{
				always_draw = true,
				north_animation = {
					filename = REFINING_GRAPHICS_PATH .. "hydro-plant-pipe-connections-flipped.png",
					priority = "extra-high",
					width = 459,
					height = 491,
					x = 0,
					y = 0,
					frame_count = 1,
					scale = 0.5,
				},
				east_animation = {
					filename = REFINING_GRAPHICS_PATH .. "hydro-plant-pipe-connections-flipped.png",
					priority = "extra-high",
					frame_count = 1,
					width = 459,
					height = 491,
					x = 459,
					y = 0,
					scale = 0.5,
				},
				south_animation = {
					filename = REFINING_GRAPHICS_PATH .. "hydro-plant-pipe-connections-flipped.png",
					priority = "extra-high",
					width = 459,
					height = 491,
					x = 918,
					y = 0,
					frame_count = 1,
					scale = 0.5,
				},
				west_animation = {
					filename = REFINING_GRAPHICS_PATH .. "hydro-plant-pipe-connections-flipped.png",
					priority = "extra-high",
					width = 459,
					height = 491,
					x = 1377,
					y = 0,
					frame_count = 1,
					scale = 0.5,
				},
			},
			{
				always_draw = true,
				north_animation = {
					draw_as_shadow = true,
					filename = REFINING_GRAPHICS_PATH .. "vertical-pipe-shadow-patch.png",
					priority = "high",
					width = 128,
					height = 128,
					repeat_count = 36,
					scale = 0.5,
					shift = { 2, -3 },
				},
				south_animation = {
					layers = {
						{
							draw_as_shadow = true,
							filename = REFINING_GRAPHICS_PATH .. "vertical-pipe-shadow-patch.png",
							priority = "high",
							width = 128,
							height = 128,
							repeat_count = 36,
							scale = 0.5,
							shift = { 2, -3 },
						},
						{
							draw_as_shadow = true,
							filename = REFINING_GRAPHICS_PATH .. "vertical-pipe-shadow-patch.png",
							priority = "high",
							width = 128,
							height = 128,
							repeat_count = 36,
							scale = 0.5,
							shift = { -2, -3 },
						},
					},
				},
			},
		},
	}

	return graphics_set
end

---Gets the pipe picture of Angel's hydro plant for the given `variation`.
---@param variation 1|2
---@return Sprite4Way
local function get_pipe_picture(variation)
	return {
		north = {
			filename = REFINING_GRAPHICS_PATH .. "pipe-north" .. variation .. ".png",
			priority = "extra-high",
			width = 48,
			height = 48,
			shift = { -0.08, 0.45 },
		},
		east = util.empty_sprite(),
		south = {
			filename = REFINING_GRAPHICS_PATH .. "pipe-south1.png",
			priority = "extra-high",
			width = 48,
			height = 48,
			shift = { 0.06, -0.6 },
		},
		west = {
			filename = REFINING_GRAPHICS_PATH .. "pipe-west" .. variation .. ".png",
			priority = "extra-high",
			width = 48,
			height = 48,
			shift = { 0.62, 0.05 },
		},
	}
end

---Gets the graphics for the fluid boxes of Angel's hydro plant.
---@return FluidBoxGraphics[]
local function get_fluid_box_graphics()
	return {
		{
			pipe_connections = {
				{ direction = defines.direction.south, position = { 2, 3 } },
			},
			pipe_picture = get_pipe_picture(2),
		},
		{
			pipe_picture = get_pipe_picture(1),
		},
	}
end

---Gets the circuit connector of Angel's hydro plant for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 25,
			main_offset = util.by_pixel(50.625, 42),
			shadow_offset = util.by_pixel(50.625, 42),
			show_shadow = true,
		},
		{
			variation = 25,
			main_offset = util.by_pixel(50.625, 42),
			shadow_offset = util.by_pixel(50.625, 42),
			show_shadow = true,
		},
		{
			variation = 25,
			main_offset = util.by_pixel(50.625, 42),
			shadow_offset = util.by_pixel(50.625, 42),
			show_shadow = true,
		},
		{
			variation = 25,
			main_offset = util.by_pixel(50.625, 42),
			shadow_offset = util.by_pixel(50.625, 42),
			show_shadow = true,
		},
	})
end

---Defines the options for the Angel's hydro plant sprite set.
---@class HydroPlantSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("HydroPlantSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for Angel's hydro plant.
---@param params HydroPlantSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's hydro plant.
---
---#### Examples
---```lua
---local hydro_plant = require("__reskins-assets-api__.assets.angels.entities.refining.hydro-plant")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = hydro_plant.get_sprite_set({ tint = tint })
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
			graphics_set = get_graphics_set(params.tint),
			graphics_set_flipped = get_graphics_set_flipped(params.tint),
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
			nominal_width = 7,
			nominal_height = 7,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-angels__/graphics/icons" })

local icon_builder = icons:tinted("hydro-plant")

---Gets the icon for Angel's hydro plant, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the icon for Angel's hydro plant as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
