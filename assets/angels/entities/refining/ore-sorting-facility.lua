---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")
local IconCatalog = require("api.icon-catalog")

local M = {}

---@param tint Color?
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint)
	local animation = {
		layers = {
			-- Base
			{
				filename = "__angelsrefininggraphics__/graphics/entity/ore-sorting-facility/ore-sorting-facility-base.png",
				priority = "extra-high",
				width = 449,
				height = 458,
				frame_count = 40,
				line_length = 10,
				shift = util.by_pixel(0, -2.5),
				animation_speed = 0.5,
				scale = 0.5,
			},
			-- Shadow
			{
				filename = "__angelsrefininggraphics__/graphics/entity/ore-sorting-facility/ore-sorting-facility-shadow.png",
				priority = "extra-high",
				width = 528,
				height = 356,
				repeat_count = 40,
				shift = util.by_pixel(21.5, 24.5),
				animation_speed = 0.5,
				draw_as_shadow = true,
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/ore-sorting-facility/ore-sorting-facility-mask.png",
			priority = "extra-high",
			width = 449,
			height = 458,
			frame_count = 40,
			line_length = 10,
			shift = util.by_pixel(0, -2.5),
			animation_speed = 0.5,
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/ore-sorting-facility/ore-sorting-facility-highlights.png",
			priority = "extra-high",
			width = 449,
			height = 458,
			frame_count = 40,
			line_length = 10,
			shift = util.by_pixel(0, -2.5),
			animation_speed = 0.5,
			blend_mode = "additive-soft",
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

---@class OreSortingFacilitySpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?

---Gets the sprite set for Angel's ore sorting facility.
---@param params OreSortingFacilitySpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---
---#### Examples
---```lua
---local ore_sorting_facility = require("__reskins-assets-api__.assets.angels.entities.refining.ore-sorting-facility")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = ore_sorting_facility.get_sprite_set({ tint = tint })
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

local icons = IconCatalog:create({ folder = "__reskins-assets-angels__/graphics/icons" })

---Gets the icon for Angel's ore sorting facility, in the tints given by `params`.
M.get_icon = icons:tinted("ore-sorting-facility"):build("get_icon")

return M
