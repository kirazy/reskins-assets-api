---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")

local M = {}

local pipe_pictures = {
	north = {
		filename = "__angelsrefininggraphics__/graphics/entity/filtration-unit/pipe-north1.png",
		priority = "extra-high",
		width = 68,
		height = 74,
		scale = 0.5,
		shift = { 0, 1 },
	},
	east = {
		filename = "__angelsrefininggraphics__/graphics/entity/filtration-unit/pipe-east.png",
		priority = "extra-high",
		width = 34,
		height = 47,
		shift = { -0.7, -0.1 },
	},
	south = {
		filename = "__angelsrefininggraphics__/graphics/entity/filtration-unit/pipe-south.png",
		priority = "extra-high",
		width = 34,
		height = 39,
		shift = { 0, -0.75 },
	},
	west = {
		filename = "__angelsrefininggraphics__/graphics/entity/filtration-unit/pipe-west.png",
		priority = "extra-high",
		width = 34,
		height = 47,
		shift = { 0.7, -0.1 },
	},
}

local mirrored_pipe_pictures = {
	north = {
		filename = "__angelsrefininggraphics__/graphics/entity/filtration-unit/pipe-north2.png",
		priority = "extra-high",
		width = 128,
		height = 128,
		scale = 0.5,
		shift = { 0, 1.5 },
	},
	east = {
		filename = "__angelsrefininggraphics__/graphics/entity/filtration-unit/pipe-east.png",
		priority = "extra-high",
		width = 34,
		height = 47,
		shift = { -0.7, -0.1 },
	},
	south = {
		filename = "__angelsrefininggraphics__/graphics/entity/filtration-unit/pipe-south.png",
		priority = "extra-high",
		width = 34,
		height = 39,
		shift = { 0, -0.75 },
	},
	west = {
		filename = "__angelsrefininggraphics__/graphics/entity/filtration-unit/pipe-west.png",
		priority = "extra-high",
		width = 34,
		height = 47,
		shift = { 0.7, -0.1 },
	},
}

---@param tint Color?
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint)
	local animation = {
		layers = {
			-- Base
			{
				filename = "__angelsrefininggraphics__/graphics/entity/filtration-unit/filtration-unit.png",
				priority = "extra-high",
				width = 224,
				height = 224,
				shift = { 0, -0.2 },
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/filtration-unit/filtration-unit-mask.png",
			priority = "extra-high",
			width = 224,
			height = 224,
			shift = { 0, -0.2 },
			tint = tint,
		})
		table.insert(animation.layers--[[@cast -?]], {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/filtration-unit/filtration-unit-highlights.png",
			priority = "extra-high",
			width = 224,
			height = 224,
			shift = { 0, -0.2 },
			blend_mode = "additive-soft",
		})
	end

	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = animation,
		working_visualisations = {},
	}

	return graphics_set
end

---@class FiltrationUnitSpriteSetParams
---@field tint Color?

---Produces the sprite set for Angel's filtration unit.
---@param params FiltrationUnitSpriteSetParams
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
			nominal_width = 5,
			nominal_height = 5,
		},
	}

	return definition
end

return M
