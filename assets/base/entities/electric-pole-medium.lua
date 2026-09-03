---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")

local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")

local M = {}

---@param tint Color?
---@return RotatedSprite
local function get_pictures(tint)
	local assets_path = _defines.assets_source.base_assets .. "/graphics/entity/electric-pole-medium/"
	local base_path = _defines.assets_source.base .. "/graphics/entity/medium-electric-pole/"

	---@type RotatedSprite
	local pictures = {
		layers = {
			{
				filename = base_path .. "medium-electric-pole.png",
				priority = "extra-high",
				width = 84,
				height = 252,
				direction_count = 4,
				shift = util.by_pixel(3.5, -44),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(pictures.layers--[[@cast -?]], {
			filename = assets_path .. "electric-pole-medium-mask.png",
			priority = "extra-high",
			width = 84,
			height = 252,
			direction_count = 4,
			shift = util.by_pixel(3.5, -44),
			tint = tint,
			scale = 0.5,
		})
		table.insert(pictures.layers--[[@cast -?]], {
			filename = assets_path .. "electric-pole-medium-highlights.png",
			priority = "extra-high",
			width = 84,
			height = 252,
			direction_count = 4,
			shift = util.by_pixel(3.5, -44),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	table.insert(pictures.layers--[[@cast -?]], {
		filename = base_path .. "medium-electric-pole-shadow.png",
		priority = "extra-high",
		width = 280,
		height = 64,
		direction_count = 4,
		shift = util.by_pixel(56.5, -1),
		draw_as_shadow = true,
		scale = 0.5,
	})

	return pictures
end

---@param tint Color?
---@return RotatedAnimationVariations
local function get_corpse_animation(tint)
	local assets_path = _defines.assets_source.base_assets .. "/graphics/entity/electric-pole-medium/remnants/"
	local base_path = _defines.assets_source.base .. "/graphics/entity/medium-electric-pole/remnants/"

	---@type RotatedAnimation
	local animation = {
		layers = {
			{
				filename = base_path .. "medium-electric-pole-base-remnants.png",
				width = 284,
				height = 140,
				direction_count = 1,
				shift = util.by_pixel(35, -5),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "electric-pole-medium-base-remnants-mask.png",
			width = 284,
			height = 140,
			direction_count = 1,
			shift = util.by_pixel(35, -5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "electric-pole-medium-base-remnants-highlights.png",
			width = 284,
			height = 140,
			direction_count = 1,
			shift = util.by_pixel(35, -5),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return { animation, util.copy(animation), util.copy(animation) }
end

---@param tint Color?
---@return RotatedAnimationVariations
local function get_corpse_animation_overlay(tint)
	local assets_path = _defines.assets_source.base_assets .. "/graphics/entity/electric-pole-medium/remnants/"
	local base_path = _defines.assets_source.base .. "/graphics/entity/medium-electric-pole/remnants/"

	---@type RotatedAnimation
	local animation = {
		layers = {
			{
				filename = base_path .. "medium-electric-pole-top-remnants.png",
				width = 100,
				height = 184,
				direction_count = 1,
				shift = util.by_pixel(0, -38.5),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "electric-pole-medium-top-remnants-mask.png",
			width = 100,
			height = 184,
			direction_count = 1,
			shift = util.by_pixel(0, -38.5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "electric-pole-medium-top-remnants-highlights.png",
			width = 100,
			height = 184,
			direction_count = 1,
			shift = util.by_pixel(0, -38.5),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return { animation, util.copy(animation), util.copy(animation) }
end

---@class ElectricPoleMediumSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?

---Gets the sprite set for the vanilla medium electric pole.
---@param params ElectricPoleMediumSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<ElectricPoleSpriteSet>
---
---#### Examples
---```lua
---local electric_pole_medium = require("__reskins-assets-api__.assets.base.entities.electric-pole-medium")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = electric_pole_medium.get_sprite_set({ tint = tint })
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
			dying_explosion = nil,
			corpse = {
				animation = get_corpse_animation(params.tint),
				animation_overlay = get_corpse_animation_overlay(params.tint),
			},
			water_reflection = nil,
			nominal_width = 1,
			nominal_height = 1,
		},
	}

	return definition
end

local check_get_icon = V.signature("get_icon", {
	{ "tint", Common.color:optional() },
})

---Gets the icon for the vanilla medium electric pole, in the given `tint`.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(tint)
	check_get_icon(tint)

	local folder = "__reskins-assets-base__/graphics/icons/electric-pole-medium/electric-pole-medium-"

	---@type SafeIconData[]
	local icon = { { icon = folder .. "base.png", icon_size = 64, scale = 0.5 } }

	if tint then
		table.insert(icon, { icon = folder .. "mask.png", icon_size = 64, scale = 0.5, tint = tint })
		table.insert(icon, { icon = folder .. "highlights.png", icon_size = 64, scale = 0.5, tint = { 1, 1, 1, 0 } })
	end

	return icon
end

return M
