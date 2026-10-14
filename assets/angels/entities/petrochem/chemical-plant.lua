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
				filename = "__angelspetrochemgraphics__/graphics/entity/chemical-plant/chemical-plant.png",
				priority = "extra-high",
				width = 160,
				height = 160,
				shift = { 0, 0 },
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = "__reskins-assets-angels__/graphics/entity/chemical-plant/chemical-plant-mask.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			shift = { 0, 0 },
			tint = tint,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = "__reskins-assets-angels__/graphics/entity/chemical-plant/chemical-plant-highlights.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			shift = { 0, 0 },
			blend_mode = "additive-soft",
		})
	end

	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = animation,
		working_visualisations = {
			{
				apply_recipe_tint = "primary",
				animation = {
					filename = "__angelspetrochemgraphics__/graphics/entity/chemical-plant/mixer-tint.png",
					line_length = 6,
					frame_count = 36,
					width = 160,
					height = 160,
					shift = { 0, 0 },
					animation_speed = 0.5,
				},
			},
			{
				animation = {
					filename = "__angelspetrochemgraphics__/graphics/entity/chemical-plant/mixer-overlay.png",
					line_length = 6,
					frame_count = 36,
					width = 160,
					height = 160,
					shift = { 0, 0 },
					animation_speed = 0.5,
				},
			},
			{
				apply_recipe_tint = "secondary",
				animation = {
					filename = "__angelspetrochemgraphics__/graphics/entity/chemical-plant/pipe-tint.png",
					line_length = 6,
					frame_count = 36,
					width = 160,
					height = 160,
					shift = { 0, 0 },
					animation_speed = 0.5,
				},
			},
			{
				animation = {
					filename = "__angelspetrochemgraphics__/graphics/entity/chemical-plant/pipe-overlay.png",
					line_length = 6,
					frame_count = 36,
					width = 160,
					height = 160,
					shift = { 0, 0 },
					animation_speed = 0.5,
				},
			},
		},
	}

	return graphics_set
end

---Defines the options for the Angel's chemical plant sprite set.
---@class ChemicalPlantSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

---Gets the sprite set for Angel's chemical plant.
---@param params ChemicalPlantSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's chemical plant.
---
---#### Examples
---```lua
---local chemical_plant = require("__reskins-assets-api__.assets.angels.entities.petrochem.chemical-plant")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = chemical_plant.get_sprite_set({ tint = tint })
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

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-angels__/graphics/icons" })

---Gets the icon for Angel's chemical plant, in the tints given by `params`.
M.get_icon = icons:tinted("chemical-plant"):build("get_icon")

return M
