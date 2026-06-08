local TurretGraphicsPack = require("turret-graphics-pack")

---@class TurretSniperGraphicsPack:Reskins.Abstractions.TurretGraphicsPack
local TurretSniperGraphicsPack = {}
TurretSniperGraphicsPack.__index = TurretSniperGraphicsPack

-- Set up inheritance.
setmetatable(TurretSniperGraphicsPack, {
	__index = TurretGraphicsPack,
})

---@class TurretSniperGraphicsParams:Reskins.Abstractions.BaseGraphicsParams

---@param params TurretSniperGraphicsParams
---@return TurretSniperGraphicsPack
---@nodiscard
function TurretSniperGraphicsPack:configure(params)
	local instance = TurretGraphicsPack.configure(self, {
		tint = params.tint,
		scale = params.scale,
		scale_factor = params.scale_factor,
		remnants = nil,
		required_assets = {},
		nominal_width = 2,
		nominal_height = 2,
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
