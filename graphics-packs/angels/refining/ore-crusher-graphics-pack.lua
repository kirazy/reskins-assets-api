local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.OreCrusherGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local OreCrusherGraphicsPack = {}
OreCrusherGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(OreCrusherGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Angels.OreCrusherGraphicsPackParams
---@field tint data.Color?

---@param params Reskins.Angels.OreCrusherGraphicsPackParams
---@return Reskins.Angels.OreCrusherGraphicsPack
---@nodiscard
function OreCrusherGraphicsPack:configure(params)
	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		required_assets = {
			[_defines.assets.refining_graphics] = true,
		},
		nominal_width = 3,
		nominal_height = 3,
		graphics_set = self.get_graphics_set(params.tint),
	}) --[[@as Reskins.Angels.OreCrusherGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, OreCrusherGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function OreCrusherGraphicsPack.get_graphics_set(tint)
	local animation = {
		layers = {
			-- Base
			{
				filename = "__angelsrefininggraphics__/graphics/entity/ore-crusher/ore-crusher-base.png",
				priority = "extra-high",
				width = 189,
				height = 214,
				frame_count = 16,
				line_length = 4,
				shift = util.by_pixel(-0.5, -5),
				animation_speed = 0.5,
				scale = 0.5,
			},
			-- Shadow
			{
				filename = "__angelsrefininggraphics__/graphics/entity/ore-crusher/ore-crusher-shadow.png",
				priority = "extra-high",
				width = 282,
				height = 140,
				repeat_count = 16,
				shift = util.by_pixel(24, 17.5),
				draw_as_shadow = true,
				animation_speed = 0.5,
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/ore-crusher/ore-crusher-mask.png",
			priority = "extra-high",
			width = 189,
			height = 214,
			repeat_count = 16,
			shift = util.by_pixel(-0.5, -5),
			tint = tint,
			animation_speed = 0.5,
			scale = 0.5,
		})
		table.insert(animation.layers, {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/ore-crusher/ore-crusher-highlights.png",
			priority = "extra-high",
			width = 189,
			height = 214,
			repeat_count = 16,
			shift = util.by_pixel(-0.5, -5),
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

return OreCrusherGraphicsPack
