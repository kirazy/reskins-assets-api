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
				filename = "__angelsrefininggraphics__/graphics/entity/ore-refinery/ore-refinery-base.png",
				priority = "extra-high",
				width = 440,
				height = 509,
				shift = util.by_pixel(0.5, -16),
				scale = 0.5,
			},
			-- Shadow
			{
				filename = "__angelsrefininggraphics__/graphics/entity/ore-refinery/ore-refinery-shadow.png",
				priority = "extra-high",
				width = 522,
				height = 340,
				shift = util.by_pixel(21.5, 29),
				draw_as_shadow = true,
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/ore-refinery/ore-refinery-mask.png",
			priority = "extra-high",
			width = 440,
			height = 509,
			shift = util.by_pixel(0.5, -16),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/ore-refinery/ore-refinery-highlights.png",
			priority = "extra-high",
			width = 440,
			height = 509,
			shift = util.by_pixel(0.5, -16),
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
				effect = "uranium-glow",
				animation = {
					filename = "__angelsrefininggraphics__/graphics/entity/ore-refinery/ore-refinery-lights.png",
					priority = "extra-high",
					width = 440,
					height = 509,
					shift = util.by_pixel(0.5, -16),
					draw_as_glow = true,
					blend_mode = "additive-soft",
					scale = 0.5,
				},
			},
			{
				fadeout = true,
				constant_speed = true,
				apply_recipe_tint = "primary",
				north_position = util.by_pixel_hr(-63, -255),
				east_position = util.by_pixel_hr(-63, -255),
				south_position = util.by_pixel_hr(-63, -255),
				west_position = util.by_pixel_hr(-63, -255),
				render_layer = "wires",
				animation = {
					filename = "__base__/graphics/entity/chemical-plant/chemical-plant-smoke-outer.png",
					frame_count = 47,
					line_length = 16,
					width = 90,
					height = 188,
					animation_speed = 0.5,
					shift = util.by_pixel(-2, -40),
					tint = util.color("808080"),
					scale = 0.5,
				},
			},
			{
				fadeout = true,
				constant_speed = true,
				--apply_recipe_tint = "primary",
				north_position = util.by_pixel_hr(-63, -255),
				east_position = util.by_pixel_hr(-63, -255),
				south_position = util.by_pixel_hr(-63, -255),
				west_position = util.by_pixel_hr(-63, -255),
				render_layer = "wires",
				animation = {
					filename = "__base__/graphics/entity/chemical-plant/chemical-plant-smoke-inner.png",
					frame_count = 47,
					line_length = 16,
					width = 40,
					height = 84,
					animation_speed = 0.5,
					shift = util.by_pixel(0, -14),
					tint = util.color("b3b3b3"),
					scale = 0.5 * 1.2,
				},
			},
			{
				always_draw = true,
				apply_recipe_tint = "primary",
				render_layer = "wires",
				animation = {
					filename = "__angelsrefininggraphics__/graphics/entity/ore-refinery/stack-patch-overlay.png",
					priority = "extra-high",
					width = 46,
					height = 25,
					shift = util.by_pixel_hr(-61, -246),
					scale = 0.5,
				},
			},
		},
	}

	return graphics_set
end

---@class OreRefinerySpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?

---Gets the sprite set for Angel's ore refinery.
---@param params OreRefinerySpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---
---#### Examples
---```lua
---local ore_refinery = require("__reskins-assets-api__.assets.angels.entities.refining.ore-refinery")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = ore_refinery.get_sprite_set({ tint = tint })
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
			nominal_width = 7,
			nominal_height = 7,
		},
	}

	return definition
end

local check_get_icon = V.signature("get_icon", {
	{ "tint", Common.color:optional() },
})

---Gets the icon for Angel's ore refinery, in the given `tint`.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(tint)
	check_get_icon(tint)

	local folder = "__reskins-assets-angels__/graphics/icons/ore-refinery/ore-refinery-"

	---@type SafeIconData[]
	local icon = { { icon = folder .. "base.png", icon_size = 64, scale = 0.5 } }

	if tint then
		table.insert(icon, { icon = folder .. "mask.png", icon_size = 64, scale = 0.5, tint = tint })
		table.insert(icon, { icon = folder .. "highlights.png", icon_size = 64, scale = 0.5, tint = { 1, 1, 1, 0 } })
	end

	return icon
end

return M
