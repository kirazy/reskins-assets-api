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
		table.insert(animation.layers--[[@cast -?]], {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/washing-plant/washing-plant-mask.png",
			priority = "extra-high",
			width = 224,
			height = 224,
			repeat_count = 25,
			shift = { 0, 0 },
			tint = tint,
		})
		table.insert(animation.layers--[[@cast -?]], {
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

	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = animation,
		working_visualisations = {},
	}

	return graphics_set
end

---@class WashingPlantSpriteSetParams
---@field tint Color?

---Produces the sprite set for Angel's washing plant.
---@param params WashingPlantSpriteSetParams
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
			corpse = {},
			water_reflection = nil,
			nominal_width = 5,
			nominal_height = 5,
		},
	}

	return definition
end

return M
