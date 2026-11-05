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

local SMELTING_GRAPHICS_PATH = "__angelssmeltinggraphics__/graphics/entity/chemical-furnace/"
local ASSETS_ANGELS_PATH = "__reskins-assets-angels__/graphics/entity/chemical-furnace/"

local M = {}

---Gets the stripes that cut the 36 frames of Angel's chemical furnace from the two given sheets, in rows of six.
---@param first_filename string
---@param second_filename string
---@return Stripe[]
local function get_stripes(first_filename, second_filename)
	return {
		{
			filename = first_filename,
			width_in_frames = 6,
			height_in_frames = 3,
		},
		{
			filename = second_filename,
			width_in_frames = 6,
			height_in_frames = 3,
		},
	}
end

---Gets the animation of Angel's chemical furnace.
---@param tint? Color
---@return Animation
local function get_animation(tint)
	local layers = {
		{
			priority = "extra-high",
			width = 332,
			height = 374,
			frame_count = 36,
			stripes = get_stripes(
				SMELTING_GRAPHICS_PATH .. "chemical-furnace-base_01.png",
				SMELTING_GRAPHICS_PATH .. "chemical-furnace-base_02.png"
			),
			animation_speed = 0.5,
			shift = util.by_pixel(-1, -11.5),
			scale = 0.5,
		},
	}

	if tint then
		layers[#layers + 1] = {
			priority = "extra-high",
			width = 332,
			height = 374,
			frame_count = 36,
			stripes = get_stripes(
				ASSETS_ANGELS_PATH .. "chemical-furnace-mask-1.png",
				ASSETS_ANGELS_PATH .. "chemical-furnace-mask-2.png"
			),
			animation_speed = 0.5,
			tint = tint,
			shift = util.by_pixel(-1, -11.5),
			scale = 0.5,
		}
		layers[#layers + 1] = {
			priority = "extra-high",
			width = 332,
			height = 374,
			frame_count = 36,
			stripes = get_stripes(
				ASSETS_ANGELS_PATH .. "chemical-furnace-highlights-1.png",
				ASSETS_ANGELS_PATH .. "chemical-furnace-highlights-2.png"
			),
			animation_speed = 0.5,
			blend_mode = "additive",
			shift = util.by_pixel(-1, -11.5),
			scale = 0.5,
		}
	end

	layers[#layers + 1] = {
		priority = "extra-high",
		width = 448,
		height = 280,
		frame_count = 36,
		stripes = {
			{
				filename = SMELTING_GRAPHICS_PATH .. "chemical-furnace-shadow_01.png",
				width_in_frames = 4,
				height_in_frames = 7,
			},
			{
				filename = SMELTING_GRAPHICS_PATH .. "chemical-furnace-shadow_02.png",
				width_in_frames = 4,
				height_in_frames = 2,
			},
		},
		animation_speed = 0.5,
		draw_as_shadow = true,
		shift = util.by_pixel(28, 12.5),
		scale = 0.5,
	}

	return { layers = layers }
end

---Gets the working visualisations of Angel's chemical furnace.
---@return WorkingVisualisation[]
local function get_working_visualisations()
	return {
		{
			always_draw = true,
			animation = {
				priority = "high",
				width = 332,
				height = 374,
				frame_count = 36,
				stripes = get_stripes(
					SMELTING_GRAPHICS_PATH .. "chemical-furnace-light_01.png",
					SMELTING_GRAPHICS_PATH .. "chemical-furnace-light_02.png"
				),
				animation_speed = 0.5,
				shift = util.by_pixel(-1, -11.5),
				draw_as_light = true,
				scale = 0.5,
			},
		},
	}
end

---Gets the circuit connector of Angel's chemical furnace for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 4,
			main_offset = util.by_pixel(-4.75, 33),
			shadow_offset = util.by_pixel(-4.75, 33),
			show_shadow = true,
		},
		{
			variation = 4,
			main_offset = util.by_pixel(-4.75, 33),
			shadow_offset = util.by_pixel(-4.75, 33),
			show_shadow = true,
		},
		{
			variation = 4,
			main_offset = util.by_pixel(-4.75, 33),
			shadow_offset = util.by_pixel(-4.75, 33),
			show_shadow = true,
		},
		{
			variation = 4,
			main_offset = util.by_pixel(-4.75, 33),
			shadow_offset = util.by_pixel(-4.75, 33),
			show_shadow = true,
		},
	})
end

---Defines the options for the Angel's chemical furnace sprite set.
---@class ChemicalFurnaceSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("ChemicalFurnaceSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for Angel's chemical furnace.
---@param params ChemicalFurnaceSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's chemical furnace.
---
---#### Examples
---```lua
---local chemical_furnace = require("__reskins-assets-api__.assets.angels.entities.smelting.chemical-furnace")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = chemical_furnace.get_sprite_set({ tint = tint })
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
			drawing_box_vertical_extension = 0.75,
			nominal_width = 5,
			nominal_height = 5,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-angels__/graphics/icons" })

local icon_builder = icons:tinted("chemical-furnace")

---Gets the icon for Angel's chemical furnace, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the icon for Angel's chemical furnace as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
