local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.NutrientExtractorGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local NutrientExtractorGraphicsPack = {}
NutrientExtractorGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(NutrientExtractorGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Angels.NutrientExtractorGraphicsPackParams
---@field tint data.Color?

---@param params Reskins.Angels.NutrientExtractorGraphicsPackParams
---@return Reskins.Angels.NutrientExtractorGraphicsPack
---@nodiscard
function NutrientExtractorGraphicsPack:configure(params)
	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		required_assets = {
			[_defines.assets.bioprocessing_graphics] = true,
		},
		nominal_width = 3,
		nominal_height = 3,
		graphics_set = self.get_graphics_set(params.tint),
	}) --[[@as Reskins.Angels.NutrientExtractorGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, NutrientExtractorGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function NutrientExtractorGraphicsPack.get_graphics_set(tint)
	local layers = {
		{
			filename = "__angelsbioprocessinggraphics__/graphics/entity/nutrient-extractor/nutrient-extractor.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			frame_count = 25,
			line_length = 5,
			shift = { 0, 0 },
			animation_speed = 0.5,
		},
	}

	if tint then
		table.insert(layers, {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/nutrient-extractor/nutrient-extractor-mask.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			repeat_count = 25,
			shift = { 0, 0 },
			animation_speed = 0.5,
			tint = tint,
		})
		table.insert(layers, {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/nutrient-extractor/nutrient-extractor-highlights.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			repeat_count = 25,
			shift = { 0, 0 },
			animation_speed = 0.5,
			blend_mode = "additive-soft",
		})
	end

	---@type data.CraftingMachineGraphicsSet
	local graphics_set = {
		animation = { layers = layers },
		working_visualisations = {},
	}

	return graphics_set
end

return NutrientExtractorGraphicsPack
