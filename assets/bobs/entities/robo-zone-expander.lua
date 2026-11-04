---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Entities

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local IconBuilderFactory = require("api.icon-builder-factory")

local ASSETS_BOBS_PATH = "__reskins-assets-bobs__/graphics/entity/robo-zone-expander/"
local ANTENNAS_PATH = "__reskins-assets-bobs__/graphics/entity/roboport/antennas/"

local M = {}

---The tier of a logistic zone expander, which selects its artwork.
---@alias RoboZoneExpanderTier 1|2|3|4

local RoboZoneExpanderTier = V.one_of({ 1, 2, 3, 4 })

---Gets the graphics set of the logistic zone expander for the given `tier`.
---@param tint? Color
---@param tier RoboZoneExpanderTier
---@return RoboportGraphicsSet
local function get_graphics_set(tint, tier)
	local base_layers = {
		{
			filename = ASSETS_BOBS_PATH .. "robo-zone-expander-" .. tier .. "-base.png",
			width = 56,
			height = 156,
			shift = util.by_pixel(0.5, -29.5),
			scale = 0.5,
		},
	}

	if tint then
		table.insert(base_layers, {
			filename = ASSETS_BOBS_PATH .. "robo-zone-expander-mask.png",
			width = 38,
			height = 30,
			shift = util.by_pixel(0.5, 0),
			tint = tint,
			scale = 0.5,
		})
		table.insert(base_layers, {
			filename = ASSETS_BOBS_PATH .. "robo-zone-expander-highlights.png",
			width = 38,
			height = 30,
			shift = util.by_pixel(0.5, 0),
			blend_mode = "additive",
			scale = 0.5,
		})
	end

	---@type RoboportGraphicsSet
	local graphics_set = {
		base = { layers = base_layers },
		base_animation = {
			layers = {
				{
					filename = ANTENNAS_PATH .. "roboport-" .. tier .. "-base-animation.png",
					priority = "medium",
					width = 83,
					height = 59,
					frame_count = 8,
					animation_speed = 0.5,
					shift = util.by_pixel(0.25, -66),
					scale = 0.5,
				},
				{
					filename = ASSETS_BOBS_PATH .. "robo-zone-expander-shadow.png",
					width = 228,
					height = 60,
					frame_count = 8,
					shift = util.by_pixel(44.5, -1.5),
					draw_as_shadow = true,
					scale = 0.5,
				},
			},
		},
		recharging_animation = {
			filename = "__base__/graphics/entity/roboport/roboport-recharging.png",
			draw_as_glow = true,
			priority = "high",
			width = 37,
			height = 35,
			frame_count = 16,
			scale = 1.5,
			animation_speed = 0.5,
		},
		recharging_light = { intensity = 0.4, size = 5 },
		spawn_and_station_height = 1.75,
	}

	return graphics_set
end

---Gets the water reflection of the logistic zone expander.
---@return WaterReflectionDefinition
local function get_water_reflection()
	return {
		pictures = {
			filename = ASSETS_BOBS_PATH .. "robo-zone-expander-reflection.png",
			priority = "extra-high",
			width = 12,
			height = 23,
			shift = util.by_pixel(0, 45),
			variation_count = 1,
			scale = 5,
		},
		rotate = false,
		orientation_to_variation = false,
	}
end

---Defines the options for the logistic zone expander sprite set.
---@class RoboZoneExpanderSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color
---The tier of the logistic zone expander, which selects its artwork.
---@field tier RoboZoneExpanderTier

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("RoboZoneExpanderSpriteSetParams", {
			tint = Common.color:optional(),
			tier = RoboZoneExpanderTier,
		}):strict(),
	},
})

---Gets the sprite set for the logistic zone expander.
---@param params RoboZoneExpanderSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<RoboportSpriteSet> # The sprite set definition for the logistic zone expander.
---
---#### Examples
---```lua
---local robo_zone_expander = require("__reskins-assets-api__.assets.bobs.entities.robo-zone-expander")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = robo_zone_expander.get_sprite_set({ tint = tint, tier = 2 })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@throws When `params.tier` is not an integer between 1 and 4.
---@throws When `params.tint` is not a `Color`.
---@nodiscard
function M.get_sprite_set(params)
	check_get_sprite_set(params)

	---@type SpriteSetDefinition<RoboportSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.roboport_sprite_set,
		set = {
			graphics_set = get_graphics_set(params.tint, params.tier),
			circuit_connector = nil,
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = nil,
			water_reflection = get_water_reflection(),
			drawing_box_vertical_extension = 1.4,
			nominal_width = 2,
			nominal_height = 2,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-bobs__/graphics/icons" })

---Gets the icon for the logistic zone expander of the `tier`, in the tints given by `params`.
---
---The base layer differs by tier, and the mask and highlights layers are the same for every tier.
M.get_icon = icons
	:tinted("robo-zone-expander")
	:keyed("tier", RoboZoneExpanderTier, { IconBuilderFactory.role.base })
	:build("get_icon")

return M
