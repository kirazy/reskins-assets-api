---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local StringValidator = require("prototypes.string-validator")
local NumberValidator = require("prototypes.number-validator")

local M = {}

---@alias AccumulatorSpriteVariant
---| "base"
---| "fast"
---| "high-capacity"
---| "slow"

---@param sprite_set AccumulatorSpriteVariant? # Default "base".
---@param tint Color? # Default nil.
---@param repeat_count integer? # Default nil.
---@return Animation
local function get_accumulator_pictures(sprite_set, tint, repeat_count)
	if repeat_count ~= nil then
		NumberValidator.validate(repeat_count, "repeat_count"):is_integer():is_positive()
	end

	sprite_set = sprite_set or "base"
	StringValidator.validate(sprite_set, "sprite_set")

	-- Validate sprite_set is one of the allowed values
	local valid_sprite_sets = {
		["base"] = true,
		["high-capacity"] = true,
		["fast"] = true,
		["slow"] = true,
	}
	if not valid_sprite_sets[sprite_set] then
		error("Invalid sprite_set: " .. tostring(sprite_set) .. ". Must be one of: base, high-capacity, fast, slow")
	end

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
---@field tint Color?
---@field sprite_set AccumulatorSpriteVariant?

---Produces the sprite set for the vanilla accumulator.
---
---The old pack built a corpse animation but never wired it up; it is carried on
---`corpse` here so the art stays reachable once an applicator consumes that field.
---@param params AccumulatorSpriteSetParams
---@return SpriteSetDefinition<AccumulatorSpriteSet>
---@nodiscard
function M.get(params)
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

return M
