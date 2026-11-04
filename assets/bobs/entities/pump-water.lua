---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Entities

local _defines = require("api.defines")
local _sprites = require("__reskins-sprite-utils__.sprites")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local IconBuilderFactory = require("api.icon-builder-factory")

local ASSETS_BOBS_PATH = "__reskins-assets-bobs__/graphics/entity/pump-water/"

-- The water pump has no light of its own, and draws the light of the air pump.
local ASSETS_BOBS_PATH_AIR = "__reskins-assets-bobs__/graphics/entity/pump-air/"

local M = {}

---Gets the animation of the water pump.
---@param tint? Color
---@return Animation4Way
local function get_animation(tint)
	local source_layers = {
		{
			filename = ASSETS_BOBS_PATH .. "pump-water-base.png",
			width = 148,
			height = 186,
			frame_count = 4,
			line_length = 4,
			frame_sequence = { 1, 2, 3, 4, 3, 2, 1 },
			animation_speed = 0.5,
			shift = util.by_pixel(0, -9.5),
			scale = 0.5,
		},
		{
			filename = ASSETS_BOBS_PATH .. "pump-water-shadow.png",
			width = 172,
			height = 134,
			frame_count = 4,
			line_length = 4,
			frame_sequence = { 1, 2, 3, 4, 3, 2, 1 },
			animation_speed = 0.5,
			draw_as_shadow = true,
			shift = util.by_pixel(11, 1.5),
			scale = 0.5,
		},
	}

	if tint then
		source_layers[#source_layers + 1] = {
			filename = ASSETS_BOBS_PATH .. "pump-water-mask.png",
			width = 148,
			height = 186,
			frame_count = 4,
			line_length = 4,
			frame_sequence = { 1, 2, 3, 4, 3, 2, 1 },
			animation_speed = 0.5,
			tint = tint,
			shift = util.by_pixel(0, -9.5),
			scale = 0.5,
		}
		source_layers[#source_layers + 1] = {
			filename = ASSETS_BOBS_PATH .. "pump-water-highlights.png",
			width = 148,
			height = 186,
			frame_count = 4,
			line_length = 4,
			frame_sequence = { 1, 2, 3, 4, 3, 2, 1 },
			animation_speed = 0.5,
			blend_mode = "additive",
			shift = util.by_pixel(0, -9.5),
			scale = 0.5,
		}
	end

	return _sprites.make_4way_animation_from_spritesheet({ layers = source_layers })
end

---Gets the working visualisation of the water pump that draws the given recipe `layer`.
---@param layer "recipe-tint-mask"|"recipe-lightening-mask"|"recipe-tint-highlights" The recipe layer to draw.
---@param apply_recipe_tint? "primary" The recipe tint applied to the layer. When `nil`, the layer is not tinted by the recipe.
---@param blend_mode? BlendMode The blend mode of the layer. When `nil`, the default blend mode is used.
---@return WorkingVisualisation
local function get_recipe_working_visualisation(layer, apply_recipe_tint, blend_mode)
	return _sprites.make_4way_working_visualisations_from_spritesheet({
		apply_recipe_tint = apply_recipe_tint,
		always_draw = true,
		animation = {
			filename = ASSETS_BOBS_PATH .. "pump-water-" .. layer .. ".png",
			width = 128,
			height = 176,
			blend_mode = blend_mode,
			shift = util.by_pixel(0, -12),
			scale = 0.5,
		},
	})
end

---Gets the working visualisations of the water pump.
---@return WorkingVisualisation[]
local function get_working_visualisations()
	return {
		get_recipe_working_visualisation("recipe-tint-mask", "primary"),
		get_recipe_working_visualisation("recipe-lightening-mask"),
		{
			always_draw = true,
			west_animation = {
				filename = ASSETS_BOBS_PATH_AIR .. "pump-light.png",
				width = 148,
				height = 186,
				draw_as_light = true,
				shift = util.by_pixel(0, -9.5),
				scale = 0.5,
			},
		},
		get_recipe_working_visualisation("recipe-tint-highlights", "primary", "additive"),
	}
end

---Gets a copy of the given `working_visualisation` with the north and south animations exchanged, and the east and
---west animations exchanged.
---@param working_visualisation WorkingVisualisation
---@return WorkingVisualisation
local function get_flipped_working_visualisation(working_visualisation)
	local flipped = util.copy(working_visualisation)
	flipped.north_animation = working_visualisation.south_animation
	flipped.east_animation = working_visualisation.west_animation
	flipped.south_animation = working_visualisation.north_animation
	flipped.west_animation = working_visualisation.east_animation

	return flipped
end

---Gets the graphics set of the water pump.
---@param tint? Color
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint)
	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = get_animation(tint),
		working_visualisations = get_working_visualisations(),
	}

	return graphics_set
end

---Gets the graphics set of the water pump when it is flipped.
---@param tint? Color
---@return CraftingMachineGraphicsSet
local function get_graphics_set_flipped(tint)
	local animation = get_animation(tint)

	local working_visualisations = {}
	for index, working_visualisation in pairs(get_working_visualisations()) do
		working_visualisations[index] = get_flipped_working_visualisation(working_visualisation)
	end

	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = {
			north = animation.south,
			east = animation.west,
			south = animation.north,
			west = animation.east,
		},
		working_visualisations = working_visualisations,
	}

	return graphics_set
end

---Gets the circuit connector of the water pump for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 0,
			main_offset = util.by_pixel(21, 14),
			shadow_offset = util.by_pixel(9, 9),
			show_shadow = false,
		},
		{
			variation = 6,
			main_offset = util.by_pixel(-24, 12),
			shadow_offset = util.by_pixel(0, 0),
			show_shadow = false,
		},
		{
			variation = 0,
			main_offset = util.by_pixel(-11, 14),
			shadow_offset = util.by_pixel(9, 9),
			show_shadow = false,
		},
		{
			variation = 6,
			main_offset = util.by_pixel(-24, -18),
			shadow_offset = util.by_pixel(0, 0),
			show_shadow = false,
		},
	})
end

---Gets the circuit connector of the water pump for each direction when it is flipped.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector_flipped()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 0,
			main_offset = util.by_pixel(-11, 14),
			shadow_offset = util.by_pixel(9, 9),
			show_shadow = false,
		},
		{
			variation = 6,
			main_offset = util.by_pixel(-24, -20),
			shadow_offset = util.by_pixel(0, 0),
			show_shadow = false,
		},
		{
			variation = 0,
			main_offset = util.by_pixel(21, 14),
			shadow_offset = util.by_pixel(9, 9),
			show_shadow = false,
		},
		{
			variation = 6,
			main_offset = util.by_pixel(-24, 12),
			shadow_offset = util.by_pixel(0, 0),
			show_shadow = false,
		},
	})
end

---Gets the water reflection of the water pump.
---@return WaterReflectionDefinition
local function get_water_reflection()
	return {
		pictures = {
			filename = ASSETS_BOBS_PATH .. "pump-water-reflection.png",
			priority = "extra-high",
			width = 28,
			height = 36,
			shift = util.by_pixel(10 / 3, 40),
			variation_count = 4,
			scale = 10 / 3,
		},
		rotate = false,
		orientation_to_variation = true,
	}
end

---Defines the options for the water pump sprite set.
---@class PumpWaterSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("PumpWaterSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for the water pump.
---@param params PumpWaterSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for the water pump.
---
---#### Examples
---```lua
---local pump_water = require("__reskins-assets-api__.assets.bobs.entities.pump-water")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = pump_water.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
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
			circuit_connector_flipped = get_circuit_connector_flipped(),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = nil,
			water_reflection = get_water_reflection(),
			nominal_width = 2,
			nominal_height = 2,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-bobs__/graphics/icons" })

---Gets the icon for the water pump, in the tints given by `params`.
M.get_icon = icons:tinted("pump-water"):build("get_icon")

return M
