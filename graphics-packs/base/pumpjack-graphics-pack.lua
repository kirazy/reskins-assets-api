local MiningDrillGraphicsPack = require("mining-drill-graphics-pack")

---@class Reskins.Base.PumpjackGraphicsPack:Reskins.Abstractions.MiningDrillGraphicsPack
local PumpjackGraphicsPack = {}
PumpjackGraphicsPack.__index = PumpjackGraphicsPack

-- Set up inheritance.
setmetatable(PumpjackGraphicsPack, {
	__index = MiningDrillGraphicsPack,
})

---@class Reskins.Base.PumpjackGraphicsParams
---@field tint data.Color?

---@param params Reskins.Base.PumpjackGraphicsParams
---@return Reskins.Base.PumpjackGraphicsPack
---@nodiscard
function PumpjackGraphicsPack:configure(params)
	local instance = MiningDrillGraphicsPack.configure(self, {
		tint = params.tint,
		remnants = nil,
		required_assets = {},
	}) --[[@as Reskins.Base.PumpjackGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, PumpjackGraphicsPack)
	return instance
end

---@param prototype data.MiningDrillPrototype
function PumpjackGraphicsPack:apply_to_entity(prototype)
	if not reskins_suppress_errors then
		error("apply_to_entity must be implemented by subclass")
	end
end

return PumpjackGraphicsPack
