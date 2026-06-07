local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.OreFlotationCellGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local OreFlotationCellGraphicsPack = {}
OreFlotationCellGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(OreFlotationCellGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Angels.OreFlotationCellGraphicsPackParams
---@field tint data.Color?

---@param params Reskins.Angels.OreFlotationCellGraphicsPackParams
---@return Reskins.Angels.OreFlotationCellGraphicsPack
---@nodiscard
function OreFlotationCellGraphicsPack:configure(params)
	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		required_assets = {
			[_defines.assets.refining_graphics] = true,
		},
		nominal_width = 5,
		nominal_height = 5,
		graphics_set = self.get_graphics_set(params.tint),
	}) --[[@as Reskins.Angels.OreFlotationCellGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, OreFlotationCellGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function OreFlotationCellGraphicsPack.get_graphics_set(tint)
	local working_visualisations = {
		{
			always_draw = true,
			animation = {
				filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/ore-flotation-cell-animation-idle.png",
				priority = "extra-high",
				width = 166,
				height = 117,
				frame_count = 32,
				line_length = 8,
				shift = util.by_pixel_hr(62, 5),
				scale = 0.5,
			},
		},
		{
			fadeout = true,
			animation = {
				filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/ore-flotation-cell-animation-base.png",
				priority = "extra-high",
				width = 166,
				height = 117,
				frame_count = 64,
				line_length = 8,
				shift = util.by_pixel_hr(62, 5),
				scale = 0.5,
			},
		},
		{
			fadeout = true,
			apply_recipe_tint = "primary",
			animation = {
				filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/ore-flotation-cell-animation-water-tintable.png",
				priority = "extra-high",
				width = 166,
				height = 117,
				frame_count = 64,
				line_length = 8,
				shift = util.by_pixel_hr(62, 5),
				scale = 0.5,
			},
		},
		{
			fadeout = true,
			apply_recipe_tint = "secondary",
			animation = {
				filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/ore-flotation-cell-animation-froth-tintable.png",
				priority = "extra-high",
				width = 166,
				height = 117,
				frame_count = 64,
				line_length = 8,
				shift = util.by_pixel_hr(62, 5),
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
						filename = "__reskins-assets-angels__/graphics/entity/ore-flotation-cell/ore-flotation-cell-mask.png",
						priority = "extra-high",
						width = 333,
						height = 363,
						shift = util.by_pixel_hr(-1, -1),
						tint = tint,
						scale = 0.5,
					},
					-- Highlights
					{
						filename = "__reskins-assets-angels__/graphics/entity/ore-flotation-cell/ore-flotation-cell-highlights.png",
						priority = "extra-high",
						width = 333,
						height = 363,
						shift = util.by_pixel_hr(-1, -1),
						blend_mode = "additive-soft",
						scale = 0.5,
					},
				},
			},
		})
	end

	table.insert(working_visualisations, {
		always_draw = true,
		render_layer = "higher-object-under",
		north_animation = {
			filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/ore-flotation-cell-pipe-cover-overlays.png",
			priority = "extra-high",
			width = 333,
			height = 363,
			shift = util.by_pixel_hr(-1, -1),
			scale = 0.5,
		},
		east_animation = {
			filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/ore-flotation-cell-pipe-cover-overlays.png",
			priority = "extra-high",
			width = 333,
			height = 363,
			x = 333,
			shift = util.by_pixel_hr(-1, -1),
			scale = 0.5,
		},
		south_animation = {
			filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/ore-flotation-cell-pipe-cover-overlays.png",
			priority = "extra-high",
			width = 333,
			height = 363,
			shift = util.by_pixel_hr(-1, -1),
			scale = 0.5,
		},
		west_animation = {
			filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/ore-flotation-cell-pipe-cover-overlays.png",
			priority = "extra-high",
			width = 333,
			height = 363,
			x = 333,
			shift = util.by_pixel_hr(-1, -1),
			scale = 0.5,
		},
	})

	table.insert(working_visualisations, {
		always_draw = true,
		north_animation = {
			filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/vertical-pipe-shadow-patch.png",
			priority = "high",
			width = 128,
			height = 128,
			repeat_count = 36,
			draw_as_shadow = true,
			shift = { 0, -2 },
			scale = 0.5,
		},
		south_animation = {
			filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/vertical-pipe-shadow-patch.png",
			priority = "high",
			width = 128,
			height = 128,
			repeat_count = 36,
			draw_as_shadow = true,
			shift = { 0, -2 },
			scale = 0.5,
		},
	})

	---@type data.CraftingMachineGraphicsSet
	local graphics_set = {
		animation = {
			north = {
				layers = {
					{
						filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/ore-flotation-cell-base.png",
						priority = "extra-high",
						width = 333,
						height = 363,
						shift = util.by_pixel_hr(-1, -1),
						scale = 0.5,
					},
					{
						filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/ore-flotation-cell-shadow.png",
						priority = "extra-high",
						width = 390,
						height = 326,
						shift = util.by_pixel_hr(29, 18),
						draw_as_shadow = true,
						scale = 0.5,
					},
				},
			},
			east = {
				layers = {
					{
						filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/ore-flotation-cell-base.png",
						priority = "extra-high",
						width = 333,
						height = 363,
						x = 333,
						shift = util.by_pixel_hr(-1, -1),
						scale = 0.5,
					},
					{
						filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/ore-flotation-cell-shadow.png",
						priority = "extra-high",
						width = 390,
						height = 326,
						x = 390,
						shift = util.by_pixel_hr(29, 18),
						draw_as_shadow = true,
						scale = 0.5,
					},
				},
			},
			south = {
				layers = {
					{
						filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/ore-flotation-cell-base.png",
						priority = "extra-high",
						width = 333,
						height = 363,
						shift = util.by_pixel_hr(-1, -1),
						scale = 0.5,
					},
					{
						filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/ore-flotation-cell-shadow.png",
						priority = "extra-high",
						width = 390,
						height = 326,
						shift = util.by_pixel_hr(29, 18),
						draw_as_shadow = true,
						scale = 0.5,
					},
				},
			},
			west = {
				layers = {
					{
						filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/ore-flotation-cell-base.png",
						priority = "extra-high",
						width = 333,
						height = 363,
						x = 333,
						shift = util.by_pixel_hr(-1, -1),
						scale = 0.5,
					},
					{
						filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/ore-flotation-cell-shadow.png",
						priority = "extra-high",
						width = 390,
						height = 326,
						x = 390,
						shift = util.by_pixel_hr(29, 18),
						draw_as_shadow = true,
						scale = 0.5,
					},
				},
			},
		},
		working_visualisations = working_visualisations,
	}

	return graphics_set
end

return OreFlotationCellGraphicsPack
