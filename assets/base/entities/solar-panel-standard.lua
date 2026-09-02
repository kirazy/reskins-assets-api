---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")

local _sprites = require("__reskins-sprite-utils__.sprites")
local _defines = require("api.defines")

local M = {}

local assets_path = _defines.assets_source.base_assets .. "/graphics/entity/solar-panel/"

---@param tint Color?
---@return SpriteVariations
local function get_picture(tint)
	---@type SpriteVariations
	local picture = {
		layers = {
			{
				filename = assets_path .. "solar-panel-base.png",
				priority = "high",
				width = 230,
				height = 224,
				shift = util.by_pixel(-3, 3.5),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(picture.layers--[[@cast -?]], {
			filename = assets_path .. "solar-panel-mask.png",
			priority = "high",
			width = 230,
			height = 224,
			shift = util.by_pixel(-3, 3.5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(picture.layers--[[@cast -?]], {
			filename = assets_path .. "solar-panel-highlights.png",
			priority = "high",
			width = 230,
			height = 224,
			shift = util.by_pixel(-3, 3.5),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	-- Shadows are always appended last.
	table.insert(picture.layers--[[@cast -?]], {
		filename = assets_path .. "solar-panel-shadow.png",
		priority = "high",
		width = 220,
		height = 180,
		shift = util.by_pixel(9.5, 6),
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
				filename = assets_path .. "solar-panel-shadow-overlay.png",
				priority = "high",
				width = 214,
				height = 180,
				shift = util.by_pixel(10.5, 6),
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
				filename = _defines.assets_source.base .. "/graphics/entity/solar-panel/remnants/solar-panel-remnants.png",
				width = 290,
				height = 282,
				direction_count = 1,
				shift = util.by_pixel(3.5, 0),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = remnants_path .. "solar-panel-remnants-mask.png",
			width = 290,
			height = 282,
			direction_count = 1,
			shift = util.by_pixel(3.5, 0),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = remnants_path .. "solar-panel-remnants-highlights.png",
			width = 290,
			height = 282,
			direction_count = 1,
			shift = util.by_pixel(3.5, 0),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return _sprites.make_rotated_animation_variations_from_spritesheet(2, animation)
end

---@class SolarPanelStandardSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?

local check_params = V.signature("get_sprite_set", {
	{ "params", V.shape({ tint = Common.color:optional() }) },
})

---Gets the sprite set for the vanilla solar panel.
---@param params SolarPanelStandardSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<SolarPanelSpriteSet>
---
---#### Examples
---```lua
---local solar_panel_standard = require("__reskins-assets-api__.assets.base.entities.solar-panel-standard")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = solar_panel_standard.get_sprite_set({ tint = tint })
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
			nominal_width = 3,
			nominal_height = 3,
		},
	}

	return definition
end

local check_get_icon = V.signature("get_icon", {
	{ "tint", Common.color:optional() },
})

---Gets the icon for the vanilla solar panel, in the given `tint`.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(tint)
	check_get_icon(tint)

	local folder = "__reskins-assets-base__/graphics/icons/solar-panel/solar-panel-icon-"

	---@type SafeIconData[]
	local icon = { { icon = folder .. "base.png", icon_size = 64, scale = 0.5 } }

	if tint then
		table.insert(icon, { icon = folder .. "mask.png", icon_size = 64, scale = 0.5, tint = tint })
		table.insert(icon, { icon = folder .. "highlights.png", icon_size = 64, scale = 0.5, tint = { 1, 1, 1, 0 } })
	end

	return icon
end

return M
