local GraphicsPackBase = require("graphics-pack-base")

---@class InserterGraphicsPack:GraphicsPackBase
local InserterGraphicsPack = {}
InserterGraphicsPack.__index = InserterGraphicsPack

-- Set up inheritance.
setmetatable(InserterGraphicsPack, {
	__index = GraphicsPackBase,
})

---@class InserterGraphicsParams
---@field tint data.Color?

---@param params InserterGraphicsParams
---@return InserterGraphicsPack
---@nodiscard
function InserterGraphicsPack:configure(params)
	local instance = GraphicsPackBase.configure(self, {
		tint = params.tint,
		remnants = nil,
		required_assets = {},
	}) --[[@as InserterGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, InserterGraphicsPack)
	return instance
end

---@param prototype data.InserterPrototype
function InserterGraphicsPack:apply_to_entity(prototype)
	if not reskins_suppress_errors then
		error("apply_to_entity must be implemented by subclass")
	end
end

return InserterGraphicsPack
