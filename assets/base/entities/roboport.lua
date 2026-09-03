---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")

local M = {}

local RoboportVariant = V.integer():in_range(0, 4)

local check_get_graphics_set = V.signature("get_graphics_set", {
	{ "tint", Common.color:optional() },
	{ "antenna_variant", RoboportVariant },
	{ "door_variant", RoboportVariant },
})

---@param tint Color?
---@param antenna_variant 0|1|2|3|4
---@param door_variant 0|1|2|3|4
---@return RoboportGraphicsSet
local function get_graphics_set(tint, antenna_variant, door_variant)
	check_get_graphics_set(tint, antenna_variant, door_variant)

	local base_path = _defines.assets_source.base .. "/graphics/entity/roboport/"
	local base_assets_path = _defines.assets_source.base_assets .. "/graphics/entity/roboport/"
	local bobs_path = _defines.assets_source.bobs_assets .. "/graphics/entity/roboport/"

	local antenna_filename = antenna_variant == 0 and base_path .. "roboport-base-animation.png"
		or bobs_path .. "antennas/roboport-" .. antenna_variant .. "-base-animation.png"

	local door_up_filename = door_variant == 0 and base_path .. "roboport-door-up.png"
		or bobs_path .. "doors/roboport-" .. door_variant .. "-door-up.png"

	local door_down_filename = door_variant == 0 and base_path .. "roboport-door-down.png"
		or bobs_path .. "doors/roboport-" .. door_variant .. "-door-down.png"

	local base_layers = {
		{
			filename = base_assets_path .. "roboport-base.png",
			width = 228,
			height = 277,
			shift = util.by_pixel(2, 7.75),
			scale = 0.5,
		},
	}

	if tint then
		table.insert(base_layers, {
			filename = base_assets_path .. "roboport-base-mask.png",
			width = 228,
			height = 277,
			shift = util.by_pixel(2, 7.75),
			tint = tint,
			scale = 0.5,
		})
		table.insert(base_layers, {
			filename = base_assets_path .. "roboport-base-highlights.png",
			width = 228,
			height = 277,
			shift = util.by_pixel(2, 7.75),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	table.insert(base_layers, {
		filename = base_assets_path .. "roboport-shadow.png",
		width = 294,
		height = 201,
		draw_as_shadow = true,
		shift = util.by_pixel(28.5, 19.25),
		scale = 0.5,
	})

	local base_patch_layers = {
		-- Padding placeholder required by the roboport prototype.
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
			shift = util.by_pixel(1.5, 5),
			scale = 0.5,
		},
	}

	if tint then
		table.insert(base_patch_layers, {
			filename = base_assets_path .. "roboport-base-patch-mask.png",
			priority = "medium",
			width = 138,
			height = 100,
			shift = util.by_pixel(1.5, 5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(base_patch_layers, {
			filename = base_assets_path .. "roboport-base-patch-highlights.png",
			priority = "medium",
			width = 138,
			height = 100,
			shift = util.by_pixel(1.5, 5),
			blend_mode = "additive-soft",
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
			shift = util.by_pixel(-17.75, -61.25),
			scale = 0.5,
		},
		door_animation_up = {
			filename = door_up_filename,
			priority = "medium",
			width = 97,
			height = 38,
			frame_count = 16,
			shift = util.by_pixel(-0.25, -29.5),
			scale = 0.5,
		},
		door_animation_down = {
			filename = door_down_filename,
			priority = "medium",
			width = 97,
			height = 41,
			frame_count = 16,
			shift = util.by_pixel(-0.25, -9.75),
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
	}

	return graphics_set
end

---@param tint Color?
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
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return { animation, util.copy(animation) }
end

---@class RoboportSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?
---The antenna to draw: `0` is the base game's, `1`-`4` are Bob's.
---@field antenna_variant 0|1|2|3|4
---The door to draw: `0` is the base game's, `1`-`4` are Bob's.
---@field door_variant 0|1|2|3|4

---Gets the sprite set for the vanilla roboport.
---@param params RoboportSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<RoboportSpriteSet>
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
	-- field rather than sprite data and has no home on this shape.
	---@type SpriteSetDefinition<RoboportSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.roboport_sprite_set,
		set = {
			graphics_set = get_graphics_set(params.tint, params.antenna_variant, params.door_variant),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = { animation = get_corpse_animation(params.tint) },
			water_reflection = nil,
			nominal_width = 4,
			nominal_height = 4,
		},
	}

	return definition
end

---The tier of a roboport, selecting the artwork it is drawn with.
---@alias RoboportTier 1|2|3|4

---Builds a roboport icon from `base_layer`, masked and highlighted from `folder`.
---@param base_layer FileName # The file the base layer is drawn from.
---@param folder string # The folder the mask and highlights are filed under.
---@param tint Color? # The color to tint the mask.
---@return SafeIconData[]
---@nodiscard
local function get_layers(base_layer, folder, tint)
	local layers = { { icon = base_layer, icon_size = 64, scale = 0.5 } }

	if tint then
		table.insert(layers, { icon = folder .. "roboport-mask.png", icon_size = 64, scale = 0.5, tint = tint })
		table.insert(layers, {
			icon = folder .. "roboport-highlights.png",
			icon_size = 64,
			scale = 0.5,
			tint = { 1, 1, 1, 0 },
		})
	end

	return layers
end

local check_get_icon = V.signature("get_icon", {
	{ "tint", Common.color:optional() },
})

---Gets the icon for the vanilla roboport, in the given `tint`.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(tint)
	check_get_icon(tint)

	local folder = "__reskins-assets-base__/graphics/icons/roboport/"

	return get_layers(folder .. "roboport-base.png", folder, tint)
end

local check_get_tier_icon = V.signature("get_tier_icon", {
	{ "tier", V.integer():in_range(1, 4) },
	{ "tint", Common.color:optional() },
})

---Gets the icon for a roboport of the given `tier`, in the given `tint`.
---@param tier RoboportTier # The tier of the roboport, selecting the artwork it is drawn with.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_tier_icon(tier, tint)
	check_get_tier_icon(tier, tint)

	local folder = "__reskins-assets-bobs__/graphics/icons/roboport/"

	return get_layers(folder .. "roboport-" .. tier .. "-base.png", folder, tint)
end

return M
