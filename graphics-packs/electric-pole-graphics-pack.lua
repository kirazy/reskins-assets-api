local GraphicsPackBase = require("graphics-pack-base")

---The abstract intermediate class for electric pole graphics packs. Mirrors the Factorio `ElectricPolePrototype`
---hierarchy.
---
---Covers big electric poles, medium electric poles, and substations.
---@class ElectricPoleGraphicsPack:GraphicsPackBase
---@field pictures data.RotatedSprite
---@field remnants_overlay data.RotatedAnimationVariations?
local ElectricPoleGraphicsPack = {}
ElectricPoleGraphicsPack.__index = ElectricPoleGraphicsPack

-- Set up inheritance.
setmetatable(ElectricPoleGraphicsPack, {
	__index = GraphicsPackBase,
})

---@class ElectricPoleGraphicsParams:GraphicsPackParams
---@field pictures data.RotatedSprite
---@field remnants_overlay data.RotatedAnimationVariations?

---@param params ElectricPoleGraphicsParams
---@return ElectricPoleGraphicsPack
---@nodiscard
function ElectricPoleGraphicsPack:configure(params)
	local instance = GraphicsPackBase.configure(self, {
		tint = params.tint,
		remnants = params.remnants,
		required_assets = params.required_assets,
	}) --[[@as ElectricPoleGraphicsPack]]

	instance.pictures = params.pictures
	instance.remnants_overlay = params.remnants_overlay

	-- Set the correct metatable for this class.
	setmetatable(instance, ElectricPoleGraphicsPack)
	return instance
end

---@param prototype data.ElectricPolePrototype
function ElectricPoleGraphicsPack:apply_to_entity(prototype)
	prototype.pictures = util.copy(self.pictures)
end

---@param corpse data.CorpsePrototype
function ElectricPoleGraphicsPack:apply_to_corpse(corpse)
	-- Call base implementation to set corpse.animation.
	GraphicsPackBase.apply_to_corpse(self, corpse)

	-- Set the overlay animation if present.
	if self.remnants_overlay then
		corpse.animation_overlay = util.copy(self.remnants_overlay)
	end
end

return ElectricPoleGraphicsPack
