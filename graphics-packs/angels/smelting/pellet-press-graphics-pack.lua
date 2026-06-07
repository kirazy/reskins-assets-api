local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.PelletPressGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local PelletPressGraphicsPack = {}
PelletPressGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(PelletPressGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Angels.PelletPressGraphicsPackParams
---@field tint data.Color?

---@param params Reskins.Angels.PelletPressGraphicsPackParams
---@return Reskins.Angels.PelletPressGraphicsPack
---@nodiscard
function PelletPressGraphicsPack:configure(params)
	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		required_assets = {
			[_defines.assets.smelting_graphics] = true,
		},
		nominal_width = 3,
		nominal_height = 3,
		graphics_set = self.get_graphics_set(params.tint),
	}) --[[@as Reskins.Angels.PelletPressGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, PelletPressGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function PelletPressGraphicsPack.get_graphics_set(tint)
	local animation = {
		layers = {
			-- Base
			{
				filename = "__angelssmeltinggraphics__/graphics/entity/pellet-press/pellet-press-base.png",
				priority = "extra-high",
				width = 200,
				height = 199,
				line_length = 10,
				frame_count = 60,
				animation_speed = 0.5,
				shift = util.by_pixel(0, 0),
				scale = 0.5,
			},
			-- Shadow
			{
				filename = "__angelssmeltinggraphics__/graphics/entity/pellet-press/pellet-press-shadow.png",
				priority = "extra-high",
				width = 246,
				height = 132,
				line_length = 6,
				frame_count = 60,
				animation_speed = 0.5,
				draw_as_shadow = true,
				shift = util.by_pixel(12, 17),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/pellet-press/pellet-press-mask.png",
			priority = "extra-high",
			width = 200,
			height = 199,
			line_length = 10,
			frame_count = 60,
			animation_speed = 0.5,
			shift = util.by_pixel(0, 0),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers, {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/pellet-press/pellet-press-highlights.png",
			priority = "extra-high",
			width = 200,
			height = 199,
			line_length = 10,
			frame_count = 60,
			animation_speed = 0.5,
			shift = util.by_pixel(0, 0),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	---@type data.CraftingMachineGraphicsSet
	local graphics_set = {
		animation = animation,
		working_visualisations = {},
	}

	return graphics_set
end

return PelletPressGraphicsPack
