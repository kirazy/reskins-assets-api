---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")

local M = {}

---@alias AccumulatorSpriteVariant
---| "base"
---| "fast"
---| "high-capacity"
---| "slow"

local check_get_accumulator_pictures = V.signature("get_accumulator_pictures", {
	{ "sprite_set", V.one_of({ "base", "fast", "high-capacity", "slow" }):optional() },
	{ "tint", Common.color:optional() },
	{ "repeat_count", Common.positive_integer:optional() },
})

---@param sprite_set AccumulatorSpriteVariant? # Default "base".
---@param tint Color? # Default nil.
---@param repeat_count integer? # Default nil.
---@return Animation
local function get_accumulator_pictures(sprite_set, tint, repeat_count)
	check_get_accumulator_pictures(sprite_set, tint, repeat_count)

	sprite_set = sprite_set or "base"

	local assets_base_path = sprite_set == "base" and _defines.assets_source.base or _defines.assets_source.bobs_assets
	local accumulator_type = sprite_set == "base" and "" or ("-" .. sprite_set)

	---@type Animation
	local sprite = {
		layers = {
			{
				filename = assets_base_path .. "/graphics/entity/accumulator/accumulator" .. accumulator_type .. ".png",
				priority = "high",
				width = 130,
				height = 189,
				repeat_count = repeat_count,
				shift = util.by_pixel(0, -11),
				scale = 0.5,
			},
			{
				filename = "__base__/graphics/entity/accumulator/accumulator-shadow.png",
				priority = "high",
				width = 234,
				height = 106,
				repeat_count = repeat_count,
				shift = util.by_pixel(29, 6),
				draw_as_shadow = true,
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(sprite.layers--[[@cast -?]], {
			filename = "__reskins-assets-base__/graphics/entity/accumulator/accumulator-mask.png",
			priority = "high",
			width = 130,
			height = 189,
			repeat_count = repeat_count,
			shift = util.by_pixel(0, -11),
			tint = tint,
			scale = 0.5,
		})

		table.insert(sprite.layers--[[@cast -?]], {
			filename = "__reskins-assets-base__/graphics/entity/accumulator/accumulator-highlights.png",
			priority = "high",
			width = 130,
			height = 189,
			repeat_count = repeat_count,
			shift = util.by_pixel(0, -11),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return sprite
end

---@param sprite_set AccumulatorSpriteVariant?
---@param tint Color?
---@return Animation
local function get_accumulator_charge_animation(sprite_set, tint)
	local repeat_count = 24

	---@type Animation
	local animation = {
		layers = {
			get_accumulator_pictures(sprite_set, tint, repeat_count),
			{
				filename = "__base__/graphics/entity/accumulator/accumulator-charge.png",
				priority = "high",
				width = 178,
				height = 210,
				line_length = 6,
				frame_count = 24,
				draw_as_glow = true,
				shift = util.by_pixel(1, -20),
				scale = 0.5,
			},
		},
	}

	return animation
end

---@param sprite_set AccumulatorSpriteVariant?
---@param tint Color?
---@return Animation
local function get_accumulator_discharge_animation(sprite_set, tint)
	local repeat_count = 24

	---@type Animation
	local animation = {
		layers = {
			get_accumulator_pictures(sprite_set, tint, repeat_count),
			{
				filename = "__base__/graphics/entity/accumulator/accumulator-discharge.png",
				priority = "high",
				width = 174,
				height = 214,
				line_length = 6,
				frame_count = 24,
				draw_as_glow = true,
				shift = util.by_pixel(-1, -21),
				scale = 0.5,
			},
		},
	}

	return animation
end

---@return WaterReflectionDefinition
local function get_accumulator_reflection()
	---@type WaterReflectionDefinition
	local reflection = {
		pictures = {
			filename = "__base__/graphics/entity/accumulator/accumulator-reflection.png",
			priority = "extra-high",
			width = 20,
			height = 24,
			shift = util.by_pixel(0, 50),
			variation_count = 1,
			scale = 5,
		},
		rotate = false,
		orientation_to_variation = false,
	}

	return reflection
end

---@param sprite_set AccumulatorSpriteVariant?
---@param tint Color?
---@return ChargableGraphics
local function get_chargable_graphics(sprite_set, tint)
	---@type ChargableGraphics
	local chargable_graphics = {
		picture = get_accumulator_pictures(sprite_set, tint) --[[@as Sprite]],
		charge_animation = get_accumulator_charge_animation(sprite_set, tint),
		charge_animation_is_looped = true,
		charge_cooldown = 30, -- same as base
		discharge_animation = get_accumulator_discharge_animation(sprite_set, tint),
		discharge_cooldown = 60, -- same as base
	}

	return chargable_graphics
end

---@param tint Color?
---@return RotatedAnimationVariations
local function get_corpse_animation(tint)
	return reskins_suppress_errors and {} or error("get_corpse_animation is not implemented")
end

---@class AccumulatorSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set rather than drawn
---untinted.
---@field tint Color?
---The accumulator to draw. Defaults to `"base"`.
---@field sprite_set AccumulatorSpriteVariant?

---Gets the sprite set for the vanilla accumulator.
---@param params AccumulatorSpriteSetParams # The options the sprite set is drawn with.
---@return SpriteSetDefinition<AccumulatorSpriteSet>
---
---### Examples
---```lua
---local accumulator = require("__reskins-assets-api__.assets.base.entities.accumulator")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = accumulator.get_sprite_set({ tint = tint, sprite_set = sprite_set })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set(params)
	---@type SpriteSetDefinition<AccumulatorSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.accumulator_sprite_set,
		set = {
			chargable_graphics = get_chargable_graphics(params.sprite_set, params.tint),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = { animation = get_corpse_animation(params.tint) },
			water_reflection = get_accumulator_reflection(),
			nominal_width = 2,
			nominal_height = 2,
		},
	}

	return definition
end

local check_get_icon = V.signature("get_icon", {
	{ "sprite_set", V.one_of({ "base", "fast", "high-capacity", "slow" }):optional() },
	{ "tint", Common.color:optional() },
})

---Gets the icon for an accumulator of the given `sprite_set`, in the given `tint`.
---@param sprite_set "base"|"fast"|"high-capacity"|"slow"? # The accumulator the icon is drawn for. Defaults to `"base"`.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(sprite_set, tint)
	check_get_icon(sprite_set, tint)

	-- The vanilla accumulator wears vanilla artwork; the rest are Bob's.
	sprite_set = sprite_set or "base"
	local name = sprite_set == "base" and "accumulator" or "accumulator-" .. sprite_set
	local mod = sprite_set == "base" and "__reskins-assets-base__" or "__reskins-assets-bobs__"
	local folder = mod .. "/graphics/icons/" .. name .. "/" .. name .. "-icon-"

	---@type SafeIconData[]
	local icon = { { icon = folder .. "base.png", icon_size = 64, scale = 0.5 } }

	if tint then
		table.insert(icon, { icon = folder .. "mask.png", icon_size = 64, scale = 0.5, tint = tint })
		table.insert(icon, { icon = folder .. "highlights.png", icon_size = 64, scale = 0.5, tint = { 1, 1, 1, 0 } })
	end

	return icon
end

return M
