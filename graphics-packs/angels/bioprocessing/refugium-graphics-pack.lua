local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.RefugiumGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local RefugiumGraphicsPack = {}
RefugiumGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(RefugiumGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Angels.RefugiumGraphicsPackParams
---@field tint data.Color?
---@field variant "fish"|"puffer"|"biter"

---@param params Reskins.Angels.RefugiumGraphicsPackParams
---@return Reskins.Angels.RefugiumGraphicsPack
---@nodiscard
function RefugiumGraphicsPack:configure(params)
	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		remnants = {},
		required_assets = {
			[_defines.assets.bioprocessing_graphics] = true,
		},
		nominal_width = 5,
		nominal_height = 5,
		graphics_set = self.get_graphics_set(params.tint, params.variant),
		graphics_set_flipped = {},
		fluid_boxes = {},
		fluid_boxes_off_when_no_fluid_recipe = false,
	}) --[[@as Reskins.Angels.RefugiumGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, RefugiumGraphicsPack)
	return instance
end

---@param tint data.Color?
---@param variant "fish"|"puffer"|"biter"
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function RefugiumGraphicsPack.get_graphics_set(tint, variant)
	if variant == "fish" then
		local working_visualisations = {
			{
				animation = {
					filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-refugium/bio-refugium-fish.png",
					width = 288,
					height = 288,
					line_length = 7,
					frame_count = 49,
					shift = { 0, 0 },
					animation_speed = 49 / 90,
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
							filename = "__reskins-assets-angels__/graphics/entity/refugium-fish/refugium-fish-mask.png",
							priority = "extra-high",
							width = 288,
							height = 288,
							shift = { 0, 0 },
							tint = tint,
						},
						-- Highlights
						{
							filename = "__reskins-assets-angels__/graphics/entity/refugium-fish/refugium-fish-highlights.png",
							priority = "extra-high",
							width = 288,
							height = 288,
							shift = { 0, 0 },
							blend_mode = "additive-soft",
						},
					},
				},
			})
		end

		---@type data.CraftingMachineGraphicsSet
		return {
			animation = {
				layers = {
					{
						filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-refugium/bio-refugium-fish-shadow.png",
						width = 288,
						height = 288,
						line_length = 1,
						frame_count = 1,
						shift = { 0, 0 },
					},
					{
						filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-refugium/bio-refugium-fish-off.png",
						width = 288,
						height = 288,
						line_length = 1,
						frame_count = 1,
						shift = { 0, 0 },
					},
				},
			},
			working_visualisations = working_visualisations,
		}
	elseif variant == "puffer" then
		local working_visualisations = {
			{
				animation = {
					filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-refugium/bio-refugium-puffer.png",
					width = 224,
					height = 256,
					line_length = 6,
					frame_count = 36,
					shift = { 0, -0.5 },
					animation_speed = 36 / 60,
				},
			},
		}

		if tint then
			table.insert(working_visualisations, {
				always_draw = true,
				animation = {
					layers = {
						-- Base patch
						{
							filename = "__reskins-assets-angels__/graphics/entity/refugium-puffer/refugium-puffer-base-patch.png",
							priority = "extra-high",
							width = 224,
							height = 256,
							shift = { 0, -0.5 },
						},
						-- Mask
						{
							filename = "__reskins-assets-angels__/graphics/entity/refugium-puffer/refugium-puffer-mask.png",
							priority = "extra-high",
							width = 224,
							height = 256,
							shift = { 0, -0.5 },
							tint = tint,
						},
						-- Highlights
						{
							filename = "__reskins-assets-angels__/graphics/entity/refugium-puffer/refugium-puffer-highlights.png",
							priority = "extra-high",
							width = 224,
							height = 256,
							shift = { 0, -0.5 },
							blend_mode = "additive-soft",
						},
					},
				},
			})
		end

		---@type data.CraftingMachineGraphicsSet
		return {
			animation = {
				filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-refugium/bio-refugium-puffer-off.png",
				width = 224,
				height = 256,
				line_length = 1,
				frame_count = 1,
				shift = { 0, -0.5 },
				animation_speed = 0.5,
			},
			working_visualisations = working_visualisations,
		}
	else -- biter
		local working_visualisations = {
			{
				animation = {
					filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-refugium/bio-refugium-biter.png",
					width = 288,
					height = 288,
					line_length = 4,
					frame_count = 16,
					shift = { 0, 0 },
					animation_speed = 0.5 * 0.75 / 2,
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
							filename = "__reskins-assets-angels__/graphics/entity/refugium-biter/refugium-biter-mask.png",
							priority = "extra-high",
							width = 288,
							height = 288,
							shift = { 0, 0 },
							tint = tint,
						},
						-- Highlights
						{
							filename = "__reskins-assets-angels__/graphics/entity/refugium-biter/refugium-biter-highlights.png",
							priority = "extra-high",
							width = 288,
							height = 288,
							shift = { 0, 0 },
							blend_mode = "additive-soft",
						},
					},
				},
			})
		end

		---@type data.CraftingMachineGraphicsSet
		return {
			animation = {
				filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-refugium/bio-refugium-biter-off.png",
				width = 288,
				height = 288,
				line_length = 1,
				frame_count = 1,
				shift = { 0, 0 },
			},
			working_visualisations = working_visualisations,
		}
	end
end

return RefugiumGraphicsPack
