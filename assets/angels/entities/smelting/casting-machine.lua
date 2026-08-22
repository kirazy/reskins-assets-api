---@diagnostic disable: generic-constraint-mismatch
---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")

local M = {}

---@param tint Color?
---@param is_flipped boolean?
---@return CraftingMachineGraphicsSet
local function get_graphics_set_internal(tint, is_flipped)
	local flipped = is_flipped == true and "-flipped" or ""

	local working_visualisations = {
		-- Integration patch.
		{
			always_draw = true,
			render_layer = "floor",
			animation = util.sprite_load(
				"__angelssmeltinggraphics__/graphics/entity/casting-machine/casting-machine-integration-patch" .. flipped,
				{
					priority = "high",
					scale = 0.5,
				}
			),
		},
	}

	if tint then
		table.insert(working_visualisations, {
			always_draw = true,
			animation = {
				layers = {
					util.sprite_load(
						"__reskins-assets-angels__/graphics/entity/casting-machine/casting-machine" .. flipped .. "-mask",
						{
							priority = "high",
							frame_count = 49,
							animation_speed = 0.5,
							tint = tint,
							scale = 0.5,
						}
					),
					util.sprite_load(
						"__reskins-assets-angels__/graphics/entity/casting-machine/casting-machine" .. flipped .. "-highlights",
						{
							priority = "high",
							frame_count = 49,
							animation_speed = 0.5,
							blend_mode = "additive-soft",
							scale = 0.5,
						}
					),
				},
			},
		})
	end

	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = {
			layers = {
				util.sprite_load(
					"__angelssmeltinggraphics__/graphics/entity/casting-machine/casting-machine-animation" .. flipped,
					{
						priority = "high",
						frame_count = 49,
						animation_speed = 0.5,
						scale = 0.5,
					}
				),
				util.sprite_load(
					"__angelssmeltinggraphics__/graphics/entity/casting-machine/casting-machine-animation-shadow" .. flipped,
					{
						priority = "high",
						frame_count = 49,
						animation_speed = 0.5,
						draw_as_shadow = true,
						scale = 0.5,
					}
				),
				util.sprite_load(
					"__angelssmeltinggraphics__/graphics/entity/casting-machine/casting-machine-lights" .. flipped,
					{
						priority = "high",
						frame_count = 49,
						animation_speed = 0.5,
						draw_as_light = true,
						scale = 0.5,
					}
				),
			},
		},
		working_visualisations = working_visualisations,
	}

	return graphics_set
end

---@param tint Color?
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint)
	return get_graphics_set_internal(tint, false)
end

---@param tint Color?
---@return CraftingMachineGraphicsSet
local function get_graphics_set_flipped(tint)
	return get_graphics_set_internal(tint, true)
end

---@class CastingMachineSpriteSetParams
---@field tint Color?

---Produces the sprite set for Angel's casting machine.
---@param params CastingMachineSpriteSetParams
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---@nodiscard
function M.get(params)
	---@type SpriteSetDefinition<CraftingMachineSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.crafting_machine_sprite_set,
		set = {
			graphics_set = get_graphics_set(params.tint),
			graphics_set_flipped = get_graphics_set_flipped(params.tint),
			fluid_boxes = {},
			fluid_boxes_off_when_no_fluid_recipe = false,
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
