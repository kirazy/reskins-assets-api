-- cspell: words robochest

---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Entities

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local IconBuilderFactory = require("api.icon-builder-factory")
local RoboportExplosion = require("assets.base.explosions.roboport")

local ASSETS_BOBS_PATH = "__reskins-assets-bobs__/graphics/entity/"
local ASSETS_BASE_PATH = "__reskins-assets-base__/graphics/entity/roboport/"

local M = {}

---The tier of a robochest, which selects its artwork.
---@alias RoboChestTier 1|2|3|4

local RoboChestTier = V.one_of({ 1, 2, 3, 4 })

---Gets the base of the robochest.
---@param tint? Color
---@return Sprite
local function get_base(tint)
	---@type Sprite[]
	local layers = {
		{
			filename = ASSETS_BOBS_PATH .. "robo-chest/robo-chest-base.png",
			width = 130,
			height = 138,
			shift = util.by_pixel(0, -2.75),
			scale = 0.5,
		},
	}

	if tint then
		table.insert(layers, {
			filename = ASSETS_BOBS_PATH .. "robo-chest/robo-chest-mask.png",
			width = 130,
			height = 138,
			shift = util.by_pixel(0, -2.75),
			tint = tint,
			scale = 0.5,
		})
		table.insert(layers, {
			filename = ASSETS_BOBS_PATH .. "robo-chest/robo-chest-highlights.png",
			width = 130,
			height = 138,
			shift = util.by_pixel(0, -2.75),
			blend_mode = "additive",
			scale = 0.5,
		})
	end

	table.insert(layers, {
		filename = ASSETS_BOBS_PATH .. "robo-chest/robo-chest-shadow.png",
		width = 174,
		height = 108,
		shift = util.by_pixel(12, 5),
		draw_as_shadow = true,
		scale = 0.5,
	})

	return { layers = layers }
end

---Gets the base patch of the robochest.
---@param tint? Color
---@return Sprite
local function get_base_patch(tint)
	---@type Sprite[]
	local layers = {
		-- The roboport prototype requires a placeholder for padding.
		{
			filename = "__core__/graphics/empty.png",
			priority = "medium",
			width = 1,
			height = 1,
		},
		{
			filename = ASSETS_BOBS_PATH .. "robo-chest/robo-chest-base-patch.png",
			priority = "medium",
			width = 110,
			height = 80,
			shift = util.by_pixel(0, 5.5),
			scale = 0.5,
		},
	}

	if tint then
		table.insert(layers, {
			filename = ASSETS_BOBS_PATH .. "robo-chest/robo-chest-base-patch-mask.png",
			priority = "medium",
			width = 110,
			height = 80,
			shift = util.by_pixel(0, 5.5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(layers, {
			filename = ASSETS_BOBS_PATH .. "robo-chest/robo-chest-base-patch-highlights.png",
			priority = "medium",
			width = 110,
			height = 80,
			shift = util.by_pixel(0, 5.5),
			blend_mode = "additive",
			scale = 0.5,
		})
	end

	return { layers = layers }
end

---Gets the graphics set of the robochest for the given `tier`.
---@param tint? Color
---@param tier RoboChestTier
---@return RoboportGraphicsSet
local function get_graphics_set(tint, tier)
	---@type RoboportGraphicsSet
	local graphics_set = {
		base = get_base(tint),
		base_patch = get_base_patch(tint),
		frozen_patch = nil,
		base_animation = nil,
		door_animation_up = {
			filename = ASSETS_BOBS_PATH .. "roboport/doors/roboport-" .. tier .. "-door-up.png",
			priority = "medium",
			width = 97,
			height = 38,
			frame_count = 16,
			shift = util.by_pixel(-0.25, -25),
			scale = 0.5,
		},
		door_animation_down = {
			filename = ASSETS_BOBS_PATH .. "robo-chest/doors/robo-chest-" .. tier .. "-door-down.png",
			priority = "medium",
			width = 97,
			height = 45,
			frame_count = 16,
			shift = util.by_pixel(-0.25, -6.25),
			scale = 0.5,
		},
		recharging_animation = {
			filename = ASSETS_BASE_PATH .. "roboport-recharging.png",
			priority = "high",
			width = 37,
			height = 35,
			frame_count = 16,
			scale = 1.5,
			animation_speed = 0.5,
		},
		recharging_light = { intensity = 0.4, size = 5 },
		spawn_and_station_height = -0.25,
		spawn_and_station_shadow_height_offset = 0,
		stationing_render_layer_swap_height = 0.87,
		stationing_offset = { 0, 0 },
		charging_offsets = { { 0, 0 } },
	}

	return graphics_set
end

---Defines the options for the robochest sprite set.
---@class RoboChestSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color
---The tier of the robochest, which selects the artwork of its doors.
---@field tier RoboChestTier

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("RoboChestSpriteSetParams", {
			tint = Common.color:optional(),
			tier = RoboChestTier,
		}):strict(),
	},
})

---Gets the sprite set for the robochest.
---@param params RoboChestSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<RoboportSpriteSet> # The sprite set definition for the robochest.
---
---#### Examples
---```lua
---local robo_chest = require("__reskins-assets-api__.assets.bobs.entities.robo-chest")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = robo_chest.get_sprite_set({ tint = tint, tier = 2 })
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
			dying_explosion = RoboportExplosion.get_explosion({
				tints = params.tint and { ["roboport-metal-particle-medium"] = params.tint },
			}),
			corpse = _defines.generic_remnants,
			water_reflection = nil,
			nominal_width = 2,
			nominal_height = 2,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-bobs__/graphics/icons" })

---Gets the icon for a robochest of the `tier`, in the tints given by `params`.
M.get_icon = icons:tinted("robo-chest"):keyed("tier", RoboChestTier, { IconBuilderFactory.role.base }):build("get_icon")

return M
