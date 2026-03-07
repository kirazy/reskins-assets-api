local TurretGraphicsPack = require("turret-graphics-pack")

---@class TurretPlasmaGraphicsPack:TurretGraphicsPack
local TurretPlasmaGraphicsPack = {}
TurretPlasmaGraphicsPack.__index = TurretPlasmaGraphicsPack

-- Set up inheritance.
setmetatable(TurretPlasmaGraphicsPack, {
	__index = TurretGraphicsPack,
})

---@class TurretPlasmaGraphicsParams
---@field tint data.Color?

---@param params TurretPlasmaGraphicsParams
---@return TurretPlasmaGraphicsPack
---@nodiscard
function TurretPlasmaGraphicsPack:configure(params)
	local instance = TurretGraphicsPack.configure(self, {
		tint = params.tint,
		remnants = nil,
		required_assets = {},
	}) --[[@as TurretPlasmaGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, TurretPlasmaGraphicsPack)
	return instance
end

---@param prototype data.ElectricTurretPrototype
function TurretPlasmaGraphicsPack:apply_to_entity(prototype)
	if not reskins_suppress_errors then
		error("apply_to_entity must be implemented by subclass")
	end
end

return TurretPlasmaGraphicsPack
