local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.BlastFurnaceGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local BlastFurnaceGraphicsPack = {}
BlastFurnaceGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(BlastFurnaceGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Angels.BlastFurnaceGraphicsPackParams
---@field tint data.Color?

---@param params Reskins.Angels.BlastFurnaceGraphicsPackParams
---@return Reskins.Angels.BlastFurnaceGraphicsPack
---@nodiscard
function BlastFurnaceGraphicsPack:configure(params)
	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		required_assets = {
			[_defines.assets.smelting_graphics] = true,
		},
		nominal_width = 5,
		nominal_height = 5,
		graphics_set = self.get_graphics_set(params.tint),
	}) --[[@as Reskins.Angels.BlastFurnaceGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, BlastFurnaceGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function BlastFurnaceGraphicsPack.get_graphics_set(tint)
	local animation = {
		layers = {
			-- Base
			{
				filename = "__angelssmeltinggraphics__/graphics/entity/blast-furnace/blast-furnace-base.png",
				priority = "extra-high",
				width = 328,
				height = 376,
				shift = util.by_pixel(0, -13.5),
				scale = 0.5,
			},
			-- Shadow
			{
				filename = "__angelssmeltinggraphics__/graphics/entity/blast-furnace/blast-furnace-shadow.png",
				priority = "extra-high",
				width = 445,
				height = 245,
				shift = util.by_pixel(29, 19.5),
				draw_as_shadow = true,
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/blast-furnace/blast-furnace-mask.png",
			priority = "extra-high",
			width = 328,
			height = 376,
			shift = util.by_pixel(0, -13.5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers, {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/blast-furnace/blast-furnace-highlights.png",
			priority = "extra-high",
			width = 328,
			height = 376,
			shift = util.by_pixel(0, -13.5),
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
				north_position = { 0, 0 },
				east_position = { 0, 0 },
				south_position = { 0, 0 },
				west_position = { 0, 0 },
				animation = {
					filename = "__angelssmeltinggraphics__/graphics/entity/blast-furnace/blast-furnace-fire.png",
					priority = "high",
					width = 23,
					height = 50,
					line_length = 8,
					frame_count = 48,
					animation_speed = 0.5,
					shift = util.by_pixel(3, 29),
					draw_as_glow = true,
					scale = 0.5,
				},
			},
			{
				fadeout = true,
				north_position = { 0, 0 },
				east_position = { 0, 0 },
				south_position = { 0, 0 },
				west_position = { 0, 0 },
				effect = "flicker",
				animation = {
					filename = "__angelssmeltinggraphics__/graphics/entity/blast-furnace/blast-furnace-glow.png",
					priority = "high",
					width = 60,
					height = 43,
					blend_mode = "additive",
					shift = util.by_pixel(5, 39),
					draw_as_glow = true,
					scale = 0.75,
				},
			},
			{
				fadeout = true,
				north_position = { 0, 0 },
				east_position = { 0, 0 },
				south_position = { 0, 0 },
				west_position = { 0, 0 },
				effect = "flicker",
				animation = {
					filename = "__angelssmeltinggraphics__/graphics/entity/blast-furnace/blast-furnace-working-light.png",
					priority = "high",
					width = 328,
					height = 376,
					blend_mode = "additive",
					shift = util.by_pixel(0, -13.5),
					draw_as_glow = true,
					scale = 0.5,
				},
			},
		},
	}

	return graphics_set
end

return BlastFurnaceGraphicsPack
