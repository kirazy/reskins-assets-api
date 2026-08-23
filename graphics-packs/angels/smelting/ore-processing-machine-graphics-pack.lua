local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.OreProcessingMachineGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local OreProcessingMachineGraphicsPack = {}
OreProcessingMachineGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(OreProcessingMachineGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Angels.OreProcessingMachineGraphicsParams:Reskins.Abstractions.BaseGraphicsParams

---@param params Reskins.Angels.OreProcessingMachineGraphicsParams
---@return Reskins.Angels.OreProcessingMachineGraphicsPack
---@nodiscard
function OreProcessingMachineGraphicsPack:configure(params)
	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		scale = params.scale,
		scale_factor = params.scale_factor,
		required_assets = {
			[_defines.assets_source.smelting_graphics] = true,
		},
		nominal_width = 3,
		nominal_height = 3,
		graphics_set = self.get_graphics_set(params.tint),
	}) --[[@as Reskins.Angels.OreProcessingMachineGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, OreProcessingMachineGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function OreProcessingMachineGraphicsPack.get_graphics_set(tint)
	local animation = {
		layers = {
			-- Base
			{
				filename = "__angelssmeltinggraphics__/graphics/entity/ore-processing-machine/ore-processing-machine-base.png",
				priority = "extra-high",
				width = 196,
				height = 206,
				line_length = 5,
				frame_count = 25,
				animation_speed = 0.5,
				shift = util.by_pixel(-0.5, -2),
				scale = 0.5,
			},
			-- Shadow
			{
				filename = "__angelssmeltinggraphics__/graphics/entity/ore-processing-machine/ore-processing-machine-shadow.png",
				priority = "extra-high",
				width = 243,
				height = 137,
				repeat_count = 25,
				animation_speed = 0.5,
				draw_as_shadow = true,
				shift = util.by_pixel(12.5, 16),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/ore-processing-machine/ore-processing-machine-mask.png",
			priority = "extra-high",
			width = 196,
			height = 206,
			line_length = 5,
			frame_count = 25,
			animation_speed = 0.5,
			shift = util.by_pixel(-0.5, -2),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers, {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/ore-processing-machine/ore-processing-machine-highlights.png",
			priority = "extra-high",
			width = 196,
			height = 206,
			line_length = 5,
			frame_count = 25,
			animation_speed = 0.5,
			shift = util.by_pixel(-0.5, -2),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	---@type data.CraftingMachineGraphicsSet
	local graphics_set = {
		animation = animation,
		working_visualisations = {
			{
				fadeout = true,
				constant_speed = true,
				animation = {
					filename = "__angelssmeltinggraphics__/graphics/entity/ore-processing-machine/ore-processing-machine-dust.png",
					priority = "high",
					width = 107,
					height = 170,
					line_length = 5,
					frame_count = 20,
					animation_speed = 0.40,
					shift = util.by_pixel(0, -21.5),
					scale = 0.5,
				},
			},
			{
				apply_recipe_tint = "primary",
				fadeout = true,
				constant_speed = true,
				animation = {
					filename = "__angelssmeltinggraphics__/graphics/entity/ore-processing-machine/ore-processing-machine-dust.png",
					priority = "high",
					width = 107,
					height = 170,
					line_length = 5,
					frame_count = 20,
					animation_speed = 0.40,
					shift = util.by_pixel(0, -21.5),
					scale = 0.5,
				},
			},
			{
				always_draw = true,
				animation = {
					filename = "__angelssmeltinggraphics__/graphics/entity/ore-processing-machine/ore-processing-machine-top.png",
					priority = "high",
					width = 192,
					height = 139,
					shift = util.by_pixel(0, -22.5),
					scale = 0.5,
				},
			},
		},
	}

	return graphics_set
end

return OreProcessingMachineGraphicsPack
