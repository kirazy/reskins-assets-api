local MiningDrillGraphicsPack = require("mining-drill-graphics-pack")

---@class PumpjackGraphicsPack:MiningDrillGraphicsPack
local PumpjackGraphicsPack = {}
PumpjackGraphicsPack.__index = PumpjackGraphicsPack

-- Set up inheritance.
setmetatable(PumpjackGraphicsPack, {
	__index = MiningDrillGraphicsPack,
})

---@class PumpjackGraphicsParams
---@field tint data.Color?

---@param params PumpjackGraphicsParams
---@return PumpjackGraphicsPack
---@nodiscard
function PumpjackGraphicsPack:configure(params)
	local instance = MiningDrillGraphicsPack.configure(self, {
		tint = params.tint,
		remnants = nil,
		required_assets = {},
	}) --[[@as PumpjackGraphicsPack]]

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
