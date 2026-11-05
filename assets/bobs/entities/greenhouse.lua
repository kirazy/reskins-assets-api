---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Entities

local _defines = require("api.defines")
local _pipes = require("assets.base.entities.pipe-pictures")
local _sprites = require("__reskins-sprite-utils__.sprites")
local IconBuilderFactory = require("api.icon-builder-factory")
local Lab = require("assets.base.entities.lab")
local LabExplosion = require("assets.base.explosions.lab")

local ASSETS_BOBS_PATH = "__reskins-assets-bobs__/graphics/entity/greenhouse/"
local BASE_LAB_PATH = "__base__/graphics/entity/lab/"

local M = {}

---Gets the shadow of the greenhouse.
---@return Animation
local function get_shadow()
	return {
		filename = BASE_LAB_PATH .. "lab-shadow.png",
		width = 242,
		height = 136,
		draw_as_shadow = true,
		shift = util.by_pixel(13, 11),
		scale = 0.5,
	}
end

---Gets the animation of the greenhouse for each direction.
---@return Animation4Way
local function get_animation()
	local base = _sprites.make_4way_animation_from_spritesheet({
		filename = ASSETS_BOBS_PATH .. "greenhouse-base.png",
		width = 194,
		height = 192,
		shift = util.by_pixel(0, 0),
		scale = 0.5,
	})

	return {
		north = { layers = { base.north, get_shadow() } },
		east = { layers = { base.east, get_shadow() } },
		south = { layers = { base.south, get_shadow() } },
		west = { layers = { base.west, get_shadow() } },
	}
end

---Gets the working visualisation of the lit greenhouse and its light.
---@return WorkingVisualisation
local function get_lights_working_visualisation()
	local animation = _sprites.make_4way_animation_from_spritesheet({
		layers = {
			{
				filename = ASSETS_BOBS_PATH .. "greenhouse-lit.png",
				width = 194,
				height = 192,
				shift = util.by_pixel(0, 0),
				scale = 0.5,
			},
			{
				filename = ASSETS_BOBS_PATH .. "greenhouse-light.png",
				width = 194,
				height = 192,
				draw_as_light = true,
				shift = util.by_pixel(0, 0),
				scale = 0.5,
			},
		},
	})

	return {
		fadeout = true,
		north_animation = animation.north,
		east_animation = animation.east,
		south_animation = animation.south,
		west_animation = animation.west,
	}
end

---Gets the working visualisation of the pipe shadow for the north and south directions.
---@return WorkingVisualisation
local function get_pipe_shadow_working_visualisation()
	return {
		always_draw = true,
		north_animation = _pipes.vertical_pipe_shadow({ 0, -1 }),
		south_animation = _pipes.vertical_pipe_shadow({ 0, 1 }),
	}
end

---Gets the graphics set of the greenhouse.
---@return CraftingMachineGraphicsSet
local function get_graphics_set()
	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = get_animation(),
		working_visualisations = {
			get_lights_working_visualisation(),
			get_pipe_shadow_working_visualisation(),
		},
		frozen_patch = Lab.get_frozen_patch(),
	}

	return graphics_set
end

---Gets the integration patch of the greenhouse.
---@return Sprite
local function get_integration_patch()
	return {
		filename = BASE_LAB_PATH .. "lab-integration.png",
		width = 242,
		height = 162,
		shift = util.by_pixel(0, 15.5),
		scale = 0.5,
	}
end

---Gets the circuit connector of the greenhouse for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 27,
			main_offset = util.by_pixel(30.5, 15.5),
			shadow_offset = util.by_pixel(37, 20.5),
			show_shadow = false,
		},
		{
			variation = 27,
			main_offset = util.by_pixel(30.5, 15.5),
			shadow_offset = util.by_pixel(37, 20.5),
			show_shadow = false,
		},
		{
			variation = 27,
			main_offset = util.by_pixel(30.5, 15.5),
			shadow_offset = util.by_pixel(37, 20.5),
			show_shadow = false,
		},
		{
			variation = 27,
			main_offset = util.by_pixel(30.5, 15.5),
			shadow_offset = util.by_pixel(37, 20.5),
			show_shadow = false,
		},
	})
end

---Gets the graphics of the fluid box of the greenhouse, which has no pipe pictures.
---@return FluidBoxGraphics
local function get_fluid_box_graphics()
	return {
		pipe_connections = { { direction = defines.direction.north } },
		secondary_draw_orders = { north = -1, east = 3, south = 3, west = 3 },
	}
end

---Gets the sprite set for the greenhouse.
---
---The frozen patch is included when the freezing feature is enabled and Space Age is loaded.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for the greenhouse.
---
---#### Examples
---```lua
---local greenhouse = require("__reskins-assets-api__.assets.bobs.entities.greenhouse")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = greenhouse.get_sprite_set()
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set()
	---@type SpriteSetDefinition<CraftingMachineSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.crafting_machine_sprite_set,
		set = {
			graphics_set = get_graphics_set(),
			circuit_connector = get_circuit_connector(),
			fluid_boxes = { get_fluid_box_graphics() },
			integration_patch = get_integration_patch(),
			integration_patch_render_layer = nil,
			dying_explosion = LabExplosion.get_explosion(),
			corpse = Lab.get_sprite_set({}).set.corpse,
			water_reflection = nil,
			nominal_width = 3,
			nominal_height = 3,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-bobs__/graphics/icons" })

local icon_builder = icons:layers("greenhouse"):base()

---Gets the icon for the greenhouse.
M.get_icon = icon_builder:build("get_icon")

---Gets the icon for the greenhouse as an `IconComposition`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
