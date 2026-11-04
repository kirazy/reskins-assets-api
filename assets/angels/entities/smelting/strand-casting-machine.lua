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

local SMELTING_GRAPHICS_PATH = "__angelssmeltinggraphics__/graphics/entity/strand-casting-machine/"
local ASSETS_ANGELS_PATH = "__reskins-assets-angels__/graphics/entity/strand-casting-machine/"

local M = {}

---Gets the graphics set of Angel's strand casting machine.
---@param tint? Color
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint)
	---@type WorkingVisualisation[]
	local working_visualisations = {
		{
			always_draw = true,
			animation = {
				layers = {
					{
						filename = SMELTING_GRAPHICS_PATH .. "strand-casting-machine-idle-state.png",
						priority = "high",
						width = 329,
						height = 392,
						shift = util.by_pixel(0, -16.5),
						scale = 0.5,
					},
					{
						filename = SMELTING_GRAPHICS_PATH .. "strand-casting-machine-shadow.png",
						priority = "high",
						width = 444,
						height = 311,
						draw_as_shadow = true,
						shift = util.by_pixel(29.5, 3.5),
						scale = 0.5,
					},
				},
			},
		},
		{
			apply_recipe_tint = "primary",
			always_draw = true,
			animation = {
				filename = SMELTING_GRAPHICS_PATH .. "strand-casting-machine-recipe-mask.png",
				priority = "high",
				width = 329,
				height = 392,
				shift = util.by_pixel(0, -16.5),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(working_visualisations, {
			always_draw = true,
			animation = {
				layers = {
					{
						filename = ASSETS_ANGELS_PATH .. "strand-casting-machine-mask.png",
						priority = "extra-high",
						width = 329,
						height = 392,
						shift = util.by_pixel(0, -16.5),
						tint = tint,
						scale = 0.5,
					},
					{
						filename = ASSETS_ANGELS_PATH .. "strand-casting-machine-highlights.png",
						priority = "extra-high",
						width = 329,
						height = 392,
						shift = util.by_pixel(0, -16.5),
						blend_mode = "additive",
						scale = 0.5,
					},
				},
			},
		})
	end

	table.insert(working_visualisations, {
		fadeout = true,
		animation = {
			filename = SMELTING_GRAPHICS_PATH .. "strand-casting-machine-working-animation.png",
			priority = "high",
			width = 329,
			height = 392,
			line_length = 6,
			frame_count = 24,
			animation_speed = 0.5,
			shift = util.by_pixel(0, -16.5),
			scale = 0.5,
		},
	})

	table.insert(working_visualisations, {
		fadeout = true,
		animation = {
			filename = SMELTING_GRAPHICS_PATH .. "strand-casting-machine-light.png",
			priority = "high",
			width = 329,
			height = 392,
			line_length = 6,
			frame_count = 24,
			animation_speed = 0.5,
			shift = util.by_pixel(0, -16.5),
			draw_as_light = true,
			scale = 0.5,
		},
	})

	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		working_visualisations = working_visualisations,
	}

	return graphics_set
end

---Gets the circuit connector of Angel's strand casting machine for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 5,
			main_offset = util.by_pixel(50, 11.625),
			shadow_offset = util.by_pixel(50, 11.625),
			show_shadow = true,
		},
		{
			variation = 5,
			main_offset = util.by_pixel(50, 11.625),
			shadow_offset = util.by_pixel(50, 11.625),
			show_shadow = true,
		},
		{
			variation = 5,
			main_offset = util.by_pixel(50, 11.625),
			shadow_offset = util.by_pixel(50, 11.625),
			show_shadow = true,
		},
		{
			variation = 5,
			main_offset = util.by_pixel(50, 11.625),
			shadow_offset = util.by_pixel(50, 11.625),
			show_shadow = true,
		},
	})
end

---Defines the options for the Angel's strand casting machine sprite set.
---@class StrandCastingMachineSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("StrandCastingMachineSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for Angel's strand casting machine.
---@param params StrandCastingMachineSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's strand casting machine.
---
---#### Examples
---```lua
---local strand_casting_machine = require("__reskins-assets-api__.assets.angels.entities.smelting.strand-casting-machine")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = strand_casting_machine.get_sprite_set({ tint = tint })
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
			drawing_box_vertical_extension = 1,
			nominal_width = 5,
			nominal_height = 5,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-angels__/graphics/icons" })

---Gets the icon for Angel's strand casting machine, in the tints given by `params`.
M.get_icon = icons:tinted("strand-casting-machine"):build("get_icon")

return M
