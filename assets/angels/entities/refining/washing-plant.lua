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

local REFINING_GRAPHICS_PATH = "__angelsrefininggraphics__/graphics/entity/washing-plant/"
local ASSETS_ANGELS_PATH = "__reskins-assets-angels__/graphics/entity/washing-plant/"

local M = {}

---Gets the animation of Angel's washing plant.
---@param tint? Color
---@return Animation
local function get_animation(tint)
	local layers = {
		{
			filename = REFINING_GRAPHICS_PATH .. "washing-plant.png",
			priority = "extra-high",
			width = 224,
			height = 224,
			frame_count = 25,
			line_length = 5,
			shift = { 0, 0 },
		},
		{
			filename = ASSETS_ANGELS_PATH .. "washing-plant-base-patch.png",
			priority = "extra-high",
			width = 224,
			height = 224,
			repeat_count = 25,
			shift = { 0, 0 },
		},
	}

	if tint then
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "washing-plant-mask.png",
			priority = "extra-high",
			width = 224,
			height = 224,
			repeat_count = 25,
			shift = { 0, 0 },
			tint = tint,
		}
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "washing-plant-highlights.png",
			priority = "extra-high",
			width = 224,
			height = 224,
			repeat_count = 25,
			shift = { 0, 0 },
			blend_mode = "additive",
		}
	end

	return { layers = layers }
end

---Gets the circuit connector of Angel's washing plant for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 5,
			main_offset = util.by_pixel(3.5, 39.625),
			shadow_offset = util.by_pixel(3.5, 39.625),
			show_shadow = true,
		},
		{
			variation = 5,
			main_offset = util.by_pixel(3.5, 39.625),
			shadow_offset = util.by_pixel(3.5, 39.625),
			show_shadow = true,
		},
		{
			variation = 5,
			main_offset = util.by_pixel(3.5, 39.625),
			shadow_offset = util.by_pixel(3.5, 39.625),
			show_shadow = true,
		},
		{
			variation = 5,
			main_offset = util.by_pixel(3.5, 39.625),
			shadow_offset = util.by_pixel(3.5, 39.625),
			show_shadow = true,
		},
	})
end

---Defines the options for the Angel's washing plant sprite set.
---@class WashingPlantSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("WashingPlantSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for Angel's washing plant.
---@param params WashingPlantSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's washing plant.
---
---#### Examples
---```lua
---local washing_plant = require("__reskins-assets-api__.assets.angels.entities.refining.washing-plant")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = washing_plant.get_sprite_set({ tint = tint })
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
			nominal_width = 5,
			nominal_height = 5,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-angels__/graphics/icons" })

---Gets the icon for Angel's washing plant, in the tints given by `params`.
M.get_icon = icons:tinted("washing-plant"):build("get_icon")

return M
