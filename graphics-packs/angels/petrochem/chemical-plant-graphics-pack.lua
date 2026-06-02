local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.ChemicalPlantGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local ChemicalPlantGraphicsPack = {}
ChemicalPlantGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(ChemicalPlantGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Angels.ChemicalPlantGraphicsPackParams
---@field tint data.Color?

---@param params Reskins.Angels.ChemicalPlantGraphicsPackParams
---@return Reskins.Angels.ChemicalPlantGraphicsPack
---@nodiscard
function ChemicalPlantGraphicsPack:configure(params)
	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		remnants = {},
		required_assets = {
			[_defines.assets.petrochem_graphics] = true,
		},
		nominal_width = 5,
		nominal_height = 5,
		graphics_set = self.get_graphics_set(params.tint),
		graphics_set_flipped = {},
		fluid_boxes = {},
		fluid_boxes_off_when_no_fluid_recipe = false,
	}) --[[@as Reskins.Angels.ChemicalPlantGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, ChemicalPlantGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function ChemicalPlantGraphicsPack.get_graphics_set(tint)
	local animation = {
		layers = {
			-- Base
			{
				filename = "__angelspetrochemgraphics__/graphics/entity/chemical-plant/chemical-plant.png",
				priority = "extra-high",
				width = 160,
				height = 160,
				shift = { 0, 0 },
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/chemical-plant/chemical-plant-mask.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			shift = { 0, 0 },
			tint = tint,
		})
		table.insert(animation.layers, {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/chemical-plant/chemical-plant-highlights.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			shift = { 0, 0 },
			blend_mode = "additive-soft",
		})
	end

	---@type data.CraftingMachineGraphicsSet
	local graphics_set = {
		animation = animation,
		working_visualisations = {
			{
				apply_recipe_tint = "primary",
				animation = {
					filename = "__angelspetrochemgraphics__/graphics/entity/chemical-plant/mixer-tint.png",
					line_length = 6,
					frame_count = 36,
					width = 160,
					height = 160,
					shift = { 0, 0 },
					animation_speed = 0.5,
				},
			},
			{
				animation = {
					filename = "__angelspetrochemgraphics__/graphics/entity/chemical-plant/mixer-overlay.png",
					line_length = 6,
					frame_count = 36,
					width = 160,
					height = 160,
					shift = { 0, 0 },
					animation_speed = 0.5,
				},
			},
			{
				apply_recipe_tint = "secondary",
				animation = {
					filename = "__angelspetrochemgraphics__/graphics/entity/chemical-plant/pipe-tint.png",
					line_length = 6,
					frame_count = 36,
					width = 160,
					height = 160,
					shift = { 0, 0 },
					animation_speed = 0.5,
				},
			},
			{
				animation = {
					filename = "__angelspetrochemgraphics__/graphics/entity/chemical-plant/pipe-overlay.png",
					line_length = 6,
					frame_count = 36,
					width = 160,
					height = 160,
					shift = { 0, 0 },
					animation_speed = 0.5,
				},
			},
		},
	}

	return graphics_set
end

return ChemicalPlantGraphicsPack
