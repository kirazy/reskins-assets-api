local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.OreRefineryGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local OreRefineryGraphicsPack = {}
OreRefineryGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(OreRefineryGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Angels.OreRefineryGraphicsPackParams
---@field tint data.Color?

---@param params Reskins.Angels.OreRefineryGraphicsPackParams
---@return Reskins.Angels.OreRefineryGraphicsPack
---@nodiscard
function OreRefineryGraphicsPack:configure(params)
	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		required_assets = {
			[_defines.assets.refining_graphics] = true,
		},
		nominal_width = 7,
		nominal_height = 7,
		graphics_set = self.get_graphics_set(params.tint),
	}) --[[@as Reskins.Angels.OreRefineryGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, OreRefineryGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function OreRefineryGraphicsPack.get_graphics_set(tint)
	local animation = {
		layers = {
			-- Base
			{
				filename = "__angelsrefininggraphics__/graphics/entity/ore-refinery/ore-refinery-base.png",
				priority = "extra-high",
				width = 440,
				height = 509,
				shift = util.by_pixel(0.5, -16),
				scale = 0.5,
			},
			-- Shadow
			{
				filename = "__angelsrefininggraphics__/graphics/entity/ore-refinery/ore-refinery-shadow.png",
				priority = "extra-high",
				width = 522,
				height = 340,
				shift = util.by_pixel(21.5, 29),
				draw_as_shadow = true,
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/ore-refinery/ore-refinery-mask.png",
			priority = "extra-high",
			width = 440,
			height = 509,
			shift = util.by_pixel(0.5, -16),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers, {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/ore-refinery/ore-refinery-highlights.png",
			priority = "extra-high",
			width = 440,
			height = 509,
			shift = util.by_pixel(0.5, -16),
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
					filename = "__angelsrefininggraphics__/graphics/entity/ore-refinery/ore-refinery-lights.png",
					priority = "extra-high",
					width = 440,
					height = 509,
					shift = util.by_pixel(0.5, -16),
					draw_as_glow = true,
					blend_mode = "additive-soft",
					scale = 0.5,
				},
			},
			{
				fadeout = true,
				constant_speed = true,
				apply_recipe_tint = "primary",
				north_position = util.by_pixel_hr(-63, -255),
				east_position = util.by_pixel_hr(-63, -255),
				south_position = util.by_pixel_hr(-63, -255),
				west_position = util.by_pixel_hr(-63, -255),
				render_layer = "wires",
				animation = {
					filename = "__base__/graphics/entity/chemical-plant/chemical-plant-smoke-outer.png",
					frame_count = 47,
					line_length = 16,
					width = 90,
					height = 188,
					animation_speed = 0.5,
					shift = util.by_pixel(-2, -40),
					tint = util.color("808080"),
					scale = 0.5,
				},
			},
			{
				fadeout = true,
				constant_speed = true,
				--apply_recipe_tint = "primary",
				north_position = util.by_pixel_hr(-63, -255),
				east_position = util.by_pixel_hr(-63, -255),
				south_position = util.by_pixel_hr(-63, -255),
				west_position = util.by_pixel_hr(-63, -255),
				render_layer = "wires",
				animation = {
					filename = "__base__/graphics/entity/chemical-plant/chemical-plant-smoke-inner.png",
					frame_count = 47,
					line_length = 16,
					width = 40,
					height = 84,
					animation_speed = 0.5,
					shift = util.by_pixel(0, -14),
					tint = util.color("b3b3b3"),
					scale = 0.5 * 1.2,
				},
			},
			{
				always_draw = true,
				apply_recipe_tint = "primary",
				render_layer = "wires",
				animation = {
					filename = "__angelsrefininggraphics__/graphics/entity/ore-refinery/stack-patch-overlay.png",
					priority = "extra-high",
					width = 46,
					height = 25,
					shift = util.by_pixel_hr(-61, -246),
					scale = 0.5,
				},
			},
		},
	}

	return graphics_set
end

return OreRefineryGraphicsPack
