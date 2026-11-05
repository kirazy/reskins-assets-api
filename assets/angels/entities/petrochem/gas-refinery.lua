---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")
local _sprites = require("__reskins-sprite-utils__.sprites")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local IconBuilderFactory = require("api.icon-builder-factory")
local OilRefineryExplosion = require("assets.base.explosions.oil-refinery")

local PETROCHEM_GRAPHICS_PATH = "__angelspetrochemgraphics__/graphics/entity/gas-refinery/"
local ASSETS_ANGELS_PATH = "__reskins-assets-angels__/graphics/entity/gas-refinery/"

local M = {}

---Gets the animation of Angel's gas refinery.
---@param tint? Color
---@return Animation4Way
local function get_animation(tint)
	local layers = {
		{
			filename = PETROCHEM_GRAPHICS_PATH .. "gas-refinery-base.png",
			priority = "extra-high",
			width = 334,
			height = 553,
			shift = util.by_pixel(0, -48),
			scale = 0.5,
		},
		{
			filename = PETROCHEM_GRAPHICS_PATH .. "gas-refinery-shadow.png",
			priority = "extra-high",
			width = 508,
			height = 338,
			shift = util.by_pixel(43.5, 6.5),
			draw_as_shadow = true,
			scale = 0.5,
		},
	}

	if tint then
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "gas-refinery-mask.png",
			priority = "extra-high",
			width = 334,
			height = 553,
			shift = util.by_pixel(0, -48),
			tint = tint,
			scale = 0.5,
		}
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "gas-refinery-highlights.png",
			priority = "extra-high",
			width = 334,
			height = 553,
			shift = util.by_pixel(0, -48),
			blend_mode = "additive",
			scale = 0.5,
		}
	end

	return _sprites.make_4way_animation_from_spritesheet({ layers = layers }) --[[@as Animation4Way]]
end

---Gets the working visualisations of Angel's gas refinery.
---@return WorkingVisualisation[]
local function get_working_visualisations()
	return {
		{
			fadeout = true,
			constant_speed = true,
			north_position = util.by_pixel(-57.5, -137.5),
			east_position = util.by_pixel(49.5, -174.5),
			south_position = util.by_pixel(59, -54),
			west_position = util.by_pixel(-50, -47.5),
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
			north_position = util.by_pixel(-57.5, -137.5),
			east_position = util.by_pixel(49.5, -174.5),
			south_position = util.by_pixel(59, -54),
			west_position = util.by_pixel(-50, -47.5),
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
			-- FIXME: Use make4way
			fadeout = true,
			north_animation = {
				filename = PETROCHEM_GRAPHICS_PATH .. "gas-refinery-light.png",
				priority = "extra-high",
				width = 334,
				height = 553,
				frame_count = 1,
				shift = util.by_pixel(0, -48),
				blend_mode = "additive-soft",
				draw_as_glow = true,
				scale = 0.5,
			},
			east_animation = {
				filename = PETROCHEM_GRAPHICS_PATH .. "gas-refinery-light.png",
				priority = "extra-high",
				width = 334,
				height = 553,
				x = 334,
				frame_count = 1,
				shift = util.by_pixel(0, -48),
				blend_mode = "additive-soft",
				draw_as_glow = true,
				scale = 0.5,
			},
			south_animation = {
				filename = PETROCHEM_GRAPHICS_PATH .. "gas-refinery-light.png",
				priority = "extra-high",
				width = 334,
				height = 553,
				x = 668,
				frame_count = 1,
				shift = util.by_pixel(0, -48),
				blend_mode = "additive-soft",
				draw_as_glow = true,
				scale = 0.5,
			},
			west_animation = {
				filename = PETROCHEM_GRAPHICS_PATH .. "gas-refinery-light.png",
				priority = "extra-high",
				width = 334,
				height = 553,
				x = 1002,
				frame_count = 1,
				shift = util.by_pixel(0, -48),
				blend_mode = "additive-soft",
				draw_as_glow = true,
				scale = 0.5,
			},
		},
		{
			-- FIXME: Use vertical pipe shadow
			always_draw = true,
			north_animation = {
				layers = {
					{
						draw_as_shadow = true,
						filename = PETROCHEM_GRAPHICS_PATH .. "vertical-pipe-shadow-patch.png",
						priority = "high",
						width = 128,
						height = 128,
						repeat_count = 36,
						shift = { -2, -2 },
						scale = 0.5,
					},
					{
						draw_as_shadow = true,
						filename = PETROCHEM_GRAPHICS_PATH .. "vertical-pipe-shadow-patch.png",
						priority = "high",
						width = 128,
						height = 128,
						repeat_count = 36,
						shift = { 0, -2 },
						scale = 0.5,
					},
					{
						draw_as_shadow = true,
						filename = PETROCHEM_GRAPHICS_PATH .. "vertical-pipe-shadow-patch.png",
						priority = "high",
						width = 128,
						height = 128,
						repeat_count = 36,
						shift = { 2, -2 },
						scale = 0.5,
					},
				},
			},
			-- FIXME: Use vertical pipe shadow
			south_animation = {
				layers = {
					{
						draw_as_shadow = true,
						filename = PETROCHEM_GRAPHICS_PATH .. "vertical-pipe-shadow-patch.png",
						priority = "high",
						width = 128,
						height = 128,
						repeat_count = 36,
						shift = { -2, 2 },
						scale = 0.5,
					},
					{
						draw_as_shadow = true,
						filename = PETROCHEM_GRAPHICS_PATH .. "vertical-pipe-shadow-patch.png",
						priority = "high",
						width = 128,
						height = 128,
						repeat_count = 36,
						shift = { 0, 2 },
						scale = 0.5,
					},
					{
						draw_as_shadow = true,
						filename = PETROCHEM_GRAPHICS_PATH .. "vertical-pipe-shadow-patch.png",
						priority = "high",
						width = 128,
						height = 128,
						repeat_count = 36,
						shift = { 2, 2 },
						scale = 0.5,
					},
				},
			},
		},
	}
end

---Gets the circuit connector of Angel's gas refinery for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 25,
			main_offset = util.by_pixel(29.875, -15.25),
			shadow_offset = util.by_pixel(29.875, -15.25),
			show_shadow = true,
		},
		{
			variation = 30,
			main_offset = util.by_pixel(-35.25, -4.875),
			shadow_offset = util.by_pixel(-35.25, -4.875),
			show_shadow = true,
		},
		{
			variation = 25,
			main_offset = util.by_pixel(-69.75, -88.625),
			shadow_offset = util.by_pixel(-69.75, -88.625),
			show_shadow = true,
		},
		{
			variation = 27,
			main_offset = util.by_pixel(56.375, -99.5),
			shadow_offset = util.by_pixel(56.375, -99.5),
			show_shadow = true,
		},
	})
end

---Defines the options for the Angel's gas refinery sprite set.
---@class GasRefinerySpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("GasRefinerySpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for Angel's gas refinery.
---@param params GasRefinerySpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's gas refinery.
---
---#### Examples
---```lua
---local gas_refinery = require("__reskins-assets-api__.assets.angels.entities.petrochem.gas-refinery")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = gas_refinery.get_sprite_set({ tint = tint })
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
			drawing_box_vertical_extension = 1.6,
			nominal_width = 5,
			nominal_height = 5,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-angels__/graphics/icons" })

local icon_builder = icons:tinted("gas-refinery")

---Gets the icon for Angel's gas refinery, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the icon for Angel's gas refinery as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
