local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.SeparatorGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local SeparatorGraphicsPack = {}
SeparatorGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(SeparatorGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Angels.SeparatorGraphicsPackParams
---@field tint data.Color?

---@param params Reskins.Angels.SeparatorGraphicsPackParams
---@return Reskins.Angels.SeparatorGraphicsPack
---@nodiscard
function SeparatorGraphicsPack:configure(params)
	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		remnants = {},
		required_assets = {
			[_defines.assets.petrochem_graphics] = true,
		},
		nominal_width = 5,
		nominal_height = 5,
		graphics_set = self.get_graphics_set(params.tint),
		graphics_set_flipped = {},
		fluid_boxes = {},
		fluid_boxes_off_when_no_fluid_recipe = false,
	}) --[[@as Reskins.Angels.SeparatorGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, SeparatorGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function SeparatorGraphicsPack.get_graphics_set(tint)
	local animation = {
		layers = {
			-- Base
			{
				filename = "__angelspetrochemgraphics__/graphics/entity/separator/separator.png",
				priority = "extra-high",
				width = 224,
				height = 224,
				shift = { 0, 0 },
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/separator/separator-mask.png",
			priority = "extra-high",
			width = 224,
			height = 224,
			shift = { 0, 0 },
			tint = tint,
		})
		table.insert(animation.layers, {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/separator/separator-highlights.png",
			priority = "extra-high",
			width = 224,
			height = 224,
			shift = { 0, 0 },
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

return SeparatorGraphicsPack
