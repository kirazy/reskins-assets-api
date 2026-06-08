local GraphicsPackBase = require("graphics-packs.abstractions.graphics-pack-base")

---The abstract intermediate class for robot graphics packs. Mirrors the Factorio
---`RobotWithLogisticInterfacePrototype` hierarchy.
---
---Covers construction robots and logistic robots, which share `RotatedAnimation` idle/in_motion/shadow states.
---@class Reskins.Abstractions.RobotGraphicsPack:Reskins.Abstractions.GraphicsPackBase
local RobotGraphicsPack = {}
RobotGraphicsPack.__index = RobotGraphicsPack

-- Set up inheritance.
setmetatable(RobotGraphicsPack, {
	__index = GraphicsPackBase,
})

---@class RobotGraphicsParams:Reskins.Abstractions.GraphicsParams

---@param params RobotGraphicsParams
---@return Reskins.Abstractions.RobotGraphicsPack
---@nodiscard
function RobotGraphicsPack:configure(params)
	local instance = GraphicsPackBase.configure(self, {
		tint = params.tint,
		scale = params.scale,
		scale_factor = params.scale_factor,
		remnants = params.remnants,
		required_assets = params.required_assets,
		nominal_width = params.nominal_width,
		nominal_height = params.nominal_height,
	}) --[[@as Reskins.Abstractions.RobotGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, RobotGraphicsPack)
	return instance
end

---@param prototype data.RobotWithLogisticInterfacePrototype
function RobotGraphicsPack:apply_to_entity(prototype)
	if not reskins_suppress_errors then
		error("apply_to_entity must be implemented by subclass")
	end
end

return RobotGraphicsPack
