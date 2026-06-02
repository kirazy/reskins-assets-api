local GraphicsPackBase = require("graphics-packs.abstractions.graphics-pack-base")

---The abstract intermediate class for generator graphics packs. Mirrors the Factorio `GeneratorPrototype` hierarchy.
---
---Covers steam engines and steam turbines, which share `horizontal_animation` / `vertical_animation` fields.
---@class Reskins.Abstractions.GeneratorGraphicsPack:Reskins.Abstractions.GraphicsPackBase
---@field horizontal_animation data.Animation
---@field vertical_animation data.Animation
local GeneratorGraphicsPack = {}
GeneratorGraphicsPack.__index = GeneratorGraphicsPack

-- Set up inheritance.
setmetatable(GeneratorGraphicsPack, {
	__index = GraphicsPackBase,
})

---@class Reskins.Abstractions.GeneratorGraphicsParams:Reskins.Abstractions.GraphicsPackParams
---@field horizontal_animation data.Animation
---@field vertical_animation data.Animation

---@param params Reskins.Abstractions.GeneratorGraphicsParams
---@return Reskins.Abstractions.GeneratorGraphicsPack
---@nodiscard
function GeneratorGraphicsPack:configure(params)
	local instance = GraphicsPackBase.configure(self, {
		tint = params.tint,
		remnants = params.remnants,
		required_assets = params.required_assets,
	}) --[[@as Reskins.Abstractions.GeneratorGraphicsPack]]

	instance.horizontal_animation = params.horizontal_animation
	instance.vertical_animation = params.vertical_animation

	-- Set the correct metatable for this class.
	setmetatable(instance, GeneratorGraphicsPack)
	return instance
end

---@param prototype data.GeneratorPrototype
function GeneratorGraphicsPack:apply_to_entity(prototype)
	prototype.horizontal_animation = util.copy(self.horizontal_animation)
	prototype.vertical_animation = util.copy(self.vertical_animation)
end

return GeneratorGraphicsPack
