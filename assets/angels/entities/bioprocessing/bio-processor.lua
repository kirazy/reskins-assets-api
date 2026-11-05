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

local BIOPROCESSING_GRAPHICS_PATH = "__angelsbioprocessinggraphics__/graphics/entity/bio-processor/"
local ASSETS_ANGELS_PATH = "__reskins-assets-angels__/graphics/entity/bio-processor/"

local M = {}

---Gets the animation of Angel's bio processor from the sheet with the given `name`.
---@param name "bio-processor"|"bio-processor-bg"|"bio-processor-trans"|"bio-processor-ani"
---@return Animation
local function get_sheet_animation(name)
	return {
		filename = BIOPROCESSING_GRAPHICS_PATH .. name .. ".png",
		width = 224,
		height = 224,
		line_length = 5,
		frame_count = 25,
		shift = { 0, 0 },
		animation_speed = 0.5,
	}
end

---Gets the working visualisations of Angel's bio processor.
---@param tint? Color
---@return WorkingVisualisation[]
local function get_working_visualisations(tint)
	---@type WorkingVisualisation[]
	local working_visualisations = {
		{
			fadeout = true,
			apply_recipe_tint = "primary",
			animation = get_sheet_animation("bio-processor-bg"),
		},
		{
			always_draw = true,
			animation = get_sheet_animation("bio-processor-trans"),
		},
		{
			fadeout = true,
			apply_recipe_tint = "secondary",
			animation = get_sheet_animation("bio-processor-ani"),
		},
	}

	if tint then
		working_visualisations[#working_visualisations + 1] = {
			always_draw = true,
			animation = {
				layers = {
					{
						filename = ASSETS_ANGELS_PATH .. "bio-processor-mask.png",
						priority = "extra-high",
						width = 224,
						height = 224,
						line_length = 5,
						frame_count = 25,
						shift = { 0, 0 },
						animation_speed = 0.5,
						tint = tint,
					},
					{
						filename = ASSETS_ANGELS_PATH .. "bio-processor-highlights.png",
						priority = "extra-high",
						width = 224,
						height = 224,
						line_length = 5,
						frame_count = 25,
						shift = { 0, 0 },
						animation_speed = 0.5,
						blend_mode = "additive",
					},
				},
			},
		}
	end

	return working_visualisations
end

---Gets the circuit connector of Angel's bio processor for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 3,
			main_offset = util.by_pixel(-11.5, -30.875),
			shadow_offset = util.by_pixel(-11.5, -30.875),
			show_shadow = true,
		},
		{
			variation = 3,
			main_offset = util.by_pixel(-11.5, -30.875),
			shadow_offset = util.by_pixel(-11.5, -30.875),
			show_shadow = true,
		},
		{
			variation = 3,
			main_offset = util.by_pixel(-11.5, -30.875),
			shadow_offset = util.by_pixel(-11.5, -30.875),
			show_shadow = true,
		},
		{
			variation = 3,
			main_offset = util.by_pixel(-11.5, -30.875),
			shadow_offset = util.by_pixel(-11.5, -30.875),
			show_shadow = true,
		},
	})
end

---Defines the options for the Angel's bio processor sprite set.
---@class BioProcessorSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("BioProcessorSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for Angel's bio processor.
---@param params BioProcessorSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's bio processor.
---
---#### Examples
---```lua
---local bio_processor = require("__reskins-assets-api__.assets.angels.entities.bioprocessing.bio-processor")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = bio_processor.get_sprite_set({ tint = tint })
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
				animation = get_sheet_animation("bio-processor"),
				working_visualisations = get_working_visualisations(params.tint),
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
			drawing_box_vertical_extension = 1,
			nominal_width = 5,
			nominal_height = 5,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-angels__/graphics/icons" })

local icon_builder = icons:tinted("bio-processor")

---Gets the icon for Angel's bio processor, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the icon for Angel's bio processor as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
