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

local BIOPROCESSING_GRAPHICS_PATH = "__angelsbioprocessinggraphics__/graphics/entity/trees/"
local ASSETS_ANGELS_PATH = "__reskins-assets-angels__/graphics/entity/tree-generator/"

local M = {}

---The variant of Angel's tree generator, which selects the trees drawn inside the generator.
---@alias TreeGeneratorVariant "temperate"|"desert"|"swamp"

local TreeGeneratorVariant = V.one_of({ "temperate", "desert", "swamp" })

---The file name of the trees for each variant.
---@type table<TreeGeneratorVariant, string>
local tree_filenames = {
	temperate = "bio-generator-1.png",
	swamp = "bio-generator-2.png",
	desert = "bio-generator-3.png",
}

---Gets the layer of Angel's tree generator for the given `filename`.
---@param filename string
---@return Animation
local function get_layer(filename)
	return {
		filename = BIOPROCESSING_GRAPHICS_PATH .. filename,
		width = 160,
		height = 160,
		line_length = 1,
		frame_count = 1,
		shift = { 0, 0 },
	}
end

---Gets the animation of Angel's tree generator for the given `variant`.
---@param tint? Color
---@param variant TreeGeneratorVariant
---@return Animation
local function get_animation(tint, variant)
	local layers = {
		get_layer("bio-generator-shadow.png"),
		get_layer("bio-generator-base.png"),
	}

	-- The pipes, the trees, and the top of the generator are drawn over the ring that the mask tints.
	if tint then
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "tree-generator-mask.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			shift = { 0, 0 },
			tint = tint,
		}
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "tree-generator-highlights.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			shift = { 0, 0 },
			blend_mode = "additive",
		}
	end

	layers[#layers + 1] = get_layer("bio-generator-pipes.png")
	layers[#layers + 1] = get_layer(tree_filenames[variant])
	layers[#layers + 1] = get_layer("bio-generator-top.png")

	return { layers = layers }
end

---Gets the working visualisations of Angel's tree generator.
---@return WorkingVisualisation[]
local function get_working_visualisations()
	return {
		{
			fadeout = true,
			animation = {
				filename = BIOPROCESSING_GRAPHICS_PATH .. "bio-generator-top-on.png",
				priority = "extra-high",
				width = 160,
				height = 160,
				shift = { 0, 0 },
				draw_as_glow = true,
			},
			light = { intensity = 4, size = 4, color = { r = 0.5, g = 1.0, b = 0.5 } },
		},
	}
end

---Gets the circuit connector of Angel's tree generator for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 4,
			main_offset = util.by_pixel(-4.625, 24.375),
			shadow_offset = util.by_pixel(-4.625, 24.375),
			show_shadow = true,
		},
		{
			variation = 4,
			main_offset = util.by_pixel(-4.625, 24.375),
			shadow_offset = util.by_pixel(-4.625, 24.375),
			show_shadow = true,
		},
		{
			variation = 4,
			main_offset = util.by_pixel(-4.625, 24.375),
			shadow_offset = util.by_pixel(-4.625, 24.375),
			show_shadow = true,
		},
		{
			variation = 4,
			main_offset = util.by_pixel(-4.625, 24.375),
			shadow_offset = util.by_pixel(-4.625, 24.375),
			show_shadow = true,
		},
	})
end

---Defines the options for the Angel's tree generator sprite set.
---@class TreeGeneratorSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color
---The variant to use.
---@field variant TreeGeneratorVariant

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("TreeGeneratorSpriteSetParams", {
			tint = Common.color:optional(),
			variant = TreeGeneratorVariant,
		}):strict(),
	},
})

---Gets the sprite set for Angel's tree generator.
---@param params TreeGeneratorSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's tree generator.
---
---#### Examples
---```lua
---local tree_generator = require("__reskins-assets-api__.assets.angels.entities.bioprocessing.tree-generator")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = tree_generator.get_sprite_set({ tint = tint, variant = variant })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@throws When `params` defines an unrecognized field.
---@throws When `params.tint` is not a `Color`.
---@throws When `params.variant` is not a `TreeGeneratorVariant`.
---@nodiscard
function M.get_sprite_set(params)
	check_get_sprite_set(params)

	---@type SpriteSetDefinition<CraftingMachineSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.crafting_machine_sprite_set,
		set = {
			graphics_set = {
				animation = get_animation(params.tint, params.variant),
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
			drawing_box_vertical_extension = 1,
			nominal_width = 3,
			nominal_height = 3,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-angels__/graphics/icons" })

local VARIANTS = { "temperate", "desert", "swamp" }

---Gets the builder of the icon of the tree generator of the given `variant`.
---@param variant TreeGeneratorVariant
---@return IconBuilder<{ base_tint?: Color, tint?: Color }>
local function get_icon_builder(variant)
	return icons:tinted("tree-generator-" .. variant)
end

---Gets the icon for Angel's tree generator of the `variant` and in the tints given by `params`.
M.get_icon = IconBuilderFactory.dispatch("variant", VARIANTS, "get_icon", get_icon_builder)

---Gets the icon for Angel's tree generator of the `variant` as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition =
	IconBuilderFactory.dispatch_composition("variant", VARIANTS, "get_icon_composition", get_icon_builder)

return M
