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

local SMELTING_GRAPHICS_PATH = "__angelssmeltinggraphics__/graphics/entity/powder-mixer/"
local ASSETS_ANGELS_PATH = "__reskins-assets-angels__/graphics/entity/powder-mixer/"

local M = {}

---Gets the animation of Angel's powder mixer.
---@param tint? Color
---@return Animation
local function get_animation(tint)
	local layers = {
		{
			filename = SMELTING_GRAPHICS_PATH .. "powder-mixer-base.png",
			priority = "extra-high",
			width = 138,
			height = 170,
			line_length = 4,
			frame_count = 4,
			animation_speed = 0.5,
			shift = util.by_pixel(0.5, -9.5),
			scale = 0.5,
		},
		{
			filename = SMELTING_GRAPHICS_PATH .. "powder-mixer-shadow.png",
			priority = "extra-high",
			width = 183,
			height = 99,
			repeat_count = 4,
			animation_speed = 0.5,
			draw_as_shadow = true,
			shift = util.by_pixel(13, 9),
			scale = 0.5,
		},
	}

	if tint then
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "powder-mixer-mask.png",
			priority = "extra-high",
			width = 138,
			height = 170,
			line_length = 4,
			frame_count = 4,
			animation_speed = 0.5,
			shift = util.by_pixel(0.5, -9.5),
			tint = tint,
			scale = 0.5,
		}
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "powder-mixer-highlights.png",
			priority = "extra-high",
			width = 138,
			height = 170,
			line_length = 4,
			frame_count = 4,
			animation_speed = 0.5,
			shift = util.by_pixel(0.5, -9.5),
			blend_mode = "additive",
			scale = 0.5,
		}
	end

	return { layers = layers }
end

---Gets the circuit connector of Angel's powder mixer for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 32,
			main_offset = util.by_pixel(-6.375, -39.5),
			shadow_offset = util.by_pixel(-6.375, -39.5),
			show_shadow = true,
		},
		{
			variation = 32,
			main_offset = util.by_pixel(-6.375, -39.5),
			shadow_offset = util.by_pixel(-6.375, -39.5),
			show_shadow = true,
		},
		{
			variation = 32,
			main_offset = util.by_pixel(-6.375, -39.5),
			shadow_offset = util.by_pixel(-6.375, -39.5),
			show_shadow = true,
		},
		{
			variation = 32,
			main_offset = util.by_pixel(-6.375, -39.5),
			shadow_offset = util.by_pixel(-6.375, -39.5),
			show_shadow = true,
		},
	})
end

---Defines the options for the Angel's powder mixer sprite set.
---@class PowderMixerSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("PowderMixerSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for Angel's powder mixer.
---@param params PowderMixerSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's powder mixer.
---
---#### Examples
---```lua
---local powder_mixer = require("__reskins-assets-api__.assets.angels.entities.smelting.powder-mixer")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = powder_mixer.get_sprite_set({ tint = tint })
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
			drawing_box_vertical_extension = 0.55,
			nominal_width = 2,
			nominal_height = 2,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-angels__/graphics/icons" })

---Gets the icon for Angel's powder mixer, in the tints given by `params`.
M.get_icon = icons:tinted("powder-mixer"):build("get_icon")

return M
