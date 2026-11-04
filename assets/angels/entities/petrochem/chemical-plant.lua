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

local PETROCHEM_GRAPHICS_PATH = "__angelspetrochemgraphics__/graphics/entity/chemical-plant/"
local ASSETS_ANGELS_PATH = "__reskins-assets-angels__/graphics/entity/chemical-plant/"

local M = {}

---Gets the animation of Angel's chemical plant.
---@param tint? Color
---@return Animation
local function get_animation(tint)
	local layers = {
		{
			filename = PETROCHEM_GRAPHICS_PATH .. "chemical-plant.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			shift = { 0, 0 },
		},
	}

	if tint then
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "chemical-plant-mask.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			shift = { 0, 0 },
			tint = tint,
		}
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "chemical-plant-highlights.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			shift = { 0, 0 },
			blend_mode = "additive",
		}
	end

	return { layers = layers }
end

---Gets the working animation of Angel's chemical plant from the given `sheet`.
---@param sheet "mixer-tint"|"mixer-overlay"|"pipe-tint"|"pipe-overlay"
---@return Animation
local function get_working_animation(sheet)
	return {
		filename = PETROCHEM_GRAPHICS_PATH .. sheet .. ".png",
		line_length = 6,
		frame_count = 36,
		width = 160,
		height = 160,
		shift = { 0, 0 },
		animation_speed = 0.5,
	}
end

---Gets the working visualisations of Angel's chemical plant.
---@return WorkingVisualisation[]
local function get_working_visualisations()
	return {
		{
			apply_recipe_tint = "primary",
			animation = get_working_animation("mixer-tint"),
		},
		{
			animation = get_working_animation("mixer-overlay"),
		},
		{
			apply_recipe_tint = "secondary",
			animation = get_working_animation("pipe-tint"),
		},
		{
			animation = get_working_animation("pipe-overlay"),
		},
	}
end

---Gets the circuit connector of Angel's chemical plant for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 3,
			main_offset = util.by_pixel(-21.25, 2.875),
			shadow_offset = util.by_pixel(-21.25, 2.875),
			show_shadow = true,
		},
		{
			variation = 3,
			main_offset = util.by_pixel(-21.25, 2.875),
			shadow_offset = util.by_pixel(-21.25, 2.875),
			show_shadow = true,
		},
		{
			variation = 3,
			main_offset = util.by_pixel(-21.25, 2.875),
			shadow_offset = util.by_pixel(-21.25, 2.875),
			show_shadow = true,
		},
		{
			variation = 3,
			main_offset = util.by_pixel(-21.25, 2.875),
			shadow_offset = util.by_pixel(-21.25, 2.875),
			show_shadow = true,
		},
	})
end

---Defines the options for the Angel's chemical plant sprite set.
---@class ChemicalPlantSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("ChemicalPlantSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for Angel's chemical plant.
---@param params ChemicalPlantSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's chemical plant.
---
---#### Examples
---```lua
---local chemical_plant = require("__reskins-assets-api__.assets.angels.entities.petrochem.chemical-plant")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = chemical_plant.get_sprite_set({ tint = tint })
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
			dying_explosion = AssemblingMachine1Explosion.get_explosion({
				tints = params.tint and {
					["assembling-machine-1-metal-particle-big"] = params.tint,
					["assembling-machine-1-metal-particle-medium"] = params.tint,
				},
			}),
			corpse = _defines.generic_remnants,
			water_reflection = nil,
			drawing_box_vertical_extension = 0.4,
			nominal_width = 3,
			nominal_height = 3,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-angels__/graphics/icons" })

---Gets the icon for Angel's chemical plant, in the tints given by `params`.
M.get_icon = icons:tinted("chemical-plant"):build("get_icon")

return M
