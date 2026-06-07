local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Bobs.DistilleryGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
---@field field Any
local ChemicalPlantGraphicsPack = {}
ChemicalPlantGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(ChemicalPlantGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Bobs.DistilleryGraphicsPackParams
---@field tint data.Color?

---@param params Reskins.Bobs.DistilleryGraphicsPackParams
---@return Reskins.Bobs.DistilleryGraphicsPack
---@nodiscard
function ChemicalPlantGraphicsPack:configure(params)
	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = nil,
		required_assets = {},
		nominal_width = 2,
		nominal_height = 2,
		graphics_set = {},
	}) --[[@as Reskins.Bobs.DistilleryGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, ChemicalPlantGraphicsPack)
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
function ChemicalPlantGraphicsPack:apply_to_entity(prototype)
	if not reskins_suppress_errors then
		error("apply_to_entity must be implemented by subclass")
	end
end

return ChemicalPlantGraphicsPack
