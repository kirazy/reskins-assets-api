local CraftingMachineGraphicsPack = require("crafting-machine-graphics-pack")

---@class Reskins.Angels.CastingMachineGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
---@field field Any
local CastingMachineGraphicsPack = {}
CastingMachineGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(CastingMachineGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Angels.CastingMachineGraphicsPackParams
---@field tint data.Color?

---@param params Reskins.Angels.CastingMachineGraphicsPackParams
---@return Reskins.Angels.CastingMachineGraphicsPack
---@nodiscard
function CastingMachineGraphicsPack:configure(params)
	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = nil,
		remnants = {},
		required_assets = {},
		graphics_set = {},
		graphics_set_flipped = {},
		fluid_boxes = {},
		fluid_boxes_off_when_no_fluid_recipe = false,
	}) --[[@as Reskins.Angels.CastingMachineGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, CastingMachineGraphicsPack)
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
function CastingMachineGraphicsPack:apply_to_entity(prototype)
	if not reskins_suppress_errors then
		error("apply_to_entity must be implemented by subclass")
	end
end

return CastingMachineGraphicsPack
