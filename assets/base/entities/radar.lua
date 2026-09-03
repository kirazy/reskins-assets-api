---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local IconCatalog = require("api.icon-catalog")

local M = {}

---@param tint Color?
---@return RotatedSprite
local function get_pictures(tint)
	local assets_path = _defines.assets_source.base_assets .. "/graphics/entity/radar/"
	local base_path = _defines.assets_source.base .. "/graphics/entity/radar/"

	---@type RotatedSprite
	local pictures = {
		layers = {
			{
				filename = base_path .. "radar.png",
				priority = "low",
				width = 196,
				height = 254,
				apply_projection = false,
				direction_count = 64,
				line_length = 8,
				shift = util.by_pixel(1, -16),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(pictures.layers--[[@cast -?]], {
			filename = assets_path .. "radar-mask.png",
			priority = "low",
			width = 196,
			height = 254,
			apply_projection = false,
			direction_count = 64,
			line_length = 8,
			shift = util.by_pixel(1, -16),
			tint = tint,
			scale = 0.5,
		})
		table.insert(pictures.layers--[[@cast -?]], {
			filename = assets_path .. "radar-highlights.png",
			priority = "low",
			width = 196,
			height = 254,
			apply_projection = false,
			direction_count = 64,
			line_length = 8,
			shift = util.by_pixel(1, -16),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	table.insert(pictures.layers--[[@cast -?]], {
		filename = base_path .. "radar-shadow.png",
		priority = "low",
		width = 336,
		height = 170,
		apply_projection = false,
		direction_count = 64,
		line_length = 8,
		shift = util.by_pixel(39, 6),
		draw_as_shadow = true,
		scale = 0.5,
	})

	return pictures
end

---@return Sprite
local function get_integration_patch()
	---@type Sprite
	local patch = {
		filename = _defines.assets_source.base .. "/graphics/entity/radar/radar-integration.png",
		priority = "low",
		width = 238,
		height = 216,
		shift = util.by_pixel(1.5, 4),
		scale = 0.5,
	}
	return patch
end

---@param tint Color?
---@return RotatedAnimationVariations
local function get_corpse_animation(tint)
	local assets_path = _defines.assets_source.base_assets .. "/graphics/entity/radar/remnants/"
	local base_path = _defines.assets_source.base .. "/graphics/entity/radar/remnants/"

	---@type RotatedAnimation
	local animation = {
		layers = {
			{
				filename = base_path .. "radar-remnants.png",
				width = 282,
				height = 212,
				direction_count = 1,
				shift = util.by_pixel(12, 4.5),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "radar-remnants-mask.png",
			width = 282,
			height = 212,
			direction_count = 1,
			shift = util.by_pixel(12, 4.5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "radar-remnants-highlights.png",
			width = 282,
			height = 212,
			direction_count = 1,
			shift = util.by_pixel(12, 4.5),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return { animation }
end

---@class RadarSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?

---Gets the sprite set for the vanilla radar.
---@param params RadarSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<RadarSpriteSet>
---
---#### Examples
---```lua
---local radar = require("__reskins-assets-api__.assets.base.entities.radar")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = radar.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set(params)
	---@type SpriteSetDefinition<RadarSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.radar_sprite_set,
		set = {
			pictures = get_pictures(params.tint),
			integration_patch = get_integration_patch(),
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = { animation = get_corpse_animation(params.tint) },
			water_reflection = nil,
			nominal_width = 3,
			nominal_height = 3,
		},
	}

	return definition
end

local icons = IconCatalog:create({ folder = "__reskins-assets-base__/graphics/icons" })

---Gets the icon for the vanilla radar, in the tints given by `params`.
M.get_icon = icons:tinted("radar"):build("get_icon")

return M
