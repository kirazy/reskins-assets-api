---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")

local M = {}

---@param tint Color?
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint)
	local animation = {
		layers = {
			-- Base
			{
				filename = "__angelssmeltinggraphics__/graphics/entity/pellet-press/pellet-press-base.png",
				priority = "extra-high",
				width = 200,
				height = 199,
				line_length = 10,
				frame_count = 60,
				animation_speed = 0.5,
				shift = util.by_pixel(0, 0),
				scale = 0.5,
			},
			-- Shadow
			{
				filename = "__angelssmeltinggraphics__/graphics/entity/pellet-press/pellet-press-shadow.png",
				priority = "extra-high",
				width = 246,
				height = 132,
				line_length = 6,
				frame_count = 60,
				animation_speed = 0.5,
				draw_as_shadow = true,
				shift = util.by_pixel(12, 17),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/pellet-press/pellet-press-mask.png",
			priority = "extra-high",
			width = 200,
			height = 199,
			line_length = 10,
			frame_count = 60,
			animation_speed = 0.5,
			shift = util.by_pixel(0, 0),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/pellet-press/pellet-press-highlights.png",
			priority = "extra-high",
			width = 200,
			height = 199,
			line_length = 10,
			frame_count = 60,
			animation_speed = 0.5,
			shift = util.by_pixel(0, 0),
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

---@class PelletPressSpriteSetParams
---@field tint Color?

---Produces the sprite set for Angel's pellet press.
---@param params PelletPressSpriteSetParams
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
			nominal_width = 3,
			nominal_height = 3,
		},
	}

	return definition
end

return M
