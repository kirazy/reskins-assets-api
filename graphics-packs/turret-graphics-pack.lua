local GraphicsPackBase = require("graphics-pack-base")

---The abstract intermediate class for turret graphics packs. Mirrors the Factorio `TurretPrototype` hierarchy.
---
---Covers `AmmoTurretPrototype` (`ammo-turret`) and `ElectricTurretPrototype` (`electric-turret`) leaf classes.
---
---**Note:** `ArtilleryTurretPrototype` does **not** inherit from `TurretPrototype` in Factorio's API; artillery
---turret graphics packs should inherit from `GraphicsPackBase` directly.
---@class TurretGraphicsPack:GraphicsPackBase
local TurretGraphicsPack = {}
TurretGraphicsPack.__index = TurretGraphicsPack

-- Set up inheritance.
setmetatable(TurretGraphicsPack, {
	__index = GraphicsPackBase,
})

---@class TurretGraphicsParams:GraphicsPackParams

---@param params TurretGraphicsParams
---@return TurretGraphicsPack
---@nodiscard
function TurretGraphicsPack:configure(params)
	local instance = GraphicsPackBase.configure(self, {
		tint = params.tint,
		remnants = params.remnants,
		required_assets = params.required_assets,
	}) --[[@as TurretGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, TurretGraphicsPack)
	return instance
end

---@param prototype data.TurretPrototype
function TurretGraphicsPack:apply_to_entity(prototype)
	if not reskins_suppress_errors then
		error("apply_to_entity must be implemented by subclass")
	end
end

return TurretGraphicsPack
