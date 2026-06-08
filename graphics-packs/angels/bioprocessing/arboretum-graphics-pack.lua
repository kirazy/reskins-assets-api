local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.ArboretumGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local ArboretumGraphicsPack = {}
ArboretumGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(ArboretumGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Angels.ArboretumGraphicsParams:Reskins.Abstractions.BaseGraphicsParams

---@param params Reskins.Angels.ArboretumGraphicsParams
---@return Reskins.Angels.ArboretumGraphicsPack
---@nodiscard
function ArboretumGraphicsPack:configure(params)
	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		scale = params.scale,
		scale_factor = params.scale_factor,
		required_assets = {
			[_defines.assets.bioprocessing_graphics] = true,
		},
		nominal_width = 5,
		nominal_height = 5,
		graphics_set = self.get_graphics_set(params.tint),
	}) --[[@as Reskins.Angels.ArboretumGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, ArboretumGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function ArboretumGraphicsPack.get_graphics_set(tint)
	local layers = {
		-- Shadow
		{
			filename = "__angelsbioprocessinggraphics__/graphics/entity/trees/bio-arboretum-shadow.png",
			width = 224,
			height = 256,
			shift = { 0, -0.50 },
		},
		-- Base
		{
			filename = "__angelsbioprocessinggraphics__/graphics/entity/trees/bio-arboretum-base.png",
			width = 224,
			height = 256,
			shift = { 0, -0.50 },
		},
	}

	if tint then
		table.insert(layers, {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/arboretum/arboretum-mask.png",
			priority = "extra-high",
			width = 224,
			height = 256,
			shift = { 0, -0.5 },
			tint = tint,
		})
		table.insert(layers, {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/arboretum/arboretum-highlights.png",
			priority = "extra-high",
			width = 224,
			height = 256,
			shift = { 0, -0.5 },
			blend_mode = "additive-soft",
		})
	end

	table.insert(layers, {
		-- Pipes
		filename = "__angelsbioprocessinggraphics__/graphics/entity/trees/bio-arboretum-pipes.png",
		width = 224,
		height = 256,
		shift = { 0, -0.50 },
	})
	table.insert(layers, {
		-- Off state
		filename = "__angelsbioprocessinggraphics__/graphics/entity/trees/bio-arboretum-off.png",
		width = 224,
		height = 256,
		shift = { 0, -0.50 },
	})

	---@type data.CraftingMachineGraphicsSet
	local graphics_set = {
		animation = { layers = layers },
		working_visualisations = {
			{
				apply_recipe_tint = "primary",
				animation = {
					filename = "__angelsbioprocessinggraphics__/graphics/entity/trees/bio-arboretum-on.png",
					blend_mode = "additive",
					width = 224,
					height = 256,
					line_length = 1,
					frame_count = 1,
					shift = { 0, -0.50 },
				},
				light = { intensity = 1, size = 8, color = { r = 0.5, g = 1.0, b = 0.5 } },
			},
		},
	}

	return graphics_set
end

return ArboretumGraphicsPack
