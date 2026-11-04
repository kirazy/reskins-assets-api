---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local IconBuilderFactory = require("api.icon-builder-factory")
local AssemblingMachine1Explosion = require("assets.base.explosions.assembling-machine-1")

local PETROCHEM_GRAPHICS_PATH = "__angelspetrochemgraphics__/graphics/entity/steam-cracker/"
local ASSETS_ANGELS_PATH = "__reskins-assets-angels__/graphics/entity/steam-cracker/"

local M = {}

---Gets the animation of Angel's steam cracker.
---@param tint? Color
---@return Animation
local function get_animation(tint)
	local layers = {
		{
			filename = PETROCHEM_GRAPHICS_PATH .. "steam-cracker.png",
			priority = "extra-high",
			width = 512,
			height = 512,
			scale = 0.5,
			shift = { 0.5, -0.5 },
		},
	}

	if tint then
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "steam-cracker-mask.png",
			priority = "extra-high",
			width = 512,
			height = 512,
			scale = 0.5,
			shift = { 0.5, -0.5 },
			tint = tint,
		}
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "steam-cracker-highlights.png",
			priority = "extra-high",
			width = 512,
			height = 512,
			scale = 0.5,
			shift = { 0.5, -0.5 },
			blend_mode = "additive",
		}
	end

	return { layers = layers }
end

---Gets the working visualisations of Angel's steam cracker.
---@return WorkingVisualisation[]
local function get_working_visualisations()
	return {
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
				filename = ASSETS_ANGELS_PATH .. "steam-cracker-light.png",
				priority = "extra-high",
				width = 512,
				height = 512,
				scale = 0.5,
				shift = { 0.5, -0.5 },
				blend_mode = "additive-soft",
				draw_as_glow = true,
			},
		},
	}
end

---Gets the pipe pictures of Angel's steam cracker that draw a pipe at a connection facing north.
---@return Sprite4Way
local function get_pipe_pictures()
	return {
		north = {
			filename = PETROCHEM_GRAPHICS_PATH .. "pipe-north1.png",
			priority = "extra-high",
			width = 64,
			height = 64,
			scale = 0.5,
			shift = { 0, 1 },
		},
		east = util.empty_sprite(),
		south = util.empty_sprite(),
		west = util.empty_sprite(),
	}
end

---Gets the pipe pictures that draw nothing in each direction.
---@return Sprite4Way
local function get_empty_pipe_pictures()
	return {
		north = util.empty_sprite(),
		east = util.empty_sprite(),
		south = util.empty_sprite(),
		west = util.empty_sprite(),
	}
end

---Gets the graphics of the fluid boxes of Angel's steam cracker.
---@return FluidBoxGraphics[]
local function get_fluid_box_graphics()
	-- The pipe on the north side is drawn at the left connection only. When the steam cracker is flipped, the fluid box
	-- at the right connection moves to the left connection and draws the pipe.
	return {
		{
			pipe_connections = {
				{ direction = defines.direction.south, position = { 1, 2 } },
				{ direction = defines.direction.north, position = { -1, -2 } },
			},
			pipe_picture = get_pipe_pictures(),
			mirrored_pipe_picture = get_empty_pipe_pictures(),
		},
		{
			pipe_connections = {
				{ direction = defines.direction.south, position = { -1, 2 } },
				{ direction = defines.direction.north, position = { 1, -2 } },
			},
			mirrored_pipe_picture = get_pipe_pictures(),
		},
	}
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

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("SteamCrackerSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

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
---@throws When `params` defines an unrecognized field.
---@throws When `params.tint` is not a `Color`.
---@nodiscard
function M.get_sprite_set(params)
	check_get_sprite_set(params)

	---@type SpriteSetDefinition<CraftingMachineSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.crafting_machine_sprite_set,
		set = {
			graphics_set = {
				animation = get_animation(params.tint),
				working_visualisations = get_working_visualisations(),
			},
			circuit_connector = get_circuit_connector(),
			fluid_boxes = get_fluid_box_graphics(),
			use_mirroring = true,
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = AssemblingMachine1Explosion.get_explosion({
				tints = params.tint and {
					["assembling-machine-1-metal-particle-big"] = params.tint,
					["assembling-machine-1-metal-particle-medium"] = params.tint,
				},
			}),
			corpse = _defines.generic_remnants,
			water_reflection = nil,
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
