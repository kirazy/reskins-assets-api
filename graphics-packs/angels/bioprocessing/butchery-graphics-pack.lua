local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.ButcheryGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local ButcheryGraphicsPack = {}
ButcheryGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(ButcheryGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Angels.ButcheryGraphicsParams:Reskins.Abstractions.BaseGraphicsParams

---@param params Reskins.Angels.ButcheryGraphicsParams
---@return Reskins.Angels.ButcheryGraphicsPack
---@nodiscard
function ButcheryGraphicsPack:configure(params)
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
	}) --[[@as Reskins.Angels.ButcheryGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, ButcheryGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function ButcheryGraphicsPack.get_graphics_set(tint)
	local working_visualisations = {}

	if tint then
		table.insert(working_visualisations, {
			always_draw = true,
			animation = {
				layers = {
					-- Base patch
					{
						filename = "__reskins-assets-angels__/graphics/entity/butchery/butchery-base-patch.png",
						priority = "extra-high",
						width = 160,
						height = 160,
						shift = { 0, 0 },
					},
					-- Mask
					{
						filename = "__reskins-assets-angels__/graphics/entity/butchery/butchery-mask.png",
						priority = "extra-high",
						width = 160,
						height = 160,
						shift = { 0, 0 },
						tint = tint,
					},
					-- Highlights
					{
						filename = "__reskins-assets-angels__/graphics/entity/butchery/butchery-highlights.png",
						priority = "extra-high",
						width = 160,
						height = 160,
						shift = { 0, 0 },
						blend_mode = "additive-soft",
					},
				},
			},
		})
	end

	---@type data.CraftingMachineGraphicsSet
	local graphics_set = {
		animation = {
			layers = {
				{
					filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-butchery/bio-butchery.png",
					width = 160,
					height = 160,
					frame_count = 36,
					line_length = 6,
					shift = { 0, 0 },
					animation_speed = 0.5,
				},
			},
		},
		working_visualisations = working_visualisations,
	}

	return graphics_set
end

return ButcheryGraphicsPack
