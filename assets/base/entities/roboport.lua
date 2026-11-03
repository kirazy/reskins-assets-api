---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local IconBuilderFactory = require("api.icon-builder-factory")

local M = {}

local RoboportVariant = V.one_of({ 1, 2, 3, 4 }):optional()

local check_get_graphics_set = V.signature("get_graphics_set", {
	{ "tint", Common.color:optional() },
	{ "antenna_variant", RoboportVariant },
	{ "door_variant", RoboportVariant },
})

---@param tint? Color
---@param antenna_variant? 1|2|3|4
---@param door_variant? 1|2|3|4
---@return RoboportGraphicsSet
local function get_graphics_set(tint, antenna_variant, door_variant)
	check_get_graphics_set(tint, antenna_variant, door_variant)

	local base_path = _defines.assets_source.base .. "/graphics/entity/roboport/"
	local base_assets_path = _defines.assets_source.base_assets .. "/graphics/entity/roboport/"
	local bobs_path = _defines.assets_source.bobs_assets .. "/graphics/entity/roboport/"

	local antenna_filename = antenna_variant
			and bobs_path .. "antennas/roboport-" .. antenna_variant .. "-base-animation.png"
		or base_path .. "roboport-base-animation.png"

	local door_up_filename = door_variant and bobs_path .. "doors/roboport-" .. door_variant .. "-door-up.png"
		or base_path .. "roboport-door-up.png"

	local door_down_filename = door_variant and bobs_path .. "doors/roboport-" .. door_variant .. "-door-down.png"
		or base_path .. "roboport-door-down.png"

	local base_layers = {
		{
			filename = base_assets_path .. "roboport-base.png",
			width = 228,
			height = 277,
			shift = util.by_pixel(2, -2.25),
			scale = 0.5,
		},
	}

	if tint then
		table.insert(base_layers, {
			filename = base_assets_path .. "roboport-base-mask.png",
			width = 228,
			height = 277,
			shift = util.by_pixel(2, -2.25),
			tint = tint,
			scale = 0.5,
		})
		table.insert(base_layers, {
			filename = base_assets_path .. "roboport-base-highlights.png",
			width = 228,
			height = 277,
			shift = util.by_pixel(2, -2.25),
			blend_mode = "additive",
			scale = 0.5,
		})
	end

	table.insert(base_layers, {
		filename = base_assets_path .. "roboport-shadow.png",
		width = 294,
		height = 201,
		draw_as_shadow = true,
		shift = util.by_pixel(28.5, 9.25),
		scale = 0.5,
	})

	local base_patch_layers = {
		-- The roboport prototype requires a placeholder for padding.
		{
			filename = "__core__/graphics/empty.png",
			priority = "medium",
			width = 1,
			height = 1,
		},
		{
			filename = base_assets_path .. "roboport-base-patch.png",
			priority = "medium",
			width = 138,
			height = 100,
			shift = util.by_pixel(1.5, -5),
			scale = 0.5,
		},
	}

	if tint then
		table.insert(base_patch_layers, {
			filename = base_assets_path .. "roboport-base-patch-mask.png",
			priority = "medium",
			width = 138,
			height = 100,
			shift = util.by_pixel(1.5, -5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(base_patch_layers, {
			filename = base_assets_path .. "roboport-base-patch-highlights.png",
			priority = "medium",
			width = 138,
			height = 100,
			shift = util.by_pixel(1.5, -5),
			blend_mode = "additive",
			scale = 0.5,
		})
	end

	---@type RoboportGraphicsSet
	local graphics_set = {
		base = { layers = base_layers },
		base_patch = { layers = base_patch_layers },
		base_animation = {
			filename = antenna_filename,
			priority = "medium",
			width = 83,
			height = 59,
			frame_count = 8,
			animation_speed = 0.5,
			shift = util.by_pixel(-17.75, -71.25),
			scale = 0.5,
		},
		door_animation_up = {
			filename = door_up_filename,
			priority = "medium",
			width = 97,
			height = 38,
			frame_count = 16,
			shift = util.by_pixel(-0.25, -39.5),
			scale = 0.5,
		},
		door_animation_down = {
			filename = door_down_filename,
			priority = "medium",
			width = 97,
			height = 41,
			frame_count = 16,
			shift = util.by_pixel(-0.25, -19.75),
			scale = 0.5,
		},
		recharging_animation = {
			filename = base_assets_path .. "roboport-recharging.png",
			priority = "high",
			width = 37,
			height = 35,
			frame_count = 16,
			scale = 1.5,
			animation_speed = 0.5,
		},
		recharging_light = { intensity = 0.2, size = 3, color = { 0.5, 0.5, 1 } },
		spawn_and_station_height = 0.3,
		spawn_and_station_shadow_height_offset = 0,
		stationing_render_layer_swap_height = 0.87,
		stationing_offset = { 0, 0 },
		charging_offsets = {
			{ -1.5, -1 },
			{ 1.5, -1 },
			{ 1.5, 1 },
			{ -1.5, 1 },
		},
	}

	if feature_flags["freezing"] and mods["space-age"] then
		graphics_set.frozen_patch = {
			filename = "__space-age__/graphics/entity/frozen/roboport/roboport-base.png",
			width = 228,
			height = 277,
			shift = util.by_pixel(2, -2.25),
			scale = 0.5,
		}
	end

	return graphics_set
end

---@param tint? Color
---@return RotatedAnimationVariations
local function get_corpse_animation(tint)
	local assets_path = _defines.assets_source.base_assets .. "/graphics/entity/roboport/remnants/"

	---@type RotatedAnimation
	local animation = {
		layers = {
			{
				filename = assets_path .. "roboport-remnants.png",
				width = 364,
				height = 358,
				direction_count = 1,
				shift = util.by_pixel(2, 8),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "roboport-remnants-mask.png",
			width = 364,
			height = 358,
			direction_count = 1,
			shift = util.by_pixel(2, 8),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "roboport-remnants-highlights.png",
			width = 364,
			height = 358,
			direction_count = 1,
			shift = util.by_pixel(2, 8),
			blend_mode = "additive",
			scale = 0.5,
		})
	end

	return { animation, util.copy(animation) }
end

---@return WaterReflectionDefinition
local function get_water_reflection()
	return {
		pictures = {
			filename = "__base__/graphics/entity/roboport/roboport-reflection.png",
			priority = "extra-high",
			width = 28,
			height = 28,
			shift = util.by_pixel(0, 65),
			variation_count = 1,
			scale = 5,
		},
		rotate = false,
		orientation_to_variation = false,
	}
end

---@return CircuitConnectorDefinition
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_single(universal_connector_template, {
		variation = 26,
		main_offset = util.by_pixel(18.5, 31),
		shadow_offset = util.by_pixel(20.5, 46.5),
		show_shadow = false,
	})
end

---Defines the options for the vanilla roboport sprite set.
---@class RoboportSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color
---The antenna variant. 0 is the base game's antenna, and the variants between 1 and 4 are Bob's.
---@field antenna_variant? 1|2|3|4
---The door variant. 0 is the base game's door, and the variants between 1 and 4 are Bob's.
---@field door_variant? 1|2|3|4

---Gets the sprite set for the vanilla roboport.
---@param params RoboportSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<RoboportSpriteSet> # The sprite set definition for the vanilla roboport.
---
---#### Examples
---```lua
---local roboport = require("__reskins-assets-api__.assets.base.entities.roboport")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = roboport.get_sprite_set({ tint = tint, antenna_variant = antenna_variant, door_variant = door_variant })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set(params)
	-- FIXME: `spawn_and_station_height = -0.1` matches these sprites, but it is a prototype
	-- field, and this sprite set has no field for it.
	-- FIXME: Current entity definition in base/prototypes/entity/entities.lua has spawn_and_station_height = 0.3
	---@type SpriteSetDefinition<RoboportSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.roboport_sprite_set,
		set = {
			graphics_set = get_graphics_set(params.tint, params.antenna_variant, params.door_variant),
			circuit_connector = get_circuit_connector(),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = { animation = get_corpse_animation(params.tint) },
			water_reflection = get_water_reflection(),
			nominal_width = 4,
			nominal_height = 4,
		},
	}

	return definition
end

---The tier of a roboport, which selects its artwork.
---@alias RoboportTier 1|2|3|4

local base_icons = IconBuilderFactory:create({ folder = "__reskins-assets-base__/graphics/icons" })
local bobs_icons = IconBuilderFactory:create({ folder = "__reskins-assets-bobs__/graphics/icons" })

---Gets the icon for the vanilla roboport, in the tints given by `params`.
M.get_icon = base_icons:tinted("roboport"):build("get_icon")

---Gets the icon for a roboport of the `tier` and in the tints given by `params`.
---
---Every tier shares one mask and one highlights layer, only the base layer differs by tier.
M.get_tier_icon = bobs_icons
	:tinted("roboport")
	:keyed("tier", V.one_of({ 1, 2, 3, 4 }), { IconBuilderFactory.role.base })
	:build("get_tier_icon")

return M
