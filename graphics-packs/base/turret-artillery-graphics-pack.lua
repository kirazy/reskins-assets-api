local GraphicsPackBase = require("graphics-packs.abstractions.graphics-pack-base")

---@class TurretArtilleryGraphicsPack:Reskins.Abstractions.GraphicsPackBase
local TurretArtilleryGraphicsPack = {}
TurretArtilleryGraphicsPack.__index = TurretArtilleryGraphicsPack

-- Set up inheritance.
-- Note: ArtilleryTurretPrototype inherits from EntityWithOwnerPrototype directly in Factorio's API,
-- not from TurretPrototype. Therefore this class inherits from GraphicsPackBase, not TurretGraphicsPack.
setmetatable(TurretArtilleryGraphicsPack, {
	__index = GraphicsPackBase,
})

---@class TurretArtilleryGraphicsParams
---@field tint data.Color?

---@param params TurretArtilleryGraphicsParams
---@return TurretArtilleryGraphicsPack
---@nodiscard
function TurretArtilleryGraphicsPack:configure(params)
	local instance = GraphicsPackBase.configure(self, {
		tint = params.tint,
		remnants = nil,
		required_assets = {},
	}) --[[@as TurretArtilleryGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, TurretArtilleryGraphicsPack)
	return instance
end

---@param prototype data.ArtilleryTurretPrototype
function TurretArtilleryGraphicsPack:apply_to_entity(prototype)
	if not reskins_suppress_errors then
		error("apply_to_entity must be implemented by subclass")
	end
end

return TurretArtilleryGraphicsPack
