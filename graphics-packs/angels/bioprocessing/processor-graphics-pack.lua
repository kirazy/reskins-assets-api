local CraftingMachineGraphicsPack = require("crafting-machine-graphics-pack")

---@class Reskins.Angels.ProcessorGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
---@field field Any
local ProcessorGraphicsPack = {}
ProcessorGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(ProcessorGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Angels.ProcessorGraphicsPackParams
---@field tint data.Color?

---@param params Reskins.Angels.ProcessorGraphicsPackParams
---@return Reskins.Angels.ProcessorGraphicsPack
---@nodiscard
function ProcessorGraphicsPack:configure(params)
	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = nil,
		remnants = {},
		required_assets = {},
		graphics_set = {},
		graphics_set_flipped = {},
		fluid_boxes = {},
		fluid_boxes_off_when_no_fluid_recipe = false,
	}) --[[@as Reskins.Angels.ProcessorGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, ProcessorGraphicsPack)
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
function ProcessorGraphicsPack:apply_to_entity(prototype)
	if not reskins_suppress_errors then
		error("apply_to_entity must be implemented by subclass")
	end
end

return ProcessorGraphicsPack
