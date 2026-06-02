local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.AirFilterGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local AirFilterGraphicsPack = {}
AirFilterGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(AirFilterGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Angels.AirFilterGraphicsPackParams
---@field tint data.Color?

---@param params Reskins.Angels.AirFilterGraphicsPackParams
---@return Reskins.Angels.AirFilterGraphicsPack
---@nodiscard
function AirFilterGraphicsPack:configure(params)
	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		remnants = {},
		required_assets = {
			[_defines.assets.angels_assets] = true,
		},
		nominal_width = 5,
		nominal_height = 5,
		graphics_set = self.get_graphics_set(params.tint),
		graphics_set_flipped = {},
		fluid_boxes = {},
		fluid_boxes_off_when_no_fluid_recipe = false,
	}) --[[@as Reskins.Angels.AirFilterGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, AirFilterGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function AirFilterGraphicsPack.get_graphics_set(tint)
	local animation = {
		layers = {
			-- Base
			{
				filename = "__reskins-assets-angels__/graphics/entity/air-filter/air-filter-base.png",
				priority = "extra-high",
				width = 256,
				height = 256,
				frame_count = 36,
				line_length = 6,
				shift = { 0.5, -0.5 },
				animation_speed = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/air-filter/air-filter-mask.png",
			priority = "extra-high",
			width = 256,
			height = 256,
			frame_count = 36,
			line_length = 6,
			shift = { 0.5, -0.5 },
			animation_speed = 0.5,
			tint = tint,
		})
		table.insert(animation.layers, {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/air-filter/air-filter-highlights.png",
			priority = "extra-high",
			width = 256,
			height = 256,
			frame_count = 36,
			line_length = 6,
			shift = { 0.5, -0.5 },
			animation_speed = 0.5,
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

return AirFilterGraphicsPack
