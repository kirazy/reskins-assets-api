local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.WashingPlantGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local WashingPlantGraphicsPack = {}
WashingPlantGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(WashingPlantGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Angels.WashingPlantGraphicsParams:Reskins.Abstractions.BaseGraphicsParams

---@param params Reskins.Angels.WashingPlantGraphicsParams
---@return Reskins.Angels.WashingPlantGraphicsPack
---@nodiscard
function WashingPlantGraphicsPack:configure(params)
	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		scale = params.scale,
		scale_factor = params.scale_factor,
		remnants = {},
		required_assets = {
			[_defines.assets.refining_graphics] = true,
			[_defines.assets.angels_assets] = true,
		},
		nominal_width = 5,
		nominal_height = 5,
		graphics_set = self.get_graphics_set(params.tint),
	}) --[[@as Reskins.Angels.WashingPlantGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, WashingPlantGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function WashingPlantGraphicsPack.get_graphics_set(tint)
	local animation = {
		layers = {
			-- Base
			{
				filename = "__angelsrefininggraphics__/graphics/entity/washing-plant/washing-plant.png",
				priority = "extra-high",
				width = 224,
				height = 224,
				frame_count = 25,
				line_length = 5,
				shift = { 0, 0 },
			},
			-- Base Patch
			{
				filename = "__reskins-assets-angels__/graphics/entity/washing-plant/washing-plant-base-patch.png",
				priority = "extra-high",
				width = 224,
				height = 224,
				repeat_count = 25,
				shift = { 0, 0 },
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/washing-plant/washing-plant-mask.png",
			priority = "extra-high",
			width = 224,
			height = 224,
			repeat_count = 25,
			shift = { 0, 0 },
			tint = tint,
		})
		table.insert(animation.layers, {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/washing-plant/washing-plant-highlights.png",
			priority = "extra-high",
			width = 224,
			height = 224,
			repeat_count = 25,
			shift = { 0, 0 },
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

return WashingPlantGraphicsPack
