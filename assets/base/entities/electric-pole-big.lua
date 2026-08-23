---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")

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
---@field tint Color?

---Produces the sprite set for the vanilla big electric pole.
---@param params ElectricPoleBigSpriteSetParams
---@return SpriteSetDefinition<ElectricPoleSpriteSet>
---@nodiscard
function M.get(params)
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

return M
