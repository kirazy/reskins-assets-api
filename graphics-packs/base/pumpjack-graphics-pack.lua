local MiningDrillGraphicsPack = require("mining-drill-graphics-pack")

---@class Reskins.Base.PumpjackGraphicsPack:Reskins.Abstractions.MiningDrillGraphicsPack
local PumpjackGraphicsPack = {}
PumpjackGraphicsPack.__index = PumpjackGraphicsPack

-- Set up inheritance.
setmetatable(PumpjackGraphicsPack, {
	__index = MiningDrillGraphicsPack,
})

---@class Reskins.Base.PumpjackGraphicsParams:Reskins.Abstractions.BaseGraphicsParams

---@param params Reskins.Base.PumpjackGraphicsParams
---@return Reskins.Base.PumpjackGraphicsPack
---@nodiscard
function PumpjackGraphicsPack:configure(params)
	local instance = MiningDrillGraphicsPack.configure(self, {
		tint = params.tint,
		scale = params.scale,
		scale_factor = params.scale_factor,
		remnants = nil,
		required_assets = {},
		nominal_width = 3,
		nominal_height = 3,
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
