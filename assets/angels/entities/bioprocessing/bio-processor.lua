---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")

local M = {}

---@param tint Color?
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint)
	local working_visualisations = {
		{
			fadeout = true,
			apply_recipe_tint = "primary",
			animation = {
				filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-processor/bio-processor-bg.png",
				line_length = 5,
				frame_count = 25,
				width = 224,
				height = 224,
				shift = { 0, 0 },
				animation_speed = 0.5,
			},
		},
		{
			always_draw = true,
			animation = {
				filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-processor/bio-processor-trans.png",
				line_length = 5,
				frame_count = 25,
				width = 224,
				height = 224,
				shift = { 0, 0 },
				animation_speed = 0.5,
			},
		},
		{
			fadeout = true,
			apply_recipe_tint = "secondary",
			animation = {
				filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-processor/bio-processor-ani.png",
				line_length = 5,
				frame_count = 25,
				width = 224,
				height = 224,
				shift = { 0, 0 },
				animation_speed = 0.5,
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
						filename = "__reskins-assets-angels__/graphics/entity/bio-processor/bio-processor-mask.png",
						priority = "extra-high",
						width = 224,
						height = 224,
						line_length = 5,
						frame_count = 25,
						shift = { 0, 0 },
						animation_speed = 0.5,
						tint = tint,
					},
					-- Highlights
					{
						filename = "__reskins-assets-angels__/graphics/entity/bio-processor/bio-processor-highlights.png",
						priority = "extra-high",
						width = 224,
						height = 224,
						line_length = 5,
						frame_count = 25,
						shift = { 0, 0 },
						animation_speed = 0.5,
						blend_mode = "additive-soft",
					},
				},
			},
		})
	end

	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = {
			filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-processor/bio-processor.png",
			width = 224,
			height = 224,
			line_length = 5,
			frame_count = 25,
			shift = { 0, 0 },
			animation_speed = 0.5,
		},
		working_visualisations = working_visualisations,
	}

	return graphics_set
end

---@class BioProcessorSpriteSetParams
---@field tint Color?

---Produces the sprite set for Angel's bio processor.
---@param params BioProcessorSpriteSetParams
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---@nodiscard
function M.get(params)
	---@type SpriteSetDefinition<CraftingMachineSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.crafting_machine_sprite_set,
		set = {
			graphics_set = get_graphics_set(params.tint),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = nil,
			water_reflection = nil,
			nominal_width = 5,
			nominal_height = 5,
		},
	}

	return definition
end

return M
