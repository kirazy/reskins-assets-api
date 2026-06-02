local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.HatcheryGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local HatcheryGraphicsPack = {}
HatcheryGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(HatcheryGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Angels.HatcheryGraphicsPackParams
---@field tint data.Color?

---@param params Reskins.Angels.HatcheryGraphicsPackParams
---@return Reskins.Angels.HatcheryGraphicsPack
---@nodiscard
function HatcheryGraphicsPack:configure(params)
	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		remnants = {},
		required_assets = {
			[_defines.assets.bioprocessing_graphics] = true,
			[_defines.assets.angels_assets] = true,
		},
		nominal_width = 3,
		nominal_height = 3,
		graphics_set = self.get_graphics_set(params.tint),
		graphics_set_flipped = {},
		fluid_boxes = {},
		fluid_boxes_off_when_no_fluid_recipe = false,
	}) --[[@as Reskins.Angels.HatcheryGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, HatcheryGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function HatcheryGraphicsPack.get_graphics_set(tint)
	local animation = {
		layers = {
			-- Base
			{
				filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-hatchery/bio-hatchery-off.png",
				priority = "extra-high",
				width = 160,
				height = 160,
				shift = { 0, 0 },
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			-- Idle Mask
			filename = "__reskins-assets-angels__/graphics/entity/hatchery/hatchery-idle-mask.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			shift = { 0, 0 },
			tint = tint,
		})
		table.insert(animation.layers, {
			-- Idle Highlights
			filename = "__reskins-assets-angels__/graphics/entity/hatchery/hatchery-idle-highlights.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			shift = { 0, 0 },
			blend_mode = "additive-soft",
		})
	end

	local working_visualisations = {}

	if tint then
		table.insert(working_visualisations, {
			animation = {
				layers = {
					{
						filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-hatchery/bio-hatchery-animation.png",
						priority = "extra-high",
						width = 160,
						height = 160,
						frame_count = 25,
						line_length = 5,
						shift = { 0, 0 },
						animation_speed = 0.35,
					},
					{
						-- Working Mask
						filename = "__reskins-assets-angels__/graphics/entity/hatchery/hatchery-working-mask.png",
						priority = "extra-high",
						width = 160,
						height = 160,
						frame_count = 25,
						line_length = 5,
						shift = { 0, 0 },
						animation_speed = 0.35,
						tint = tint,
					},
					{
						-- Working Highlights
						filename = "__reskins-assets-angels__/graphics/entity/hatchery/hatchery-working-highlights.png",
						priority = "extra-high",
						width = 160,
						height = 160,
						frame_count = 25,
						line_length = 5,
						shift = { 0, 0 },
						animation_speed = 0.35,
						blend_mode = "additive-soft",
					},
				},
			},
		})
	end

	-- Shadow (always_draw, always required)
	table.insert(working_visualisations, {
		always_draw = true,
		animation = {
			filename = "__reskins-assets-angels__/graphics/entity/hatchery/hatchery-shadow.png",
			width = 160,
			height = 160,
			shift = { 0, 0 },
			draw_as_shadow = true,
		},
	})

	-- Lights (fadeout)
	table.insert(working_visualisations, {
		fadeout = true,
		animation = {
			filename = "__reskins-assets-angels__/graphics/entity/hatchery/hatchery-working-light.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			frame_count = 25,
			line_length = 5,
			shift = { 0, 0 },
			animation_speed = 0.35,
			draw_as_light = true,
		},
	})

	---@type data.CraftingMachineGraphicsSet
	local graphics_set = {
		animation = animation,
		working_visualisations = working_visualisations,
	}

	return graphics_set
end

return HatcheryGraphicsPack
