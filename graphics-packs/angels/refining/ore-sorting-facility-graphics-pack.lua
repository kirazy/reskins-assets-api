local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.OreSortingFacilityGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local OreSortingFacilityGraphicsPack = {}
OreSortingFacilityGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(OreSortingFacilityGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Angels.OreSortingFacilityGraphicsPackParams
---@field tint data.Color?

---@param params Reskins.Angels.OreSortingFacilityGraphicsPackParams
---@return Reskins.Angels.OreSortingFacilityGraphicsPack
---@nodiscard
function OreSortingFacilityGraphicsPack:configure(params)
	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		remnants = {},
		required_assets = {
			[_defines.assets.refining_graphics] = true,
		},
		nominal_width = 7,
		nominal_height = 7,
		graphics_set = self.get_graphics_set(params.tint),
		graphics_set_flipped = {},
		fluid_boxes = {},
		fluid_boxes_off_when_no_fluid_recipe = false,
	}) --[[@as Reskins.Angels.OreSortingFacilityGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, OreSortingFacilityGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function OreSortingFacilityGraphicsPack.get_graphics_set(tint)
	local animation = {
		layers = {
			-- Base
			{
				filename = "__angelsrefininggraphics__/graphics/entity/ore-sorting-facility/ore-sorting-facility-base.png",
				priority = "extra-high",
				width = 449,
				height = 458,
				frame_count = 40,
				line_length = 10,
				shift = util.by_pixel(0, -2.5),
				animation_speed = 0.5,
				scale = 0.5,
			},
			-- Shadow
			{
				filename = "__angelsrefininggraphics__/graphics/entity/ore-sorting-facility/ore-sorting-facility-shadow.png",
				priority = "extra-high",
				width = 528,
				height = 356,
				repeat_count = 40,
				shift = util.by_pixel(21.5, 24.5),
				animation_speed = 0.5,
				draw_as_shadow = true,
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/ore-sorting-facility/ore-sorting-facility-mask.png",
			priority = "extra-high",
			width = 449,
			height = 458,
			frame_count = 40,
			line_length = 10,
			shift = util.by_pixel(0, -2.5),
			animation_speed = 0.5,
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers, {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/ore-sorting-facility/ore-sorting-facility-highlights.png",
			priority = "extra-high",
			width = 449,
			height = 458,
			frame_count = 40,
			line_length = 10,
			shift = util.by_pixel(0, -2.5),
			animation_speed = 0.5,
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

return OreSortingFacilityGraphicsPack
