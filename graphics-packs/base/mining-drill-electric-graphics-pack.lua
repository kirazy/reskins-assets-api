local MiningDrillGraphicsPack = require("mining-drill-graphics-pack")

---@class Reskins.Base.MiningDrillElectricGraphicsPack:Reskins.Abstractions.MiningDrillGraphicsPack
local MiningDrillElectricGraphicsPack = {}
MiningDrillElectricGraphicsPack.__index = MiningDrillElectricGraphicsPack

-- Set up inheritance.
setmetatable(MiningDrillElectricGraphicsPack, {
	__index = MiningDrillGraphicsPack,
})

---@class Reskins.Base.MiningDrillElectricGraphicsParams:Reskins.Abstractions.BaseGraphicsParams

---@param params Reskins.Base.MiningDrillElectricGraphicsParams
---@return Reskins.Base.MiningDrillElectricGraphicsPack
---@nodiscard
function MiningDrillElectricGraphicsPack:configure(params)
	local instance = MiningDrillGraphicsPack.configure(self, {
		tint = params.tint,
		scale = params.scale,
		scale_factor = params.scale_factor,
		remnants = nil,
		required_assets = {},
		nominal_width = 3,
		nominal_height = 3,
	}) --[[@as Reskins.Base.MiningDrillElectricGraphicsPack]]

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
