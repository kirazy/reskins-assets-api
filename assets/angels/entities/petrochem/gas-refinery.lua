---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")
local _sprites = require("__reskins-sprite-utils__.sprites")
local IconBuilderFactory = require("api.icon-builder-factory")

local M = {}

---@param tint? Color
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint)
	local layers = {
		{
			filename = "__angelspetrochemgraphics__/graphics/entity/gas-refinery/gas-refinery-base.png",
			priority = "extra-high",
			width = 334,
			height = 553,
			shift = util.by_pixel(0, -48),
			scale = 0.5,
		},
		{
			filename = "__angelspetrochemgraphics__/graphics/entity/gas-refinery/gas-refinery-shadow.png",
			priority = "extra-high",
			width = 508,
			height = 338,
			shift = util.by_pixel(43.5, 6.5),
			draw_as_shadow = true,
			scale = 0.5,
		},
	}

	if tint then
		table.insert(layers, {
			filename = "__reskins-assets-angels__/graphics/entity/gas-refinery/gas-refinery-mask.png",
			priority = "extra-high",
			width = 334,
			height = 553,
			shift = util.by_pixel(0, -48),
			tint = tint,
			scale = 0.5,
		})
		table.insert(layers, {
			filename = "__reskins-assets-angels__/graphics/entity/gas-refinery/gas-refinery-highlights.png",
			priority = "extra-high",
			width = 334,
			height = 553,
			shift = util.by_pixel(0, -48),
			blend_mode = "additive",
			scale = 0.5,
		})
	end

	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = _sprites.make_4way_animation_from_spritesheet({ layers = layers }) --[[@as Animation4Way]],
		working_visualisations = {
			{
				fadeout = true,
				constant_speed = true,
				north_position = util.by_pixel(-57.5, -137.5),
				east_position = util.by_pixel(49.5, -174.5),
				south_position = util.by_pixel(59, -54),
				west_position = util.by_pixel(-50, -47.5),
				animation = {
					filename = "__base__/graphics/entity/oil-refinery/oil-refinery-fire-smoke.png",
					width = 54,
					height = 144,
					line_length = 5,
					frame_count = 20,
					animation_speed = 0.75,
					allow_reducing_frames = true,
					shift = util.by_pixel(1.0, -31.5),
					scale = 0.5,
				},
			},
			{
				fadeout = true,
				constant_speed = true,
				north_position = util.by_pixel(-57.5, -137.5),
				east_position = util.by_pixel(49.5, -174.5),
				south_position = util.by_pixel(59, -54),
				west_position = util.by_pixel(-50, -47.5),
				animation = {
					filename = "__base__/graphics/entity/oil-refinery/oil-refinery-fire-light.png",
					width = 28,
					height = 86,
					line_length = 5,
					frame_count = 20,
					animation_speed = 0.75,
					allow_reducing_frames = true,
					blend_mode = "additive",
					draw_as_glow = true,
					shift = util.by_pixel(0.5, -18.5),
					scale = 0.5,
				},
			},
			{
				-- FIXME: Use make4way
				fadeout = true,
				north_animation = {
					filename = "__angelspetrochemgraphics__/graphics/entity/gas-refinery/gas-refinery-light.png",
					priority = "extra-high",
					width = 334,
					height = 553,
					frame_count = 1,
					shift = util.by_pixel(0, -48),
					blend_mode = "additive",
					draw_as_glow = true,
					scale = 0.5,
				},
				east_animation = {
					filename = "__angelspetrochemgraphics__/graphics/entity/gas-refinery/gas-refinery-light.png",
					priority = "extra-high",
					width = 334,
					height = 553,
					x = 334,
					frame_count = 1,
					shift = util.by_pixel(0, -48),
					blend_mode = "additive",
					draw_as_glow = true,
					scale = 0.5,
				},
				south_animation = {
					filename = "__angelspetrochemgraphics__/graphics/entity/gas-refinery/gas-refinery-light.png",
					priority = "extra-high",
					width = 334,
					height = 553,
					x = 668,
					frame_count = 1,
					shift = util.by_pixel(0, -48),
					blend_mode = "additive",
					draw_as_glow = true,
					scale = 0.5,
				},
				west_animation = {
					filename = "__angelspetrochemgraphics__/graphics/entity/gas-refinery/gas-refinery-light.png",
					priority = "extra-high",
					width = 334,
					height = 553,
					x = 1002,
					frame_count = 1,
					shift = util.by_pixel(0, -48),
					blend_mode = "additive",
					draw_as_glow = true,
					scale = 0.5,
				},
			},
			{
				-- FIXME: Use vertical pipe shadow
				always_draw = true,
				north_animation = {
					layers = {
						{
							draw_as_shadow = true,
							filename = "__angelspetrochemgraphics__/graphics/entity/gas-refinery/vertical-pipe-shadow-patch.png",
							priority = "high",
							width = 128,
							height = 128,
							repeat_count = 36,
							shift = { -2, -2 },
							scale = 0.5,
						},
						{
							draw_as_shadow = true,
							filename = "__angelspetrochemgraphics__/graphics/entity/gas-refinery/vertical-pipe-shadow-patch.png",
							priority = "high",
							width = 128,
							height = 128,
							repeat_count = 36,
							shift = { 0, -2 },
							scale = 0.5,
						},
						{
							draw_as_shadow = true,
							filename = "__angelspetrochemgraphics__/graphics/entity/gas-refinery/vertical-pipe-shadow-patch.png",
							priority = "high",
							width = 128,
							height = 128,
							repeat_count = 36,
							shift = { 2, -2 },
							scale = 0.5,
						},
					},
				},
				-- FIXME: Use vertical pipe shadow
				south_animation = {
					layers = {
						{
							draw_as_shadow = true,
							filename = "__angelspetrochemgraphics__/graphics/entity/gas-refinery/vertical-pipe-shadow-patch.png",
							priority = "high",
							width = 128,
							height = 128,
							repeat_count = 36,
							shift = { -2, 2 },
							scale = 0.5,
						},
						{
							draw_as_shadow = true,
							filename = "__angelspetrochemgraphics__/graphics/entity/gas-refinery/vertical-pipe-shadow-patch.png",
							priority = "high",
							width = 128,
							height = 128,
							repeat_count = 36,
							shift = { 0, 2 },
							scale = 0.5,
						},
						{
							draw_as_shadow = true,
							filename = "__angelspetrochemgraphics__/graphics/entity/gas-refinery/vertical-pipe-shadow-patch.png",
							priority = "high",
							width = 128,
							height = 128,
							repeat_count = 36,
							shift = { 2, 2 },
							scale = 0.5,
						},
					},
				},
			},
		},
	}

	return graphics_set
end

---Gets the circuit connector of Angel's gas refinery for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 25,
			main_offset = util.by_pixel(29.875, -15.25),
			shadow_offset = util.by_pixel(29.875, -15.25),
			show_shadow = true,
		},
		{
			variation = 30,
			main_offset = util.by_pixel(-35.25, -4.875),
			shadow_offset = util.by_pixel(-35.25, -4.875),
			show_shadow = true,
		},
		{
			variation = 25,
			main_offset = util.by_pixel(-69.75, -88.625),
			shadow_offset = util.by_pixel(-69.75, -88.625),
			show_shadow = true,
		},
		{
			variation = 27,
			main_offset = util.by_pixel(56.375, -99.5),
			shadow_offset = util.by_pixel(56.375, -99.5),
			show_shadow = true,
		},
	})
end

---Defines the options for the Angel's gas refinery sprite set.
---@class GasRefinerySpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

---Gets the sprite set for Angel's gas refinery.
---@param params GasRefinerySpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's gas refinery.
---
---#### Examples
---```lua
---local gas_refinery = require("__reskins-assets-api__.assets.angels.entities.petrochem.gas-refinery")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = gas_refinery.get_sprite_set({ tint = tint })
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
			drawing_box_vertical_extension = 1.6,
			nominal_width = 5,
			nominal_height = 5,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-angels__/graphics/icons" })

---Gets the icon for Angel's gas refinery, in the tints given by `params`.
M.get_icon = icons:tinted("gas-refinery"):build("get_icon")

return M
