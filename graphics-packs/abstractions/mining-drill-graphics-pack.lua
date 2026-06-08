local GraphicsPackBase = require("graphics-packs.abstractions.graphics-pack-base")

---The abstract intermediate class for mining drill graphics packs. Mirrors the Factorio `MiningDrillPrototype`
---hierarchy.
---
---Covers electric mining drills and pumpjacks.
---@class Reskins.Abstractions.MiningDrillGraphicsPack:Reskins.Abstractions.GraphicsPackBase
local MiningDrillGraphicsPack = {}
MiningDrillGraphicsPack.__index = MiningDrillGraphicsPack

-- Set up inheritance.
setmetatable(MiningDrillGraphicsPack, {
	__index = GraphicsPackBase,
})

---@class Reskins.Abstractions.MiningDrillGraphicsParams:Reskins.Abstractions.GraphicsParams

---@param params Reskins.Abstractions.MiningDrillGraphicsParams
---@return Reskins.Abstractions.MiningDrillGraphicsPack
---@nodiscard
function MiningDrillGraphicsPack:configure(params)
	local instance = GraphicsPackBase.configure(self, {
		tint = params.tint,
		scale = params.scale,
		scale_factor = params.scale_factor,
		remnants = params.remnants,
		required_assets = params.required_assets,
		nominal_width = params.nominal_width,
		nominal_height = params.nominal_height,
	}) --[[@as Reskins.Abstractions.MiningDrillGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, MiningDrillGraphicsPack)
	return instance
end

---@param prototype data.MiningDrillPrototype
function MiningDrillGraphicsPack:apply_to_entity(prototype)
	if not reskins_suppress_errors then
		error("apply_to_entity must be implemented by subclass")
	end
end

return MiningDrillGraphicsPack
