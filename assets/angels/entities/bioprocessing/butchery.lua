---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")

local M = {}

---@param tint Color?
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint)
	local working_visualisations = {}

	if tint then
		table.insert(working_visualisations, {
			always_draw = true,
			animation = {
				layers = {
					-- Base patch
					{
						filename = "__reskins-assets-angels__/graphics/entity/butchery/butchery-base-patch.png",
						priority = "extra-high",
						width = 160,
						height = 160,
						shift = { 0, 0 },
					},
					-- Mask
					{
						filename = "__reskins-assets-angels__/graphics/entity/butchery/butchery-mask.png",
						priority = "extra-high",
						width = 160,
						height = 160,
						shift = { 0, 0 },
						tint = tint,
					},
					-- Highlights
					{
						filename = "__reskins-assets-angels__/graphics/entity/butchery/butchery-highlights.png",
						priority = "extra-high",
						width = 160,
						height = 160,
						shift = { 0, 0 },
						blend_mode = "additive-soft",
					},
				},
			},
		})
	end

	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = {
			layers = {
				{
					filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-butchery/bio-butchery.png",
					width = 160,
					height = 160,
					frame_count = 36,
					line_length = 6,
					shift = { 0, 0 },
					animation_speed = 0.5,
				},
			},
		},
		working_visualisations = working_visualisations,
	}

	return graphics_set
end

---@class ButcherySpriteSetParams
---@field tint Color?

---Produces the sprite set for Angel's butchery.
---@param params ButcherySpriteSetParams
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
