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

local BIOPROCESSING_GRAPHICS_PATH = "__angelsbioprocessinggraphics__/graphics/entity/crop-farm/"
local ASSETS_ANGELS_PATH = "__reskins-assets-angels__/graphics/entity/field/"

local M = {}

---The variant of Angel's crop farm, which selects the field drawn inside the farm.
---@alias CropFarmVariant "basic"|"temperate"|"desert"|"swamp"

local CropFarmVariant = V.one_of({ "basic", "temperate", "desert", "swamp" })

---The file names of the field and the field animation, and the speed of the field animation, for each variant.
---@type table<CropFarmVariant, { field: string, animation: string, animation_speed: number }>
local field_artwork = {
	basic = { field = "field-basic.png", animation = "field-animation-1.png", animation_speed = 0.005 },
	temperate = { field = "field-temperate.png", animation = "field-animation-2.png", animation_speed = 0.01 },
	desert = { field = "field-desert.png", animation = "field-animation-3.png", animation_speed = 0.01 },
	swamp = { field = "field-water.png", animation = "field-animation-4.png", animation_speed = 0.01 },
}

---Gets the animation of Angel's crop farm for the given `variant`.
---@param variant CropFarmVariant
---@return Animation
local function get_animation(variant)
	return {
		layers = {
			{
				filename = BIOPROCESSING_GRAPHICS_PATH .. "farm-base.png",
				width = 224,
				height = 224,
				line_length = 1,
				frame_count = 1,
				shift = { 0, 0 },
			},
			{
				filename = BIOPROCESSING_GRAPHICS_PATH .. field_artwork[variant].field,
				width = 224,
				height = 224,
				line_length = 1,
				frame_count = 1,
				shift = { 0, 0 },
			},
		},
	}
end

---Gets the working visualisations of Angel's crop farm for the given `variant`.
---@param tint? Color
---@param variant CropFarmVariant
---@return WorkingVisualisation[]
local function get_working_visualisations(tint, variant)
	---@type WorkingVisualisation[]
	local working_visualisations = {
		{
			apply_recipe_tint = "primary",
			animation = {
				filename = BIOPROCESSING_GRAPHICS_PATH .. field_artwork[variant].animation,
				line_length = 6,
				frame_count = 36,
				width = 224,
				height = 224,
				shift = { 0, 0 },
				animation_speed = field_artwork[variant].animation_speed,
			},
		},
	}

	if tint then
		working_visualisations[#working_visualisations + 1] = {
			always_draw = true,
			animation = {
				layers = {
					{
						filename = ASSETS_ANGELS_PATH .. "field-mask.png",
						priority = "extra-high",
						width = 224,
						height = 224,
						shift = { 0, 0 },
						tint = tint,
					},
					{
						filename = ASSETS_ANGELS_PATH .. "field-highlights.png",
						priority = "extra-high",
						width = 224,
						height = 224,
						shift = { 0, 0 },
						blend_mode = "additive",
					},
				},
			},
		}
	end

	return working_visualisations
end

---Gets the circuit connector of Angel's crop farm for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 4,
			main_offset = util.by_pixel(38.5, 55.125),
			shadow_offset = util.by_pixel(38.5, 55.125),
			show_shadow = true,
		},
		{
			variation = 4,
			main_offset = util.by_pixel(38.5, 55.125),
			shadow_offset = util.by_pixel(38.5, 55.125),
			show_shadow = true,
		},
		{
			variation = 4,
			main_offset = util.by_pixel(38.5, 55.125),
			shadow_offset = util.by_pixel(38.5, 55.125),
			show_shadow = true,
		},
		{
			variation = 4,
			main_offset = util.by_pixel(38.5, 55.125),
			shadow_offset = util.by_pixel(38.5, 55.125),
			show_shadow = true,
		},
	})
end

---Defines the options for the Angel's crop farm sprite set.
---@class CropFarmSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color
---The variant to use.
---@field variant CropFarmVariant

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("CropFarmSpriteSetParams", {
			tint = Common.color:optional(),
			variant = CropFarmVariant,
		}):strict(),
	},
})

---Gets the sprite set for Angel's crop farm.
---@param params CropFarmSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's crop farm.
---
---#### Examples
---```lua
---local crop_farm = require("__reskins-assets-api__.assets.angels.entities.bioprocessing.crop-farm")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = crop_farm.get_sprite_set({ tint = tint, variant = variant })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@throws When `params` defines an unrecognized field.
---@throws When `params.tint` is not a `Color`.
---@throws When `params.variant` is not a `CropFarmVariant`.
---@nodiscard
function M.get_sprite_set(params)
	check_get_sprite_set(params)

	---@type SpriteSetDefinition<CraftingMachineSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.crafting_machine_sprite_set,
		set = {
			graphics_set = {
				animation = get_animation(params.variant),
				working_visualisations = get_working_visualisations(params.tint, params.variant),
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
			nominal_width = 5,
			nominal_height = 5,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-angels__/graphics/icons" })

local VARIANTS = { "basic", "temperate", "desert", "swamp" }

---Gets the builder of the icon of the crop farm of the given `variant`.
---@param variant CropFarmVariant
---@return IconBuilder<{ base_tint?: Color, tint?: Color }>
local function get_icon_builder(variant)
	-- The basic farm's artwork is filed under the bare field name.
	return icons:tinted(variant == "basic" and "field" or "field-" .. variant)
end

---Gets the icon for Angel's crop farm of the given `variant` and in the tints given by `params`.
M.get_icon = IconBuilderFactory.dispatch("variant", VARIANTS, "get_icon", get_icon_builder)

---Gets the icon for Angel's crop farm of the given `variant` as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition =
	IconBuilderFactory.dispatch_composition("variant", VARIANTS, "get_icon_composition", get_icon_builder)

return M
