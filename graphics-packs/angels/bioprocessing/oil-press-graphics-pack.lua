local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.OilPressGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local OilPressGraphicsPack = {}
OilPressGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(OilPressGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Angels.OilPressGraphicsParams:Reskins.Abstractions.BaseGraphicsParams

---@param params Reskins.Angels.OilPressGraphicsParams
---@return Reskins.Angels.OilPressGraphicsPack
---@nodiscard
function OilPressGraphicsPack:configure(params)
	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		scale = params.scale,
		scale_factor = params.scale_factor,
		required_assets = {
			[_defines.assets_source.bioprocessing_graphics] = true,
		},
		nominal_width = 3,
		nominal_height = 3,
		graphics_set = self.get_graphics_set(params.tint),
	}) --[[@as Reskins.Angels.OilPressGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, OilPressGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function OilPressGraphicsPack.get_graphics_set(tint)
	local layers = {
		-- Base
		{
			filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-press/bio-press.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			frame_count = 25,
			line_length = 5,
			shift = { 0, 0 },
			animation_speed = 0.5,
		},
	}

	if tint then
		table.insert(layers, {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/press/press-mask.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			repeat_count = 25,
			shift = { 0, 0 },
			animation_speed = 0.5,
			tint = tint,
		})
		table.insert(layers, {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/press/press-highlights.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			repeat_count = 25,
			shift = { 0, 0 },
			animation_speed = 0.5,
			blend_mode = "additive-soft",
		})
	end

	---@type data.CraftingMachineGraphicsSet
	local graphics_set = {
		animation = { layers = layers },
		working_visualisations = {},
	}

	return graphics_set
end

return OilPressGraphicsPack
