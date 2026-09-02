---@diagnostic disable: generic-constraint-mismatch
---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")

local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")

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
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?

---Gets the sprite set for Angel's casting machine.
---@param params CastingMachineSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---
---#### Examples
---```lua
---local casting_machine = require("__reskins-assets-api__.assets.angels.entities.smelting.casting-machine")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = casting_machine.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set(params)
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

local check_get_icon = V.signature("get_icon", {
	{ "tint", Common.color:optional() },
})

---Gets the icon for Angel's casting machine, in the given `tint`.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(tint)
	check_get_icon(tint)

	local folder = "__reskins-assets-angels__/graphics/icons/casting-machine/casting-machine-icon-"

	---@type SafeIconData[]
	local icon = { { icon = folder .. "base.png", icon_size = 64, scale = 0.5 } }

	if tint then
		table.insert(icon, { icon = folder .. "mask.png", icon_size = 64, scale = 0.5, tint = tint })
		table.insert(icon, { icon = folder .. "highlights.png", icon_size = 64, scale = 0.5, tint = { 1, 1, 1, 0 } })
	end

	return icon
end

return M
