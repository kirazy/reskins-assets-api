local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.SinteringOvenGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local SinteringOvenGraphicsPack = {}
SinteringOvenGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(SinteringOvenGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Angels.SinteringOvenGraphicsParams:Reskins.Abstractions.BaseGraphicsParams

---@param params Reskins.Angels.SinteringOvenGraphicsParams
---@return Reskins.Angels.SinteringOvenGraphicsPack
---@nodiscard
function SinteringOvenGraphicsPack:configure(params)
	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		scale = params.scale,
		scale_factor = params.scale_factor,
		required_assets = {
			[_defines.assets_source.smelting_graphics] = true,
		},
		nominal_width = 5,
		nominal_height = 5,
		graphics_set = self.get_graphics_set(params.tint),
	}) --[[@as Reskins.Angels.SinteringOvenGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, SinteringOvenGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function SinteringOvenGraphicsPack.get_graphics_set(tint)
	local animation = {
		layers = {
			-- Base
			{
				filename = "__angelssmeltinggraphics__/graphics/entity/sintering-oven/sintering-oven-base.png",
				priority = "extra-high",
				width = 326,
				height = 350,
				shift = util.by_pixel(-1, -6.5),
				scale = 0.5,
			},
			-- Shadow
			{
				filename = "__angelssmeltinggraphics__/graphics/entity/sintering-oven/sintering-oven-shadow.png",
				priority = "extra-high",
				width = 424,
				height = 227,
				shift = util.by_pixel(23, 28),
				draw_as_shadow = true,
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/sintering-oven/sintering-oven-mask.png",
			priority = "extra-high",
			width = 326,
			height = 350,
			shift = util.by_pixel(-1, -6.5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers, {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/sintering-oven/sintering-oven-highlights.png",
			priority = "extra-high",
			width = 326,
			height = 350,
			shift = util.by_pixel(-1, -6.5),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	---@type data.CraftingMachineGraphicsSet
	local graphics_set = {
		animation = animation,
		working_visualisations = {
			{
				fadeout = true,
				effect = "uranium-glow",
				animation = {
					filename = "__angelssmeltinggraphics__/graphics/entity/sintering-oven/sintering-oven-glow.png",
					priority = "high",
					width = 326,
					height = 350,
					blend_mode = "additive",
					shift = util.by_pixel(-1, -6.5),
					draw_as_glow = true,
					scale = 0.5,
				},
			},
			{
				fadeout = true,
				effect = "uranium-glow",
				animation = {
					filename = "__angelssmeltinggraphics__/graphics/entity/sintering-oven/sintering-oven-light.png",
					priority = "high",
					width = 326,
					height = 350,
					shift = util.by_pixel(-1, -6.5),
					draw_as_light = true,
					scale = 0.5,
				},
			},
		},
	}

	return graphics_set
end

return SinteringOvenGraphicsPack
