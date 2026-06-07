local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.SalinationPlantGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local SalinationPlantGraphicsPack = {}
SalinationPlantGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(SalinationPlantGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

local pipe_pictures = {
	north = util.empty_sprite(),
	east = util.empty_sprite(),
	south = util.empty_sprite(),
	west = util.empty_sprite(),
}

local mirrored_pipe_pictures = {
	north = util.empty_sprite(),
	east = {
		filename = "__angelsrefininggraphics__/graphics/entity/salination-plant/pipe-east2.png",
		priority = "extra-high",
		width = 128,
		height = 128,
		scale = 0.5,
		shift = { -1, 0 },
	},
	south = util.empty_sprite(),
	west = util.empty_sprite(),
}

---@class Reskins.Angels.SalinationPlantGraphicsPackParams
---@field tint data.Color?

---@param params Reskins.Angels.SalinationPlantGraphicsPackParams
---@return Reskins.Angels.SalinationPlantGraphicsPack
---@nodiscard
function SalinationPlantGraphicsPack:configure(params)
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
		nominal_width = 7,
		nominal_height = 7,
		graphics_set = self.get_graphics_set(params.tint),
		fluid_boxes = { fluid_box },
		fluid_boxes_off_when_no_fluid_recipe = false,
	}) --[[@as Reskins.Angels.SalinationPlantGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, SalinationPlantGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function SalinationPlantGraphicsPack.get_graphics_set(tint)
	local animation = {
		layers = {
			-- Base
			{
				filename = "__angelsrefininggraphics__/graphics/entity/salination-plant/salination-plant-base.png",
				priority = "extra-high",
				width = 484,
				height = 540,
				frame_count = 36,
				line_length = 6,
				shift = util.by_pixel(-2.5, -12),
				animation_speed = 0.5,
				scale = 0.5,
			},
			-- Shadow
			{
				filename = "__angelsrefininggraphics__/graphics/entity/salination-plant/salination-plant-shadow.png",
				priority = "extra-high",
				width = 509,
				height = 467,
				repeat_count = 36,
				shift = util.by_pixel(10, 6.5),
				draw_as_shadow = true,
				animation_speed = 0.5,
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/salination-plant/salination-plant-mask.png",
			priority = "extra-high",
			width = 484,
			height = 540,
			repeat_count = 36,
			shift = util.by_pixel(-2.5, -12),
			tint = tint,
			animation_speed = 0.5,
			scale = 0.5,
		})
		table.insert(animation.layers, {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/salination-plant/salination-plant-highlights.png",
			priority = "extra-high",
			width = 484,
			height = 540,
			repeat_count = 36,
			shift = util.by_pixel(-2.5, -12),
			blend_mode = "additive-soft",
			animation_speed = 0.5,
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

return SalinationPlantGraphicsPack
