local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.FiltrationUnitGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local FiltrationUnitGraphicsPack = {}
FiltrationUnitGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(FiltrationUnitGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

local pipe_pictures = {
	north = {
		filename = "__angelsrefininggraphics__/graphics/entity/filtration-unit/pipe-north1.png",
		priority = "extra-high",
		width = 68,
		height = 74,
		scale = 0.5,
		shift = { 0, 1 },
	},
	east = {
		filename = "__angelsrefininggraphics__/graphics/entity/filtration-unit/pipe-east.png",
		priority = "extra-high",
		width = 34,
		height = 47,
		shift = { -0.7, -0.1 },
	},
	south = {
		filename = "__angelsrefininggraphics__/graphics/entity/filtration-unit/pipe-south.png",
		priority = "extra-high",
		width = 34,
		height = 39,
		shift = { 0, -0.75 },
	},
	west = {
		filename = "__angelsrefininggraphics__/graphics/entity/filtration-unit/pipe-west.png",
		priority = "extra-high",
		width = 34,
		height = 47,
		shift = { 0.7, -0.1 },
	},
}

local mirrored_pipe_pictures = {
	north = {
		filename = "__angelsrefininggraphics__/graphics/entity/filtration-unit/pipe-north2.png",
		priority = "extra-high",
		width = 128,
		height = 128,
		scale = 0.5,
		shift = { 0, 1.5 },
	},
	east = {
		filename = "__angelsrefininggraphics__/graphics/entity/filtration-unit/pipe-east.png",
		priority = "extra-high",
		width = 34,
		height = 47,
		shift = { -0.7, -0.1 },
	},
	south = {
		filename = "__angelsrefininggraphics__/graphics/entity/filtration-unit/pipe-south.png",
		priority = "extra-high",
		width = 34,
		height = 39,
		shift = { 0, -0.75 },
	},
	west = {
		filename = "__angelsrefininggraphics__/graphics/entity/filtration-unit/pipe-west.png",
		priority = "extra-high",
		width = 34,
		height = 47,
		shift = { 0.7, -0.1 },
	},
}

---@class Reskins.Angels.FiltrationUnitGraphicsPackParams
---@field tint data.Color?

---@param params Reskins.Angels.FiltrationUnitGraphicsPackParams
---@return Reskins.Angels.FiltrationUnitGraphicsPack
---@nodiscard
function FiltrationUnitGraphicsPack:configure(params)
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
	}) --[[@as Reskins.Angels.FiltrationUnitGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, FiltrationUnitGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function FiltrationUnitGraphicsPack.get_graphics_set(tint)
	local animation = {
		layers = {
			-- Base
			{
				filename = "__angelsrefininggraphics__/graphics/entity/filtration-unit/filtration-unit.png",
				priority = "extra-high",
				width = 224,
				height = 224,
				shift = { 0, -0.2 },
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/filtration-unit/filtration-unit-mask.png",
			priority = "extra-high",
			width = 224,
			height = 224,
			shift = { 0, -0.2 },
			tint = tint,
		})
		table.insert(animation.layers, {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/filtration-unit/filtration-unit-highlights.png",
			priority = "extra-high",
			width = 224,
			height = 224,
			shift = { 0, -0.2 },
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

return FiltrationUnitGraphicsPack
