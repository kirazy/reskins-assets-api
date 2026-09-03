---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")
local IconCatalog = require("api.icon-catalog")

local M = {}

-- The ore-floatation-cell picture set is used only for the electro-winning-cell entity.
local pipe_pictures = {
	north = {
		filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/pipe-north.png",
		priority = "extra-high",
		width = 48,
		height = 48,
		shift = { 0.01, 0.95 },
	},
	east = {
		filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/pipe-east.png",
		priority = "extra-high",
		width = 40,
		height = 45,
		shift = { -0.71875, 0.1 },
	},
	south = {
		filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/pipe-south.png",
		priority = "extra-high",
		width = 34,
		height = 39,
		shift = { 0, -0.75 },
	},
	west = {
		filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/pipe-west.png",
		priority = "extra-high",
		width = 40,
		height = 45,
		shift = { 0.78125, 0.01 },
	},
}

---@param tint Color?
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint)
	local layers = {
		-- Base
		{
			-- cspell: disable-next-line
			filename = "__angelsrefininggraphics__/graphics/entity/electro-whinning-cell/electro-whinning-cell.png",
			priority = "extra-high",
			width = 224,
			height = 224,
			frame_count = 36,
			line_length = 6,
			shift = { 0, 0 },
			animation_speed = 0.5,
		},
	}

	if tint then
		table.insert(layers, {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/electro-winning-cell/electro-winning-cell-mask.png",
			priority = "extra-high",
			width = 224,
			height = 224,
			repeat_count = 36,
			shift = { 0, 0 },
			animation_speed = 0.5,
			tint = tint,
		})
		table.insert(layers, {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/electro-winning-cell/electro-winning-cell-highlights.png",
			priority = "extra-high",
			width = 224,
			height = 224,
			repeat_count = 36,
			shift = { 0, 0 },
			animation_speed = 0.5,
			blend_mode = "additive-soft",
		})
	end

	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = { layers = layers },
		working_visualisations = {},
	}

	return graphics_set
end

---@class ElectroWinningCellSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?

---Gets the sprite set for Angel's electro-winning cell.
---@param params ElectroWinningCellSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---
---#### Examples
---```lua
---local electro_winning_cell = require("__reskins-assets-api__.assets.angels.entities.refining.electro-winning-cell")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = electro_winning_cell.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set(params)
	---@type FluidBoxGraphics
	local fluid_box = {
		pipe_picture = pipe_pictures,
	}

	---@type SpriteSetDefinition<CraftingMachineSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.crafting_machine_sprite_set,
		set = {
			graphics_set = get_graphics_set(params.tint),
			fluid_boxes = { fluid_box },
			fluid_boxes_off_when_no_fluid_recipe = false,
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

local icons = IconCatalog:create({ folder = "__reskins-assets-angels__/graphics/icons" })

---Gets the icon for Angel's electro-winning cell, in the tints given by `params`.
M.get_icon = icons:tinted("electro-winning-cell"):build("get_icon")

return M
