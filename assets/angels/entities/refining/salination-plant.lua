---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")

local M = {}

local pipe_pictures = {
	north = util.empty_sprite(),
	east = util.empty_sprite(),
	south = util.empty_sprite(),
	west = util.empty_sprite(),
}

local mirrored_pipe_pictures = {
	north = util.empty_sprite(),
	east = {
		filename = "__angelsrefininggraphics__/graphics/entity/salination-plant/pipe-east2.png",
		priority = "extra-high",
		width = 128,
		height = 128,
		scale = 0.5,
		shift = { -1, 0 },
	},
	south = util.empty_sprite(),
	west = util.empty_sprite(),
}

---@param tint Color?
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint)
	local animation = {
		layers = {
			-- Base
			{
				filename = "__angelsrefininggraphics__/graphics/entity/salination-plant/salination-plant-base.png",
				priority = "extra-high",
				width = 484,
				height = 540,
				frame_count = 36,
				line_length = 6,
				shift = util.by_pixel(-2.5, -12),
				animation_speed = 0.5,
				scale = 0.5,
			},
			-- Shadow
			{
				filename = "__angelsrefininggraphics__/graphics/entity/salination-plant/salination-plant-shadow.png",
				priority = "extra-high",
				width = 509,
				height = 467,
				repeat_count = 36,
				shift = util.by_pixel(10, 6.5),
				draw_as_shadow = true,
				animation_speed = 0.5,
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/salination-plant/salination-plant-mask.png",
			priority = "extra-high",
			width = 484,
			height = 540,
			repeat_count = 36,
			shift = util.by_pixel(-2.5, -12),
			tint = tint,
			animation_speed = 0.5,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/salination-plant/salination-plant-highlights.png",
			priority = "extra-high",
			width = 484,
			height = 540,
			repeat_count = 36,
			shift = util.by_pixel(-2.5, -12),
			blend_mode = "additive-soft",
			animation_speed = 0.5,
			scale = 0.5,
		})
	end

	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = animation,
		working_visualisations = {},
	}

	return graphics_set
end

---@class SalinationPlantSpriteSetParams
---@field tint Color?

---Produces the sprite set for Angel's salination plant.
---@param params SalinationPlantSpriteSetParams
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---@nodiscard
function M.get(params)
	---@type FluidBoxGraphics
	local fluid_box = {
		pipe_picture = pipe_pictures,
		mirrored_pipe_picture = mirrored_pipe_pictures,
	}

	---@type SpriteSetDefinition<CraftingMachineSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.crafting_machine_sprite_set,
		set = {
			graphics_set = get_graphics_set(params.tint),
			fluid_boxes = { fluid_box },
			fluid_boxes_off_when_no_fluid_recipe = false,
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = nil,
			water_reflection = nil,
			nominal_width = 7,
			nominal_height = 7,
		},
	}

	return definition
end

return M
