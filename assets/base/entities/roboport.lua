---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local NumberValidator = require("prototypes.number-validator")

---@class RoboportGraphicsSet
---@field base Sprite
---@field base_patch Sprite
---@field base_animation Animation
---@field door_animation_up Animation
---@field door_animation_down Animation
---@field recharging_animation Animation

local M = {}

---@param tint Color?
---@param antenna_variant 0|1|2|3|4
---@param door_variant 0|1|2|3|4
---@return RoboportGraphicsSet
local function get_graphics_set(tint, antenna_variant, door_variant)
	NumberValidator.validate(antenna_variant, "antenna_variant"):is_integer():in_range(0, 4)
	NumberValidator.validate(door_variant, "door_variant"):is_integer():in_range(0, 4)

	local base_path = _defines.assets_source.base .. "/graphics/entity/roboport/"
	local base_assets_path = _defines.assets_source.base_assets .. "/graphics/entity/roboport/"
	local bobs_path = _defines.assets_source.bobs_assets .. "/graphics/entity/roboport/"

	local antenna_filename = antenna_variant == 0 and base_path .. "roboport-base-animation.png"
		or bobs_path .. "antennas/roboport-" .. antenna_variant .. "-base-animation.png"

	local door_up_filename = door_variant == 0 and base_path .. "roboport-door-up.png"
		or bobs_path .. "doors/roboport-" .. door_variant .. "-door-up.png"

	local door_down_filename = door_variant == 0 and base_path .. "roboport-door-down.png"
		or bobs_path .. "doors/roboport-" .. door_variant .. "-door-down.png"

	local base_layers = {
		{
			filename = base_assets_path .. "roboport-base.png",
			width = 228,
			height = 277,
			shift = util.by_pixel(2, 7.75),
			scale = 0.5,
		},
	}

	if tint then
		table.insert(base_layers, {
			filename = base_assets_path .. "roboport-base-mask.png",
			width = 228,
			height = 277,
			shift = util.by_pixel(2, 7.75),
			tint = tint,
			scale = 0.5,
		})
		table.insert(base_layers, {
			filename = base_assets_path .. "roboport-base-highlights.png",
			width = 228,
			height = 277,
			shift = util.by_pixel(2, 7.75),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	table.insert(base_layers, {
		filename = base_assets_path .. "roboport-shadow.png",
		width = 294,
		height = 201,
		draw_as_shadow = true,
		shift = util.by_pixel(28.5, 19.25),
		scale = 0.5,
	})

	local base_patch_layers = {
		-- Padding placeholder required by the roboport prototype.
		{
			filename = "__core__/graphics/empty.png",
			priority = "medium",
			width = 1,
			height = 1,
		},
		{
			filename = base_assets_path .. "roboport-base-patch.png",
			priority = "medium",
			width = 138,
			height = 100,
			shift = util.by_pixel(1.5, 5),
			scale = 0.5,
		},
	}

	if tint then
		table.insert(base_patch_layers, {
			filename = base_assets_path .. "roboport-base-patch-mask.png",
			priority = "medium",
			width = 138,
			height = 100,
			shift = util.by_pixel(1.5, 5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(base_patch_layers, {
			filename = base_assets_path .. "roboport-base-patch-highlights.png",
			priority = "medium",
			width = 138,
			height = 100,
			shift = util.by_pixel(1.5, 5),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	---@type RoboportGraphicsSet
	local graphics_set = {
		base = { layers = base_layers },
		base_patch = { layers = base_patch_layers },
		base_animation = {
			filename = antenna_filename,
			priority = "medium",
			width = 83,
			height = 59,
			frame_count = 8,
			animation_speed = 0.5,
			shift = util.by_pixel(-17.75, -61.25),
			scale = 0.5,
		},
		door_animation_up = {
			filename = door_up_filename,
			priority = "medium",
			width = 97,
			height = 38,
			frame_count = 16,
			shift = util.by_pixel(-0.25, -29.5),
			scale = 0.5,
		},
		door_animation_down = {
			filename = door_down_filename,
			priority = "medium",
			width = 97,
			height = 41,
			frame_count = 16,
			shift = util.by_pixel(-0.25, -9.75),
			scale = 0.5,
		},
		recharging_animation = {
			filename = base_assets_path .. "roboport-recharging.png",
			priority = "high",
			width = 37,
			height = 35,
			frame_count = 16,
			scale = 1.5,
			animation_speed = 0.5,
		},
	}

	return graphics_set
end

---@param tint Color?
---@return RotatedAnimationVariations
local function get_corpse_animation(tint)
	local assets_path = _defines.assets_source.base_assets .. "/graphics/entity/roboport/remnants/"

	---@type RotatedAnimation
	local animation = {
		layers = {
			{
				filename = assets_path .. "roboport-remnants.png",
				width = 364,
				height = 358,
				direction_count = 1,
				shift = util.by_pixel(2, 8),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "roboport-remnants-mask.png",
			width = 364,
			height = 358,
			direction_count = 1,
			shift = util.by_pixel(2, 8),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "roboport-remnants-highlights.png",
			width = 364,
			height = 358,
			direction_count = 1,
			shift = util.by_pixel(2, 8),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return { animation, util.copy(animation) }
end

---The sprite data a `roboport_sprite_set`-tagged `SpriteSetDefinition` carries.
---
---Provisional: no applicator consumes this shape yet. When one is written, this
---declaration moves to it, the way `BoilerSpriteSet` lives in `api/applicators/boiler.lua`.
---@class (exact) RoboportSpriteSet : EntityWithHealthSpriteSet
---The sprites making up the roboport, spread across the prototype's own fields.
---@field graphics_set RoboportGraphicsSet

---@class RoboportSpriteSetParams
---@field tint Color?
---@field antenna_variant 0|1|2|3|4 # 0 = base game, 1-4 = Bob's variants
---@field door_variant 0|1|2|3|4 # 0 = base game, 1-4 = Bob's variants

---Produces the sprite set for the vanilla roboport.
---
---FIXME: the old pack's `apply_to_entity` also set `spawn_and_station_height = -0.1`
---to match these sprites. That's a prototype field rather than sprite data, so it has
---no home on this shape and is not carried here.
---@param params RoboportSpriteSetParams
---@return SpriteSetDefinition<RoboportSpriteSet>
---@nodiscard
function M.get(params)
	---@type SpriteSetDefinition<RoboportSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.roboport_sprite_set,
		set = {
			graphics_set = get_graphics_set(params.tint, params.antenna_variant, params.door_variant),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = get_corpse_animation(params.tint),
			water_reflection = nil,
			nominal_width = 4,
			nominal_height = 4,
		},
	}

	return definition
end

return M
