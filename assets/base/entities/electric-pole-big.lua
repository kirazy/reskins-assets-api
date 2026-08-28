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
			blend_mode = "additive-soft",
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

---@param tint Color?
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
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return { animation, util.copy(animation), util.copy(animation), util.copy(animation) }
end

---@param tint Color?
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
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return { animation, util.copy(animation), util.copy(animation), util.copy(animation) }
end

---@class ElectricPoleBigSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set rather than drawn
---untinted.
---@field tint Color?

---Gets the sprite set for the vanilla big electric pole.
---@param params ElectricPoleBigSpriteSetParams # The options the sprite set is drawn with.
---@return SpriteSetDefinition<ElectricPoleSpriteSet>
---
---### Examples
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
			dying_explosion = nil,
			corpse = {
				animation = get_corpse_animation(params.tint),
				animation_overlay = get_corpse_animation_overlay(params.tint),
			},
			water_reflection = nil,
			nominal_width = 2,
			nominal_height = 2,
		},
	}

	return definition
end

local check_get_icon = V.signature("get_icon", {
	{ "tint", Common.color:optional() },
})

---Gets the icon for the vanilla big electric pole, in the given `tint`.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(tint)
	check_get_icon(tint)

	local folder = "__reskins-assets-base__/graphics/icons/electric-pole-big/electric-pole-big-icon-"

	---@type SafeIconData[]
	local icon = { { icon = folder .. "base.png", icon_size = 64, scale = 0.5 } }

	if tint then
		table.insert(icon, { icon = folder .. "mask.png", icon_size = 64, scale = 0.5, tint = tint })
		table.insert(icon, { icon = folder .. "highlights.png", icon_size = 64, scale = 0.5, tint = { 1, 1, 1, 0 } })
	end

	return icon
end

return M
