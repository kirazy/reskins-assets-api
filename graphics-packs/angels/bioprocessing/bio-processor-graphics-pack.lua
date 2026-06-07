local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.BioProcessorGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local BioProcessorGraphicsPack = {}
BioProcessorGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(BioProcessorGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Angels.BioProcessorGraphicsPackParams
---@field tint data.Color?

---@param params Reskins.Angels.BioProcessorGraphicsPackParams
---@return Reskins.Angels.BioProcessorGraphicsPack
---@nodiscard
function BioProcessorGraphicsPack:configure(params)
	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		required_assets = {
			[_defines.assets.bioprocessing_graphics] = true,
		},
		nominal_width = 5,
		nominal_height = 5,
		graphics_set = self.get_graphics_set(params.tint),
	}) --[[@as Reskins.Angels.BioProcessorGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, BioProcessorGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function BioProcessorGraphicsPack.get_graphics_set(tint)
	local working_visualisations = {
		{
			fadeout = true,
			apply_recipe_tint = "primary",
			animation = {
				filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-processor/bio-processor-bg.png",
				line_length = 5,
				frame_count = 25,
				width = 224,
				height = 224,
				shift = { 0, 0 },
				animation_speed = 0.5,
			},
		},
		{
			always_draw = true,
			animation = {
				filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-processor/bio-processor-trans.png",
				line_length = 5,
				frame_count = 25,
				width = 224,
				height = 224,
				shift = { 0, 0 },
				animation_speed = 0.5,
			},
		},
		{
			fadeout = true,
			apply_recipe_tint = "secondary",
			animation = {
				filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-processor/bio-processor-ani.png",
				line_length = 5,
				frame_count = 25,
				width = 224,
				height = 224,
				shift = { 0, 0 },
				animation_speed = 0.5,
			},
		},
	}

	if tint then
		table.insert(working_visualisations, {
			always_draw = true,
			animation = {
				layers = {
					-- Mask
					{
						filename = "__reskins-assets-angels__/graphics/entity/bio-processor/bio-processor-mask.png",
						priority = "extra-high",
						width = 224,
						height = 224,
						line_length = 5,
						frame_count = 25,
						shift = { 0, 0 },
						animation_speed = 0.5,
						tint = tint,
					},
					-- Highlights
					{
						filename = "__reskins-assets-angels__/graphics/entity/bio-processor/bio-processor-highlights.png",
						priority = "extra-high",
						width = 224,
						height = 224,
						line_length = 5,
						frame_count = 25,
						shift = { 0, 0 },
						animation_speed = 0.5,
						blend_mode = "additive-soft",
					},
				},
			},
		})
	end

	---@type data.CraftingMachineGraphicsSet
	local graphics_set = {
		animation = {
			filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-processor/bio-processor.png",
			width = 224,
			height = 224,
			line_length = 5,
			frame_count = 25,
			shift = { 0, 0 },
			animation_speed = 0.5,
		},
		working_visualisations = working_visualisations,
	}

	return graphics_set
end

return BioProcessorGraphicsPack
