local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.AdvancedChemicalPlantGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local AdvancedChemicalPlantGraphicsPack = {}
AdvancedChemicalPlantGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(AdvancedChemicalPlantGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Angels.AdvancedChemicalPlantGraphicsPackParams
---@field tint data.Color?

---@param params Reskins.Angels.AdvancedChemicalPlantGraphicsPackParams
---@return Reskins.Angels.AdvancedChemicalPlantGraphicsPack
---@nodiscard
function AdvancedChemicalPlantGraphicsPack:configure(params)
	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		required_assets = {
			[_defines.assets.petrochem_graphics] = true,
			[_defines.assets.angels_assets] = true,
		},
		nominal_width = 5,
		nominal_height = 5,
		graphics_set = self.get_graphics_set(params.tint),
	}) --[[@as Reskins.Angels.AdvancedChemicalPlantGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, AdvancedChemicalPlantGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function AdvancedChemicalPlantGraphicsPack.get_graphics_set(tint)
	local animation = {
		layers = {
			-- Base
			{
				filename = "__angelspetrochemgraphics__/graphics/entity/advanced-chemical-plant/advanced-chemical-plant.png",
				priority = "extra-high",
				width = 224,
				height = 224,
				frame_count = 16,
				line_length = 4,
				animation_speed = 0.5,
				shift = { 0, 0 },
			},
			-- Base Patch
			{
				filename = "__reskins-assets-angels__/graphics/entity/chemical-plant-advanced/chemical-plant-advanced-base-patch.png",
				priority = "extra-high",
				width = 224,
				height = 224,
				repeat_count = 16,
				animation_speed = 0.5,
				shift = { 0, 0 },
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/chemical-plant-advanced/chemical-plant-advanced-mask.png",
			priority = "extra-high",
			width = 224,
			height = 224,
			repeat_count = 16,
			animation_speed = 0.5,
			shift = { 0, 0 },
			tint = tint,
		})
		table.insert(animation.layers, {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/chemical-plant-advanced/chemical-plant-advanced-highlights.png",
			priority = "extra-high",
			width = 224,
			height = 224,
			repeat_count = 16,
			animation_speed = 0.5,
			shift = { 0, 0 },
			blend_mode = "additive-soft",
		})
	end

	---@type data.CraftingMachineGraphicsSet
	local graphics_set = {
		animation = animation,
		working_visualisations = {},
	}

	return graphics_set
end

return AdvancedChemicalPlantGraphicsPack
