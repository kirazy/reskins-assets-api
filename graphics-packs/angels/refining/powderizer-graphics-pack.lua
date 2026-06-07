local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.PowderizerGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local PowderizerGraphicsPack = {}
PowderizerGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(PowderizerGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Angels.PowderizerGraphicsPackParams
---@field tint data.Color?

---@param params Reskins.Angels.PowderizerGraphicsPackParams
---@return Reskins.Angels.PowderizerGraphicsPack
---@nodiscard
function PowderizerGraphicsPack:configure(params)
	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		required_assets = {
			[_defines.assets.refining_graphics] = true,
		},
		nominal_width = 2,
		nominal_height = 2,
		graphics_set = self.get_graphics_set(params.tint),
	}) --[[@as Reskins.Angels.PowderizerGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, PowderizerGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function PowderizerGraphicsPack.get_graphics_set(tint)
	local layers = {
		-- Base
		{
			filename = "__angelsrefininggraphics__/graphics/entity/ore-powderizer/powderizer.png",
			priority = "extra-high",
			width = 256,
			height = 256,
			frame_count = 36,
			line_length = 6,
			shift = { 0, 0 },
			animation_speed = 0.5,
			scale = 0.5,
		},
	}

	if tint then
		table.insert(layers, {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/powderizer/powderizer-mask.png",
			priority = "extra-high",
			width = 256,
			height = 256,
			repeat_count = 36,
			shift = { 0, 0 },
			animation_speed = 0.5,
			tint = tint,
			scale = 0.5,
		})
		table.insert(layers, {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/powderizer/powderizer-highlights.png",
			priority = "extra-high",
			width = 256,
			height = 256,
			repeat_count = 36,
			shift = { 0, 0 },
			animation_speed = 0.5,
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	---@type data.CraftingMachineGraphicsSet
	local graphics_set = {
		animation = { layers = layers },
		working_visualisations = {},
	}

	return graphics_set
end

return PowderizerGraphicsPack
