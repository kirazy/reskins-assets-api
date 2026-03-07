local _defines = require("api.defines")
local RobotGraphicsPack = require("robot-graphics-pack")

---@class RobotConstructionGraphicsPack:RobotGraphicsPack
---@field idle data.RotatedAnimation
---@field in_motion data.RotatedAnimation
---@field working data.RotatedAnimation
---@field shadow_idle data.RotatedAnimation
---@field shadow_in_motion data.RotatedAnimation
---@field shadow_working data.RotatedAnimation
local RobotConstructionGraphicsPack = {}
RobotConstructionGraphicsPack.__index = RobotConstructionGraphicsPack

-- Set up inheritance.
setmetatable(RobotConstructionGraphicsPack, {
	__index = RobotGraphicsPack,
})

---@class RobotConstructionGraphicsParams
---@field tint data.Color?

---@param params RobotConstructionGraphicsParams
---@return RobotConstructionGraphicsPack
---@nodiscard
function RobotConstructionGraphicsPack:configure(params)
	local animations = self.get_animations(params.tint)

	local instance = RobotGraphicsPack.configure(self, {
		tint = params.tint,
		remnants = self.get_corpse_animation(params.tint),
		required_assets = { [_defines.assets.base_assets] = true },
	}) --[[@as RobotConstructionGraphicsPack]]

	instance.idle = animations.idle
	instance.in_motion = animations.in_motion
	instance.working = animations.working
	instance.shadow_idle = animations.shadow_idle
	instance.shadow_in_motion = animations.shadow_in_motion
	instance.shadow_working = animations.shadow_working

	-- Set the correct metatable for this class.
	setmetatable(instance, RobotConstructionGraphicsPack)
	return instance
end

---@param prototype data.ConstructionRobotPrototype
function RobotConstructionGraphicsPack:apply_to_entity(prototype)
	prototype.idle = util.copy(self.idle)
	prototype.in_motion = util.copy(self.in_motion)
	prototype.working = util.copy(self.working)
	prototype.shadow_idle = util.copy(self.shadow_idle)
	prototype.shadow_in_motion = util.copy(self.shadow_in_motion)
	prototype.shadow_working = util.copy(self.shadow_working)
	prototype.corpse = nil
	self:try_apply_to_named_corpse(prototype.name .. "-remnants")
end

---@param tint data.Color?
---@return { idle: data.RotatedAnimation, in_motion: data.RotatedAnimation, working: data.RotatedAnimation, shadow_idle: data.RotatedAnimation, shadow_in_motion: data.RotatedAnimation, shadow_working: data.RotatedAnimation }
---@nodiscard
function RobotConstructionGraphicsPack.get_animations(tint)
	local base_path = _defines.assets.base .. "/graphics/entity/construction-robot/"
	local assets_path = _defines.assets.base_assets .. "/graphics/entity/robot-construction/"

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
		if y and y ~= 0 then layer.y = y end
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
		if y and y ~= 0 then layer.y = y end
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
		if y and y ~= 0 then layer.y = y end
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

---@param tint data.Color?
---@return data.RotatedAnimationVariations
---@nodiscard
function RobotConstructionGraphicsPack.get_corpse_animation(tint)
	local base_path = _defines.assets.base .. "/graphics/entity/construction-robot/remnants/"
	local assets_path = _defines.assets.base_assets .. "/graphics/entity/robot-construction/remnants/"

	---@type data.RotatedAnimation
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
		table.insert(animation.layers, {
			filename = assets_path .. "robot-construction-remnants-mask.png",
			width = 120,
			height = 114,
			direction_count = 1,
			shift = util.by_pixel(2, 1),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers, {
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

return RobotConstructionGraphicsPack
