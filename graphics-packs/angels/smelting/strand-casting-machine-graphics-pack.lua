local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.StrandCastingMachineGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
---@field field Any
local StrandCastingMachineGraphicsPack = {}
StrandCastingMachineGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(StrandCastingMachineGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Angels.StrandCastingMachineGraphicsPackParams
---@field tint data.Color?

---@param params Reskins.Angels.StrandCastingMachineGraphicsPackParams
---@return Reskins.Angels.StrandCastingMachineGraphicsPack
---@nodiscard
function StrandCastingMachineGraphicsPack:configure(params)
	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		remnants = {},
		required_assets = {
			[_defines.assets.angels_assets] = true,
			[_defines.assets.smelting_graphics] = true,
		},
		nominal_width = 5,
		nominal_height = 5,
		graphics_set = self.get_graphics_set(params.tint),
	}) --[[@as Reskins.Angels.StrandCastingMachineGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, StrandCastingMachineGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function StrandCastingMachineGraphicsPack.get_graphics_set(tint)
	---@type data.WorkingVisualisations
	working_visualisations = {
		{
			always_draw = true,
			animation = {
				layers = {
					{
						filename = "__angelssmeltinggraphics__/graphics/entity/strand-casting-machine/strand-casting-machine-idle-state.png",
						priority = "high",
						width = 329,
						height = 392,
						shift = util.by_pixel(0, -16.5),
						scale = 0.5,
					},
					{
						filename = "__angelssmeltinggraphics__/graphics/entity/strand-casting-machine/strand-casting-machine-shadow.png",
						priority = "high",
						width = 444,
						height = 311,
						draw_as_shadow = true,
						shift = util.by_pixel(29.5, 3.5),
						scale = 0.5,
					},
				},
			},
		},
		{
			apply_recipe_tint = "primary",
			always_draw = true,
			animation = {
				filename = "__angelssmeltinggraphics__/graphics/entity/strand-casting-machine/strand-casting-machine-recipe-mask.png",
				priority = "high",
				width = 329,
				height = 392,
				shift = util.by_pixel(0, -16.5),
				scale = 0.5,
			},
		},
		{
			fadeout = true,
			animation = {
				filename = "__angelssmeltinggraphics__/graphics/entity/strand-casting-machine/strand-casting-machine-working-animation.png",
				priority = "high",
				width = 329,
				height = 392,
				line_length = 6,
				frame_count = 24,
				animation_speed = 0.5,
				shift = util.by_pixel(0, -16.5),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(working_visualisations, {
			always_draw = true,
			animation = {
				layers = {
					-- Mask
					{
						filename = "__reskins-assets-angels__/graphics/entity/strand-casting-machine/strand-casting-machine-mask.png",
						priority = "extra-high",
						width = 329,
						height = 392,
						shift = util.by_pixel(0, -16.5),
						tint = tint,
						scale = 0.5,
					},
					-- Highlights
					{
						filename = "__reskins-assets-angels__/graphics/entity/strand-casting-machine/strand-casting-machine-highlights.png",
						priority = "extra-high",
						width = 329,
						height = 392,
						shift = util.by_pixel(0, -16.5),
						blend_mode = "additive-soft",
						scale = 0.5,
					},
				},
			},
		})
	end

	table.insert(working_visualisations, {
		fadeout = true,
		animation = {
			filename = "__angelssmeltinggraphics__/graphics/entity/strand-casting-machine/strand-casting-machine-light.png",
			priority = "high",
			width = 329,
			height = 392,
			line_length = 6,
			frame_count = 24,
			animation_speed = 0.5,
			shift = util.by_pixel(0, -16.5),
			draw_as_light = true,
			scale = 0.5,
		},
	})

	---@type data.CraftingMachineGraphicsSet
	local graphics_set = {
		working_visualisations = working_visualisations,
	}

	return graphics_set
end

return StrandCastingMachineGraphicsPack
