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
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint)
	local animation = {
		layers = {
			-- Base
			{
				filename = "__angelssmeltinggraphics__/graphics/entity/ore-processing-machine/ore-processing-machine-base.png",
				priority = "extra-high",
				width = 196,
				height = 206,
				line_length = 5,
				frame_count = 25,
				animation_speed = 0.5,
				shift = util.by_pixel(-0.5, -2),
				scale = 0.5,
			},
			-- Shadow
			{
				filename = "__angelssmeltinggraphics__/graphics/entity/ore-processing-machine/ore-processing-machine-shadow.png",
				priority = "extra-high",
				width = 243,
				height = 137,
				repeat_count = 25,
				animation_speed = 0.5,
				draw_as_shadow = true,
				shift = util.by_pixel(12.5, 16),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/ore-processing-machine/ore-processing-machine-mask.png",
			priority = "extra-high",
			width = 196,
			height = 206,
			line_length = 5,
			frame_count = 25,
			animation_speed = 0.5,
			shift = util.by_pixel(-0.5, -2),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/ore-processing-machine/ore-processing-machine-highlights.png",
			priority = "extra-high",
			width = 196,
			height = 206,
			line_length = 5,
			frame_count = 25,
			animation_speed = 0.5,
			shift = util.by_pixel(-0.5, -2),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = animation,
		working_visualisations = {
			{
				fadeout = true,
				constant_speed = true,
				animation = {
					filename = "__angelssmeltinggraphics__/graphics/entity/ore-processing-machine/ore-processing-machine-dust.png",
					priority = "high",
					width = 107,
					height = 170,
					line_length = 5,
					frame_count = 20,
					animation_speed = 0.40,
					shift = util.by_pixel(0, -21.5),
					scale = 0.5,
				},
			},
			{
				apply_recipe_tint = "primary",
				fadeout = true,
				constant_speed = true,
				animation = {
					filename = "__angelssmeltinggraphics__/graphics/entity/ore-processing-machine/ore-processing-machine-dust.png",
					priority = "high",
					width = 107,
					height = 170,
					line_length = 5,
					frame_count = 20,
					animation_speed = 0.40,
					shift = util.by_pixel(0, -21.5),
					scale = 0.5,
				},
			},
			{
				always_draw = true,
				animation = {
					filename = "__angelssmeltinggraphics__/graphics/entity/ore-processing-machine/ore-processing-machine-top.png",
					priority = "high",
					width = 192,
					height = 139,
					shift = util.by_pixel(0, -22.5),
					scale = 0.5,
				},
			},
		},
	}

	return graphics_set
end

---@class OreProcessingMachineSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?

---Gets the sprite set for Angel's ore processing machine.
---@param params OreProcessingMachineSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---
---#### Examples
---```lua
---local ore_processing_machine = require("__reskins-assets-api__.assets.angels.entities.smelting.ore-processing-machine")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = ore_processing_machine.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set(params)
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

local check_get_icon = V.signature("get_icon", {
	{ "tint", Common.color:optional() },
})

---Gets the icon for Angel's ore processing machine, in the given `tint`.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(tint)
	check_get_icon(tint)

	local folder = "__reskins-assets-angels__/graphics/icons/ore-processing-machine/ore-processing-machine-"

	---@type SafeIconData[]
	local icon = { { icon = folder .. "base.png", icon_size = 64, scale = 0.5 } }

	if tint then
		table.insert(icon, { icon = folder .. "mask.png", icon_size = 64, scale = 0.5, tint = tint })
		table.insert(icon, { icon = folder .. "highlights.png", icon_size = 64, scale = 0.5, tint = { 1, 1, 1, 0 } })
	end

	return icon
end

return M
