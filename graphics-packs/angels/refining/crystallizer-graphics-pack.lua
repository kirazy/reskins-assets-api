local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.CrystallizerGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local CrystallizerGraphicsPack = {}
CrystallizerGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(CrystallizerGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

local pipe_picture = {
	north = {
		filename = "__angelsrefininggraphics__/graphics/entity/crystallizer/crystallizer-pipe-connection.png",
		priority = "extra-high",
		size = 128,
		x = 0,
		shift = { 0, 1 },
		scale = 0.5,
	},
	east = {
		filename = "__angelsrefininggraphics__/graphics/entity/crystallizer/crystallizer-pipe-connection.png",
		priority = "extra-high",
		size = 128,
		x = 128,
		shift = { -1, 0 },
		scale = 0.5,
	},
	south = {
		filename = "__angelsrefininggraphics__/graphics/entity/crystallizer/crystallizer-pipe-connection.png",
		priority = "extra-high",
		size = 128,
		x = 256,
		shift = { 0, -1 },
		scale = 0.5,
	},
	west = {
		filename = "__angelsrefininggraphics__/graphics/entity/crystallizer/crystallizer-pipe-connection.png",
		priority = "extra-high",
		size = 128,
		x = 384,
		shift = { 1, 0 },
		scale = 0.5,
	},
}

---@class Reskins.Angels.CrystallizerGraphicsPackParams
---@field tint data.Color?

---@param params Reskins.Angels.CrystallizerGraphicsPackParams
---@return Reskins.Angels.CrystallizerGraphicsPack
---@nodiscard
function CrystallizerGraphicsPack:configure(params)
	---@type FluidBoxGraphics
	local fluid_box = {
		pipe_picture = pipe_picture,
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
	}) --[[@as Reskins.Angels.CrystallizerGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, CrystallizerGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function CrystallizerGraphicsPack.get_graphics_set(tint)
	local animation = {
		layers = {
			-- Base
			{
				filename = "__angelsrefininggraphics__/graphics/entity/crystallizer/crystallizer.png",
				priority = "extra-high",
				width = 390,
				height = 326,
				shift = util.by_pixel(16, 0),
				scale = 0.5,
			},
			-- Shadow
			{
				filename = "__angelsrefininggraphics__/graphics/entity/crystallizer/crystallizer-shadow.png",
				priority = "extra-high",
				width = 390,
				height = 326,
				shift = util.by_pixel(16, 0),
				draw_as_shadow = true,
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/crystallizer/crystallizer-mask.png",
			priority = "extra-high",
			width = 390,
			height = 326,
			shift = util.by_pixel(16, 0),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers, {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/crystallizer/crystallizer-highlights.png",
			priority = "extra-high",
			width = 390,
			height = 326,
			shift = util.by_pixel(16, 0),
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

return CrystallizerGraphicsPack
