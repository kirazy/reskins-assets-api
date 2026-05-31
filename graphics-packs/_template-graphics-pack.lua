local GraphicsPackBase = require("graphics-pack-base")

---@class __TEMPLATE__Pack:Reskins.Abstractions.GraphicsPackBase
---@field field Any
local __TEMPLATE__Pack = {}
__TEMPLATE__Pack.__index = GraphicsPackBase

-- Set up inheritance
setmetatable(__TEMPLATE__Pack, {
	__index = GraphicsPackBase,
})

---@class __TEMPLATE__PackParams
---@field param Any

---@param params __TEMPLATE__PackParams
---@return __TEMPLATE__Pack
---@nodiscard
function __TEMPLATE__Pack:configure(params)
	local instance = GraphicsPackBase.configure(self, {
		tint = nil,
		remnants = {},
		required_assets = {},
	}) --[[@as __TEMPLATE__Pack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, __TEMPLATE__Pack)
	return instance
end

---Applies a copy of the graphics pack to the specified `prototype`.
---
---#### Exceptions
---*@throws* - `string` - When `prototype` is `nil`.</br>
---*@throws* - `string` - When `prototype` is is not a `table`.
---
---#### Implementation Guidance
---- This is an abstract method that must be implemented by subclasses.
---- Implementations should mutate the prototype in place, and set copies of the graphics.
---@param prototype data.PrototypeBase
function __TEMPLATE__Pack:apply_to_entity(prototype)
	if not reskins_suppress_errors then
		error("apply_to_entity must be implemented by subclass")
	end
end

return __TEMPLATE__Pack
