---@diagnostic disable: generic-constraint-mismatch

---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _sprite_utils = {
	sprites = require("__reskins-sprite-utils__.sprites"),
	utils = require("__reskins-sprite-utils__.utils"),
}
local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local BASE_PATH = "__base__/graphics/entity/centrifuge/"
local ASSETS_BASE_PATH = "__reskins-assets-base__/graphics/entity/centrifuge/"

local M = {}

---@param tint? Color
---@return Animation[]
local function get_idle_animation_integration_layers(tint)
	---@type Animation[]
	local layers = {
		util.sprite_load(BASE_PATH .. "centrifuge-ABC-integration", {
			priority = "high",
			scale = 0.5,
			frame_count = 1,
			repeat_count = 64,
		}),
	}

	if tint then
		layers[#layers + 1] = util.sprite_load(ASSETS_BASE_PATH .. "centrifuge-abc-integration-mask", {
			priority = "high",
			scale = 0.5,
			frame_count = 1,
			repeat_count = 64,
			tint = tint,
		})
		layers[#layers + 1] = util.sprite_load(ASSETS_BASE_PATH .. "centrifuge-abc-integration-highlights", {
			priority = "high",
			scale = 0.5,
			frame_count = 1,
			repeat_count = 64,
			blend_mode = "additive",
		})
	end

	return layers
end

---@param tint? Color
---@return Animation[]
local function get_idle_animation_layers(tint)
	---@type Animation[]
	local layers = {
		util.sprite_load(BASE_PATH .. "centrifuge-ABC", {
			priority = "high",
			scale = 0.5,
			frame_count = 64,
		}),
	}

	if tint then
		layers[#layers + 1] = util.sprite_load(ASSETS_BASE_PATH .. "centrifuge-abc-mask", {
			priority = "high",
			scale = 0.5,
			frame_count = 64,
			tint = tint,
		})
		layers[#layers + 1] = util.sprite_load(ASSETS_BASE_PATH .. "centrifuge-abc-highlights", {
			priority = "high",
			scale = 0.5,
			frame_count = 64,
			blend_mode = "additive",
		})
	end

	return layers
end

---@param tint? Color
---@return Animation
local function get_idle_animation(tint)
	return {
		layers = _sprite_utils.utils.array_concat(
			get_idle_animation_integration_layers(tint),
			get_idle_animation_layers(tint),
			{
				util.sprite_load("__base__/graphics/entity/centrifuge/centrifuge-ABC-shadow", {
					priority = "high",
					scale = 0.5,
					frame_count = 64,
					draw_as_shadow = true,
				}),
			}
		),
	}
end

---@return WorkingVisualisation[]
local function get_working_visualisations()
	return {
		{
			effect = "uranium-glow",
			apply_recipe_tint = "primary",
			fadeout = true,
			light = { intensity = 0.1, size = 9.9, shift = { 0.0, 0.0 }, color = { r = 0.0, g = 1.0, b = 0.0 } },
		},
		{
			effect = "uranium-glow",
			apply_recipe_tint = "primary",
			fadeout = true,
			animation = {
				layers = {
					util.sprite_load(ASSETS_BASE_PATH .. "lights/centrifuge-abc-light", {
						priority = "high",
						scale = 0.5,
						frame_count = 64,
						blend_mode = "additive",
						draw_as_glow = true,
					}),
				},
			},
		},
	}
end

---@param tint? Color
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint)
	return {
		always_draw_idle_animation = true,
		idle_animation = get_idle_animation(tint),
		working_visualisations = get_working_visualisations(),
	}
end

---@param tint? Color
---@return RotatedAnimationVariations
local function get_corpse_animation(tint)
	local layers = {
		{
			filename = BASE_PATH .. "remnants/centrifuge-remnants.png",
			width = 286,
			height = 284,
			direction_count = 1,
			shift = util.by_pixel(7, 4),
			scale = 0.5,
		},
	}

	if tint then
		table.insert(layers, {
			filename = ASSETS_BASE_PATH .. "remnants/centrifuge-remnants-mask.png",
			width = 286,
			height = 284,
			direction_count = 1,
			shift = util.by_pixel(7, 4),
			tint = tint,
			scale = 0.5,
		})
		table.insert(layers, {
			filename = ASSETS_BASE_PATH .. "remnants/centrifuge-remnants-highlights.png",
			width = 286,
			height = 284,
			direction_count = 1,
			shift = util.by_pixel(7, 4),
			blend_mode = "additive",
			scale = 0.5,
		})
	end

	return _sprite_utils.sprites.make_rotated_animation_variations_from_spritesheet(1, { layers = layers })
end

---@return WaterReflectionDefinition
local function get_water_reflection()
	return {
		pictures = {
			filename = BASE_PATH .. "centrifuge-reflection.png",
			priority = "extra-high",
			width = 28,
			height = 32,
			shift = util.by_pixel(0, 65),
			variation_count = 1,
			scale = 5,
		},
		rotate = false,
		orientation_to_variation = false,
	}
end

---Defines the options for the vanilla centrifuge sprite set.
---@class CentrifugeSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

---Gets the sprite set for the vanilla centrifuge.
---@param params CentrifugeSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for the vanilla centrifuge.
---
---#### Examples
---```lua
---local centrifuge = require("__reskins-assets-api__.assets.base.entities.centrifuge")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = centrifuge.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set(params)
	---@type SpriteSetDefinition<CraftingMachineSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.crafting_machine_sprite_set,
		set = {
			graphics_set = get_graphics_set(params.tint),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = { animation = get_corpse_animation(params.tint) },
			water_reflection = get_water_reflection(),
			nominal_width = 3,
			nominal_height = 3,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-base__/graphics/icons" })

---Gets the icon for the vanilla centrifuge, in the tints given by `params`.
M.get_icon = icons:tinted("centrifuge"):build("get_icon")

return M
