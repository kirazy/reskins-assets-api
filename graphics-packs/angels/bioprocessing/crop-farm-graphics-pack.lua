local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.CropFarmGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local CropFarmGraphicsPack = {}
CropFarmGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(CropFarmGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Angels.CropFarmGraphicsParams:Reskins.Abstractions.BaseGraphicsParams
---@field variant "basic"|"temperate"|"desert"|"swamp"

---@param params Reskins.Angels.CropFarmGraphicsParams
---@return Reskins.Angels.CropFarmGraphicsPack
---@nodiscard
function CropFarmGraphicsPack:configure(params)
	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		scale = params.scale,
		scale_factor = params.scale_factor,
		required_assets = {
			[_defines.assets.bioprocessing_graphics] = true,
		},
		nominal_width = 5,
		nominal_height = 5,
		graphics_set = self.get_graphics_set(params.tint, params.variant),
	}) --[[@as Reskins.Angels.CropFarmGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, CropFarmGraphicsPack)
	return instance
end

local check_get_graphics_set = V.signature("get_graphics_set", {
	{ "tint", Common.color:optional() },
	{ "variant", V.one_of({ "basic", "temperate", "desert", "swamp" }) },
})

---@param tint data.Color?
---@param variant "basic"|"temperate"|"desert"|"swamp"
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function CropFarmGraphicsPack.get_graphics_set(tint, variant)
	check_get_graphics_set(tint, variant)

	local variant_data = {
		basic = {
			field_filename = "__angelsbioprocessinggraphics__/graphics/entity/crop-farm/field-basic.png",
			animation_filename = "__angelsbioprocessinggraphics__/graphics/entity/crop-farm/field-animation-1.png",
			animation_speed = 0.005,
		},
		temperate = {
			field_filename = "__angelsbioprocessinggraphics__/graphics/entity/crop-farm/field-temperate.png",
			animation_filename = "__angelsbioprocessinggraphics__/graphics/entity/crop-farm/field-animation-2.png",
			animation_speed = 0.01,
		},
		desert = {
			field_filename = "__angelsbioprocessinggraphics__/graphics/entity/crop-farm/field-desert.png",
			animation_filename = "__angelsbioprocessinggraphics__/graphics/entity/crop-farm/field-animation-3.png",
			animation_speed = 0.01,
		},
		swamp = {
			field_filename = "__angelsbioprocessinggraphics__/graphics/entity/crop-farm/field-water.png",
			animation_filename = "__angelsbioprocessinggraphics__/graphics/entity/crop-farm/field-animation-4.png",
			animation_speed = 0.01,
		},
	}

	local data = variant_data[variant]

	local working_visualisations = {
		{
			apply_recipe_tint = "primary",
			animation = {
				filename = data.animation_filename,
				line_length = 6,
				frame_count = 36,
				width = 224,
				height = 224,
				shift = { 0, 0 },
				animation_speed = data.animation_speed,
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
						filename = "__reskins-assets-angels__/graphics/entity/field/field-mask.png",
						priority = "extra-high",
						width = 224,
						height = 224,
						shift = { 0, 0 },
						tint = tint,
					},
					-- Highlights
					{
						filename = "__reskins-assets-angels__/graphics/entity/field/field-highlights.png",
						priority = "extra-high",
						width = 224,
						height = 224,
						shift = { 0, 0 },
						blend_mode = "additive-soft",
					},
				},
			},
		})
	end

	---@type data.CraftingMachineGraphicsSet
	local graphics_set = {
		animation = {
			layers = {
				{
					filename = "__angelsbioprocessinggraphics__/graphics/entity/crop-farm/farm-base.png",
					width = 224,
					height = 224,
					line_length = 1,
					frame_count = 1,
					shift = { 0, 0 },
				},
				{
					filename = data.field_filename,
					width = 224,
					height = 224,
					line_length = 1,
					frame_count = 1,
					shift = { 0, 0 },
				},
			},
		},
		working_visualisations = working_visualisations,
	}

	return graphics_set
end

return CropFarmGraphicsPack
