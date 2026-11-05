---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local _sprites = require("__reskins-sprite-utils__.sprites")
local IconBuilderFactory = require("api.icon-builder-factory")
local BigElectricPoleExplosion = require("assets.base.explosions.big-electric-pole")
local Remnants = require("assets.base.remnants")

local M = {}

---@param tint? Color
---@return RotatedSprite
local function get_pictures(tint)
	local assets_path = _defines.assets_source.base_assets .. "/graphics/entity/electric-pole-big/"

	---@type RotatedSprite
	local pictures = {
		layers = {
			{
				filename = assets_path .. "electric-pole-big.png",
				priority = "extra-high",
				width = 148,
				height = 312,
				direction_count = 4,
				shift = util.by_pixel(0, -51),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(pictures.layers--[[@cast -?]], {
			filename = assets_path .. "electric-pole-big-mask.png",
			priority = "extra-high",
			width = 148,
			height = 312,
			direction_count = 4,
			shift = util.by_pixel(0, -51),
			tint = tint,
			scale = 0.5,
		})
		table.insert(pictures.layers--[[@cast -?]], {
			filename = assets_path .. "electric-pole-big-highlights.png",
			priority = "extra-high",
			width = 148,
			height = 312,
			direction_count = 4,
			shift = util.by_pixel(0, -51),
			blend_mode = "additive",
			scale = 0.5,
		})
	end

	table.insert(pictures.layers--[[@cast -?]], {
		filename = assets_path .. "electric-pole-big-shadow.png",
		priority = "extra-high",
		width = 374,
		height = 94,
		direction_count = 4,
		shift = util.by_pixel(60, 0),
		draw_as_shadow = true,
		scale = 0.5,
	})

	return pictures
end

---@param tint? Color
---@return RotatedAnimationVariations
local function get_corpse_animation(tint)
	local assets_path = _defines.assets_source.base_assets .. "/graphics/entity/electric-pole-big/remnants/"

	---@type RotatedAnimation
	local animation = {
		layers = {
			{
				filename = assets_path .. "electric-pole-big-base-remnants.png",
				width = 366,
				height = 188,
				direction_count = 1,
				shift = util.by_pixel(43, 0.5),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "electric-pole-big-base-remnants-mask.png",
			width = 366,
			height = 188,
			direction_count = 1,
			shift = util.by_pixel(43, 0.5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "electric-pole-big-base-remnants-highlights.png",
			width = 366,
			height = 188,
			direction_count = 1,
			shift = util.by_pixel(43, 0.5),
			blend_mode = "additive",
			scale = 0.5,
		})
	end

	return _sprites.make_rotated_animation_variations_from_spritesheet(4, animation)
end

---@param tint? Color
---@return RotatedAnimationVariations
local function get_corpse_animation_overlay(tint)
	local assets_path = _defines.assets_source.base_assets .. "/graphics/entity/electric-pole-big/remnants/"

	---@type RotatedAnimation
	local animation = {
		layers = {
			{
				filename = assets_path .. "electric-pole-big-top-remnants.png",
				width = 148,
				height = 252,
				direction_count = 1,
				shift = util.by_pixel(-1.5, -48),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "electric-pole-big-top-remnants-mask.png",
			width = 148,
			height = 252,
			direction_count = 1,
			shift = util.by_pixel(-1.5, -48),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "electric-pole-big-top-remnants-highlights.png",
			width = 148,
			height = 252,
			direction_count = 1,
			shift = util.by_pixel(-1.5, -48),
			blend_mode = "additive",
			scale = 0.5,
		})
	end

	return _sprites.make_rotated_animation_variations_from_spritesheet(4, animation)
end

---@return WaterReflectionDefinition
local function get_water_reflection()
	return {
		pictures = {
			filename = "__base__/graphics/entity/big-electric-pole/big-electric-pole-reflection.png",
			priority = "extra-high",
			width = 16,
			height = 32,
			shift = util.by_pixel(0, 60),
			variation_count = 1,
			scale = 5,
		},
		rotate = false,
		orientation_to_variation = false,
	}
end

---Defines the options for the vanilla big electric pole sprite set.
---@class ElectricPoleBigSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

---Gets the sprite set for the vanilla big electric pole.
---@param params ElectricPoleBigSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<ElectricPoleSpriteSet> # The sprite set definition for the vanilla big electric pole.
---
---#### Examples
---```lua
---local electric_pole_big = require("__reskins-assets-api__.assets.base.entities.electric-pole-big")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = electric_pole_big.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set(params)
	---@type SpriteSetDefinition<ElectricPoleSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.electric_pole_sprite_set,
		set = {
			pictures = get_pictures(params.tint),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = BigElectricPoleExplosion.get_explosion({
				tints = params.tint and { ["big-electric-pole-long-metal-particle-medium"] = params.tint },
			}),
			corpse = Remnants.get_corpse("big-electric-pole-remnants", {
				animation = get_corpse_animation(params.tint),
				animation_overlay = get_corpse_animation_overlay(params.tint),
			}),
			water_reflection = get_water_reflection(),
			drawing_box_vertical_extension = 3,
			nominal_width = 2,
			nominal_height = 2,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-base__/graphics/icons" })

local icon_builder = icons:tinted("electric-pole-big")

---Gets the icon for the vanilla big electric pole, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the icon for the vanilla big electric pole as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
