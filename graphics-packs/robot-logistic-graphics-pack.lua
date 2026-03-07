local _defines = require("api.defines")
local RobotGraphicsPack = require("robot-graphics-pack")

---@class RobotLogisticGraphicsPack:RobotGraphicsPack
---@field idle data.RotatedAnimation
---@field idle_with_cargo data.RotatedAnimation
---@field in_motion data.RotatedAnimation
---@field in_motion_with_cargo data.RotatedAnimation
---@field shadow_idle data.RotatedAnimation
---@field shadow_idle_with_cargo data.RotatedAnimation
---@field shadow_in_motion data.RotatedAnimation
---@field shadow_in_motion_with_cargo data.RotatedAnimation
local RobotLogisticGraphicsPack = {}
RobotLogisticGraphicsPack.__index = RobotLogisticGraphicsPack

-- Set up inheritance.
setmetatable(RobotLogisticGraphicsPack, {
	__index = RobotGraphicsPack,
})

---@class RobotLogisticGraphicsParams
---@field tint data.Color?

---@param params RobotLogisticGraphicsParams
---@return RobotLogisticGraphicsPack
---@nodiscard
function RobotLogisticGraphicsPack:configure(params)
	local animations = self.get_animations(params.tint)

	local instance = RobotGraphicsPack.configure(self, {
		tint = params.tint,
		remnants = self.get_corpse_animation(params.tint),
		required_assets = { [_defines.assets.base_assets] = true },
	}) --[[@as RobotLogisticGraphicsPack]]

	instance.idle = animations.idle
	instance.idle_with_cargo = animations.idle_with_cargo
	instance.in_motion = animations.in_motion
	instance.in_motion_with_cargo = animations.in_motion_with_cargo
	instance.shadow_idle = animations.shadow_idle
	instance.shadow_idle_with_cargo = animations.shadow_idle_with_cargo
	instance.shadow_in_motion = animations.shadow_in_motion
	instance.shadow_in_motion_with_cargo = animations.shadow_in_motion_with_cargo

	-- Set the correct metatable for this class.
	setmetatable(instance, RobotLogisticGraphicsPack)
	return instance
end

---@param prototype data.LogisticRobotPrototype
function RobotLogisticGraphicsPack:apply_to_entity(prototype)
	prototype.idle = util.copy(self.idle)
	prototype.idle_with_cargo = util.copy(self.idle_with_cargo)
	prototype.in_motion = util.copy(self.in_motion)
	prototype.in_motion_with_cargo = util.copy(self.in_motion_with_cargo)
	prototype.shadow_idle = util.copy(self.shadow_idle)
	prototype.shadow_idle_with_cargo = util.copy(self.shadow_idle_with_cargo)
	prototype.shadow_in_motion = util.copy(self.shadow_in_motion)
	prototype.shadow_in_motion_with_cargo = util.copy(self.shadow_in_motion_with_cargo)
	prototype.corpse = nil
	self:try_apply_to_named_corpse(prototype.name .. "-remnants")
end

---@param tint data.Color?
---@return { idle: data.RotatedAnimation, idle_with_cargo: data.RotatedAnimation, in_motion: data.RotatedAnimation, in_motion_with_cargo: data.RotatedAnimation, shadow_idle: data.RotatedAnimation, shadow_idle_with_cargo: data.RotatedAnimation, shadow_in_motion: data.RotatedAnimation, shadow_in_motion_with_cargo: data.RotatedAnimation }
---@nodiscard
function RobotLogisticGraphicsPack.get_animations(tint)
	local base_path = _defines.assets.base .. "/graphics/entity/logistic-robot/"
	local assets_path = _defines.assets.base_assets .. "/graphics/entity/robot-logistic/"

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

---@param tint data.Color?
---@return data.RotatedAnimationVariations
---@nodiscard
function RobotLogisticGraphicsPack.get_corpse_animation(tint)
	local base_path = _defines.assets.base .. "/graphics/entity/logistic-robot/remnants/"
	local assets_path = _defines.assets.base_assets .. "/graphics/entity/robot-logistic/remnants/"

	---@type data.RotatedAnimation
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
		table.insert(animation.layers, {
			filename = assets_path .. "robot-logistic-remnants-mask.png",
			width = 116,
			height = 114,
			direction_count = 1,
			shift = util.by_pixel(1, 1),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers, {
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

return RobotLogisticGraphicsPack
