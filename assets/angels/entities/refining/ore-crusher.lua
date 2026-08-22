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
				filename = "__angelsrefininggraphics__/graphics/entity/ore-crusher/ore-crusher-base.png",
				priority = "extra-high",
				width = 189,
				height = 214,
				frame_count = 16,
				line_length = 4,
				shift = util.by_pixel(-0.5, -5),
				animation_speed = 0.5,
				scale = 0.5,
			},
			-- Shadow
			{
				filename = "__angelsrefininggraphics__/graphics/entity/ore-crusher/ore-crusher-shadow.png",
				priority = "extra-high",
				width = 282,
				height = 140,
				repeat_count = 16,
				shift = util.by_pixel(24, 17.5),
				draw_as_shadow = true,
				animation_speed = 0.5,
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/ore-crusher/ore-crusher-mask.png",
			priority = "extra-high",
			width = 189,
			height = 214,
			repeat_count = 16,
			shift = util.by_pixel(-0.5, -5),
			tint = tint,
			animation_speed = 0.5,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/ore-crusher/ore-crusher-highlights.png",
			priority = "extra-high",
			width = 189,
			height = 214,
			repeat_count = 16,
			shift = util.by_pixel(-0.5, -5),
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

---@class OreCrusherSpriteSetParams
---@field tint Color?

---Produces the sprite set for Angel's ore crusher.
---@param params OreCrusherSpriteSetParams
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
