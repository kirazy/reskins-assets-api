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
				filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-hatchery/bio-hatchery-off.png",
				priority = "extra-high",
				width = 160,
				height = 160,
				shift = { 0, 0 },
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			-- Idle Mask
			filename = "__reskins-assets-angels__/graphics/entity/hatchery/hatchery-idle-mask.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			shift = { 0, 0 },
			tint = tint,
		})
		table.insert(animation.layers--[[@cast -?]], {
			-- Idle Highlights
			filename = "__reskins-assets-angels__/graphics/entity/hatchery/hatchery-idle-highlights.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			shift = { 0, 0 },
			blend_mode = "additive-soft",
		})
	end

	local working_visualisations = {}

	if tint then
		table.insert(working_visualisations, {
			animation = {
				layers = {
					{
						filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-hatchery/bio-hatchery-animation.png",
						priority = "extra-high",
						width = 160,
						height = 160,
						frame_count = 25,
						line_length = 5,
						shift = { 0, 0 },
						animation_speed = 0.35,
					},
					{
						-- Working Mask
						filename = "__reskins-assets-angels__/graphics/entity/hatchery/hatchery-working-mask.png",
						priority = "extra-high",
						width = 160,
						height = 160,
						frame_count = 25,
						line_length = 5,
						shift = { 0, 0 },
						animation_speed = 0.35,
						tint = tint,
					},
					{
						-- Working Highlights
						filename = "__reskins-assets-angels__/graphics/entity/hatchery/hatchery-working-highlights.png",
						priority = "extra-high",
						width = 160,
						height = 160,
						frame_count = 25,
						line_length = 5,
						shift = { 0, 0 },
						animation_speed = 0.35,
						blend_mode = "additive-soft",
					},
				},
			},
		})
	end

	-- Shadow (always_draw, always required)
	table.insert(working_visualisations, {
		always_draw = true,
		animation = {
			filename = "__reskins-assets-angels__/graphics/entity/hatchery/hatchery-shadow.png",
			width = 160,
			height = 160,
			shift = { 0, 0 },
			draw_as_shadow = true,
		},
	})

	-- Lights (fadeout)
	table.insert(working_visualisations, {
		fadeout = true,
		animation = {
			filename = "__reskins-assets-angels__/graphics/entity/hatchery/hatchery-working-light.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			frame_count = 25,
			line_length = 5,
			shift = { 0, 0 },
			animation_speed = 0.35,
			draw_as_light = true,
		},
	})

	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = animation,
		working_visualisations = working_visualisations,
	}

	return graphics_set
end

---@class HatcherySpriteSetParams
---@field tint Color?

---Produces the sprite set for Angel's hatchery.
---@param params HatcherySpriteSetParams
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
