---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")

local M = {}

local pipe_picture = {
	north = {
		filename = "__angelsrefininggraphics__/graphics/entity/crystallizer/crystallizer-pipe-connection.png",
		priority = "extra-high",
		size = 128,
		x = 0,
		shift = { 0, 1 },
		scale = 0.5,
	},
	east = {
		filename = "__angelsrefininggraphics__/graphics/entity/crystallizer/crystallizer-pipe-connection.png",
		priority = "extra-high",
		size = 128,
		x = 128,
		shift = { -1, 0 },
		scale = 0.5,
	},
	south = {
		filename = "__angelsrefininggraphics__/graphics/entity/crystallizer/crystallizer-pipe-connection.png",
		priority = "extra-high",
		size = 128,
		x = 256,
		shift = { 0, -1 },
		scale = 0.5,
	},
	west = {
		filename = "__angelsrefininggraphics__/graphics/entity/crystallizer/crystallizer-pipe-connection.png",
		priority = "extra-high",
		size = 128,
		x = 384,
		shift = { 1, 0 },
		scale = 0.5,
	},
}

---@param tint Color?
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint)
	local animation = {
		layers = {
			-- Base
			{
				filename = "__angelsrefininggraphics__/graphics/entity/crystallizer/crystallizer.png",
				priority = "extra-high",
				width = 390,
				height = 326,
				shift = util.by_pixel(16, 0),
				scale = 0.5,
			},
			-- Shadow
			{
				filename = "__angelsrefininggraphics__/graphics/entity/crystallizer/crystallizer-shadow.png",
				priority = "extra-high",
				width = 390,
				height = 326,
				shift = util.by_pixel(16, 0),
				draw_as_shadow = true,
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/crystallizer/crystallizer-mask.png",
			priority = "extra-high",
			width = 390,
			height = 326,
			shift = util.by_pixel(16, 0),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/crystallizer/crystallizer-highlights.png",
			priority = "extra-high",
			width = 390,
			height = 326,
			shift = util.by_pixel(16, 0),
			blend_mode = "additive-soft",
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

---@class CrystallizerSpriteSetParams
---@field tint Color?

---Produces the sprite set for Angel's crystallizer.
---@param params CrystallizerSpriteSetParams
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---@nodiscard
function M.get(params)
	---@type FluidBoxGraphics
	local fluid_box = {
		pipe_picture = pipe_picture,
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
