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

local SMELTING_GRAPHICS_PATH = "__angelssmeltinggraphics__/graphics/entity/pellet-press/"
local ASSETS_ANGELS_PATH = "__reskins-assets-angels__/graphics/entity/pellet-press/"

local M = {}

---Gets the animation of Angel's pellet press.
---@param tint? Color
---@return Animation
local function get_animation(tint)
	local layers = {
		{
			filename = SMELTING_GRAPHICS_PATH .. "pellet-press-base.png",
			priority = "extra-high",
			width = 200,
			height = 199,
			line_length = 10,
			frame_count = 60,
			animation_speed = 0.5,
			shift = util.by_pixel(0, 0),
			scale = 0.5,
		},
		{
			filename = SMELTING_GRAPHICS_PATH .. "pellet-press-shadow.png",
			priority = "extra-high",
			width = 246,
			height = 132,
			line_length = 6,
			frame_count = 60,
			animation_speed = 0.5,
			draw_as_shadow = true,
			shift = util.by_pixel(12, 17),
			scale = 0.5,
		},
	}

	if tint then
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "pellet-press-mask.png",
			priority = "extra-high",
			width = 200,
			height = 199,
			line_length = 10,
			frame_count = 60,
			animation_speed = 0.5,
			shift = util.by_pixel(0, 0),
			tint = tint,
			scale = 0.5,
		}
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "pellet-press-highlights.png",
			priority = "extra-high",
			width = 200,
			height = 199,
			line_length = 10,
			frame_count = 60,
			animation_speed = 0.5,
			shift = util.by_pixel(0, 0),
			blend_mode = "additive",
			scale = 0.5,
		}
	end

	return { layers = layers }
end

---Gets the circuit connector of Angel's pellet press for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 2,
			main_offset = util.by_pixel(-21.25, -16.375),
			shadow_offset = util.by_pixel(-21.25, -16.375),
			show_shadow = true,
		},
		{
			variation = 2,
			main_offset = util.by_pixel(-21.25, -16.375),
			shadow_offset = util.by_pixel(-21.25, -16.375),
			show_shadow = true,
		},
		{
			variation = 2,
			main_offset = util.by_pixel(-21.25, -16.375),
			shadow_offset = util.by_pixel(-21.25, -16.375),
			show_shadow = true,
		},
		{
			variation = 2,
			main_offset = util.by_pixel(-21.25, -16.375),
			shadow_offset = util.by_pixel(-21.25, -16.375),
			show_shadow = true,
		},
	})
end

---Defines the options for the Angel's pellet press sprite set.
---@class PelletPressSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("PelletPressSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for Angel's pellet press.
---@param params PelletPressSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's pellet press.
---
---#### Examples
---```lua
---local pellet_press = require("__reskins-assets-api__.assets.angels.entities.smelting.pellet-press")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = pellet_press.get_sprite_set({ tint = tint })
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
			graphics_set = { animation = get_animation(params.tint) },
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

---Gets the icon for Angel's pellet press, in the tints given by `params`.
M.get_icon = icons:tinted("pellet-press"):build("get_icon")

return M
