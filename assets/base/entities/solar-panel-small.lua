---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")

local _sprites = require("__reskins-sprite-utils__.sprites")
local _defines = require("api.defines")
local IconCatalog = require("api.icon-catalog")

local M = {}

local assets_path = _defines.assets_source.bobs_assets .. "/graphics/entity/solar-panel-small/"

---@param tint Color?
---@return SpriteVariations
local function get_picture(tint)
	---@type SpriteVariations
	local picture = {
		layers = {
			{
				filename = assets_path .. "solar-panel-small-base.png",
				priority = "high",
				width = 180,
				height = 150,
				shift = util.by_pixel(5, 0.5),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(picture.layers--[[@cast -?]], {
			filename = assets_path .. "solar-panel-small-mask.png",
			priority = "high",
			width = 180,
			height = 150,
			shift = util.by_pixel(5, 0.5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(picture.layers--[[@cast -?]], {
			filename = assets_path .. "solar-panel-small-highlights.png",
			priority = "high",
			width = 180,
			height = 150,
			shift = util.by_pixel(5, 0.5),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	-- Shadows are always appended last.
	table.insert(picture.layers--[[@cast -?]], {
		filename = assets_path .. "solar-panel-small-shadow.png",
		priority = "high",
		width = 180,
		height = 150,
		shift = util.by_pixel(5, 0.5),
		draw_as_shadow = true,
		scale = 0.5,
	})

	return picture
end

---@return SpriteVariations
local function get_overlay()
	---@type SpriteVariations
	local overlay = {
		layers = {
			{
				filename = assets_path .. "solar-panel-small-shadow-overlay.png",
				priority = "high",
				width = 180,
				height = 150,
				shift = util.by_pixel(5, 0.5),
				scale = 0.5,
			},
		},
	}

	return overlay
end

---@param tint Color?
---@return RotatedAnimationVariations
local function get_corpse_animation(tint)
	local remnants_path = assets_path .. "remnants/"

	---@type RotatedAnimation
	local animation = {
		layers = {
			{
				filename = remnants_path .. "small-solar-panel-remnants-base.png",
				width = 246,
				height = 198,
				direction_count = 1,
				shift = util.by_pixel(-1, -0.5),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = remnants_path .. "small-solar-panel-remnants-mask.png",
			width = 246,
			height = 198,
			direction_count = 1,
			shift = util.by_pixel(-1, -0.5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = remnants_path .. "small-solar-panel-remnants-highlights.png",
			width = 246,
			height = 198,
			direction_count = 1,
			shift = util.by_pixel(-1, -0.5),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return _sprites.make_rotated_animation_variations_from_spritesheet(2, animation)
end

---@class SolarPanelSmallSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?

local check_params = V.signature("get_sprite_set", {
	{ "params", V.shape({ tint = Common.color:optional() }) },
})

---Gets the sprite set for Bob's small solar panel.
---@param params SolarPanelSmallSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<SolarPanelSpriteSet>
---
---#### Examples
---```lua
---local solar_panel_small = require("__reskins-assets-api__.assets.base.entities.solar-panel-small")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = solar_panel_small.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@throws Thrown when `params.tint` is not a `Color`.
---@nodiscard
function M.get_sprite_set(params)
	check_params(params)

	---@type SpriteSetDefinition<SolarPanelSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.solar_panel_sprite_set,
		set = {
			picture = get_picture(params.tint),
			overlay = get_overlay(),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = { animation = get_corpse_animation(params.tint) },
			water_reflection = nil,
			nominal_width = 2,
			nominal_height = 2,
		},
	}

	return definition
end

local icons = IconCatalog:create({ folder = "__reskins-assets-bobs__/graphics/icons" })

---Gets the icon for Bob's small solar panel, in the tints given by `params`.
M.get_icon = icons:tinted("solar-panel-small"):build("get_icon")

return M
