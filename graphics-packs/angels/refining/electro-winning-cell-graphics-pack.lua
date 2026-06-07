local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.ElectroWinningCellGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local ElectroWinningCellGraphicsPack = {}
ElectroWinningCellGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(ElectroWinningCellGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

-- The ore-floatation-cell picture set is used only for the electro-winning-cell entity.
local pipe_pictures = {
	north = {
		filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/pipe-north.png",
		priority = "extra-high",
		width = 48,
		height = 48,
		shift = { 0.01, 0.95 },
	},
	east = {
		filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/pipe-east.png",
		priority = "extra-high",
		width = 40,
		height = 45,
		shift = { -0.71875, 0.1 },
	},
	south = {
		filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/pipe-south.png",
		priority = "extra-high",
		width = 34,
		height = 39,
		shift = { 0, -0.75 },
	},
	west = {
		filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/pipe-west.png",
		priority = "extra-high",
		width = 40,
		height = 45,
		shift = { 0.78125, 0.01 },
	},
}

---@class Reskins.Angels.ElectroWinningCellGraphicsPackParams
---@field tint data.Color?

---@param params Reskins.Angels.ElectroWinningCellGraphicsPackParams
---@return Reskins.Angels.ElectroWinningCellGraphicsPack
---@nodiscard
function ElectroWinningCellGraphicsPack:configure(params)
	---@type FluidBoxGraphics
	local fluid_box = {
		pipe_picture = pipe_pictures,
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
	}) --[[@as Reskins.Angels.ElectroWinningCellGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, ElectroWinningCellGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function ElectroWinningCellGraphicsPack.get_graphics_set(tint)
	local layers = {
		-- Base
		{
			-- cspell: disable-next-line
			filename = "__angelsrefininggraphics__/graphics/entity/electro-whinning-cell/electro-whinning-cell.png",
			priority = "extra-high",
			width = 224,
			height = 224,
			frame_count = 36,
			line_length = 6,
			shift = { 0, 0 },
			animation_speed = 0.5,
		},
	}

	if tint then
		table.insert(layers, {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/electro-winning-cell/electro-winning-cell-mask.png",
			priority = "extra-high",
			width = 224,
			height = 224,
			repeat_count = 36,
			shift = { 0, 0 },
			animation_speed = 0.5,
			tint = tint,
		})
		table.insert(layers, {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/electro-winning-cell/electro-winning-cell-highlights.png",
			priority = "extra-high",
			width = 224,
			height = 224,
			repeat_count = 36,
			shift = { 0, 0 },
			animation_speed = 0.5,
			blend_mode = "additive-soft",
		})
	end

	---@type data.CraftingMachineGraphicsSet
	local graphics_set = {
		animation = { layers = layers },
		working_visualisations = {},
	}

	return graphics_set
end

return ElectroWinningCellGraphicsPack
