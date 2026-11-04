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
				filename = "__reskins-assets-angels__/graphics/entity/air-filter/air-filter-base.png",
				priority = "extra-high",
				width = 256,
				height = 256,
				frame_count = 36,
				line_length = 6,
				shift = { 0.5, -0.5 },
				animation_speed = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = "__reskins-assets-angels__/graphics/entity/air-filter/air-filter-mask.png",
			priority = "extra-high",
			width = 256,
			height = 256,
			frame_count = 36,
			line_length = 6,
			shift = { 0.5, -0.5 },
			animation_speed = 0.5,
			tint = tint,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = "__reskins-assets-angels__/graphics/entity/air-filter/air-filter-highlights.png",
			priority = "extra-high",
			width = 256,
			height = 256,
			frame_count = 36,
			line_length = 6,
			shift = { 0.5, -0.5 },
			animation_speed = 0.5,
			blend_mode = "additive",
		})
	end

	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = animation,
		working_visualisations = {},
	}

	return graphics_set
end

---Gets the circuit connector of Angel's air filter for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 4,
			main_offset = util.by_pixel(-4.375, 62.625),
			shadow_offset = util.by_pixel(-4.375, 62.625),
			show_shadow = true,
		},
		{
			variation = 4,
			main_offset = util.by_pixel(-4.375, 62.625),
			shadow_offset = util.by_pixel(-4.375, 62.625),
			show_shadow = true,
		},
		{
			variation = 4,
			main_offset = util.by_pixel(-4.375, 62.625),
			shadow_offset = util.by_pixel(-4.375, 62.625),
			show_shadow = true,
		},
		{
			variation = 4,
			main_offset = util.by_pixel(-4.375, 62.625),
			shadow_offset = util.by_pixel(-4.375, 62.625),
			show_shadow = true,
		},
	})
end

---Defines the options for the Angel's air filter sprite set.
---@class AirFilterSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

---Gets the sprite set for Angel's air filter.
---@param params AirFilterSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's air filter.
---
---#### Examples
---```lua
---local air_filter = require("__reskins-assets-api__.assets.angels.entities.petrochem.air-filter")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = air_filter.get_sprite_set({ tint = tint })
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
			circuit_connector = get_circuit_connector(),
			drawing_box_vertical_extension = 0.3,
			nominal_width = 5,
			nominal_height = 5,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-angels__/graphics/icons" })

---Gets the icon for Angel's air filter, in the tints given by `params`.
M.get_icon = icons:tinted("air-filter"):build("get_icon")

return M
