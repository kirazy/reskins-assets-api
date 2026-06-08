local GraphicsPackBase = require("graphics-packs.abstractions.graphics-pack-base")

---The abstract intermediate class for electric pole graphics packs. Mirrors the Factorio `ElectricPolePrototype`
---hierarchy.
---
---Covers big electric poles, medium electric poles, and substations.
---@class Reskins.Abstractions.ElectricPoleGraphicsPack:Reskins.Abstractions.GraphicsPackBase
---@field pictures data.RotatedSprite
---@field remnants_overlay data.RotatedAnimationVariations?
local ElectricPoleGraphicsPack = {}
ElectricPoleGraphicsPack.__index = ElectricPoleGraphicsPack

-- Set up inheritance.
setmetatable(ElectricPoleGraphicsPack, {
	__index = GraphicsPackBase,
})

---@class Reskins.Abstractions.ElectricPoleGraphicsParams:Reskins.Abstractions.GraphicsParams
---@field pictures data.RotatedSprite
---@field remnants_overlay data.RotatedAnimationVariations?

---@param params Reskins.Abstractions.ElectricPoleGraphicsParams
---@return Reskins.Abstractions.ElectricPoleGraphicsPack
---@nodiscard
function ElectricPoleGraphicsPack:configure(params)
	local instance = GraphicsPackBase.configure(self, {
		tint = params.tint,
		scale = params.scale,
		scale_factor = params.scale_factor,
		nominal_width = params.nominal_width,
		nominal_height = params.nominal_height,
		remnants = params.remnants,
		required_assets = params.required_assets,
	}) --[[@as Reskins.Abstractions.ElectricPoleGraphicsPack]]

	instance.pictures = params.pictures
	instance.remnants_overlay = params.remnants_overlay

	-- Set the correct metatable for this class.
	setmetatable(instance, ElectricPoleGraphicsPack)
	return instance
end

---@param prototype data.ElectricPolePrototype
function ElectricPoleGraphicsPack:apply_to_entity(prototype)
	local pictures = util.copy(self.pictures)

	-- Scale the graphics to the prototype's footprint, if it differs from the nominal dimensions.
	local scaler = self:create_scaler(prototype)
	scaler:rescale(pictures)

	prototype.pictures = pictures
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
