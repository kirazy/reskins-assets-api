local GraphicsPackBase = require("graphics-pack-base")

---@class Reskins.Abstractions.OffshorePumpGraphicsPack:Reskins.Abstractions.GraphicsPackBase
local OffshorePumpGraphicsPack = {}
OffshorePumpGraphicsPack.__index = OffshorePumpGraphicsPack

-- Set up inheritance.
setmetatable(OffshorePumpGraphicsPack, {
	__index = GraphicsPackBase,
})

---@class Reskins.Abstractions.OffshorePumpGraphicsParams
---@field tint data.Color?

---@param params Reskins.Abstractions.OffshorePumpGraphicsParams
---@return Reskins.Abstractions.OffshorePumpGraphicsPack
---@nodiscard
function OffshorePumpGraphicsPack:configure(params)
	local instance = GraphicsPackBase.configure(self, {
		tint = params.tint,
		remnants = nil,
		required_assets = {},
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
