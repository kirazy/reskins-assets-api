local TurretGraphicsPack = require("turret-graphics-pack")

---@class TurretGunGraphicsPack:Reskins.Abstractions.TurretGraphicsPack
local TurretGunGraphicsPack = {}
TurretGunGraphicsPack.__index = TurretGunGraphicsPack

-- Set up inheritance.
setmetatable(TurretGunGraphicsPack, {
	__index = TurretGraphicsPack,
})

---@class TurretGunGraphicsParams:Reskins.Abstractions.BaseGraphicsParams

---@param params TurretGunGraphicsParams
---@return TurretGunGraphicsPack
---@nodiscard
function TurretGunGraphicsPack:configure(params)
	local instance = TurretGraphicsPack.configure(self, {
		tint = params.tint,
		scale = params.scale,
		scale_factor = params.scale_factor,
		remnants = nil,
		required_assets = {},
		nominal_width = 2,
		nominal_height = 2,
	}) --[[@as TurretGunGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, TurretGunGraphicsPack)
	return instance
end

---@param prototype data.AmmoTurretPrototype
function TurretGunGraphicsPack:apply_to_entity(prototype)
	if not reskins_suppress_errors then
		error("apply_to_entity must be implemented by subclass")
	end
end

return TurretGunGraphicsPack
