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
local ASSETS_ANGELS_PATH = "__reskins-assets-angels__/graphics/entity/arboretum/"

local M = {}

---Gets the animation of Angel's arboretum.
---@param tint? Color
---@return Animation
local function get_animation(tint)
	local layers = {
		{
			filename = BIOPROCESSING_GRAPHICS_PATH .. "bio-arboretum-shadow.png",
			width = 224,
			height = 256,
			shift = { 0, -0.50 },
		},
		{
			filename = BIOPROCESSING_GRAPHICS_PATH .. "bio-arboretum-base.png",
			width = 224,
			height = 256,
			shift = { 0, -0.50 },
		},
	}

	if tint then
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "arboretum-mask.png",
			priority = "extra-high",
			width = 224,
			height = 256,
			shift = { 0, -0.5 },
			tint = tint,
		}
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "arboretum-highlights.png",
			priority = "extra-high",
			width = 224,
			height = 256,
			shift = { 0, -0.5 },
			blend_mode = "additive",
		}
	end

	layers[#layers + 1] = {
		filename = BIOPROCESSING_GRAPHICS_PATH .. "bio-arboretum-pipes.png",
		width = 224,
		height = 256,
		shift = { 0, -0.50 },
	}
	layers[#layers + 1] = {
		filename = BIOPROCESSING_GRAPHICS_PATH .. "bio-arboretum-off.png",
		width = 224,
		height = 256,
		shift = { 0, -0.50 },
	}

	return { layers = layers }
end

---Gets the working visualisations of Angel's arboretum.
---@return WorkingVisualisation[]
local function get_working_visualisations()
	return {
		{
			apply_recipe_tint = "primary",
			animation = {
				filename = BIOPROCESSING_GRAPHICS_PATH .. "bio-arboretum-on.png",
				blend_mode = "additive",
				width = 224,
				height = 256,
				line_length = 1,
				frame_count = 1,
				shift = { 0, -0.50 },
			},
			light = { intensity = 1, size = 8, color = { r = 0.5, g = 1.0, b = 0.5 } },
		},
	}
end

---Gets the circuit connector of Angel's arboretum for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 8,
			main_offset = util.by_pixel(-66.125, -11.5),
			shadow_offset = util.by_pixel(-66.125, -11.5),
			show_shadow = true,
		},
		{
			variation = 8,
			main_offset = util.by_pixel(-66.125, -11.5),
			shadow_offset = util.by_pixel(-66.125, -11.5),
			show_shadow = true,
		},
		{
			variation = 8,
			main_offset = util.by_pixel(-66.125, -11.5),
			shadow_offset = util.by_pixel(-66.125, -11.5),
			show_shadow = true,
		},
		{
			variation = 8,
			main_offset = util.by_pixel(-66.125, -11.5),
			shadow_offset = util.by_pixel(-66.125, -11.5),
			show_shadow = true,
		},
	})
end

---Defines the options for the Angel's arboretum sprite set.
---@class ArboretumSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("ArboretumSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for Angel's arboretum.
---@param params ArboretumSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's arboretum.
---
---#### Examples
---```lua
---local arboretum = require("__reskins-assets-api__.assets.angels.entities.bioprocessing.arboretum")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = arboretum.get_sprite_set({ tint = tint })
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
			drawing_box_vertical_extension = 1.5,
			nominal_width = 5,
			nominal_height = 5,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-angels__/graphics/icons" })

---Gets the icon for Angel's arboretum, in the tints given by `params`.
M.get_icon = icons:tinted("arboretum"):build("get_icon")

return M
