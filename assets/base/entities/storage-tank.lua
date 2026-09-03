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
---@return StorageTankPictures
local function get_pictures(tint)
	local base_path = _defines.assets_source.base .. "/graphics/entity/storage-tank/"
	local pipe_path = _defines.assets_source.base .. "/graphics/entity/pipe/"
	local assets_path = _defines.assets_source.base_assets .. "/graphics/entity/storage-tank/base/"

	local sheets = {
		{
			filename = base_path .. "storage-tank.png",
			priority = "extra-high",
			frames = 2,
			width = 219,
			height = 235,
			shift = util.by_pixel(-0.25, -1.25),
			scale = 0.5,
		},
	}

	if tint then
		table.insert(sheets, {
			filename = assets_path .. "storage-tank-mask.png",
			priority = "extra-high",
			frames = 2,
			width = 219,
			height = 215,
			shift = util.by_pixel(-0.25, 3.75),
			tint = tint,
			scale = 0.5,
		})
		table.insert(sheets, {
			filename = assets_path .. "storage-tank-highlights.png",
			priority = "extra-high",
			frames = 2,
			width = 219,
			height = 215,
			shift = util.by_pixel(-0.25, 3.75),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	table.insert(sheets, {
		filename = base_path .. "storage-tank-shadow.png",
		priority = "extra-high",
		frames = 2,
		width = 291,
		height = 153,
		shift = util.by_pixel(29.75, 22.25),
		scale = 0.5,
		draw_as_shadow = true,
	})

	---@type StorageTankPictures
	return {
		picture = { sheets = sheets },
		fluid_background = {
			filename = base_path .. "fluid-background.png",
			priority = "extra-high",
			width = 32,
			height = 15,
		},
		window_background = {
			filename = base_path .. "window-background.png",
			priority = "extra-high",
			width = 34,
			height = 48,
			scale = 0.5,
		},
		flow_sprite = {
			filename = pipe_path .. "fluid-flow-low-temperature.png",
			priority = "extra-high",
			width = 160,
			height = 20,
		},
		gas_flow = {
			filename = pipe_path .. "steam.png",
			priority = "extra-high",
			line_length = 10,
			width = 48,
			height = 30,
			frame_count = 60,
			animation_speed = 0.25,
			scale = 0.5,
		},
	}
end

---@param tint Color?
---@return RotatedAnimation
local function get_corpse_animation(tint)
	local base_path = _defines.assets_source.base .. "/graphics/entity/storage-tank/remnants/"
	local assets_path = _defines.assets_source.base_assets .. "/graphics/entity/storage-tank/remnants/"

	---@type RotatedAnimation
	local animation = {
		layers = {
			{
				filename = base_path .. "storage-tank-remnants.png",
				width = 426,
				height = 282,
				shift = util.by_pixel(27, 21),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "storage-tank-remnants-mask.png",
			width = 426,
			height = 282,
			shift = util.by_pixel(27, 21),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "storage-tank-remnants-highlights.png",
			width = 426,
			height = 282,
			shift = util.by_pixel(27, 21),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return animation
end

---@class StorageTankSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?

---Gets the sprite set for the vanilla storage tank.
---@param params StorageTankSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<StorageTankSpriteSet>
---
---#### Examples
---```lua
---local storage_tank = require("__reskins-assets-api__.assets.base.entities.storage-tank")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = storage_tank.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set(params)
	---@type SpriteSetDefinition<StorageTankSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.storage_tank_sprite_set,
		set = {
			pictures = get_pictures(params.tint),
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

---Builds the base, mask, and highlights layers filed under `prefix`.
---@param prefix string # The path the layers are filed under, up to the `-base`/`-mask`/`-highlights` suffix.
---@param tint Color? # The color to tint the mask.
---@return SafeIconData[]
---@nodiscard
local function get_tinted_layers(prefix, tint)
	local layers = { { icon = prefix .. "base.png", icon_size = 64, scale = 0.5 } }

	if tint then
		table.insert(layers, { icon = prefix .. "mask.png", icon_size = 64, scale = 0.5, tint = tint })
		table.insert(layers, { icon = prefix .. "highlights.png", icon_size = 64, scale = 0.5, tint = { 1, 1, 1, 0 } })
	end

	return layers
end

local check_get_icon = V.signature("get_icon", {
	{ "tint", Common.color:optional() },
})

---Gets the icon for the vanilla storage tank, in the given `tint`.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(tint)
	check_get_icon(tint)

	return get_tinted_layers("__reskins-assets-base__/graphics/icons/storage-tank/storage-tank-", tint)
end

local check_get_all_corners_icon = V.signature("get_all_corners_icon", {
	{ "tint", Common.color:optional() },
})

---Gets the icon for a storage tank with a connection on every corner, in the given `tint`.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_all_corners_icon(tint)
	check_get_all_corners_icon(tint)

	return get_tinted_layers(
		"__reskins-assets-bobs__/graphics/icons/storage-tank-all-corners/storage-tank-all-corners-",
		tint
	)
end

return M
