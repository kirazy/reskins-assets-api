---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")

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

---The sprite data a `storage_tank_sprite_set`-tagged `SpriteSetDefinition` carries.
---
---Provisional: no applicator consumes this shape yet. When one is written, this
---declaration moves to it, the way `BoilerSpriteSet` lives in `api/applicators/boiler.lua`.
---@class (exact) StorageTankSpriteSet : EntityWithHealthSpriteSet
---The prototype's `pictures`.
---@field pictures StorageTankPictures

---@class StorageTankSpriteSetParams
---@field tint Color?

---Produces the sprite set for the vanilla storage tank.
---@param params StorageTankSpriteSetParams
---@return SpriteSetDefinition<StorageTankSpriteSet>
---@nodiscard
function M.get(params)
	---@type SpriteSetDefinition<StorageTankSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.storage_tank_sprite_set,
		set = {
			pictures = get_pictures(params.tint),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = get_corpse_animation(params.tint),
			water_reflection = nil,
			nominal_width = 3,
			nominal_height = 3,
		},
	}

	return definition
end

return M
