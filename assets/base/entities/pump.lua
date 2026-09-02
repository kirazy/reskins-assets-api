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
---@return Animation4Way
local function get_animations(tint)
	local base_path = _defines.assets_source.base .. "/graphics/entity/pump/"
	local assets_path = _defines.assets_source.base_assets .. "/graphics/entity/pump/"

	---@type Animation4Way
	local animations = {
		north = {
			layers = {
				{
					filename = base_path .. "pump-north.png",
					width = 103,
					height = 164,
					scale = 0.5,
					line_length = 8,
					frame_count = 32,
					animation_speed = 0.5,
					shift = util.by_pixel(8.25, -1),
				},
			},
		},
		east = {
			layers = {
				{
					filename = base_path .. "pump-east.png",
					width = 130,
					height = 109,
					scale = 0.5,
					line_length = 8,
					frame_count = 32,
					animation_speed = 0.5,
					shift = util.by_pixel(-0.5, 1.75),
				},
			},
		},
		south = {
			layers = {
				{
					filename = base_path .. "pump-south.png",
					width = 114,
					height = 160,
					scale = 0.5,
					line_length = 8,
					frame_count = 32,
					animation_speed = 0.5,
					shift = util.by_pixel(12.5, -8),
				},
			},
		},
		west = {
			layers = {
				{
					filename = base_path .. "pump-west.png",
					width = 131,
					height = 111,
					scale = 0.5,
					line_length = 8,
					frame_count = 32,
					animation_speed = 0.5,
					shift = util.by_pixel(-0.25, 1.25),
				},
			},
		},
	}

	---@cast animations.north -?
	---@cast animations.east -?
	---@cast animations.south -?
	---@cast animations.west -?

	if tint then
		-- North mask/highlights have a different shift from the north base layer.
		table.insert(animations.north.layers--[[@cast -?]], {
			filename = assets_path .. "pump-north-mask.png",
			width = 103,
			height = 164,
			scale = 0.5,
			line_length = 8,
			frame_count = 32,
			animation_speed = 0.5,
			shift = util.by_pixel(8, 3.5),
			tint = tint,
		})
		table.insert(animations.north.layers--[[@cast -?]], {
			filename = assets_path .. "pump-north-highlights.png",
			width = 103,
			height = 164,
			scale = 0.5,
			line_length = 8,
			frame_count = 32,
			animation_speed = 0.5,
			shift = util.by_pixel(8, 3.5),
			blend_mode = "additive-soft",
		})

		table.insert(animations.east.layers--[[@cast -?]], {
			filename = assets_path .. "pump-east-mask.png",
			width = 130,
			height = 109,
			scale = 0.5,
			line_length = 8,
			frame_count = 32,
			animation_speed = 0.5,
			shift = util.by_pixel(-0.5, 1.75),
			tint = tint,
		})
		table.insert(animations.east.layers--[[@cast -?]], {
			filename = assets_path .. "pump-east-highlights.png",
			width = 130,
			height = 109,
			scale = 0.5,
			line_length = 8,
			frame_count = 32,
			animation_speed = 0.5,
			shift = util.by_pixel(-0.5, 1.75),
			blend_mode = "additive-soft",
		})

		table.insert(animations.south.layers--[[@cast -?]], {
			filename = assets_path .. "pump-south-mask.png",
			width = 114,
			height = 160,
			scale = 0.5,
			line_length = 8,
			frame_count = 32,
			animation_speed = 0.5,
			shift = util.by_pixel(12.5, -8),
			tint = tint,
		})
		table.insert(animations.south.layers--[[@cast -?]], {
			filename = assets_path .. "pump-south-highlights.png",
			width = 114,
			height = 160,
			scale = 0.5,
			line_length = 8,
			frame_count = 32,
			animation_speed = 0.5,
			shift = util.by_pixel(12.5, -8),
			blend_mode = "additive-soft",
		})

		table.insert(animations.west.layers--[[@cast -?]], {
			filename = assets_path .. "pump-west-mask.png",
			width = 131,
			height = 111,
			scale = 0.5,
			line_length = 8,
			frame_count = 32,
			animation_speed = 0.5,
			shift = util.by_pixel(-0.25, 1.25),
			tint = tint,
		})
		table.insert(animations.west.layers--[[@cast -?]], {
			filename = assets_path .. "pump-west-highlights.png",
			width = 131,
			height = 111,
			scale = 0.5,
			line_length = 8,
			frame_count = 32,
			animation_speed = 0.5,
			shift = util.by_pixel(-0.25, 1.25),
			blend_mode = "additive-soft",
		})
	end

	return animations
end

---@param tint Color?
---@return RotatedAnimationVariations
local function get_corpse_animation(tint)
	local base_path = _defines.assets_source.base .. "/graphics/entity/pump/remnants/"
	local assets_path = _defines.assets_source.base_assets .. "/graphics/entity/pump/remnants/"

	---@type RotatedAnimation
	local animation = {
		layers = {
			{
				filename = base_path .. "pump-remnants.png",
				width = 188,
				height = 186,
				direction_count = 4,
				shift = util.by_pixel(2, 2),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "pump-remnants-mask.png",
			width = 188,
			height = 186,
			direction_count = 4,
			shift = util.by_pixel(2, 2),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "pump-remnants-highlights.png",
			width = 188,
			height = 186,
			direction_count = 4,
			shift = util.by_pixel(2, 2),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return { animation }
end

---@class PumpSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?

---Gets the sprite set for the vanilla pump.
---@param params PumpSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<PumpSpriteSet>
---
---#### Examples
---```lua
---local pump = require("__reskins-assets-api__.assets.base.entities.pump")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = pump.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set(params)
	---@type SpriteSetDefinition<PumpSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.pump_sprite_set,
		set = {
			animations = get_animations(params.tint),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = { animation = get_corpse_animation(params.tint) },
			water_reflection = nil,
			nominal_width = 1,
			nominal_height = 2,
		},
	}

	return definition
end

local check_get_icon = V.signature("get_icon", {
	{ "tint", Common.color:optional() },
})

---Gets the icon for the vanilla pump, in the given `tint`.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(tint)
	check_get_icon(tint)

	local folder = "__reskins-assets-base__/graphics/icons/pump/pump-icon-"

	---@type SafeIconData[]
	local icon = { { icon = folder .. "base.png", icon_size = 64, scale = 0.5 } }

	if tint then
		table.insert(icon, { icon = folder .. "mask.png", icon_size = 64, scale = 0.5, tint = tint })
		table.insert(icon, { icon = folder .. "highlights.png", icon_size = 64, scale = 0.5, tint = { 1, 1, 1, 0 } })
	end

	return icon
end

return M
