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
---@return Animation
local function get_horizontal_animation(tint)
	local base_path = "__base__/graphics/entity/steam-engine/"
	local assets_path = "__reskins-assets-base__/graphics/entity/steam-engine/"

	---@type Animation
	local animation = {
		layers = {
			{
				filename = base_path .. "steam-engine-H.png",
				width = 352,
				height = 257,
				frame_count = 32,
				line_length = 8,
				shift = util.by_pixel(1, -4.75),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "steam-engine-horizontal-mask.png",
			width = 352,
			height = 257,
			frame_count = 32,
			line_length = 8,
			shift = util.by_pixel(1, -4.75),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "steam-engine-horizontal-highlights.png",
			width = 352,
			height = 257,
			frame_count = 32,
			line_length = 8,
			shift = util.by_pixel(1, -4.75),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	table.insert(animation.layers--[[@cast -?]], {
		filename = base_path .. "steam-engine-H-shadow.png",
		width = 508,
		height = 160,
		frame_count = 32,
		line_length = 8,
		shift = util.by_pixel(48, 24),
		draw_as_shadow = true,
		scale = 0.5,
	})

	return animation
end

---@param tint Color?
---@return Animation
local function get_vertical_animation(tint)
	local base_path = "__base__/graphics/entity/steam-engine/"
	local assets_path = "__reskins-assets-base__/graphics/entity/steam-engine/"

	---@type Animation
	local animation = {
		layers = {
			{
				filename = base_path .. "steam-engine-V.png",
				width = 225,
				height = 391,
				frame_count = 32,
				line_length = 8,
				shift = util.by_pixel(4.75, -6.25),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "steam-engine-vertical-mask.png",
			width = 225,
			height = 391,
			frame_count = 32,
			line_length = 8,
			shift = util.by_pixel(4.75, -6.25),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "steam-engine-vertical-highlights.png",
			width = 225,
			height = 391,
			frame_count = 32,
			line_length = 8,
			shift = util.by_pixel(4.75, -6.25),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	table.insert(animation.layers--[[@cast -?]], {
		filename = base_path .. "steam-engine-V-shadow.png",
		width = 330,
		height = 307,
		frame_count = 32,
		line_length = 8,
		shift = util.by_pixel(40.5, 9.25),
		draw_as_shadow = true,
		scale = 0.5,
	})

	return animation
end

---@param tint Color?
---@return RotatedAnimation
local function get_corpse_animation(tint)
	local assets_path = "__reskins-assets-base__/graphics/entity/steam-engine/remnants/"

	---@type RotatedAnimation
	local animation = {
		layers = {
			{
				filename = "__base__/graphics/entity/steam-engine/remnants/steam-engine-remnants.png",
				width = 462,
				height = 386,
				direction_count = 4,
				shift = util.by_pixel(17, 6.5),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "steam-engine-remnants-mask.png",
			width = 462,
			height = 386,
			direction_count = 4,
			shift = util.by_pixel(17, 6.5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "steam-engine-remnants-highlights.png",
			width = 462,
			height = 386,
			direction_count = 4,
			shift = util.by_pixel(17, 6.5),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return animation
end

---@class SteamEngineSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set rather than drawn
---untinted.
---@field tint Color?

---Gets the sprite set for the vanilla steam engine.
---@param params SteamEngineSpriteSetParams # The options the sprite set is drawn with.
---@return SpriteSetDefinition<GeneratorSpriteSet>
---
---### Examples
---```lua
---local steam_engine = require("__reskins-assets-api__.assets.base.entities.steam-engine")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = steam_engine.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set(params)
	---@type SpriteSetDefinition<GeneratorSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.generator_sprite_set,
		set = {
			horizontal_animation = get_horizontal_animation(params.tint),
			vertical_animation = get_vertical_animation(params.tint),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = { animation = get_corpse_animation(params.tint) },
			water_reflection = nil,
			nominal_width = 3,
			nominal_height = 5,
		},
	}

	return definition
end

local check_get_icon = V.signature("get_icon", {
	{ "tint", Common.color:optional() },
})

---Gets the icon for the vanilla steam engine, in the given `tint`.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(tint)
	check_get_icon(tint)

	local folder = "__reskins-assets-base__/graphics/icons/steam-engine/steam-engine-icon-"

	---@type SafeIconData[]
	local icon = { { icon = folder .. "base.png", icon_size = 64, scale = 0.5 } }

	if tint then
		table.insert(icon, { icon = folder .. "mask.png", icon_size = 64, scale = 0.5, tint = tint })
		table.insert(icon, { icon = folder .. "highlights.png", icon_size = 64, scale = 0.5, tint = { 1, 1, 1, 0 } })
	end

	return icon
end

return M
