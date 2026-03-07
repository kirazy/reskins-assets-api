local GraphicsPackBase = require("graphics-pack-base")

---The abstract intermediate class for mining drill graphics packs. Mirrors the Factorio `MiningDrillPrototype`
---hierarchy.
---
---Covers electric mining drills and pumpjacks.
---@class MiningDrillGraphicsPack:GraphicsPackBase
local MiningDrillGraphicsPack = {}
MiningDrillGraphicsPack.__index = MiningDrillGraphicsPack

-- Set up inheritance.
setmetatable(MiningDrillGraphicsPack, {
	__index = GraphicsPackBase,
})

---@class MiningDrillGraphicsParams:GraphicsPackParams

---@param params MiningDrillGraphicsParams
---@return MiningDrillGraphicsPack
---@nodiscard
function MiningDrillGraphicsPack:configure(params)
	local instance = GraphicsPackBase.configure(self, {
		tint = params.tint,
		remnants = params.remnants,
		required_assets = params.required_assets,
	}) --[[@as MiningDrillGraphicsPack]]

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
