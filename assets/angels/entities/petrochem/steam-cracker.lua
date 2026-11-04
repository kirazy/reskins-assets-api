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
				filename = "__angelspetrochemgraphics__/graphics/entity/steam-cracker/steam-cracker.png",
				priority = "extra-high",
				width = 512,
				height = 512,
				scale = 0.5,
				shift = { 0.5, -0.5 },
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = "__reskins-assets-angels__/graphics/entity/steam-cracker/steam-cracker-mask.png",
			priority = "extra-high",
			width = 512,
			height = 512,
			scale = 0.5,
			shift = { 0.5, -0.5 },
			tint = tint,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = "__reskins-assets-angels__/graphics/entity/steam-cracker/steam-cracker-highlights.png",
			priority = "extra-high",
			width = 512,
			height = 512,
			scale = 0.5,
			shift = { 0.5, -0.5 },
			blend_mode = "additive",
		})
	end

	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = animation,
		working_visualisations = {
			{
				fadeout = true,
				constant_speed = true,
				north_position = util.by_pixel(-66, -96.0),
				east_position = util.by_pixel(-66, -96.0),
				south_position = util.by_pixel(-66, -96.0),
				west_position = util.by_pixel(-66, -96.0),
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
				north_position = util.by_pixel(-66, -96.0),
				east_position = util.by_pixel(-66, -96.0),
				south_position = util.by_pixel(-66, -96.0),
				west_position = util.by_pixel(-66, -96.0),
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
				light = { intensity = 0.8, size = 6, color = { r = 1.0, g = 1.0, b = 1.0 } },
			},
			{
				animation = {
					filename = "__reskins-assets-angels__/graphics/entity/steam-cracker/steam-cracker-light.png",
					priority = "extra-high",
					width = 512,
					height = 512,
					scale = 0.5,
					shift = { 0.5, -0.5 },
					blend_mode = "additive",
					draw_as_glow = true,
				},
			},
		},
	}

	return graphics_set
end

---Gets the circuit connector of Angel's steam cracker for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 18,
			main_offset = util.by_pixel(-55.375, 63.375),
			shadow_offset = util.by_pixel(-55.375, 63.375),
			show_shadow = true,
		},
		{
			variation = 18,
			main_offset = util.by_pixel(-55.375, 63.375),
			shadow_offset = util.by_pixel(-55.375, 63.375),
			show_shadow = true,
		},
		{
			variation = 18,
			main_offset = util.by_pixel(-55.375, 63.375),
			shadow_offset = util.by_pixel(-55.375, 63.375),
			show_shadow = true,
		},
		{
			variation = 18,
			main_offset = util.by_pixel(-55.375, 63.375),
			shadow_offset = util.by_pixel(-55.375, 63.375),
			show_shadow = true,
		},
	})
end

---Defines the options for the Angel's steam cracker sprite set.
---@class SteamCrackerSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

---Gets the sprite set for Angel's steam cracker.
---@param params SteamCrackerSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's steam cracker.
---
---#### Examples
---```lua
---local steam_cracker = require("__reskins-assets-api__.assets.angels.entities.petrochem.steam-cracker")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = steam_cracker.get_sprite_set({ tint = tint })
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
			drawing_box_vertical_extension = 0.6,
			nominal_width = 5,
			nominal_height = 5,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-angels__/graphics/icons" })

---Gets the icon for Angel's steam cracker, in the tints given by `params`.
M.get_icon = icons:tinted("steam-cracker"):build("get_icon")

return M
