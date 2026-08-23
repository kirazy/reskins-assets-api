local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.ComposterGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local ComposterGraphicsPack = {}
ComposterGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(ComposterGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Angels.ComposterGraphicsParams:Reskins.Abstractions.BaseGraphicsParams

---@param params Reskins.Angels.ComposterGraphicsParams
---@return Reskins.Angels.ComposterGraphicsPack
---@nodiscard
function ComposterGraphicsPack:configure(params)
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
	}) --[[@as Reskins.Angels.ComposterGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, ComposterGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function ComposterGraphicsPack.get_graphics_set(tint)
	local working_visualisations = {}

	if tint then
		table.insert(working_visualisations, {
			always_draw = true,
			animation = {
				layers = {
					-- Mask
					{
						filename = "__reskins-assets-angels__/graphics/entity/composter/composter-mask.png",
						priority = "extra-high",
						width = 160,
						height = 160,
						shift = { 0, 0 },
						tint = tint,
					},
					-- Highlights
					{
						filename = "__reskins-assets-angels__/graphics/entity/composter/composter-highlights.png",
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
			filename = "__angelsbioprocessinggraphics__/graphics/entity/composter/composter.png",
			width = 160,
			height = 160,
			frame_count = 1,
			line_length = 1,
			shift = { 0, 0 },
		},
		working_visualisations = working_visualisations,
	}

	return graphics_set
end

return ComposterGraphicsPack
