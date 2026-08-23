---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")

local M = {}

---@param tint Color?
---@param variant "2-slots"|"4-slots"|"6-slots"
---@return AnimationElement[]
local function get_animation_list(tint, variant)
	local assets_path = _defines.assets_source.base_assets .. "/graphics/entity/beacon/" .. variant .. "/"
	local base_path = _defines.assets_source.base .. "/graphics/entity/beacon/"

	-- 1. Bottom (floor-mechanics) animation with base/mask/highlights/shadow.
	local bottom_layers = {
		{
			filename = assets_path .. "beacon-" .. variant .. "-bottom-base.png",
			width = 212,
			height = 192,
			scale = 0.5,
			shift = util.by_pixel(0.5, 1),
		},
	}

	if tint then
		table.insert(bottom_layers, {
			filename = assets_path .. "beacon-" .. variant .. "-bottom-mask.png",
			width = 212,
			height = 192,
			scale = 0.5,
			shift = util.by_pixel(0.5, 1),
			tint = tint,
		})
		table.insert(bottom_layers, {
			filename = assets_path .. "beacon-" .. variant .. "-bottom-highlights.png",
			width = 212,
			height = 192,
			scale = 0.5,
			shift = util.by_pixel(0.5, 1),
			blend_mode = "additive-soft",
		})
	end

	table.insert(bottom_layers, {
		filename = base_path .. "beacon-shadow.png",
		width = 244,
		height = 176,
		scale = 0.5,
		draw_as_shadow = true,
		shift = util.by_pixel(12.5, 0.5),
	})

	---@type AnimationElement[]
	local animation_list = {
		-- 1. Bottom base animation (renders on floor-mechanics layer).
		{
			render_layer = "floor-mechanics",
			animation = { layers = bottom_layers },
		},
		-- 2. Antenna top.
		{
			animation = {
				filename = assets_path .. "beacon-" .. variant .. "-top.png",
				width = 96,
				height = 140,
				scale = 0.5,
				repeat_count = 45,
				animation_speed = 0.5,
				shift = util.by_pixel(3, -19),
			},
		},
		-- 3. Light animation, tinted by active modules.
		{
			apply_tint = true,
			always_draw = false,
			animation = {
				filename = base_path .. "beacon-light.png",
				line_length = 9,
				width = 110,
				height = 186,
				frame_count = 45,
				animation_speed = 0.5,
				scale = 0.5,
				shift = util.by_pixel(0.5, -18),
				blend_mode = "additive",
			},
		},
		-- 4. Light animation, untinted (base game uses two copies).
		{
			apply_tint = false,
			always_draw = false,
			animation = {
				filename = base_path .. "beacon-light.png",
				line_length = 9,
				width = 110,
				height = 186,
				frame_count = 45,
				animation_speed = 0.5,
				scale = 0.5,
				shift = util.by_pixel(0.5, -18),
				blend_mode = "additive",
			},
		},
	}

	-- 5. Module slot overlay (only for "4-slots" and "6-slots").
	if variant == "4-slots" then
		table.insert(animation_list, {
			render_layer = "transport-belt-circuit-connector",
			animation = {
				layers = {
					{
						filename = assets_path .. "beacon-4-slots-bottom-slot-overlay.png",
						width = 212,
						height = 192,
						scale = 0.5,
						shift = util.by_pixel(0.5, 1),
					},
				},
			},
		})
	elseif variant == "6-slots" then
		local overlay_layers = {
			{
				filename = assets_path .. "beacon-6-slots-bottom-slot-overlay-base.png",
				width = 212,
				height = 192,
				scale = 0.5,
				shift = util.by_pixel(0.5, 1),
			},
		}

		if tint then
			table.insert(overlay_layers, {
				filename = assets_path .. "beacon-6-slots-bottom-slot-overlay-mask.png",
				width = 212,
				height = 192,
				scale = 0.5,
				shift = util.by_pixel(0.5, 1),
				tint = tint,
			})
			table.insert(overlay_layers, {
				filename = assets_path .. "beacon-6-slots-bottom-slot-overlay-highlights.png",
				width = 212,
				height = 192,
				scale = 0.5,
				shift = util.by_pixel(0.5, 1),
				blend_mode = "additive-soft",
			})
		end

		table.insert(animation_list, {
			render_layer = "transport-belt-circuit-connector",
			animation = { layers = overlay_layers },
		})
	end

	return animation_list
end

---@param tint Color?
---@return RotatedAnimationVariations
local function get_corpse_animation(tint)
	local base_path = _defines.assets_source.base .. "/graphics/entity/beacon/remnants/"
	local assets_path = _defines.assets_source.base_assets .. "/graphics/entity/beacon/remnants/"

	---@type RotatedAnimation
	local animation = {
		layers = {
			{
				filename = base_path .. "beacon-remnants.png",
				direction_count = 1,
				width = 212,
				height = 206,
				shift = util.by_pixel(1, 5),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "beacon-remnants-mask.png",
			direction_count = 1,
			width = 212,
			height = 206,
			shift = util.by_pixel(1, 5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "beacon-remnants-highlights.png",
			direction_count = 1,
			width = 212,
			height = 206,
			shift = util.by_pixel(1, 5),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return { animation, util.copy(animation) }
end

---@class BeaconSpriteSetParams
---@field tint Color?
---@field variant "2-slots"|"4-slots"|"6-slots"

---Produces the sprite set for the vanilla beacon.
---
---The old pack merged `animation_list` into whatever `graphics_set` the prototype
---already carried rather than replacing it. An applicator for this shape has to do
---the same — the rest of a beacon's `graphics_set` is not produced here.
---@param params BeaconSpriteSetParams
---@return SpriteSetDefinition<BeaconSpriteSet>
---@nodiscard
function M.get(params)
	---@type SpriteSetDefinition<BeaconSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.beacon_sprite_set,
		set = {
			animation_list = get_animation_list(params.tint, params.variant),
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

return M
