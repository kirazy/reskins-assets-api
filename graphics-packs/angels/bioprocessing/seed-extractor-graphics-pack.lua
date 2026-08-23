local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.SeedExtractorGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local SeedExtractorGraphicsPack = {}
SeedExtractorGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(SeedExtractorGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Angels.SeedExtractorGraphicsParams:Reskins.Abstractions.BaseGraphicsParams

---@param params Reskins.Angels.SeedExtractorGraphicsParams
---@return Reskins.Angels.SeedExtractorGraphicsPack
---@nodiscard
function SeedExtractorGraphicsPack:configure(params)
	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		scale = params.scale,
		scale_factor = params.scale_factor,
		required_assets = {
			[_defines.assets_source.bioprocessing_graphics] = true,
		},
		nominal_width = 3,
		nominal_height = 3,
		graphics_set = self.get_graphics_set(params.tint),
	}) --[[@as Reskins.Angels.SeedExtractorGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, SeedExtractorGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function SeedExtractorGraphicsPack.get_graphics_set(tint)
	local animation = {
		layers = {
			-- Base
			{
				filename = "__angelsbioprocessinggraphics__/graphics/entity/seed-extractor/seed-extractor.png",
				priority = "extra-high",
				width = 160,
				height = 160,
				frame_count = 25,
				line_length = 5,
				shift = { 0, 0 },
				animation_speed = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/seed-extractor/seed-extractor-mask.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			frame_count = 25,
			line_length = 5,
			shift = { 0, 0 },
			animation_speed = 0.5,
			tint = tint,
		})
		table.insert(animation.layers, {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/seed-extractor/seed-extractor-highlights.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			frame_count = 25,
			line_length = 5,
			shift = { 0, 0 },
			animation_speed = 0.5,
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

return SeedExtractorGraphicsPack
