local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.OreLeachingPlantGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local OreLeachingPlantGraphicsPack = {}
OreLeachingPlantGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(OreLeachingPlantGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

local pipe_pictures = {
	north = util.empty_sprite(),
	east = {
		filename = "__angelsrefininggraphics__/graphics/entity/ore-leaching-plant/pipe-east1.png",
		priority = "extra-high",
		width = 64,
		height = 64,
		scale = 0.5,
		shift = { -1, 0 },
	},
	south = {
		filename = "__angelsrefininggraphics__/graphics/entity/ore-leaching-plant/pipe-south.png",
		priority = "extra-high",
		width = 41,
		height = 40,
		shift = { 0.05, -0.375 },
	},
	west = util.empty_sprite(),
}

local mirrored_pipe_pictures = {
	north = {
		filename = "__angelsrefininggraphics__/graphics/entity/ore-leaching-plant/pipe-north2.png",
		priority = "extra-high",
		width = 64,
		height = 64,
		scale = 0.5,
		shift = { 0, 1 },
	},
	east = {
		filename = "__angelsrefininggraphics__/graphics/entity/ore-leaching-plant/pipe-east2.png",
		priority = "extra-high",
		width = 64,
		height = 64,
		scale = 0.5,
		shift = { -1, 0 },
	},
	south = {
		filename = "__angelsrefininggraphics__/graphics/entity/ore-leaching-plant/pipe-south.png",
		priority = "extra-high",
		width = 41,
		height = 40,
		shift = { 0.05, -0.375 },
	},
	west = {
		filename = "__angelsrefininggraphics__/graphics/entity/ore-leaching-plant/pipe-west2.png",
		priority = "extra-high",
		width = 64,
		height = 64,
		scale = 0.5,
		shift = { 1, 0 },
	},
}

---@class Reskins.Angels.OreLeachingPlantGraphicsPackParams
---@field tint data.Color?

---@param params Reskins.Angels.OreLeachingPlantGraphicsPackParams
---@return Reskins.Angels.OreLeachingPlantGraphicsPack
---@nodiscard
function OreLeachingPlantGraphicsPack:configure(params)
	---@type FluidBoxGraphics
	local fluid_box = {
		pipe_picture = pipe_pictures,
		mirrored_pipe_picture = mirrored_pipe_pictures,
	}

	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		required_assets = {
			[_defines.assets.refining_graphics] = true,
		},
		nominal_width = 5,
		nominal_height = 5,
		graphics_set = self.get_graphics_set(params.tint),
		fluid_boxes = { fluid_box },
		fluid_boxes_off_when_no_fluid_recipe = false,
	}) --[[@as Reskins.Angels.OreLeachingPlantGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, OreLeachingPlantGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function OreLeachingPlantGraphicsPack.get_graphics_set(tint)
	local animation = {
		layers = {
			-- Base
			{
				filename = "__angelsrefininggraphics__/graphics/entity/ore-leaching-plant/1ore-leaching-plant.png",
				priority = "extra-high",
				width = 192,
				height = 192,
				shift = { 0.4, -0.14 },
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/ore-leaching-plant/ore-leaching-plant-mask.png",
			priority = "extra-high",
			width = 192,
			height = 192,
			shift = { 0.4, -0.14 },
			tint = tint,
		})
		table.insert(animation.layers, {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/ore-leaching-plant/ore-leaching-plant-highlights.png",
			priority = "extra-high",
			width = 192,
			height = 192,
			shift = { 0.4, -0.14 },
			blend_mode = "additive-soft",
		})
	end

	local shift_offset = util.by_pixel_hr(-63, -191)

	---@type data.CraftingMachineGraphicsSet
	local graphics_set = {
		animation = animation,
		working_visualisations = {
			{
				apply_recipe_tint = "primary",
				fadeout = true,
				constant_speed = true,
				render_layer = "wires",
				animation = {
					filename = "__base__/graphics/entity/chemical-plant/chemical-plant-smoke-outer.png",
					frame_count = 47,
					line_length = 16,
					width = 90,
					height = 188,
					animation_speed = 0.5,
					shift = util.add_shift(util.by_pixel(-2, -40), shift_offset),
					scale = 0.5,
				},
			},
			{
				apply_recipe_tint = "secondary",
				fadeout = true,
				constant_speed = true,
				render_layer = "wires",
				animation = {
					filename = "__base__/graphics/entity/chemical-plant/chemical-plant-smoke-inner.png",
					frame_count = 47,
					line_length = 16,
					width = 40,
					height = 84,
					animation_speed = 0.5,
					shift = util.add_shift(util.by_pixel(0, -14), shift_offset),
					scale = 0.5,
				},
			},
		},
	}

	return graphics_set
end

return OreLeachingPlantGraphicsPack
