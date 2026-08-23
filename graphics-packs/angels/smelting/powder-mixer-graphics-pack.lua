local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.PowderMixerGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local PowderMixerGraphicsPack = {}
PowderMixerGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(PowderMixerGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Angels.PowderMixerGraphicsParams:Reskins.Abstractions.BaseGraphicsParams

---@param params Reskins.Angels.PowderMixerGraphicsParams
---@return Reskins.Angels.PowderMixerGraphicsPack
---@nodiscard
function PowderMixerGraphicsPack:configure(params)
	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		scale = params.scale,
		scale_factor = params.scale_factor,
		required_assets = {
			[_defines.assets_source.smelting_graphics] = true,
		},
		nominal_width = 2,
		nominal_height = 2,
		graphics_set = self.get_graphics_set(params.tint),
	}) --[[@as Reskins.Angels.PowderMixerGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, PowderMixerGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function PowderMixerGraphicsPack.get_graphics_set(tint)
	local animation = {
		layers = {
			-- Base
			{
				filename = "__angelssmeltinggraphics__/graphics/entity/powder-mixer/powder-mixer-base.png",
				priority = "extra-high",
				width = 138,
				height = 170,
				line_length = 4,
				frame_count = 4,
				animation_speed = 0.5,
				shift = util.by_pixel(0.5, -9.5),
				scale = 0.5,
			},
			-- Shadow
			{
				filename = "__angelssmeltinggraphics__/graphics/entity/powder-mixer/powder-mixer-shadow.png",
				priority = "extra-high",
				width = 183,
				height = 99,
				repeat_count = 4,
				animation_speed = 0.5,
				draw_as_shadow = true,
				shift = util.by_pixel(13, 9),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/powder-mixer/powder-mixer-mask.png",
			priority = "extra-high",
			width = 138,
			height = 170,
			line_length = 4,
			frame_count = 4,
			animation_speed = 0.5,
			shift = util.by_pixel(0.5, -9.5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers, {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/powder-mixer/powder-mixer-highlights.png",
			priority = "extra-high",
			width = 138,
			height = 170,
			line_length = 4,
			frame_count = 4,
			animation_speed = 0.5,
			shift = util.by_pixel(0.5, -9.5),
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

return PowderMixerGraphicsPack
