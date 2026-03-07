local MiningDrillGraphicsPack = require("mining-drill-graphics-pack")

---@class MiningDrillElectricGraphicsPack:MiningDrillGraphicsPack
local MiningDrillElectricGraphicsPack = {}
MiningDrillElectricGraphicsPack.__index = MiningDrillElectricGraphicsPack

-- Set up inheritance.
setmetatable(MiningDrillElectricGraphicsPack, {
	__index = MiningDrillGraphicsPack,
})

---@class MiningDrillElectricGraphicsParams
---@field tint data.Color?

---@param params MiningDrillElectricGraphicsParams
---@return MiningDrillElectricGraphicsPack
---@nodiscard
function MiningDrillElectricGraphicsPack:configure(params)
	local instance = MiningDrillGraphicsPack.configure(self, {
		tint = params.tint,
		remnants = nil,
		required_assets = {},
	}) --[[@as MiningDrillElectricGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, MiningDrillElectricGraphicsPack)
	return instance
end

---@param prototype data.MiningDrillPrototype
function MiningDrillElectricGraphicsPack:apply_to_entity(prototype)
	if not reskins_suppress_errors then
		error("apply_to_entity must be implemented by subclass")
	end
end

return MiningDrillElectricGraphicsPack
