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
		remnants = {},
		required_assets = {
			[_defines.assets.refining_graphics] = true,
		},
		nominal_width = 5,
		nominal_height = 5,
		graphics_set = self.get_graphics_set(params.tint),
		graphics_set_flipped = {},
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

	---@type data.CraftingMachineGraphicsSet
	local graphics_set = {
		animation = animation,
		working_visualisations = {},
	}

	return graphics_set
end

return OreLeachingPlantGraphicsPack
