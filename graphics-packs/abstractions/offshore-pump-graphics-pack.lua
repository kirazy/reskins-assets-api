local GraphicsPackBase = require("graphics-packs.abstractions.graphics-pack-base")

---@class Reskins.Abstractions.OffshorePumpGraphicsPack:Reskins.Abstractions.GraphicsPackBase
local OffshorePumpGraphicsPack = {}
OffshorePumpGraphicsPack.__index = OffshorePumpGraphicsPack

-- Set up inheritance.
setmetatable(OffshorePumpGraphicsPack, {
	__index = GraphicsPackBase,
})

---@class Reskins.Abstractions.OffshorePumpGraphicsParams:Reskins.Abstractions.GraphicsParams

---@param params Reskins.Abstractions.OffshorePumpGraphicsParams
---@return Reskins.Abstractions.OffshorePumpGraphicsPack
---@nodiscard
function OffshorePumpGraphicsPack:configure(params)
	local instance = GraphicsPackBase.configure(self, {
		tint = params.tint,
		scale = params.scale,
		scale_factor = params.scale_factor,
		remnants = nil,
		required_assets = {},
		nominal_width = params.nominal_width,
		nominal_height = params.nominal_height,
	}) --[[@as Reskins.Abstractions.OffshorePumpGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, OffshorePumpGraphicsPack)
	return instance
end

---@param prototype data.OffshorePumpPrototype
function OffshorePumpGraphicsPack:apply_to_entity(prototype)
	if not reskins_suppress_errors then
		error("apply_to_entity must be implemented by subclass")
	end
end

return OffshorePumpGraphicsPack
