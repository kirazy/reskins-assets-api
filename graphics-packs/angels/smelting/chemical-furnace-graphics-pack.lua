local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.ChemicalFurnaceGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local ChemicalFurnaceGraphicsPack = {}
ChemicalFurnaceGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(ChemicalFurnaceGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Angels.ChemicalFurnaceGraphicsParams:Reskins.Abstractions.BaseGraphicsParams

---@param params Reskins.Angels.ChemicalFurnaceGraphicsParams
---@return Reskins.Angels.ChemicalFurnaceGraphicsPack
---@nodiscard
function ChemicalFurnaceGraphicsPack:configure(params)
	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		scale = params.scale,
		scale_factor = params.scale_factor,
		required_assets = {
			[_defines.assets.smelting_graphics] = true,
		},
		nominal_width = 5,
		nominal_height = 5,
		graphics_set = self.get_graphics_set(params.tint),
	}) --[[@as Reskins.Angels.ChemicalFurnaceGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, ChemicalFurnaceGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function ChemicalFurnaceGraphicsPack.get_graphics_set(tint)
	local animation = {
		layers = {
			-- Base
			{
				priority = "extra-high",
				width = 332,
				height = 374,
				frame_count = 36,
				stripes = {
					{
						filename = "__angelssmeltinggraphics__/graphics/entity/chemical-furnace/chemical-furnace-base_01.png",
						width_in_frames = 6,
						height_in_frames = 3,
					},
					{
						filename = "__angelssmeltinggraphics__/graphics/entity/chemical-furnace/chemical-furnace-base_02.png",
						width_in_frames = 6,
						height_in_frames = 3,
					},
				},
				animation_speed = 0.5,
				shift = util.by_pixel(-1, -11.5),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			-- Mask
			priority = "extra-high",
			width = 332,
			height = 374,
			frame_count = 36,
			stripes = {
				{
					filename = "__reskins-assets-angels__/graphics/entity/chemical-furnace/chemical-furnace-mask-1.png",
					width_in_frames = 6,
					height_in_frames = 3,
				},
				{
					filename = "__reskins-assets-angels__/graphics/entity/chemical-furnace/chemical-furnace-mask-2.png",
					width_in_frames = 6,
					height_in_frames = 3,
				},
			},
			animation_speed = 0.5,
			tint = tint,
			shift = util.by_pixel(-1, -11.5),
			scale = 0.5,
		})
		table.insert(animation.layers, {
			-- Highlights
			priority = "extra-high",
			width = 332,
			height = 374,
			frame_count = 36,
			stripes = {
				{
					filename = "__reskins-assets-angels__/graphics/entity/chemical-furnace/chemical-furnace-highlights-1.png",
					width_in_frames = 6,
					height_in_frames = 3,
				},
				{
					filename = "__reskins-assets-angels__/graphics/entity/chemical-furnace/chemical-furnace-highlights-2.png",
					width_in_frames = 6,
					height_in_frames = 3,
				},
			},
			animation_speed = 0.5,
			blend_mode = "additive-soft",
			shift = util.by_pixel(-1, -11.5),
			scale = 0.5,
		})
	end

	table.insert(animation.layers, {
		-- Shadow
		priority = "extra-high",
		width = 448,
		height = 280,
		frame_count = 36,
		stripes = {
			{
				filename = "__angelssmeltinggraphics__/graphics/entity/chemical-furnace/chemical-furnace-shadow_01.png",
				width_in_frames = 4,
				height_in_frames = 7,
			},
			{
				filename = "__angelssmeltinggraphics__/graphics/entity/chemical-furnace/chemical-furnace-shadow_02.png",
				width_in_frames = 4,
				height_in_frames = 2,
			},
		},
		animation_speed = 0.5,
		draw_as_shadow = true,
		shift = util.by_pixel(28, 12.5),
		scale = 0.5,
	})

	---@type data.CraftingMachineGraphicsSet
	local graphics_set = {
		animation = animation,
		working_visualisations = {
			{
				always_draw = true,
				animation = {
					priority = "high",
					width = 332,
					height = 374,
					frame_count = 36,
					stripes = {
						{
							filename = "__angelssmeltinggraphics__/graphics/entity/chemical-furnace/chemical-furnace-light_01.png",
							width_in_frames = 6,
							height_in_frames = 3,
						},
						{
							filename = "__angelssmeltinggraphics__/graphics/entity/chemical-furnace/chemical-furnace-light_02.png",
							width_in_frames = 6,
							height_in_frames = 3,
						},
					},
					animation_speed = 0.5,
					shift = util.by_pixel(-1, -11.5),
					draw_as_light = true,
					scale = 0.5,
				},
			},
		},
	}

	return graphics_set
end

return ChemicalFurnaceGraphicsPack
