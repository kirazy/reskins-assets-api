---cspell: words liquifier
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

local REFINING_GRAPHICS_PATH = "__angelsrefininggraphics__/graphics/entity/liquifier/"
local ASSETS_ANGELS_PATH = "__reskins-assets-angels__/graphics/entity/liquefier/"

local M = {}

---Gets the animation of Angel's liquefier.
---@param tint? Color
---@return Animation
local function get_animation(tint)
	local layers = {
		{
			filename = REFINING_GRAPHICS_PATH .. "liquifier.png",
			width = 160,
			height = 160,
			line_length = 10,
			frame_count = 30,
			shift = { 0, 0 },
			animation_speed = 0.5,
		},
	}

	if tint then
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "liquefier-mask.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			repeat_count = 30,
			shift = { 0, 0 },
			animation_speed = 0.5,
			tint = tint,
		}
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "liquefier-highlights.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			repeat_count = 30,
			shift = { 0, 0 },
			animation_speed = 0.5,
			blend_mode = "additive",
		}
	end

	return { layers = layers }
end

---Gets the circuit connector of Angel's liquefier for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 4,
			main_offset = util.by_pixel(16.5, 12),
			shadow_offset = util.by_pixel(16.5, 12),
			show_shadow = true,
		},
		{
			variation = 4,
			main_offset = util.by_pixel(16.5, 12),
			shadow_offset = util.by_pixel(16.5, 12),
			show_shadow = true,
		},
		{
			variation = 4,
			main_offset = util.by_pixel(16.5, 12),
			shadow_offset = util.by_pixel(16.5, 12),
			show_shadow = true,
		},
		{
			variation = 4,
			main_offset = util.by_pixel(16.5, 12),
			shadow_offset = util.by_pixel(16.5, 12),
			show_shadow = true,
		},
	})
end

---Defines the options for the Angel's liquefier sprite set.
---@class LiquefierSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("LiquefierSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for Angel's liquefier.
---@param params LiquefierSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's liquefier.
---
---#### Examples
---```lua
---local liquefier = require("__reskins-assets-api__.assets.angels.entities.refining.liquefier")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = liquefier.get_sprite_set({ tint = tint })
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

local icon_builder = icons:tinted("liquefier")

---Gets the icon for Angel's liquefier, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the icon for Angel's liquefier as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
