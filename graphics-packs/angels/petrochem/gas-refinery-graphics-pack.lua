local _defines = require("api.defines")
local _sprites = require("__reskins-sprite-utils__.sprites")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.GasRefineryGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local GasRefineryGraphicsPack = {}
GasRefineryGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(GasRefineryGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Angels.GasRefineryGraphicsPackParams
---@field tint data.Color?

---@param params Reskins.Angels.GasRefineryGraphicsPackParams
---@return Reskins.Angels.GasRefineryGraphicsPack
---@nodiscard
function GasRefineryGraphicsPack:configure(params)
	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		remnants = {},
		required_assets = {
			[_defines.assets.petrochem_graphics] = true,
		},
		nominal_width = 5,
		nominal_height = 5,
		graphics_set = self.get_graphics_set(params.tint),
		graphics_set_flipped = {},
		fluid_boxes = {},
		fluid_boxes_off_when_no_fluid_recipe = false,
	}) --[[@as Reskins.Angels.GasRefineryGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, GasRefineryGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function GasRefineryGraphicsPack.get_graphics_set(tint)
	local layers = {
		-- Base
		{
			filename = "__angelspetrochemgraphics__/graphics/entity/gas-refinery/gas-refinery-base.png",
			priority = "extra-high",
			width = 334,
			height = 553,
			shift = util.by_pixel(0, -48),
			scale = 0.5,
		},
		-- Shadow
		{
			filename = "__angelspetrochemgraphics__/graphics/entity/gas-refinery/gas-refinery-shadow.png",
			priority = "extra-high",
			width = 508,
			height = 338,
			shift = util.by_pixel(43.5, 6.5),
			draw_as_shadow = true,
			scale = 0.5,
		},
	}

	if tint then
		table.insert(layers, {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/gas-refinery/gas-refinery-mask.png",
			priority = "extra-high",
			width = 334,
			height = 553,
			shift = util.by_pixel(0, -48),
			tint = tint,
			scale = 0.5,
		})
		table.insert(layers, {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/gas-refinery/gas-refinery-highlights.png",
			priority = "extra-high",
			width = 334,
			height = 553,
			shift = util.by_pixel(0, -48),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	---@type data.CraftingMachineGraphicsSet
	local graphics_set = {
		animation = _sprites.make_4way_animation_from_spritesheet({ layers = layers }),
		working_visualisations = {
			{
				fadeout = true,
				constant_speed = true,
				north_position = util.by_pixel(-57.5, -152.5),
				east_position = util.by_pixel(49.5, -189.5),
				south_position = util.by_pixel(59, -69),
				west_position = util.by_pixel(-50, -62.5),
				animation = {
					filename = "__base__/graphics/entity/oil-refinery/oil-refinery-fire.png",
					line_length = 10,
					width = 40,
					height = 81,
					frame_count = 60,
					animation_speed = 0.75,
					draw_as_glow = true,
					scale = 0.5,
				},
			},
			{
				-- FIXME: Use make4way
				fadeout = true,
				north_animation = {
					filename = "__angelspetrochemgraphics__/graphics/entity/gas-refinery/gas-refinery-light.png",
					priority = "extra-high",
					width = 334,
					height = 553,
					frame_count = 1,
					shift = util.by_pixel(0, -48),
					blend_mode = "additive-soft",
					draw_as_glow = true,
					scale = 0.5,
				},
				east_animation = {
					filename = "__angelspetrochemgraphics__/graphics/entity/gas-refinery/gas-refinery-light.png",
					priority = "extra-high",
					width = 334,
					height = 553,
					x = 334,
					frame_count = 1,
					shift = util.by_pixel(0, -48),
					blend_mode = "additive-soft",
					draw_as_glow = true,
					scale = 0.5,
				},
				south_animation = {
					filename = "__angelspetrochemgraphics__/graphics/entity/gas-refinery/gas-refinery-light.png",
					priority = "extra-high",
					width = 334,
					height = 553,
					x = 668,
					frame_count = 1,
					shift = util.by_pixel(0, -48),
					blend_mode = "additive-soft",
					draw_as_glow = true,
					scale = 0.5,
				},
				west_animation = {
					filename = "__angelspetrochemgraphics__/graphics/entity/gas-refinery/gas-refinery-light.png",
					priority = "extra-high",
					width = 334,
					height = 553,
					x = 1002,
					frame_count = 1,
					shift = util.by_pixel(0, -48),
					blend_mode = "additive-soft",
					draw_as_glow = true,
					scale = 0.5,
				},
			},
			{
				-- FIXME: Use vertical pipe shadow
				always_draw = true,
				north_animation = {
					layers = {
						{
							draw_as_shadow = true,
							filename = "__angelspetrochemgraphics__/graphics/entity/gas-refinery/vertical-pipe-shadow-patch.png",
							priority = "high",
							width = 128,
							height = 128,
							repeat_count = 36,
							shift = { -2, -2 },
							scale = 0.5,
						},
						{
							draw_as_shadow = true,
							filename = "__angelspetrochemgraphics__/graphics/entity/gas-refinery/vertical-pipe-shadow-patch.png",
							priority = "high",
							width = 128,
							height = 128,
							repeat_count = 36,
							shift = { 0, -2 },
							scale = 0.5,
						},
						{
							draw_as_shadow = true,
							filename = "__angelspetrochemgraphics__/graphics/entity/gas-refinery/vertical-pipe-shadow-patch.png",
							priority = "high",
							width = 128,
							height = 128,
							repeat_count = 36,
							shift = { 2, -2 },
							scale = 0.5,
						},
					},
				},
				-- FIXME: Use vertical pipe shadow
				south_animation = {
					layers = {
						{
							draw_as_shadow = true,
							filename = "__angelspetrochemgraphics__/graphics/entity/gas-refinery/vertical-pipe-shadow-patch.png",
							priority = "high",
							width = 128,
							height = 128,
							repeat_count = 36,
							shift = { -2, 2 },
							scale = 0.5,
						},
						{
							draw_as_shadow = true,
							filename = "__angelspetrochemgraphics__/graphics/entity/gas-refinery/vertical-pipe-shadow-patch.png",
							priority = "high",
							width = 128,
							height = 128,
							repeat_count = 36,
							shift = { 0, 2 },
							scale = 0.5,
						},
						{
							draw_as_shadow = true,
							filename = "__angelspetrochemgraphics__/graphics/entity/gas-refinery/vertical-pipe-shadow-patch.png",
							priority = "high",
							width = 128,
							height = 128,
							repeat_count = 36,
							shift = { 2, 2 },
							scale = 0.5,
						},
					},
				},
			},
		},
	}

	return graphics_set
end

return GasRefineryGraphicsPack
