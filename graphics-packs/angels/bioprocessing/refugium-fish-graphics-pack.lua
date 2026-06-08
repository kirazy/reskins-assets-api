local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.RefugiumFishGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local RefugiumFishGraphicsPack = {}
RefugiumFishGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(RefugiumFishGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Angels.RefugiumFishGraphicsParams:Reskins.Abstractions.BaseGraphicsParams

---@param params Reskins.Angels.RefugiumFishGraphicsParams
---@return Reskins.Angels.RefugiumFishGraphicsPack
---@nodiscard
function RefugiumFishGraphicsPack:configure(params)
	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		scale = params.scale,
		scale_factor = params.scale_factor,
		required_assets = {
			[_defines.assets.bioprocessing_graphics] = true,
		},
		nominal_width = 7,
		nominal_height = 7,
		graphics_set = self.get_graphics_set(params.tint),
	}) --[[@as Reskins.Angels.RefugiumFishGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, RefugiumFishGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function RefugiumFishGraphicsPack.get_graphics_set(tint, variant)
	local working_visualisations = {
		{
			animation = {
				filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-refugium/bio-refugium-fish.png",
				width = 288,
				height = 288,
				line_length = 7,
				frame_count = 49,
				shift = { 0, 0 },
				animation_speed = 49 / 90,
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
						filename = "__reskins-assets-angels__/graphics/entity/refugium-fish/refugium-fish-mask.png",
						priority = "extra-high",
						width = 288,
						height = 288,
						shift = { 0, 0 },
						tint = tint,
					},
					-- Highlights
					{
						filename = "__reskins-assets-angels__/graphics/entity/refugium-fish/refugium-fish-highlights.png",
						priority = "extra-high",
						width = 288,
						height = 288,
						shift = { 0, 0 },
						blend_mode = "additive-soft",
					},
				},
			},
		})
	end

	---@type data.CraftingMachineGraphicsSet
	return {
		animation = {
			layers = {
				{
					filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-refugium/bio-refugium-fish-shadow.png",
					width = 288,
					height = 288,
					line_length = 1,
					frame_count = 1,
					shift = { 0, 0 },
				},
				{
					filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-refugium/bio-refugium-fish-off.png",
					width = 288,
					height = 288,
					line_length = 1,
					frame_count = 1,
					shift = { 0, 0 },
				},
			},
		},
		working_visualisations = working_visualisations,
	}
end

return RefugiumFishGraphicsPack
