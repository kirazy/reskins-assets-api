local TurretGraphicsPack = require("turret-graphics-pack")

---@class TurretSniperGraphicsPack:TurretGraphicsPack
local TurretSniperGraphicsPack = {}
TurretSniperGraphicsPack.__index = TurretSniperGraphicsPack

-- Set up inheritance.
setmetatable(TurretSniperGraphicsPack, {
	__index = TurretGraphicsPack,
})

---@class TurretSniperGraphicsParams
---@field tint data.Color?

---@param params TurretSniperGraphicsParams
---@return TurretSniperGraphicsPack
---@nodiscard
function TurretSniperGraphicsPack:configure(params)
	local instance = TurretGraphicsPack.configure(self, {
		tint = params.tint,
		remnants = nil,
		required_assets = {},
	}) --[[@as TurretSniperGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, TurretSniperGraphicsPack)
	return instance
end

---@param prototype data.AmmoTurretPrototype
function TurretSniperGraphicsPack:apply_to_entity(prototype)
	if not reskins_suppress_errors then
		error("apply_to_entity must be implemented by subclass")
	end
end

return TurretSniperGraphicsPack
