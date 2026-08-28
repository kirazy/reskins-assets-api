---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")

local _defines = require("api.defines")

local M = {}

local assets_path = _defines.assets_source.bobs_assets .. "/graphics/entity/solar-panel-large/"

---@param tint Color?
---@return SpriteVariations
local function get_picture(tint)
	---@type SpriteVariations
	local picture = {
		layers = {
			{
				filename = assets_path .. "solar-panel-large-base.png",
				priority = "high",
				width = 308,
				height = 274,
				shift = util.by_pixel(5, 3.5),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(picture.layers--[[@cast -?]], {
			filename = assets_path .. "solar-panel-large-mask.png",
			priority = "high",
			width = 308,
			height = 274,
			shift = util.by_pixel(5, 3.5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(picture.layers--[[@cast -?]], {
			filename = assets_path .. "solar-panel-large-highlights.png",
			priority = "high",
			width = 308,
			height = 274,
			shift = util.by_pixel(5, 3.5),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	-- Shadows are always appended last.
	table.insert(picture.layers--[[@cast -?]], {
		filename = assets_path .. "solar-panel-large-shadow.png",
		priority = "high",
		width = 308,
		height = 274,
		shift = util.by_pixel(5, 3.5),
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
				filename = assets_path .. "solar-panel-large-shadow-overlay.png",
				priority = "high",
				width = 308,
				height = 274,
				shift = util.by_pixel(5, 3.5),
				scale = 0.5,
			},
		},
	}

	return overlay
end

---@class SolarPanelLargeSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set rather than drawn
---untinted.
---@field tint Color?

local check_params = V.signature("get_sprite_set", {
	{ "params", V.shape({ tint = Common.color:optional() }) },
})

---Gets the sprite set for Bob's large solar panel.
---@param params SolarPanelLargeSpriteSetParams # The options the sprite set is drawn with.
---@return SpriteSetDefinition<SolarPanelSpriteSet>
---
---### Examples
---```lua
---local solar_panel_large = require("__reskins-assets-api__.assets.base.entities.solar-panel-large")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = solar_panel_large.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---
---### Exceptions
---*@throws* `string` — Thrown when `params.tint` is not a `Color`.
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
			-- Bob's large solar panel ships no remnant art.
			corpse = nil,
			water_reflection = nil,
			nominal_width = 4,
			nominal_height = 4,
		},
	}

	return definition
end

local check_get_icon = V.signature("get_icon", {
	{ "tint", Common.color:optional() },
})

---Gets the icon for Bob's large solar panel, in the given `tint`.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(tint)
	check_get_icon(tint)

	local folder = "__reskins-assets-bobs__/graphics/icons/solar-panel-large/solar-panel-large-icon-"

	---@type SafeIconData[]
	local icon = { { icon = folder .. "base.png", icon_size = 64, scale = 0.5 } }

	if tint then
		table.insert(icon, { icon = folder .. "mask.png", icon_size = 64, scale = 0.5, tint = tint })
		table.insert(icon, { icon = folder .. "highlights.png", icon_size = 64, scale = 0.5, tint = { 1, 1, 1, 0 } })
	end

	return icon
end

return M
