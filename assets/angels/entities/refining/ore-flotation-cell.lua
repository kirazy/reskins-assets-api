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
	local working_visualisations = {
		{
			always_draw = true,
			animation = {
				filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/ore-flotation-cell-animation-idle.png",
				priority = "extra-high",
				width = 166,
				height = 117,
				frame_count = 32,
				line_length = 8,
				shift = util.by_pixel_hr(62, 5),
				scale = 0.5,
			},
		},
		{
			fadeout = true,
			animation = {
				filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/ore-flotation-cell-animation-base.png",
				priority = "extra-high",
				width = 166,
				height = 117,
				frame_count = 64,
				line_length = 8,
				shift = util.by_pixel_hr(62, 5),
				scale = 0.5,
			},
		},
		{
			fadeout = true,
			apply_recipe_tint = "primary",
			animation = {
				filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/ore-flotation-cell-animation-water-tintable.png",
				priority = "extra-high",
				width = 166,
				height = 117,
				frame_count = 64,
				line_length = 8,
				shift = util.by_pixel_hr(62, 5),
				scale = 0.5,
			},
		},
		{
			fadeout = true,
			apply_recipe_tint = "secondary",
			animation = {
				filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/ore-flotation-cell-animation-froth-tintable.png",
				priority = "extra-high",
				width = 166,
				height = 117,
				frame_count = 64,
				line_length = 8,
				shift = util.by_pixel_hr(62, 5),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(working_visualisations, {
			always_draw = true,
			animation = {
				layers = {
					-- Mask
					{
						filename = "__reskins-assets-angels__/graphics/entity/ore-flotation-cell/ore-flotation-cell-mask.png",
						priority = "extra-high",
						width = 333,
						height = 363,
						shift = util.by_pixel_hr(-1, -1),
						tint = tint,
						scale = 0.5,
					},
					-- Highlights
					{
						filename = "__reskins-assets-angels__/graphics/entity/ore-flotation-cell/ore-flotation-cell-highlights.png",
						priority = "extra-high",
						width = 333,
						height = 363,
						shift = util.by_pixel_hr(-1, -1),
						blend_mode = "additive-soft",
						scale = 0.5,
					},
				},
			},
		})
	end

	table.insert(working_visualisations, {
		always_draw = true,
		render_layer = "higher-object-under",
		north_animation = {
			filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/ore-flotation-cell-pipe-cover-overlays.png",
			priority = "extra-high",
			width = 333,
			height = 363,
			shift = util.by_pixel_hr(-1, -1),
			scale = 0.5,
		},
		east_animation = {
			filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/ore-flotation-cell-pipe-cover-overlays.png",
			priority = "extra-high",
			width = 333,
			height = 363,
			x = 333,
			shift = util.by_pixel_hr(-1, -1),
			scale = 0.5,
		},
		south_animation = {
			filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/ore-flotation-cell-pipe-cover-overlays.png",
			priority = "extra-high",
			width = 333,
			height = 363,
			shift = util.by_pixel_hr(-1, -1),
			scale = 0.5,
		},
		west_animation = {
			filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/ore-flotation-cell-pipe-cover-overlays.png",
			priority = "extra-high",
			width = 333,
			height = 363,
			x = 333,
			shift = util.by_pixel_hr(-1, -1),
			scale = 0.5,
		},
	})

	table.insert(working_visualisations, {
		always_draw = true,
		north_animation = {
			filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/vertical-pipe-shadow-patch.png",
			priority = "high",
			width = 128,
			height = 128,
			repeat_count = 36,
			draw_as_shadow = true,
			shift = { 0, -2 },
			scale = 0.5,
		},
		south_animation = {
			filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/vertical-pipe-shadow-patch.png",
			priority = "high",
			width = 128,
			height = 128,
			repeat_count = 36,
			draw_as_shadow = true,
			shift = { 0, -2 },
			scale = 0.5,
		},
	})

	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = {
			north = {
				layers = {
					{
						filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/ore-flotation-cell-base.png",
						priority = "extra-high",
						width = 333,
						height = 363,
						shift = util.by_pixel_hr(-1, -1),
						scale = 0.5,
					},
					{
						filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/ore-flotation-cell-shadow.png",
						priority = "extra-high",
						width = 390,
						height = 326,
						shift = util.by_pixel_hr(29, 18),
						draw_as_shadow = true,
						scale = 0.5,
					},
				},
			},
			east = {
				layers = {
					{
						filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/ore-flotation-cell-base.png",
						priority = "extra-high",
						width = 333,
						height = 363,
						x = 333,
						shift = util.by_pixel_hr(-1, -1),
						scale = 0.5,
					},
					{
						filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/ore-flotation-cell-shadow.png",
						priority = "extra-high",
						width = 390,
						height = 326,
						x = 390,
						shift = util.by_pixel_hr(29, 18),
						draw_as_shadow = true,
						scale = 0.5,
					},
				},
			},
			south = {
				layers = {
					{
						filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/ore-flotation-cell-base.png",
						priority = "extra-high",
						width = 333,
						height = 363,
						shift = util.by_pixel_hr(-1, -1),
						scale = 0.5,
					},
					{
						filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/ore-flotation-cell-shadow.png",
						priority = "extra-high",
						width = 390,
						height = 326,
						shift = util.by_pixel_hr(29, 18),
						draw_as_shadow = true,
						scale = 0.5,
					},
				},
			},
			west = {
				layers = {
					{
						filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/ore-flotation-cell-base.png",
						priority = "extra-high",
						width = 333,
						height = 363,
						x = 333,
						shift = util.by_pixel_hr(-1, -1),
						scale = 0.5,
					},
					{
						filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/ore-flotation-cell-shadow.png",
						priority = "extra-high",
						width = 390,
						height = 326,
						x = 390,
						shift = util.by_pixel_hr(29, 18),
						draw_as_shadow = true,
						scale = 0.5,
					},
				},
			},
		},
		working_visualisations = working_visualisations,
	}

	return graphics_set
end

---@class OreFlotationCellSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set rather than drawn
---untinted.
---@field tint Color?

---Gets the sprite set for Angel's ore flotation cell.
---@param params OreFlotationCellSpriteSetParams # The options the sprite set is drawn with.
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---
---### Examples
---```lua
---local ore_flotation_cell = require("__reskins-assets-api__.assets.angels.entities.refining.ore-flotation-cell")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = ore_flotation_cell.get_sprite_set({ tint = tint })
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
			nominal_width = 5,
			nominal_height = 5,
		},
	}

	return definition
end

local check_get_icon = V.signature("get_icon", {
	{ "tint", Common.color:optional() },
})

---Gets the icon for Angel's ore flotation cell, in the given `tint`.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(tint)
	check_get_icon(tint)

	local folder = "__reskins-assets-angels__/graphics/icons/ore-flotation-cell/ore-flotation-cell-icon-"

	---@type SafeIconData[]
	local icon = { { icon = folder .. "base.png", icon_size = 64, scale = 0.5 } }

	if tint then
		table.insert(icon, { icon = folder .. "mask.png", icon_size = 64, scale = 0.5, tint = tint })
		table.insert(icon, { icon = folder .. "highlights.png", icon_size = 64, scale = 0.5, tint = { 1, 1, 1, 0 } })
	end

	return icon
end

return M
