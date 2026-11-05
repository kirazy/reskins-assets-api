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

local BIOPROCESSING_GRAPHICS_PATH = "__angelsbioprocessinggraphics__/graphics/entity/algae-farm/"
local ASSETS_ANGELS_PATH = "__reskins-assets-angels__/graphics/entity/algae-farm/"

local M = {}

---Gets the animation of Angel's algae farm.
---@param tint? Color
---@return Animation
local function get_animation(tint)
	local layers = {
		{
			filename = BIOPROCESSING_GRAPHICS_PATH .. "algae-farm.png",
			priority = "extra-high",
			width = 288,
			height = 288,
			line_length = 6,
			frame_count = 36,
			shift = { 0, 0 },
			animation_speed = 0.4,
		},
	}

	if tint then
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "algae-farm-mask.png",
			priority = "extra-high",
			width = 288,
			height = 288,
			repeat_count = 36,
			shift = { 0, 0 },
			animation_speed = 0.4,
			tint = tint,
		}
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "algae-farm-highlights.png",
			priority = "extra-high",
			width = 288,
			height = 288,
			repeat_count = 36,
			shift = { 0, 0 },
			animation_speed = 0.4,
			blend_mode = "additive",
		}
	end

	return { layers = layers }
end

---Gets the working visualisations of Angel's algae farm.
---@return WorkingVisualisation[]
local function get_working_visualisations()
	return {
		{
			animation = {
				filename = BIOPROCESSING_GRAPHICS_PATH .. "water-splash.png",
				line_length = 5,
				frame_count = 10,
				width = 92,
				height = 99,
				scale = 0.4,
				shift = { -1.4, 0 },
				animation_speed = 0.2,
				run_mode = "forward",
			},
			light = { intensity = 0.4, size = 6 },
		},
	}
end

---Gets the circuit connector of Angel's algae farm for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 6,
			main_offset = util.by_pixel(97, -51.375),
			shadow_offset = util.by_pixel(97, -51.375),
			show_shadow = true,
		},
		{
			variation = 6,
			main_offset = util.by_pixel(97, -51.375),
			shadow_offset = util.by_pixel(97, -51.375),
			show_shadow = true,
		},
		{
			variation = 6,
			main_offset = util.by_pixel(97, -51.375),
			shadow_offset = util.by_pixel(97, -51.375),
			show_shadow = true,
		},
		{
			variation = 6,
			main_offset = util.by_pixel(97, -51.375),
			shadow_offset = util.by_pixel(97, -51.375),
			show_shadow = true,
		},
	})
end

---Defines the options for the Angel's algae farm sprite set.
---@class AlgaeFarmSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("AlgaeFarmSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for Angel's algae farm.
---@param params AlgaeFarmSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's algae farm.
---
---#### Examples
---```lua
---local algae_farm = require("__reskins-assets-api__.assets.angels.entities.bioprocessing.algae-farm")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = algae_farm.get_sprite_set({ tint = tint })
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
			nominal_width = 7,
			nominal_height = 7,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-angels__/graphics/icons" })

local icon_builder = icons:tinted("algae-farm")

---Gets the icon for Angel's algae farm, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the icon for Angel's algae farm as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
