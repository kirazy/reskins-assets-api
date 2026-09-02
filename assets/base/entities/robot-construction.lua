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
---@return { idle: RotatedAnimation, in_motion: RotatedAnimation, working: RotatedAnimation, shadow_idle: RotatedAnimation, shadow_in_motion: RotatedAnimation, shadow_working: RotatedAnimation }
local function get_animations(tint)
	local base_path = _defines.assets_source.base .. "/graphics/entity/construction-robot/"
	local assets_path = _defines.assets_source.base_assets .. "/graphics/entity/robot-construction/"

	-- Shared dimensions for the main body sprite.
	local body_w, body_h = 66, 76
	local body_shift = util.by_pixel(0, -4.5)

	-- Shared dimensions for the working sprite.
	local work_w, work_h = 57, 74
	local work_shift = util.by_pixel(-0.25, -5)

	-- Shared dimensions for the shadow sprite.
	local shadow_w, shadow_h = 104, 49
	local shadow_shift = util.by_pixel(33.5, 18.75)

	local function body_layer(y)
		local layer = {
			filename = base_path .. "construction-robot.png",
			priority = "high",
			line_length = 16,
			width = body_w,
			height = body_h,
			shift = body_shift,
			direction_count = 16,
			scale = 0.5,
		}
		if y and y ~= 0 then
			layer.y = y
		end
		return layer
	end

	local function mask_layer(y)
		local layer = {
			filename = assets_path .. "robot-construction-mask.png",
			priority = "high",
			line_length = 16,
			width = body_w,
			height = body_h,
			shift = body_shift,
			tint = tint,
			direction_count = 16,
			scale = 0.5,
		}
		if y and y ~= 0 then
			layer.y = y
		end
		return layer
	end

	local function highlights_layer(y)
		local layer = {
			filename = assets_path .. "robot-construction-highlights.png",
			priority = "high",
			line_length = 16,
			width = body_w,
			height = body_h,
			shift = body_shift,
			blend_mode = "additive-soft",
			direction_count = 16,
			scale = 0.5,
		}
		if y and y ~= 0 then
			layer.y = y
		end
		return layer
	end

	local idle_layers = { body_layer(0) }
	local in_motion_layers = { body_layer(body_h) }

	if tint then
		table.insert(idle_layers, mask_layer(0))
		table.insert(idle_layers, highlights_layer(0))
		table.insert(in_motion_layers, mask_layer(body_h))
		table.insert(in_motion_layers, highlights_layer(body_h))
	end

	local working_layers = {
		{
			filename = base_path .. "construction-robot-working.png",
			priority = "high",
			line_length = 2,
			width = work_w,
			height = work_h,
			frame_count = 2,
			shift = work_shift,
			direction_count = 16,
			animation_speed = 0.3,
			scale = 0.5,
		},
	}

	if tint then
		table.insert(working_layers, {
			filename = assets_path .. "robot-construction-working-mask.png",
			priority = "high",
			line_length = 2,
			width = work_w,
			height = work_h,
			frame_count = 2,
			shift = work_shift,
			tint = tint,
			direction_count = 16,
			animation_speed = 0.3,
			scale = 0.5,
		})
		table.insert(working_layers, {
			filename = assets_path .. "robot-construction-working-highlights.png",
			priority = "high",
			line_length = 2,
			width = work_w,
			height = work_h,
			frame_count = 2,
			shift = work_shift,
			blend_mode = "additive-soft",
			direction_count = 16,
			animation_speed = 0.3,
			scale = 0.5,
		})
	end

	return {
		idle = { layers = idle_layers },
		in_motion = { layers = in_motion_layers },
		working = { layers = working_layers },
		shadow_idle = {
			filename = base_path .. "construction-robot-shadow.png",
			priority = "high",
			line_length = 16,
			width = shadow_w,
			height = shadow_h,
			shift = shadow_shift,
			direction_count = 16,
			scale = 0.5,
			draw_as_shadow = true,
		},
		shadow_in_motion = {
			filename = base_path .. "construction-robot-shadow.png",
			priority = "high",
			line_length = 16,
			width = shadow_w,
			height = shadow_h,
			shift = shadow_shift,
			direction_count = 16,
			scale = 0.5,
			draw_as_shadow = true,
		},
		shadow_working = {
			filename = base_path .. "construction-robot-shadow.png",
			priority = "high",
			line_length = 16,
			width = shadow_w,
			height = shadow_h,
			repeat_count = 2,
			shift = shadow_shift,
			direction_count = 16,
			scale = 0.5,
			draw_as_shadow = true,
		},
	}
end

---@param tint Color?
---@return RotatedAnimationVariations
local function get_corpse_animation(tint)
	local base_path = _defines.assets_source.base .. "/graphics/entity/construction-robot/remnants/"
	local assets_path = _defines.assets_source.base_assets .. "/graphics/entity/robot-construction/remnants/"

	---@type RotatedAnimation
	local animation = {
		layers = {
			{
				filename = base_path .. "construction-robot-remnants.png",
				width = 120,
				height = 114,
				direction_count = 1,
				shift = util.by_pixel(2, 1),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "robot-construction-remnants-mask.png",
			width = 120,
			height = 114,
			direction_count = 1,
			shift = util.by_pixel(2, 1),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "robot-construction-remnants-highlights.png",
			width = 120,
			height = 114,
			direction_count = 1,
			shift = util.by_pixel(2, 1),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return { animation, util.copy(animation), util.copy(animation) }
end

---@class RobotConstructionSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?

---Gets the sprite set for the vanilla construction robot.
---@param params RobotConstructionSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<ConstructionRobotSpriteSet>
---
---#### Examples
---```lua
---local robot_construction = require("__reskins-assets-api__.assets.base.entities.robot-construction")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = robot_construction.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set(params)
	local animations = get_animations(params.tint)

	---@type SpriteSetDefinition<ConstructionRobotSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.construction_robot_sprite_set,
		set = {
			working = animations.working,
			shadow_working = animations.shadow_working,

			idle = animations.idle,
			in_motion = animations.in_motion,
			shadow_idle = animations.shadow_idle,
			shadow_in_motion = animations.shadow_in_motion,

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

---Gets the icon for the vanilla construction robot, in the given `tint`.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(tint)
	check_get_icon(tint)

	local folder = "__reskins-assets-base__/graphics/icons/robot-construction/robot-construction-icon-"

	---@type SafeIconData[]
	local icon = { { icon = folder .. "base.png", icon_size = 64, scale = 0.5 } }

	if tint then
		table.insert(icon, { icon = folder .. "mask.png", icon_size = 64, scale = 0.5, tint = tint })
		table.insert(icon, { icon = folder .. "highlights.png", icon_size = 64, scale = 0.5, tint = { 1, 1, 1, 0 } })
	end

	return icon
end

return M
