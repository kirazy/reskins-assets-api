local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.RefugiumPufferGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local RefugiumPufferGraphicsPack = {}
RefugiumPufferGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(RefugiumPufferGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Angels.RefugiumPufferGraphicsParams:Reskins.Abstractions.BaseGraphicsParams

---@param params Reskins.Angels.RefugiumPufferGraphicsParams
---@return Reskins.Angels.RefugiumPufferGraphicsPack
---@nodiscard
function RefugiumPufferGraphicsPack:configure(params)
	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		scale = params.scale,
		scale_factor = params.scale_factor,
		required_assets = {
			[_defines.assets_source.bioprocessing_graphics] = true,
		},
		nominal_width = 5,
		nominal_height = 5,
		graphics_set = self.get_graphics_set(params.tint),
	}) --[[@as Reskins.Angels.RefugiumPufferGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, RefugiumPufferGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function RefugiumPufferGraphicsPack.get_graphics_set(tint)
	local working_visualisations = {
		{
			animation = {
				filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-refugium/bio-refugium-puffer.png",
				width = 224,
				height = 256,
				line_length = 6,
				frame_count = 36,
				shift = { 0, -0.5 },
				animation_speed = 36 / 60,
			},
		},
	}

	if tint then
		table.insert(working_visualisations, {
			always_draw = true,
			animation = {
				layers = {
					-- Base patch
					{
						filename = "__reskins-assets-angels__/graphics/entity/refugium-puffer/refugium-puffer-base-patch.png",
						priority = "extra-high",
						width = 224,
						height = 256,
						shift = { 0, -0.5 },
					},
					-- Mask
					{
						filename = "__reskins-assets-angels__/graphics/entity/refugium-puffer/refugium-puffer-mask.png",
						priority = "extra-high",
						width = 224,
						height = 256,
						shift = { 0, -0.5 },
						tint = tint,
					},
					-- Highlights
					{
						filename = "__reskins-assets-angels__/graphics/entity/refugium-puffer/refugium-puffer-highlights.png",
						priority = "extra-high",
						width = 224,
						height = 256,
						shift = { 0, -0.5 },
						blend_mode = "additive-soft",
					},
				},
			},
		})
	end

	---@type data.CraftingMachineGraphicsSet
	return {
		animation = {
			filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-refugium/bio-refugium-puffer-off.png",
			width = 224,
			height = 256,
			line_length = 1,
			frame_count = 1,
			shift = { 0, -0.5 },
			animation_speed = 0.5,
		},
		working_visualisations = working_visualisations,
	}
end

return RefugiumPufferGraphicsPack
