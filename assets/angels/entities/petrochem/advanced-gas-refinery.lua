---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")
local _sprites = require("__reskins-sprite-utils__.sprites")
local _pipes = require("assets.base.entities.pipe-pictures")
local IconBuilderFactory = require("api.icon-builder-factory")

local M = {}

---@param tint? Color
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint)
	local layers = {
		{
			filename = "__angelspetrochemgraphics__/graphics/entity/advanced-gas-refinery/advanced-gas-refinery-base.png",
			priority = "extra-high",
			width = 462,
			height = 657,
			shift = util.by_pixel(0, -42),
			scale = 0.5,
		},
		{
			filename = "__angelspetrochemgraphics__/graphics/entity/advanced-gas-refinery/advanced-gas-refinery-shadow.png",
			priority = "extra-high",
			vertically_oriented = true,
			width = 655,
			height = 454,
			shift = util.by_pixel(48.5, 9.5),
			draw_as_shadow = true,
			scale = 0.5,
		},
	}

	if tint then
		table.insert(layers, {
			filename = "__reskins-assets-angels__/graphics/entity/gas-refinery-advanced/gas-refinery-advanced-mask.png",
			priority = "extra-high",
			width = 462,
			height = 657,
			shift = util.by_pixel(0, -42),
			tint = tint,
			scale = 0.5,
		})
		table.insert(layers, {
			filename = "__reskins-assets-angels__/graphics/entity/gas-refinery-advanced/gas-refinery-advanced-highlights.png",
			priority = "extra-high",
			width = 462,
			height = 657,
			shift = util.by_pixel(0, -42),
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
				north_position = util.by_pixel(-89, -121.5),
				east_position = util.by_pixel(34.5, -192.5),
				south_position = util.by_pixel(90.5, -79),
				west_position = util.by_pixel(-16, -20),
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
				north_position = util.by_pixel(-89, -121.5),
				east_position = util.by_pixel(34.5, -192.5),
				south_position = util.by_pixel(90.5, -79),
				west_position = util.by_pixel(-16, -20),
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
				fadeout = true,
				-- Convert this to use make4way
				north_animation = {
					filename = "__angelspetrochemgraphics__/graphics/entity/advanced-gas-refinery/advanced-gas-refinery-light.png",
					priority = "high",
					width = 462,
					height = 657,
					shift = util.by_pixel(0, -42),
					blend_mode = "additive",
					draw_as_glow = true,
					scale = 0.5,
				},
				east_animation = {
					filename = "__angelspetrochemgraphics__/graphics/entity/advanced-gas-refinery/advanced-gas-refinery-light.png",
					priority = "high",
					width = 462,
					height = 657,
					x = 462,
					shift = util.by_pixel(0, -42),
					blend_mode = "additive",
					draw_as_glow = true,
					scale = 0.5,
				},
				south_animation = {
					filename = "__angelspetrochemgraphics__/graphics/entity/advanced-gas-refinery/advanced-gas-refinery-light.png",
					priority = "high",
					width = 462,
					height = 657,
					x = 924,
					shift = util.by_pixel(0, -42),
					blend_mode = "additive",
					draw_as_glow = true,
					scale = 0.5,
				},
				west_animation = {
					filename = "__angelspetrochemgraphics__/graphics/entity/advanced-gas-refinery/advanced-gas-refinery-light.png",
					priority = "high",
					width = 462,
					height = 657,
					x = 1386,
					shift = util.by_pixel(0, -42),
					blend_mode = "additive",
					draw_as_glow = true,
					scale = 0.5,
				},
			},
			{
				always_draw = true,
				north_animation = {
					layers = {
						_pipes.vertical_pipe_shadow({ -1, -3 }),
						(_pipes.vertical_pipe_shadow({ 3, -3 })),
					},
				},
				south_animation = {
					layers = {
						_pipes.vertical_pipe_shadow({ -3, 3 }),
						_pipes.vertical_pipe_shadow({ -1, 3 }),
						(_pipes.vertical_pipe_shadow({ 1, 3 })),
					},
				},
			},
		},
	}

	return graphics_set
end

---Gets the circuit connector of Angel's advanced gas refinery for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 25,
			main_offset = util.by_pixel(60.875, -36.25),
			shadow_offset = util.by_pixel(60.875, -36.25),
			show_shadow = true,
		},
		{
			variation = 26,
			main_offset = util.by_pixel(-21.5, 12.75),
			shadow_offset = util.by_pixel(-21.5, 12.75),
			show_shadow = true,
		},
		{
			variation = 25,
			main_offset = util.by_pixel(-104, -114.875),
			shadow_offset = util.by_pixel(-104, -114.875),
			show_shadow = true,
		},
		{
			variation = 27,
			main_offset = util.by_pixel(42.25, -148.75),
			shadow_offset = util.by_pixel(42.25, -148.75),
			show_shadow = true,
		},
	})
end

---Defines the options for the Angel's advanced gas refinery sprite set.
---@class AdvancedGasRefinerySpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

---Gets the sprite set for Angel's advanced gas refinery.
---@param params AdvancedGasRefinerySpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's advanced gas refinery.
---
---#### Examples
---```lua
---local advanced_gas_refinery = require("__reskins-assets-api__.assets.angels.entities.petrochem.advanced-gas-refinery")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = advanced_gas_refinery.get_sprite_set({ tint = tint })
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
			drawing_box_vertical_extension = 2.2,
			nominal_width = 7,
			nominal_height = 7,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-angels__/graphics/icons" })

---Gets the icon for Angel's advanced gas refinery, in the tints given by `params`.
M.get_icon = icons:tinted("gas-refinery-advanced"):build("get_icon")

return M
