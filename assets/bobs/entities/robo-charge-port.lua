---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Entities

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local _sprite_utils = { utils = require("__reskins-sprite-utils__.utils") }
local IconBuilderFactory = require("api.icon-builder-factory")
local RoboportExplosion = require("assets.base.explosions.roboport")

local ASSETS_BOBS_PATH = "__reskins-assets-bobs__/graphics/entity/robo-charge-port/"
local ASSETS_BASE_PATH = "__reskins-assets-base__/graphics/entity/roboport/"

local M = {}

---The tier of a robot charge port, which selects its artwork.
---@alias RoboChargePortTier 1|2|3|4

local RoboChargePortTier = V.one_of({ 1, 2, 3, 4 })

---Gets the layers of a charging pad at the given `x` and `y`, in tiles, for the given `tier` and `pad_scale`.
---@param tint? Color
---@param tier RoboChargePortTier
---@param x number
---@param y number
---@param pad_scale number
---@return Animation[]
local function get_pad_layers(tint, tier, x, y, pad_scale)
	local scale = 0.5 * pad_scale

	---@type Animation[]
	local layers = {
		{
			filename = ASSETS_BOBS_PATH .. "robo-charge-port-" .. tier .. "-base.png",
			priority = "medium",
			animation_speed = 0.2,
			width = 60,
			height = 56,
			repeat_count = 12,
			shift = { x, y },
			scale = scale,
		},
	}

	if tint then
		table.insert(layers, {
			filename = ASSETS_BOBS_PATH .. "robo-charge-port-mask.png",
			priority = "medium",
			animation_speed = 0.2,
			width = 60,
			height = 56,
			repeat_count = 12,
			shift = { x, y },
			tint = tint,
			scale = scale,
		})
		table.insert(layers, {
			filename = ASSETS_BOBS_PATH .. "robo-charge-port-highlights.png",
			priority = "medium",
			animation_speed = 0.2,
			width = 60,
			height = 56,
			repeat_count = 12,
			shift = { x, y },
			blend_mode = "additive",
			scale = scale,
		})
	end

	table.insert(layers, {
		filename = ASSETS_BOBS_PATH .. "robo-charge-port-shadow.png",
		priority = "medium",
		animation_speed = 0.2,
		width = 70,
		height = 58,
		repeat_count = 12,
		shift = util.by_pixel(x * 32 + 2.5 * pad_scale, y * 32 + 0.5 * pad_scale),
		draw_as_shadow = true,
		scale = scale,
	})

	if tint then
		table.insert(layers, {
			filename = ASSETS_BOBS_PATH .. "robo-charge-port-lights-mask.png",
			priority = "medium",
			animation_speed = 0.2,
			width = 32,
			height = 32,
			frame_count = 12,
			shift = util.by_pixel(x * 32, y * 32 + pad_scale),
			draw_as_glow = true,
			tint = tint,
			scale = scale,
		})
		table.insert(layers, {
			filename = ASSETS_BOBS_PATH .. "robo-charge-port-lights-highlights.png",
			priority = "medium",
			animation_speed = 0.2,
			width = 32,
			height = 32,
			frame_count = 12,
			shift = util.by_pixel(x * 32, y * 32 + pad_scale),
			draw_as_glow = true,
			blend_mode = "additive",
			scale = scale,
		})
	end

	return layers
end

---Gets the graphics set of a robot charge port with a pad at each of the given `pad_positions`.
---@param tint? Color
---@param tier RoboChargePortTier
---@param pad_positions Vector[]
---@param pad_scale number
---@return RoboportGraphicsSet
local function get_graphics_set(tint, tier, pad_positions, pad_scale)
	---@type Animation[]
	local layers = {}
	---@type Vector[]
	local charging_offsets = {}
	for _, position in pairs(pad_positions) do
		local x, y = _sprite_utils.utils.unpack_vector(position)
		for _, layer in pairs(get_pad_layers(tint, tier, x, y, pad_scale)) do
			table.insert(layers, layer)
		end
		table.insert(charging_offsets, { x, y })
	end

	---@type RoboportGraphicsSet
	local graphics_set = {
		base = nil,
		base_patch = nil,
		frozen_patch = nil,
		base_animation = { layers = layers },
		door_animation_up = nil,
		door_animation_down = nil,
		recharging_animation = {
			filename = ASSETS_BASE_PATH .. "roboport-recharging.png",
			priority = "high",
			width = 37,
			height = 35,
			frame_count = 16,
			scale = 1.5 * pad_scale,
			animation_speed = 0.5,
		},
		recharging_light = { intensity = 0.4, size = 5 },
		spawn_and_station_height = 0.33,
		spawn_and_station_shadow_height_offset = 0,
		stationing_render_layer_swap_height = 0.87,
		stationing_offset = { 0, 0 },
		charging_offsets = charging_offsets,
	}

	return graphics_set
end

---Gets the width and height, in whole tiles, of the smallest area centered on the entity that holds every pad.
---@param pad_positions Vector[]
---@param pad_scale number
---@return integer width
---@return integer height
local function get_nominal_size(pad_positions, pad_scale)
	-- A pad at a scale of 1 fits in one tile.
	local half_pad = pad_scale / 2
	---@type double
	local half_width = 0
	---@type double
	local half_height = 0
	for _, position in pairs(pad_positions) do
		local x, y = _sprite_utils.utils.unpack_vector(position)
		half_width = math.max(half_width, math.abs(x) + half_pad)
		half_height = math.max(half_height, math.abs(y) + half_pad)
	end

	-- Subtract a tolerance so that rounding errors in the positions do not add a tile.
	return math.ceil(2 * half_width - 1e-6), math.ceil(2 * half_height - 1e-6)
end

---Defines the options for the robot charge port sprite set.
---@class RoboChargePortSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color
---The tier of the robot charge port, which selects its artwork.
---@field tier RoboChargePortTier
---The positions of the charging pads, in tiles from the center of the entity. A pad is drawn at each position, and a
---robot charges at each position.
---@field pad_positions Vector[]
---The factor by which each pad is resized. A pad fits in one tile at a factor of 1. Default `1`.
---@field pad_scale? number

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("RoboChargePortSpriteSetParams", {
			tint = Common.color:optional(),
			tier = RoboChargePortTier,
			pad_positions = V.array(Common.vector):not_empty(),
			pad_scale = Common.positive_number:optional(),
		}):strict(),
	},
})

---Gets the sprite set for a robot charge port with a charging pad at each of the given positions.
---
---The nominal size of the set is the smallest area, in whole tiles and centered on the entity, that holds every pad.
---@param params RoboChargePortSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<RoboportSpriteSet> # The sprite set definition for the robot charge port.
---
---#### Examples
---```lua
---local robo_charge_port = require("__reskins-assets-api__.assets.bobs.entities.robo-charge-port")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
----- Draw four pads in a 2 by 2 grid.
---local sprite_set = robo_charge_port.get_sprite_set({
---    tint = tint,
---    tier = 2,
---    pad_positions = { { -0.5, -0.5 }, { 0.5, -0.5 }, { -0.5, 0.5 }, { 0.5, 0.5 } },
---})
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@throws When `params` defines an unrecognized field.
---@throws When `params.tier` is not an integer between 1 and 4.
---@throws When `params.pad_positions` is not a non-empty array of `Vector`.
---@throws When `params.pad_scale` is not a positive number.
---@throws When `params.tint` is not a `Color`.
---@nodiscard
function M.get_sprite_set(params)
	check_get_sprite_set(params)

	local pad_scale = params.pad_scale or 1
	local nominal_width, nominal_height = get_nominal_size(params.pad_positions, pad_scale)

	---@type SpriteSetDefinition<RoboportSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.roboport_sprite_set,
		set = {
			graphics_set = get_graphics_set(params.tint, params.tier, params.pad_positions, pad_scale),
			circuit_connector = nil,
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = RoboportExplosion.get_explosion({
				tints = params.tint and { ["roboport-metal-particle-medium"] = params.tint },
			}),
			corpse = _defines.generic_remnants,
			water_reflection = nil,
			nominal_width = nominal_width,
			nominal_height = nominal_height,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-bobs__/graphics/icons" })

local icon_builder =
	icons:tinted("robo-charge-port"):keyed("tier", RoboChargePortTier, { IconBuilderFactory.role.base })

---Gets the icon for a robot charge port of the `tier`, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the icon for a robot charge port of the `tier` as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

local large_icon_builder =
	icons:tinted("robo-charge-port-large"):keyed("tier", RoboChargePortTier, { IconBuilderFactory.role.base })

---Gets the icon for a large robot charge port of the `tier`, in the tints given by `params`.
M.get_large_icon = large_icon_builder:build("get_large_icon")

---Gets the icon for a large robot charge port of the `tier` as an `IconComposition`, in the tints given by `params`.
M.get_large_icon_composition = large_icon_builder:build_composition("get_large_icon_composition")

return M
