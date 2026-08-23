local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.RefugiumBiterGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local RefugiumBiterGraphicsPack = {}
RefugiumBiterGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(RefugiumBiterGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Angels.RefugiumBiterGraphicsParams:Reskins.Abstractions.BaseGraphicsParams

---@param params Reskins.Angels.RefugiumBiterGraphicsParams
---@return Reskins.Angels.RefugiumBiterGraphicsPack
---@nodiscard
function RefugiumBiterGraphicsPack:configure(params)
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
	}) --[[@as Reskins.Angels.RefugiumBiterGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, RefugiumBiterGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function RefugiumBiterGraphicsPack.get_graphics_set(tint)
	local working_visualisations = {
		{
			animation = {
				filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-refugium/bio-refugium-biter.png",
				width = 288,
				height = 288,
				line_length = 4,
				frame_count = 16,
				shift = { 0, 0 },
				animation_speed = 0.5 * 0.75 / 2,
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
						filename = "__reskins-assets-angels__/graphics/entity/refugium-biter/refugium-biter-mask.png",
						priority = "extra-high",
						width = 288,
						height = 288,
						shift = { 0, 0 },
						tint = tint,
					},
					-- Highlights
					{
						filename = "__reskins-assets-angels__/graphics/entity/refugium-biter/refugium-biter-highlights.png",
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
			filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-refugium/bio-refugium-biter-off.png",
			width = 288,
			height = 288,
			line_length = 1,
			frame_count = 1,
			shift = { 0, 0 },
		},
		working_visualisations = working_visualisations,
	}
end

return RefugiumBiterGraphicsPack
