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
	local animation = {
		layers = {
			{
				filename = "__angelspetrochemgraphics__/graphics/entity/advanced-chemical-plant/advanced-chemical-plant.png",
				priority = "extra-high",
				width = 224,
				height = 224,
				frame_count = 16,
				line_length = 4,
				animation_speed = 0.5,
				shift = { 0, 0 },
			},
			{
				filename = "__reskins-assets-angels__/graphics/entity/chemical-plant-advanced/chemical-plant-advanced-base-patch.png",
				priority = "extra-high",
				width = 224,
				height = 224,
				repeat_count = 16,
				animation_speed = 0.5,
				shift = { 0, 0 },
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = "__reskins-assets-angels__/graphics/entity/chemical-plant-advanced/chemical-plant-advanced-mask.png",
			priority = "extra-high",
			width = 224,
			height = 224,
			repeat_count = 16,
			animation_speed = 0.5,
			shift = { 0, 0 },
			tint = tint,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = "__reskins-assets-angels__/graphics/entity/chemical-plant-advanced/chemical-plant-advanced-highlights.png",
			priority = "extra-high",
			width = 224,
			height = 224,
			repeat_count = 16,
			animation_speed = 0.5,
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

---Defines the options for the Angel's advanced chemical plant sprite set.
---@class AdvancedChemicalPlantSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

---Gets the sprite set for Angel's advanced chemical plant.
---@param params AdvancedChemicalPlantSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's advanced chemical plant.
---
---#### Examples
---```lua
---local advanced_chemical_plant = require("__reskins-assets-api__.assets.angels.entities.petrochem.advanced-chemical-plant")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = advanced_chemical_plant.get_sprite_set({ tint = tint })
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

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-angels__/graphics/icons" })

---Gets the icon for Angel's advanced chemical plant, in the tints given by `params`.
M.get_icon = icons:tinted("chemical-plant-advanced"):build("get_icon")

return M
