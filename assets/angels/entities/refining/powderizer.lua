---cspell: words Powderizer
---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local M = {}

---@param tint? Color
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint)
	local layers = {
		{
			filename = "__angelsrefininggraphics__/graphics/entity/ore-powderizer/powderizer.png",
			priority = "extra-high",
			width = 256,
			height = 256,
			frame_count = 36,
			line_length = 6,
			shift = { 0, 0 },
			animation_speed = 0.5,
			scale = 0.5,
		},
	}

	if tint then
		table.insert(layers, {
			filename = "__reskins-assets-angels__/graphics/entity/powderizer/powderizer-mask.png",
			priority = "extra-high",
			width = 256,
			height = 256,
			repeat_count = 36,
			shift = { 0, 0 },
			animation_speed = 0.5,
			tint = tint,
			scale = 0.5,
		})
		table.insert(layers, {
			filename = "__reskins-assets-angels__/graphics/entity/powderizer/powderizer-highlights.png",
			priority = "extra-high",
			width = 256,
			height = 256,
			repeat_count = 36,
			shift = { 0, 0 },
			animation_speed = 0.5,
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = { layers = layers },
		working_visualisations = {},
	}

	return graphics_set
end

---Defines the options for the Angel's powderizer sprite set.
---@class PowderizerSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

---Gets the sprite set for Angel's powderizer.
---@param params PowderizerSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's powderizer.
---
---#### Examples
---```lua
---local powderizer = require("__reskins-assets-api__.assets.angels.entities.refining.powderizer")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = powderizer.get_sprite_set({ tint = tint })
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
			nominal_width = 2,
			nominal_height = 2,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-angels__/graphics/icons" })

---Gets the icon for Angel's powderizer, in the tints given by `params`.
M.get_icon = icons:tinted("powderizer"):build("get_icon")

return M
