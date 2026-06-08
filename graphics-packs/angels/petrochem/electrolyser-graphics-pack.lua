local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.ElectrolyserGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local ElectrolyserGraphicsPack = {}
ElectrolyserGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(ElectrolyserGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

local entity_horizontal_base = {
	filename = "__angelspetrochemgraphics__/graphics/entity/electrolyser/electrolyser-east.png",
	width = 224,
	height = 224,
	frame_count = 36,
	line_length = 6,
	shift = { 0, 0 },
	animation_speed = 0.5,
}

local entity_vertical_base = {
	filename = "__angelspetrochemgraphics__/graphics/entity/electrolyser/electrolyser-north.png",
	priority = "extra-high",
	width = 224,
	height = 224,
	frame_count = 36,
	line_length = 6,
	shift = { 0, 0 },
	animation_speed = 0.5,
}

local pipe_pictures = {
	north = util.empty_sprite(),
	east = util.empty_sprite(),
	south = {
		filename = "__angelspetrochemgraphics__/graphics/entity/electrolyser/pipe-south.png",
		priority = "extra-high",
		width = 41,
		height = 40,
		shift = util.by_pixel(5, -8),
	},
	west = util.empty_sprite(),
}

---@class Reskins.Angels.ElectrolyserGraphicsParams:Reskins.Abstractions.BaseGraphicsParams

---@param params Reskins.Angels.ElectrolyserGraphicsParams
---@return Reskins.Angels.ElectrolyserGraphicsPack
---@nodiscard
function ElectrolyserGraphicsPack:configure(params)
	---@type FluidBoxGraphics
	local fluid_box = {
		pipe_picture = pipe_pictures,
	}

	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		scale = params.scale,
		scale_factor = params.scale_factor,
		required_assets = {
			[_defines.assets.petrochem_graphics] = true,
		},
		nominal_width = 5,
		nominal_height = 5,
		graphics_set = self.get_graphics_set(params.tint),
		fluid_boxes = { fluid_box },
		fluid_boxes_off_when_no_fluid_recipe = false,
	}) --[[@as Reskins.Angels.ElectrolyserGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, ElectrolyserGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function ElectrolyserGraphicsPack.get_graphics_set(tint)
	local animation = {
		north = { layers = { entity_vertical_base } },
		east = { layers = { entity_horizontal_base } },
		south = { layers = { entity_vertical_base } },
		west = { layers = { entity_horizontal_base } },
	}

	if tint then
		local entity_mask = {
			filename = "__reskins-assets-angels__/graphics/entity/electrolyser/electrolyser-mask.png",
			priority = "extra-high",
			width = 224,
			height = 224,
			frame_count = 36,
			line_length = 6,
			shift = { 0, 0 },
			animation_speed = 0.5,
			tint = tint,
		}
		local entity_highlights = {
			filename = "__reskins-assets-angels__/graphics/entity/electrolyser/electrolyser-highlights.png",
			priority = "extra-high",
			width = 224,
			height = 224,
			frame_count = 36,
			line_length = 6,
			shift = { 0, 0 },
			animation_speed = 0.5,
			blend_mode = "additive-soft",
		}
		table.insert(animation.north.layers, entity_mask)
		table.insert(animation.north.layers, entity_highlights)
		table.insert(animation.east.layers, entity_mask)
		table.insert(animation.east.layers, entity_highlights)
		table.insert(animation.south.layers, entity_mask)
		table.insert(animation.south.layers, entity_highlights)
		table.insert(animation.west.layers, entity_mask)
		table.insert(animation.west.layers, entity_highlights)
	end

	---@type data.CraftingMachineGraphicsSet
	local graphics_set = {
		animation = animation,
		working_visualisations = {},
	}

	return graphics_set
end

return ElectrolyserGraphicsPack
