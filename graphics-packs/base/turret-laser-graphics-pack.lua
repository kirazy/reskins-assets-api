local TurretGraphicsPack = require("turret-graphics-pack")

---@class TurretLaserGraphicsPack:Reskins.Abstractions.TurretGraphicsPack
local TurretLaserGraphicsPack = {}
TurretLaserGraphicsPack.__index = TurretLaserGraphicsPack

-- Set up inheritance.
setmetatable(TurretLaserGraphicsPack, {
	__index = TurretGraphicsPack,
})

---@class TurretLaserGraphicsParams:Reskins.Abstractions.BaseGraphicsParams

---@param params TurretLaserGraphicsParams
---@return TurretLaserGraphicsPack
---@nodiscard
function TurretLaserGraphicsPack:configure(params)
	local instance = TurretGraphicsPack.configure(self, {
		tint = params.tint,
		scale = params.scale,
		scale_factor = params.scale_factor,
		remnants = nil,
		required_assets = {},
		nominal_width = 2,
		nominal_height = 2,
	}) --[[@as TurretLaserGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, TurretLaserGraphicsPack)
	return instance
end

---@param prototype data.ElectricTurretPrototype
function TurretLaserGraphicsPack:apply_to_entity(prototype)
	if not reskins_suppress_errors then
		error("apply_to_entity must be implemented by subclass")
	end
end

return TurretLaserGraphicsPack
