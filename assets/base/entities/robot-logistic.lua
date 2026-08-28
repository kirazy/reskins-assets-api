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
---@return { idle: RotatedAnimation, idle_with_cargo: RotatedAnimation, in_motion: RotatedAnimation, in_motion_with_cargo: RotatedAnimation, shadow_idle: RotatedAnimation, shadow_idle_with_cargo: RotatedAnimation, shadow_in_motion: RotatedAnimation, shadow_in_motion_with_cargo: RotatedAnimation }
local function get_animations(tint)
	local base_path = _defines.assets_source.base .. "/graphics/entity/logistic-robot/"
	local assets_path = _defines.assets_source.base_assets .. "/graphics/entity/robot-logistic/"

	-- Shared body sprite dimensions.
	local body_w, body_h = 80, 84
	local body_shift = util.by_pixel(0, -3)

	-- Shared shadow sprite dimensions.
	local shadow_w, shadow_h = 115, 57
	local shadow_shift = util.by_pixel(31.75, 19.75)

	local function body_layer(y)
		local layer = {
			filename = base_path .. "logistic-robot.png",
			priority = "high",
			line_length = 16,
			width = body_w,
			height = body_h,
			shift = body_shift,
			direction_count = 16,
			scale = 0.5,
		}
		if y ~= 0 then
			layer.y = y
		end
		return layer
	end

	local function mask_layer(y)
		local layer = {
			filename = assets_path .. "robot-logistic-mask.png",
			priority = "high",
			line_length = 16,
			width = body_w,
			height = body_h,
			shift = body_shift,
			tint = tint,
			direction_count = 16,
			scale = 0.5,
		}
		if y ~= 0 then
			layer.y = y
		end
		return layer
	end

	local function highlights_layer(y)
		local layer = {
			filename = assets_path .. "robot-logistic-highlights.png",
			priority = "high",
			line_length = 16,
			width = body_w,
			height = body_h,
			shift = body_shift,
			blend_mode = "additive-soft",
			direction_count = 16,
			scale = 0.5,
		}
		if y ~= 0 then
			layer.y = y
		end
		return layer
	end

	local function shadow_layer(y)
		local layer = {
			filename = base_path .. "logistic-robot-shadow.png",
			priority = "high",
			line_length = 16,
			width = shadow_w,
			height = shadow_h,
			shift = shadow_shift,
			direction_count = 16,
			scale = 0.5,
			draw_as_shadow = true,
		}
		if y ~= 0 then
			layer.y = y
		end
		return layer
	end

	local function make_body_animation(y)
		local layers = { body_layer(y) }
		if tint then
			table.insert(layers, mask_layer(y))
			table.insert(layers, highlights_layer(y))
		end
		return { layers = layers }
	end

	return {
		-- y=84: with cargo row (no cargo row is y=0, in_motion_with_cargo is y=168, in_motion is y=252)
		idle = make_body_animation(84),
		idle_with_cargo = make_body_animation(0),
		in_motion = make_body_animation(252),
		in_motion_with_cargo = make_body_animation(168),
		-- Shadow y layout: idle_with_cargo=0, idle=57, in_motion_with_cargo=114, in_motion=171
		shadow_idle = shadow_layer(57),
		shadow_idle_with_cargo = shadow_layer(0),
		shadow_in_motion = shadow_layer(171),
		shadow_in_motion_with_cargo = shadow_layer(114),
	}
end

---@param tint Color?
---@return RotatedAnimationVariations
local function get_corpse_animation(tint)
	local base_path = _defines.assets_source.base .. "/graphics/entity/logistic-robot/remnants/"
	local assets_path = _defines.assets_source.base_assets .. "/graphics/entity/robot-logistic/remnants/"

	---@type RotatedAnimation
	local animation = {
		layers = {
			{
				filename = base_path .. "logistic-robot-remnants.png",
				width = 116,
				height = 114,
				direction_count = 1,
				shift = util.by_pixel(1, 1),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "robot-logistic-remnants-mask.png",
			width = 116,
			height = 114,
			direction_count = 1,
			shift = util.by_pixel(1, 1),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "robot-logistic-remnants-highlights.png",
			width = 116,
			height = 114,
			direction_count = 1,
			shift = util.by_pixel(1, 1),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return { animation, util.copy(animation), util.copy(animation) }
end

---@class RobotLogisticSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set rather than drawn
---untinted.
---@field tint Color?

---Gets the sprite set for the vanilla logistic robot.
---@param params RobotLogisticSpriteSetParams # The options the sprite set is drawn with.
---@return SpriteSetDefinition<LogisticRobotSpriteSet>
---
---### Examples
---```lua
---local robot_logistic = require("__reskins-assets-api__.assets.base.entities.robot-logistic")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = robot_logistic.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set(params)
	local animations = get_animations(params.tint)

	---@type SpriteSetDefinition<LogisticRobotSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.logistic_robot_sprite_set,
		set = {
			idle = animations.idle,
			in_motion = animations.in_motion,
			shadow_idle = animations.shadow_idle,
			shadow_in_motion = animations.shadow_in_motion,

			idle_with_cargo = animations.idle_with_cargo,
			shadow_idle_with_cargo = animations.shadow_idle_with_cargo,
			in_motion_with_cargo = animations.in_motion_with_cargo,
			shadow_in_motion_with_cargo = animations.shadow_in_motion_with_cargo,

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

---Gets the icon for the vanilla logistic robot, in the given `tint`.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(tint)
	check_get_icon(tint)

	local folder = "__reskins-assets-base__/graphics/icons/robot-logistic/robot-logistic-icon-"

	---@type SafeIconData[]
	local icon = { { icon = folder .. "base.png", icon_size = 64, scale = 0.5 } }

	if tint then
		table.insert(icon, { icon = folder .. "mask.png", icon_size = 64, scale = 0.5, tint = tint })
		table.insert(icon, { icon = folder .. "highlights.png", icon_size = 64, scale = 0.5, tint = { 1, 1, 1, 0 } })
	end

	return icon
end

return M
