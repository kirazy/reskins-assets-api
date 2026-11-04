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

local BIOPROCESSING_GRAPHICS_PATH = "__angelsbioprocessinggraphics__/graphics/entity/bio-refugium/"
local ASSETS_ANGELS_PATH = "__reskins-assets-angels__/graphics/entity/refugium-fish/"

local M = {}

---Gets the graphics set of Angel's fish refugium.
---@param tint? Color
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint)
	---@type WorkingVisualisation[]
	local working_visualisations = {
		{
			animation = {
				filename = BIOPROCESSING_GRAPHICS_PATH .. "bio-refugium-fish.png",
				width = 288,
				height = 288,
				line_length = 7,
				frame_count = 49,
				shift = { 0, 0 },
				animation_speed = 49 / 90,
			},
		},
	}

	if tint then
		table.insert(working_visualisations, {
			always_draw = true,
			animation = {
				layers = {
					{
						filename = ASSETS_ANGELS_PATH .. "refugium-fish-mask.png",
						priority = "extra-high",
						width = 288,
						height = 288,
						shift = { 0, 0 },
						tint = tint,
					},
					{
						filename = ASSETS_ANGELS_PATH .. "refugium-fish-highlights.png",
						priority = "extra-high",
						width = 288,
						height = 288,
						shift = { 0, 0 },
						blend_mode = "additive",
					},
				},
			},
		})
	end

	---@type CraftingMachineGraphicsSet
	return {
		animation = {
			layers = {
				{
					filename = BIOPROCESSING_GRAPHICS_PATH .. "bio-refugium-fish-shadow.png",
					width = 288,
					height = 288,
					line_length = 1,
					frame_count = 1,
					shift = { 0, 0 },
				},
				{
					filename = BIOPROCESSING_GRAPHICS_PATH .. "bio-refugium-fish-off.png",
					width = 288,
					height = 288,
					line_length = 1,
					frame_count = 1,
					shift = { 0, 0 },
				},
			},
		},
		working_visualisations = working_visualisations,
	}
end

---Gets the circuit connector of Angel's fish refugium for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 5,
			main_offset = util.by_pixel(84.5, 105),
			shadow_offset = util.by_pixel(84.5, 105),
			show_shadow = true,
		},
		{
			variation = 5,
			main_offset = util.by_pixel(84.5, 105),
			shadow_offset = util.by_pixel(84.5, 105),
			show_shadow = true,
		},
		{
			variation = 5,
			main_offset = util.by_pixel(84.5, 105),
			shadow_offset = util.by_pixel(84.5, 105),
			show_shadow = true,
		},
		{
			variation = 5,
			main_offset = util.by_pixel(84.5, 105),
			shadow_offset = util.by_pixel(84.5, 105),
			show_shadow = true,
		},
	})
end

---Defines the options for the Angel's fish refugium sprite set.
---@class RefugiumFishSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("RefugiumFishSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for Angel's fish refugium.
---@param params RefugiumFishSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's fish refugium.
---
---#### Examples
---```lua
---local refugium_fish = require("__reskins-assets-api__.assets.angels.entities.bioprocessing.refugium-fish")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = refugium_fish.get_sprite_set({ tint = tint })
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
			dying_explosion = AssemblingMachine1Explosion.get_explosion({
				tints = params.tint and {
					["assembling-machine-1-metal-particle-big"] = params.tint,
					["assembling-machine-1-metal-particle-medium"] = params.tint,
				},
			}),
			corpse = _defines.generic_remnants,
			water_reflection = nil,
			drawing_box_vertical_extension = 1,
			nominal_width = 7,
			nominal_height = 7,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-angels__/graphics/icons" })

---Gets the icon for Angel's fish refugium, in the tints given by `params`.
M.get_icon = icons:tinted("refugium-fish"):build("get_icon")

return M
