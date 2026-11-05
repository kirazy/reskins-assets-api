---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")
local _sprites = require("__reskins-sprite-utils__.sprites")
local _pipes = require("assets.base.entities.pipe-pictures")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local IconBuilderFactory = require("api.icon-builder-factory")
local OilRefineryExplosion = require("assets.base.explosions.oil-refinery")

local PETROCHEM_GRAPHICS_PATH = "__angelspetrochemgraphics__/graphics/entity/advanced-gas-refinery/"
local ASSETS_ANGELS_PATH = "__reskins-assets-angels__/graphics/entity/gas-refinery-advanced/"

local M = {}

---Gets the animation of Angel's advanced gas refinery.
---@param tint? Color
---@return Animation4Way
local function get_animation(tint)
	local layers = {
		{
			filename = PETROCHEM_GRAPHICS_PATH .. "advanced-gas-refinery-base.png",
			priority = "extra-high",
			width = 462,
			height = 657,
			shift = util.by_pixel(0, -42),
			scale = 0.5,
		},
		{
			filename = PETROCHEM_GRAPHICS_PATH .. "advanced-gas-refinery-shadow.png",
			priority = "extra-high",
			vertically_oriented = true,
			width = 655,
			height = 454,
			shift = util.by_pixel(48.5, 9.5),
			draw_as_shadow = true,
			scale = 0.5,
		},
	}

	if tint then
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "gas-refinery-advanced-mask.png",
			priority = "extra-high",
			width = 462,
			height = 657,
			shift = util.by_pixel(0, -42),
			tint = tint,
			scale = 0.5,
		}
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "gas-refinery-advanced-highlights.png",
			priority = "extra-high",
			width = 462,
			height = 657,
			shift = util.by_pixel(0, -42),
			blend_mode = "additive",
			scale = 0.5,
		}
	end

	return _sprites.make_4way_animation_from_spritesheet({ layers = layers }) --[[@as Animation4Way]]
end

---Gets the working visualisations of Angel's advanced gas refinery.
---@return WorkingVisualisation[]
local function get_working_visualisations()
	return {
		{
			fadeout = true,
			constant_speed = true,
			north_position = util.by_pixel(-89, -121.5),
			east_position = util.by_pixel(34.5, -192.5),
			south_position = util.by_pixel(90.5, -79),
			west_position = util.by_pixel(-16, -20),
			animation = {
				filename = "__base__/graphics/entity/oil-refinery/oil-refinery-fire-smoke.png",
				width = 54,
				height = 144,
				line_length = 5,
				frame_count = 20,
				animation_speed = 0.75,
				allow_reducing_frames = true,
				shift = util.by_pixel(1.0, -31.5),
				scale = 0.5,
			},
		},
		{
			fadeout = true,
			constant_speed = true,
			north_position = util.by_pixel(-89, -121.5),
			east_position = util.by_pixel(34.5, -192.5),
			south_position = util.by_pixel(90.5, -79),
			west_position = util.by_pixel(-16, -20),
			animation = {
				filename = "__base__/graphics/entity/oil-refinery/oil-refinery-fire-light.png",
				width = 28,
				height = 86,
				line_length = 5,
				frame_count = 20,
				animation_speed = 0.75,
				allow_reducing_frames = true,
				blend_mode = "additive",
				draw_as_glow = true,
				shift = util.by_pixel(0.5, -18.5),
				scale = 0.5,
			},
		},
		{
			fadeout = true,
			-- Convert this to use make4way
			north_animation = {
				filename = PETROCHEM_GRAPHICS_PATH .. "advanced-gas-refinery-light.png",
				priority = "high",
				width = 462,
				height = 657,
				shift = util.by_pixel(0, -42),
				blend_mode = "additive-soft",
				draw_as_glow = true,
				scale = 0.5,
			},
			east_animation = {
				filename = PETROCHEM_GRAPHICS_PATH .. "advanced-gas-refinery-light.png",
				priority = "high",
				width = 462,
				height = 657,
				x = 462,
				shift = util.by_pixel(0, -42),
				blend_mode = "additive-soft",
				draw_as_glow = true,
				scale = 0.5,
			},
			south_animation = {
				filename = PETROCHEM_GRAPHICS_PATH .. "advanced-gas-refinery-light.png",
				priority = "high",
				width = 462,
				height = 657,
				x = 924,
				shift = util.by_pixel(0, -42),
				blend_mode = "additive-soft",
				draw_as_glow = true,
				scale = 0.5,
			},
			west_animation = {
				filename = PETROCHEM_GRAPHICS_PATH .. "advanced-gas-refinery-light.png",
				priority = "high",
				width = 462,
				height = 657,
				x = 1386,
				shift = util.by_pixel(0, -42),
				blend_mode = "additive-soft",
				draw_as_glow = true,
				scale = 0.5,
			},
		},
		{
			always_draw = true,
			north_animation = {
				layers = {
					_pipes.vertical_pipe_shadow({ -1, -3 }),
					(_pipes.vertical_pipe_shadow({ 3, -3 })),
				},
			},
			south_animation = {
				layers = {
					_pipes.vertical_pipe_shadow({ -3, 3 }),
					_pipes.vertical_pipe_shadow({ -1, 3 }),
					(_pipes.vertical_pipe_shadow({ 1, 3 })),
				},
			},
		},
	}
end

---Gets the circuit connector of Angel's advanced gas refinery for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 25,
			main_offset = util.by_pixel(60.875, -36.25),
			shadow_offset = util.by_pixel(60.875, -36.25),
			show_shadow = true,
		},
		{
			variation = 26,
			main_offset = util.by_pixel(-21.5, 12.75),
			shadow_offset = util.by_pixel(-21.5, 12.75),
			show_shadow = true,
		},
		{
			variation = 25,
			main_offset = util.by_pixel(-104, -114.875),
			shadow_offset = util.by_pixel(-104, -114.875),
			show_shadow = true,
		},
		{
			variation = 27,
			main_offset = util.by_pixel(42.25, -148.75),
			shadow_offset = util.by_pixel(42.25, -148.75),
			show_shadow = true,
		},
	})
end

---Defines the options for the Angel's advanced gas refinery sprite set.
---@class AdvancedGasRefinerySpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("AdvancedGasRefinerySpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for Angel's advanced gas refinery.
---@param params AdvancedGasRefinerySpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's advanced gas refinery.
---
---#### Examples
---```lua
---local advanced_gas_refinery = require("__reskins-assets-api__.assets.angels.entities.petrochem.advanced-gas-refinery")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = advanced_gas_refinery.get_sprite_set({ tint = tint })
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
			use_mirroring = true,
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
			drawing_box_vertical_extension = 2.2,
			nominal_width = 7,
			nominal_height = 7,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-angels__/graphics/icons" })

local icon_builder = icons:tinted("gas-refinery-advanced")

---Gets the icon for Angel's advanced gas refinery, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the icon for Angel's advanced gas refinery as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
