local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.TreeGeneratorGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local TreeGeneratorGraphicsPack = {}
TreeGeneratorGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(TreeGeneratorGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Angels.TreeGeneratorGraphicsParams:Reskins.Abstractions.BaseGraphicsParams
---@field variant "temperate"|"desert"|"swamp"

---@param params Reskins.Angels.TreeGeneratorGraphicsParams
---@return Reskins.Angels.TreeGeneratorGraphicsPack
---@nodiscard
function TreeGeneratorGraphicsPack:configure(params)
	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		scale = params.scale,
		scale_factor = params.scale_factor,
		required_assets = {
			[_defines.assets_source.bioprocessing_graphics] = true,
		},
		nominal_width = 3,
		nominal_height = 3,
		graphics_set = self.get_graphics_set(params.tint, params.variant),
	}) --[[@as Reskins.Angels.TreeGeneratorGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, TreeGeneratorGraphicsPack)
	return instance
end

---@param tint data.Color?
---@param variant "temperate"|"desert"|"swamp"
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function TreeGeneratorGraphicsPack.get_graphics_set(tint, variant)
	local variant_filenames = {
		temperate = "__angelsbioprocessinggraphics__/graphics/entity/trees/bio-generator-1.png",
		swamp = "__angelsbioprocessinggraphics__/graphics/entity/trees/bio-generator-2.png",
		desert = "__angelsbioprocessinggraphics__/graphics/entity/trees/bio-generator-3.png",
	}

	local layers = {
		{
			filename = "__angelsbioprocessinggraphics__/graphics/entity/trees/bio-generator-shadow.png",
			width = 160,
			height = 160,
			line_length = 1,
			frame_count = 1,
			shift = { 0, 0 },
		},
		{
			filename = "__angelsbioprocessinggraphics__/graphics/entity/trees/bio-generator-base.png",
			width = 160,
			height = 160,
			line_length = 1,
			frame_count = 1,
			shift = { 0, 0 },
		},
		{
			filename = "__angelsbioprocessinggraphics__/graphics/entity/trees/bio-generator-pipes.png",
			width = 160,
			height = 160,
			line_length = 1,
			frame_count = 1,
			shift = { 0, 0 },
		},
		{
			filename = variant_filenames[variant],
			width = 160,
			height = 160,
			line_length = 1,
			frame_count = 1,
			shift = { 0, 0 },
		},
		{
			filename = "__angelsbioprocessinggraphics__/graphics/entity/trees/bio-generator-top.png",
			width = 160,
			height = 160,
			line_length = 1,
			frame_count = 1,
			shift = { 0, 0 },
		},
	}

	if tint then
		table.insert(layers, {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/tree-generator/tree-generator-mask.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			shift = { 0, 0 },
			tint = tint,
		})
		table.insert(layers, {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/tree-generator/tree-generator-highlights.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			shift = { 0, 0 },
			blend_mode = "additive-soft",
		})
	end

	---@type data.CraftingMachineGraphicsSet
	local graphics_set = {
		animation = { layers = layers },
		working_visualisations = {
			{
				fadeout = true,
				animation = {
					filename = "__angelsbioprocessinggraphics__/graphics/entity/trees/bio-generator-top-on.png",
					priority = "extra-high",
					width = 160,
					height = 160,
					shift = { 0, 0 },
					draw_as_glow = true,
				},
				light = { intensity = 4, size = 4, color = { r = 0.5, g = 1.0, b = 0.5 } },
			},
		},
	}

	return graphics_set
end

return TreeGeneratorGraphicsPack
