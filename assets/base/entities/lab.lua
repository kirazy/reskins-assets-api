---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local _sprite_utils = { sprites = require("__reskins-sprite-utils__.sprites") }

local M = {}

---@param tint Color?
---@return Animation
local function get_on_animation(tint)
	local assets_path = _defines.assets_source.base_assets .. "/graphics/entity/lab/"
	local base_path = _defines.assets_source.base .. "/graphics/entity/lab/"

	---@type Animation
	local animation = {
		layers = {
			{
				filename = base_path .. "lab.png",
				width = 194,
				height = 174,
				frame_count = 33,
				line_length = 11,
				animation_speed = 1 / 3,
				shift = util.by_pixel(0, 1.5),
				scale = 0.5,
			},
			{
				filename = base_path .. "lab-light.png",
				width = 216,
				height = 194,
				repeat_count = 33,
				animation_speed = 1 / 3,
				blend_mode = "additive",
				draw_as_light = true,
				shift = util.by_pixel(0, 0),
				scale = 0.5,
			},
			{
				filename = base_path .. "lab-shadow.png",
				width = 242,
				height = 136,
				repeat_count = 33,
				animation_speed = 1 / 3,
				draw_as_shadow = true,
				shift = util.by_pixel(13, 11),
				scale = 0.5,
			},
		},
	}

	if tint then
		---@cast animation.layers -?
		table.insert(animation.layers, {
			filename = assets_path .. "lab-mask.png",
			width = 194,
			height = 174,
			frame_count = 33,
			line_length = 11,
			animation_speed = 1 / 3,
			tint = tint,
			shift = util.by_pixel(0, 1.5),
			scale = 0.5,
		})
		table.insert(animation.layers, {
			filename = assets_path .. "lab-highlights.png",
			width = 194,
			height = 174,
			frame_count = 33,
			line_length = 11,
			animation_speed = 1 / 3,
			blend_mode = "additive-soft",
			shift = util.by_pixel(0, 1.5),
			scale = 0.5,
		})
	end

	return animation
end

---@param tint Color?
---@return Animation
local function get_off_animation(tint)
	local assets_path = _defines.assets_source.base_assets .. "/graphics/entity/lab/"
	local base_path = _defines.assets_source.base .. "/graphics/entity/lab/"

	---@type Animation
	local animation = {
		layers = {
			{
				filename = base_path .. "lab.png",
				width = 194,
				height = 174,
				shift = util.by_pixel(0, 1.5),
				scale = 0.5,
			},
			{
				filename = base_path .. "lab-shadow.png",
				width = 242,
				height = 136,
				draw_as_shadow = true,
				shift = util.by_pixel(13, 11),
				scale = 0.5,
			},
		},
	}

	if tint then
		---@cast animation.layers -?
		table.insert(animation.layers, {
			filename = assets_path .. "lab-mask.png",
			width = 194,
			height = 174,
			tint = tint,
			shift = util.by_pixel(0, 1.5),
			scale = 0.5,
		})
		table.insert(animation.layers, {
			filename = assets_path .. "lab-highlights.png",
			width = 194,
			height = 174,
			blend_mode = "additive-soft",
			shift = util.by_pixel(0, 1.5),
			scale = 0.5,
		})
	end

	return animation
end

---@return Sprite
local function get_frozen_patch()
	return {
		filename = "__space-age__/graphics/entity/frozen/lab/lab.png",
		width = 194,
		height = 174,
		shift = util.by_pixel(0, 1.5),
		scale = 0.5,
	}
end

---@return Sprite
local function get_integration_patch()
	---@type Sprite
	local patch = {
		filename = "__base__/graphics/entity/lab/lab-integration.png",
		width = 242,
		height = 162,
		shift = util.by_pixel(0, 15.5),
		scale = 0.5,
	}
	return patch
end

---@return WaterReflectionDefinition
local function get_water_reflection()
	return {
		pictures = {
			filename = "__reskins-assets-base__/graphics/entity/lab/lab-reflection.png",
			priority = "extra-high",
			width = 24,
			height = 24,
			shift = util.by_pixel(5, 40),
			variation_count = 1,
			scale = 5,
		},
		rotate = false,
		orientation_to_variation = false,
	}
end

---@param tint Color?
---@return RotatedAnimationVariations
local function get_corpse_animation(tint)
	local assets_path = _defines.assets_source.base_assets .. "/graphics/entity/lab/remnants/"
	local base_path = _defines.assets_source.base .. "/graphics/entity/lab/remnants/"

	---@type RotatedAnimation
	local animation = {
		layers = {
			{
				filename = base_path .. "lab-remnants.png",
				width = 266,
				height = 196,
				direction_count = 1,
				shift = util.by_pixel(12, 4.5),
				scale = 0.5,
			},
		},
	}

	if tint then
		---@cast animation.layers -?
		table.insert(animation.layers, {
			filename = assets_path .. "lab-remnants-mask.png",
			width = 266,
			height = 196,
			direction_count = 1,
			shift = util.by_pixel(12, 4.5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers, {
			filename = assets_path .. "lab-remnants-highlights.png",
			width = 266,
			height = 196,
			direction_count = 1,
			shift = util.by_pixel(12, 4.5),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return _sprite_utils.sprites.make_rotated_animation_variations_from_spritesheet(2, animation)
end

---@class LabSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?

---Gets the sprite set for the vanilla lab.
---@param params LabSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<LabSpriteSet>
---
---#### Examples
---```lua
---local lab = require("__reskins-assets-api__.assets.base.entities.lab")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = lab.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set(params)
	---@type SpriteSetDefinition<LabSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.lab_sprite_set,
		set = {
			on_animation = get_on_animation(params.tint),
			off_animation = get_off_animation(params.tint),
			frozen_patch = get_frozen_patch(),
			integration_patch = get_integration_patch(),
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

return M
