local GraphicsPackBase = require("graphics-pack-base")

---@class CraftingMachineGraphicsPack:GraphicsPackBase
---@field graphics_set data.CraftingMachineGraphicsSet
---@field graphics_set_flipped data.CraftingMachineGraphicsSet?
---@field fluid_boxes FluidBoxGraphics[]?
local CraftingMachineGraphicsPack = {}
CraftingMachineGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(CraftingMachineGraphicsPack, {
	__index = GraphicsPackBase,
})

---@class CraftingMachineGraphicsParams:GraphicsPackParams
---@field graphics_set data.CraftingMachineGraphicsSet
---@field graphics_set_flipped data.CraftingMachineGraphicsSet?
---@field fluid_boxes FluidBoxGraphics[]?

---Creates a new `CraftingMachineGraphicsPack` instance.
---
---The parameters are not copied for performance reasons; if they are not properly isolated changes made elsewhere will
---apply to the graphics pack. The recommended pattern is to create the parameters alongside the graphics pack instance.
---@param params CraftingMachineGraphicsParams
---@return CraftingMachineGraphicsPack
---@nodiscard
function CraftingMachineGraphicsPack:new(params)
	local instance = GraphicsPackBase.new(self, {
		tint = params.tint,
		remnants = params.remnants,
		required_assets = params.required_assets,
	}) --[[@as CraftingMachineGraphicsPack]]

	-- Add specialized fields
	instance.graphics_set = params.graphics_set
	instance.graphics_set_flipped = params.graphics_set_flipped
	instance.fluid_boxes = params.fluid_boxes

	-- Set the correct metatable for this class
	setmetatable(instance, CraftingMachineGraphicsPack)
	return instance
end

---Applies the graphics pack to the specified crafting machine `prototype`.
---
---The prototype is mutated in place.
---@param prototype data.CraftingMachinePrototype
function CraftingMachineGraphicsPack:apply_to_entity(prototype)
	-- Apply graphics set, clear any conflicting properties.
	prototype.graphics_set = util.copy(self.graphics_set)
	prototype.graphics_set_flipped = self.graphics_set_flipped and util.copy(self.graphics_set_flipped) or nil
	prototype.water_reflection = nil

	-- Apply fluid box configurations if present
	if self.fluid_boxes and prototype.fluid_boxes then
		self:apply_fluid_box_graphics(prototype)
	end

	-- Need to go through energy source and a few other things.
	if not reskins_suppress_errors then
		error("apply_to_entity is incomplete")
	end
end

---Applies fluid box graphics to the specified `prototype`.
---
---The prototype is mutated in place.
---@param prototype data.CraftingMachinePrototype
---@private
function CraftingMachineGraphicsPack:apply_fluid_box_graphics(prototype)
	if not reskins_suppress_errors then
		error("apply_fluid_box_graphics is not implemented")
	end
end

return CraftingMachineGraphicsPack
