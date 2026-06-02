local _defines = require("api.defines")
local _sprites = require("__reskins-sprite-utils__.sprites")
local _pipes = require("assets.base.entities.pipe-pictures")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.AdvancedGasRefineryGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local AdvancedGasRefineryGraphicsPack = {}
AdvancedGasRefineryGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(AdvancedGasRefineryGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Angels.AdvancedGasRefineryGraphicsPackParams
---@field tint data.Color?

---@param params Reskins.Angels.AdvancedGasRefineryGraphicsPackParams
---@return Reskins.Angels.AdvancedGasRefineryGraphicsPack
---@nodiscard
function AdvancedGasRefineryGraphicsPack:configure(params)
	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		remnants = {},
		required_assets = {
			[_defines.assets.petrochem_graphics] = true,
		},
		nominal_width = 7,
		nominal_height = 7,
		graphics_set = self.get_graphics_set(params.tint),
		graphics_set_flipped = {},
		fluid_boxes = {},
		fluid_boxes_off_when_no_fluid_recipe = false,
	}) --[[@as Reskins.Angels.AdvancedGasRefineryGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, AdvancedGasRefineryGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function AdvancedGasRefineryGraphicsPack.get_graphics_set(tint)
	local layers = {
		-- Base
		{
			filename = "__angelspetrochemgraphics__/graphics/entity/advanced-gas-refinery/advanced-gas-refinery-base.png",
			priority = "extra-high",
			width = 462,
			height = 657,
			shift = util.by_pixel(0, -42),
			scale = 0.5,
		},
		-- Shadow
		{
			filename = "__angelspetrochemgraphics__/graphics/entity/advanced-gas-refinery/advanced-gas-refinery-shadow.png",
			priority = "extra-high",
			vertically_oriented = true,
			width = 655,
			height = 454,
			shift = util.by_pixel(48.5, 9.5),
			draw_as_shadow = true,
			scale = 0.5,
		},
	}

	if tint then
		table.insert(layers, {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/gas-refinery-advanced/gas-refinery-advanced-mask.png",
			priority = "extra-high",
			width = 462,
			height = 657,
			shift = util.by_pixel(0, -42),
			tint = tint,
			scale = 0.5,
		})
		table.insert(layers, {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/gas-refinery-advanced/gas-refinery-advanced-highlights.png",
			priority = "extra-high",
			width = 462,
			height = 657,
			shift = util.by_pixel(0, -42),
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
				north_position = util.by_pixel(-89, -136.5),
				east_position = util.by_pixel(34.5, -207.5),
				south_position = util.by_pixel(90.5, -94),
				west_position = util.by_pixel(-16, -35),
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
				fadeout = true,
				-- Convert this to use make4way
				north_animation = {
					filename = "__angelspetrochemgraphics__/graphics/entity/advanced-gas-refinery/advanced-gas-refinery-light.png",
					priority = "high",
					width = 462,
					height = 657,
					shift = util.by_pixel(0, -42),
					blend_mode = "additive-soft",
					draw_as_glow = true,
					scale = 0.5,
				},
				east_animation = {
					filename = "__angelspetrochemgraphics__/graphics/entity/advanced-gas-refinery/advanced-gas-refinery-light.png",
					priority = "high",
					width = 462,
					height = 657,
					x = 462,
					shift = util.by_pixel(0, -42),
					blend_mode = "additive-soft",
					draw_as_glow = true,
					scale = 0.5,
				},
				south_animation = {
					filename = "__angelspetrochemgraphics__/graphics/entity/advanced-gas-refinery/advanced-gas-refinery-light.png",
					priority = "high",
					width = 462,
					height = 657,
					x = 924,
					shift = util.by_pixel(0, -42),
					blend_mode = "additive-soft",
					draw_as_glow = true,
					scale = 0.5,
				},
				west_animation = {
					filename = "__angelspetrochemgraphics__/graphics/entity/advanced-gas-refinery/advanced-gas-refinery-light.png",
					priority = "high",
					width = 462,
					height = 657,
					x = 1386,
					shift = util.by_pixel(0, -42),
					blend_mode = "additive-soft",
					draw_as_glow = true,
					scale = 0.5,
				},
			},
			{
				always_draw = true,
				north_animation = {
					layers = {
						_pipes.vertical_pipe_shadow({ -1, -3 }),
						(_pipes.vertical_pipe_shadow({ 3, -3 })),
					},
				},
				south_animation = {
					layers = {
						_pipes.vertical_pipe_shadow({ -3, 3 }),
						_pipes.vertical_pipe_shadow({ -1, 3 }),
						(_pipes.vertical_pipe_shadow({ 1, 3 })),
					},
				},
			},
		},
	}

	return graphics_set
end

return AdvancedGasRefineryGraphicsPack
