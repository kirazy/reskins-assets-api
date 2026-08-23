local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.LiquefierGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local LiquefierGraphicsPack = {}
LiquefierGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(LiquefierGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Angels.LiquefierGraphicsParams:Reskins.Abstractions.BaseGraphicsParams

---@param params Reskins.Angels.LiquefierGraphicsParams
---@return Reskins.Angels.LiquefierGraphicsPack
---@nodiscard
function LiquefierGraphicsPack:configure(params)
	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		scale = params.scale,
		scale_factor = params.scale_factor,
		required_assets = {
			[_defines.assets_source.refining_graphics] = true,
		},
		nominal_width = 3,
		nominal_height = 3,
		graphics_set = self.get_graphics_set(params.tint),
	}) --[[@as Reskins.Angels.LiquefierGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, LiquefierGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function LiquefierGraphicsPack.get_graphics_set(tint)
	local animation = {
		layers = {
			{
				-- cspell: disable-next-line
				filename = "__angelsrefininggraphics__/graphics/entity/liquifier/liquifier.png",
				width = 160,
				height = 160,
				line_length = 10,
				frame_count = 30,
				shift = { 0, 0 },
				animation_speed = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/liquefier/liquefier-mask.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			repeat_count = 30,
			shift = { 0, 0 },
			animation_speed = 0.5,
			tint = tint,
		})
		table.insert(animation.layers, {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/liquefier/liquefier-highlights.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			repeat_count = 30,
			shift = { 0, 0 },
			animation_speed = 0.5,
			blend_mode = "additive-soft",
		})
	end

	---@type data.CraftingMachineGraphicsSet
	local graphics_set = {
		animation = animation,
		working_visualisations = {},
	}

	return graphics_set
end

return LiquefierGraphicsPack
