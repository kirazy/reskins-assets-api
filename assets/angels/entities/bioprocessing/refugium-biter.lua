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
local ASSETS_ANGELS_PATH = "__reskins-assets-angels__/graphics/entity/refugium-biter/"

local M = {}

---Gets the graphics set of Angel's biter refugium.
---@param tint? Color
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint)
	---@type WorkingVisualisation[]
	local working_visualisations = {
		{
			animation = {
				filename = BIOPROCESSING_GRAPHICS_PATH .. "bio-refugium-biter.png",
				width = 288,
				height = 288,
				line_length = 4,
				frame_count = 16,
				shift = { 0, 0 },
				animation_speed = 0.5 * 0.75 / 2,
			},
		},
	}

	if tint then
		table.insert(working_visualisations, {
			always_draw = true,
			animation = {
				layers = {
					{
						filename = ASSETS_ANGELS_PATH .. "refugium-biter-mask.png",
						priority = "extra-high",
						width = 288,
						height = 288,
						shift = { 0, 0 },
						tint = tint,
					},
					{
						filename = ASSETS_ANGELS_PATH .. "refugium-biter-highlights.png",
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
			filename = BIOPROCESSING_GRAPHICS_PATH .. "bio-refugium-biter-off.png",
			width = 288,
			height = 288,
			line_length = 1,
			frame_count = 1,
			shift = { 0, 0 },
		},
		working_visualisations = working_visualisations,
	}
end

---Gets the circuit connector of Angel's biter refugium for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 4,
			main_offset = util.by_pixel(-3.5, -49),
			shadow_offset = util.by_pixel(-3.5, -49),
			show_shadow = true,
		},
		{
			variation = 4,
			main_offset = util.by_pixel(-3.5, -49),
			shadow_offset = util.by_pixel(-3.5, -49),
			show_shadow = true,
		},
		{
			variation = 4,
			main_offset = util.by_pixel(-3.5, -49),
			shadow_offset = util.by_pixel(-3.5, -49),
			show_shadow = true,
		},
		{
			variation = 4,
			main_offset = util.by_pixel(-3.5, -49),
			shadow_offset = util.by_pixel(-3.5, -49),
			show_shadow = true,
		},
	})
end

---Defines the options for the Angel's biter refugium sprite set.
---@class RefugiumBiterSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("RefugiumBiterSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for Angel's biter refugium.
---@param params RefugiumBiterSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's biter refugium.
---
---#### Examples
---```lua
---local refugium_biter = require("__reskins-assets-api__.assets.angels.entities.bioprocessing.refugium-biter")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = refugium_biter.get_sprite_set({ tint = tint })
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

local icon_builder = icons:tinted("refugium-biter")

---Gets the icon for Angel's biter refugium, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the icon for Angel's biter refugium as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
