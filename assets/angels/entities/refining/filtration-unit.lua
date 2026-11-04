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

local REFINING_GRAPHICS_PATH = "__angelsrefininggraphics__/graphics/entity/filtration-unit/"
local ASSETS_ANGELS_PATH = "__reskins-assets-angels__/graphics/entity/filtration-unit/"

local M = {}

---Gets the animation of Angel's filtration unit.
---@param tint? Color
---@return Animation
local function get_animation(tint)
	local layers = {
		{
			filename = REFINING_GRAPHICS_PATH .. "filtration-unit.png",
			priority = "extra-high",
			width = 224,
			height = 224,
			shift = { 0, -0.2 },
		},
	}

	if tint then
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "filtration-unit-mask.png",
			priority = "extra-high",
			width = 224,
			height = 224,
			shift = { 0, -0.2 },
			tint = tint,
		}
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "filtration-unit-highlights.png",
			priority = "extra-high",
			width = 224,
			height = 224,
			shift = { 0, -0.2 },
			blend_mode = "additive",
		}
	end

	return { layers = layers }
end

---Gets the pipe picture of Angel's filtration unit for the given `variation`.
---@param variation 1|2
---@return Sprite4Way
local function get_pipe_picture(variation)
	---@type Sprite
	local north
	if variation == 1 then
		north = {
			filename = REFINING_GRAPHICS_PATH .. "pipe-north1.png",
			priority = "extra-high",
			width = 68,
			height = 74,
			scale = 0.5,
			shift = { 0, 1 },
		}
	else
		north = {
			filename = REFINING_GRAPHICS_PATH .. "pipe-north2.png",
			priority = "extra-high",
			width = 128,
			height = 128,
			scale = 0.5,
			shift = { 0, 1.5 },
		}
	end

	return {
		north = north,
		east = {
			filename = REFINING_GRAPHICS_PATH .. "pipe-east.png",
			priority = "extra-high",
			width = 34,
			height = 47,
			shift = { -0.7, -0.1 },
		},
		south = {
			filename = REFINING_GRAPHICS_PATH .. "pipe-south.png",
			priority = "extra-high",
			width = 34,
			height = 39,
			shift = { 0, -0.75 },
		},
		west = {
			filename = REFINING_GRAPHICS_PATH .. "pipe-west.png",
			priority = "extra-high",
			width = 34,
			height = 47,
			shift = { 0.7, -0.1 },
		},
	}
end

---Gets the graphics of the fluid boxes of Angel's filtration unit.
---@return FluidBoxGraphics[]
local function get_fluid_box_graphics()
	-- The two connections on each side take opposite pipe pictures.
	return {
		{
			pipe_connections = {
				{ direction = defines.direction.south, position = { 1, 2 } },
				{ direction = defines.direction.north, position = { -1, -2 } },
			},
			pipe_picture = get_pipe_picture(1),
			mirrored_pipe_picture = get_pipe_picture(2),
		},
		{
			pipe_connections = {
				{ direction = defines.direction.south, position = { -1, 2 } },
				{ direction = defines.direction.north, position = { 1, -2 } },
			},
			pipe_picture = get_pipe_picture(2),
			mirrored_pipe_picture = get_pipe_picture(1),
		},
	}
end

---Gets the circuit connector of Angel's filtration unit for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 4,
			main_offset = util.by_pixel(-27.25, 38),
			shadow_offset = util.by_pixel(-27.25, 38),
			show_shadow = true,
		},
		{
			variation = 4,
			main_offset = util.by_pixel(-27.25, 38),
			shadow_offset = util.by_pixel(-27.25, 38),
			show_shadow = true,
		},
		{
			variation = 4,
			main_offset = util.by_pixel(-27.25, 38),
			shadow_offset = util.by_pixel(-27.25, 38),
			show_shadow = true,
		},
		{
			variation = 4,
			main_offset = util.by_pixel(-27.25, 38),
			shadow_offset = util.by_pixel(-27.25, 38),
			show_shadow = true,
		},
	})
end

---Defines the options for the Angel's filtration unit sprite set.
---@class FiltrationUnitSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("FiltrationUnitSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for Angel's filtration unit.
---@param params FiltrationUnitSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's filtration unit.
---
---#### Examples
---```lua
---local filtration_unit = require("__reskins-assets-api__.assets.angels.entities.refining.filtration-unit")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = filtration_unit.get_sprite_set({ tint = tint })
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
			graphics_set = { animation = get_animation(params.tint) },
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
			nominal_width = 5,
			nominal_height = 5,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-angels__/graphics/icons" })

---Gets the icon for Angel's filtration unit, in the tints given by `params`.
M.get_icon = icons:tinted("filtration-unit"):build("get_icon")

return M
