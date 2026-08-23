local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.AlgaeFarmGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local AlgaeFarmGraphicsPack = {}
AlgaeFarmGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(AlgaeFarmGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Angels.AlgaeFarmGraphicsParams:Reskins.Abstractions.BaseGraphicsParams

---@param params Reskins.Angels.AlgaeFarmGraphicsParams
---@return Reskins.Angels.AlgaeFarmGraphicsPack
---@nodiscard
function AlgaeFarmGraphicsPack:configure(params)
	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		scale = params.scale,
		scale_factor = params.scale_factor,
		required_assets = {
			[_defines.assets_source.bioprocessing_graphics] = true,
		},
		nominal_width = 7,
		nominal_height = 7,
		graphics_set = self.get_graphics_set(params.tint),
	}) --[[@as Reskins.Angels.AlgaeFarmGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, AlgaeFarmGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function AlgaeFarmGraphicsPack.get_graphics_set(tint)
	local animation = {
		layers = {
			-- Base
			{
				filename = "__angelsbioprocessinggraphics__/graphics/entity/algae-farm/algae-farm.png",
				priority = "extra-high",
				width = 288,
				height = 288,
				line_length = 6,
				frame_count = 36,
				shift = { 0, 0 },
				animation_speed = 0.4,
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/algae-farm/algae-farm-mask.png",
			priority = "extra-high",
			width = 288,
			height = 288,
			repeat_count = 36,
			shift = { 0, 0 },
			animation_speed = 0.4,
			tint = tint,
		})
		table.insert(animation.layers, {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/algae-farm/algae-farm-highlights.png",
			priority = "extra-high",
			width = 288,
			height = 288,
			repeat_count = 36,
			shift = { 0, 0 },
			animation_speed = 0.4,
			blend_mode = "additive-soft",
		})
	end

	---@type data.CraftingMachineGraphicsSet
	local graphics_set = {
		animation = animation,
		working_visualisations = {
			{
				animation = {
					filename = "__angelsbioprocessinggraphics__/graphics/entity/algae-farm/water-splash.png",
					line_length = 5,
					frame_count = 10,
					width = 92,
					height = 99,
					scale = 0.4,
					shift = { -1.4, 0 },
					animation_speed = 0.2,
					run_mode = "forward",
				},
				light = { intensity = 0.4, size = 6 },
			},
		},
	}

	return graphics_set
end

return AlgaeFarmGraphicsPack
