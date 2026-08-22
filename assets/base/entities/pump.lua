---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")

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

---The sprite data a `pump_sprite_set`-tagged `SpriteSetDefinition` carries.
---
---Provisional: no applicator consumes this shape yet. When one is written, this
---declaration moves to it, the way `BoilerSpriteSet` lives in `api/applicators/boiler.lua`.
---@class (exact) PumpSpriteSet : EntityWithHealthSpriteSet
---The prototype's `animations`.
---@field animations Animation4Way

---@class PumpSpriteSetParams
---@field tint Color?

---Produces the sprite set for the vanilla pump.
---@param params PumpSpriteSetParams
---@return SpriteSetDefinition<PumpSpriteSet>
---@nodiscard
function M.get(params)
	---@type SpriteSetDefinition<PumpSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.pump_sprite_set,
		set = {
			animations = get_animations(params.tint),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = get_corpse_animation(params.tint),
			water_reflection = nil,
			nominal_width = 1,
			nominal_height = 2,
		},
	}

	return definition
end

return M
