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

local BIOPROCESSING_GRAPHICS_PATH = "__angelsbioprocessinggraphics__/graphics/entity/composter/"
local ASSETS_ANGELS_PATH = "__reskins-assets-angels__/graphics/entity/composter/"

local M = {}

---Gets the animation of Angel's composter.
---@return Animation
local function get_animation()
	return {
		filename = BIOPROCESSING_GRAPHICS_PATH .. "composter.png",
		width = 160,
		height = 160,
		frame_count = 1,
		line_length = 1,
		shift = { 0, 0 },
	}
end

---Gets the working visualisations of Angel's composter for the given `tint`.
---@param tint Color
---@return WorkingVisualisation[]
local function get_working_visualisations(tint)
	return {
		{
			always_draw = true,
			animation = {
				layers = {
					{
						filename = ASSETS_ANGELS_PATH .. "composter-mask.png",
						priority = "extra-high",
						width = 160,
						height = 160,
						shift = { 0, 0 },
						tint = tint,
					},
					{
						filename = ASSETS_ANGELS_PATH .. "composter-highlights.png",
						priority = "extra-high",
						width = 160,
						height = 160,
						shift = { 0, 0 },
						blend_mode = "additive",
					},
				},
			},
		},
	}
end

---Gets the circuit connector of Angel's composter for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 5,
			main_offset = util.by_pixel(31.5, 27.75),
			shadow_offset = util.by_pixel(31.5, 27.75),
			show_shadow = true,
		},
		{
			variation = 5,
			main_offset = util.by_pixel(31.5, 27.75),
			shadow_offset = util.by_pixel(31.5, 27.75),
			show_shadow = true,
		},
		{
			variation = 5,
			main_offset = util.by_pixel(31.5, 27.75),
			shadow_offset = util.by_pixel(31.5, 27.75),
			show_shadow = true,
		},
		{
			variation = 5,
			main_offset = util.by_pixel(31.5, 27.75),
			shadow_offset = util.by_pixel(31.5, 27.75),
			show_shadow = true,
		},
	})
end

---Defines the options for the Angel's composter sprite set.
---@class ComposterSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("ComposterSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for Angel's composter.
---@param params ComposterSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's composter.
---
---#### Examples
---```lua
---local composter = require("__reskins-assets-api__.assets.angels.entities.bioprocessing.composter")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = composter.get_sprite_set({ tint = tint })
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
				animation = get_animation(),
				working_visualisations = params.tint and get_working_visualisations(params.tint),
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
			nominal_width = 3,
			nominal_height = 3,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-angels__/graphics/icons" })

---Gets the icon for Angel's composter, in the tints given by `params`.
M.get_icon = icons:tinted("composter"):build("get_icon")

return M
