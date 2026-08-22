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
				filename = "__angelsbioprocessinggraphics__/graphics/entity/algae-farm/algae-farm.png",
				priority = "extra-high",
				width = 288,
				height = 288,
				line_length = 6,
				frame_count = 36,
				shift = { 0, 0 },
				animation_speed = 0.4,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/algae-farm/algae-farm-mask.png",
			priority = "extra-high",
			width = 288,
			height = 288,
			repeat_count = 36,
			shift = { 0, 0 },
			animation_speed = 0.4,
			tint = tint,
		})
		table.insert(animation.layers--[[@cast -?]], {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/algae-farm/algae-farm-highlights.png",
			priority = "extra-high",
			width = 288,
			height = 288,
			repeat_count = 36,
			shift = { 0, 0 },
			animation_speed = 0.4,
			blend_mode = "additive-soft",
		})
	end

	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = animation,
		working_visualisations = {
			{
				animation = {
					filename = "__angelsbioprocessinggraphics__/graphics/entity/algae-farm/water-splash.png",
					line_length = 5,
					frame_count = 10,
					width = 92,
					height = 99,
					scale = 0.4,
					shift = { -1.4, 0 },
					animation_speed = 0.2,
					run_mode = "forward",
				},
				light = { intensity = 0.4, size = 6 },
			},
		},
	}

	return graphics_set
end

---@class AlgaeFarmSpriteSetParams
---@field tint Color?

---Produces the sprite set for Angel's algae farm.
---@param params AlgaeFarmSpriteSetParams
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
			nominal_width = 7,
			nominal_height = 7,
		},
	}

	return definition
end

return M
