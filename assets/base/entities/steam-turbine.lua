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
	local base_path = "__base__/graphics/entity/steam-turbine/"
	local assets_path = "__reskins-assets-base__/graphics/entity/steam-turbine/"

	---@type Animation
	local animation = {
		layers = {
			{
				filename = base_path .. "steam-turbine-H.png",
				width = 320,
				height = 245,
				frame_count = 8,
				line_length = 4,
				shift = util.by_pixel(0, -2.75),
				run_mode = "backward",
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "steam-turbine-horizontal-mask.png",
			width = 320,
			height = 245,
			repeat_count = 8,
			shift = util.by_pixel(0, -2.75),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "steam-turbine-horizontal-highlights.png",
			width = 320,
			height = 245,
			repeat_count = 8,
			shift = util.by_pixel(0, -2.75),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	table.insert(animation.layers--[[@cast -?]], {
		filename = base_path .. "steam-turbine-H-shadow.png",
		width = 435,
		height = 150,
		repeat_count = 8,
		shift = util.by_pixel(28.5, 18),
		run_mode = "backward",
		draw_as_shadow = true,
		scale = 0.5,
	})

	return animation
end

---@param tint Color?
---@return Animation
local function get_vertical_animation(tint)
	local base_path = "__base__/graphics/entity/steam-turbine/"
	local assets_path = "__reskins-assets-base__/graphics/entity/steam-turbine/"

	---@type Animation
	local animation = {
		layers = {
			{
				filename = base_path .. "steam-turbine-V.png",
				width = 217,
				height = 374,
				frame_count = 8,
				line_length = 4,
				shift = util.by_pixel(4.75, 0),
				run_mode = "backward",
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "steam-turbine-vertical-mask.png",
			width = 217,
			height = 347,
			repeat_count = 8,
			shift = util.by_pixel(4.75, 6.75),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "steam-turbine-vertical-highlights.png",
			width = 217,
			height = 347,
			repeat_count = 8,
			shift = util.by_pixel(4.75, 6.75),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	table.insert(animation.layers--[[@cast -?]], {
		filename = base_path .. "steam-turbine-V-shadow.png",
		width = 302,
		height = 260,
		repeat_count = 8,
		shift = util.by_pixel(39.5, 24.5),
		run_mode = "backward",
		draw_as_shadow = true,
		scale = 0.5,
	})

	return animation
end

---@param tint Color?
---@return RotatedAnimation
local function get_corpse_animation(tint)
	local assets_path = "__reskins-assets-base__/graphics/entity/steam-turbine/remnants/"

	---@type RotatedAnimation
	local animation = {
		layers = {
			{
				filename = "__base__/graphics/entity/steam-turbine/remnants/steam-turbine-remnants.png",
				width = 460,
				height = 408,
				direction_count = 4,
				shift = util.by_pixel(6, 0),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "steam-turbine-remnants-mask.png",
			width = 460,
			height = 408,
			direction_count = 4,
			shift = util.by_pixel(6, 0),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "steam-turbine-remnants-highlights.png",
			width = 460,
			height = 408,
			direction_count = 4,
			shift = util.by_pixel(6, 0),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return animation
end

---@class SteamTurbineSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?

---Gets the sprite set for the vanilla steam turbine.
---@param params SteamTurbineSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<GeneratorSpriteSet>
---
---#### Examples
---```lua
---local steam_turbine = require("__reskins-assets-api__.assets.base.entities.steam-turbine")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = steam_turbine.get_sprite_set({ tint = tint })
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

---Gets the icon for the vanilla steam turbine, in the given `tint`.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(tint)
	check_get_icon(tint)

	local folder = "__reskins-assets-base__/graphics/icons/steam-turbine/steam-turbine-"

	---@type SafeIconData[]
	local icon = { { icon = folder .. "base.png", icon_size = 64, scale = 0.5 } }

	if tint then
		table.insert(icon, { icon = folder .. "mask.png", icon_size = 64, scale = 0.5, tint = tint })
		table.insert(icon, { icon = folder .. "highlights.png", icon_size = 64, scale = 0.5, tint = { 1, 1, 1, 0 } })
	end

	return icon
end

return M
