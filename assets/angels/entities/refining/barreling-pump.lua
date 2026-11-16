---@diagnostic disable: generic-constraint-mismatch
---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")
local _sprites = require("__reskins-sprite-utils__.sprites")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local IconBuilderFactory = require("api.icon-builder-factory")
local AssemblingMachine1Explosion = require("assets.base.explosions.assembling-machine-1")
local Remnants = require("assets.base.remnants")

local PATH = _defines.assets_source.angels_assets .. "/graphics/entity/barreling-pump/barreling-pump"
local FOLDER = PATH .. "-"
local REMNANTS_PATH = _defines.assets_source.angels_assets
	.. "/graphics/entity/barreling-pump/remnants/barreling-pump-remnants"

-- Each entry defines a state of the working animation. The impeller speeds up as the chamber fills, turns once in each
-- loop, and slows to a stop as the chamber drains. When the machine does not work at the end of `fill-1`, the next
-- state is `drain-short`. The first frame of `fill-1`, which shows the empty chamber, is drawn in the idle state.
local STATES = {
	{ name = "idle", next_active = "fill-1", next_inactive = "idle" },
	{ name = "fill-1", frame_count = 12, next_active = "fill-2", next_inactive = "drain-short" },
	{ name = "fill-2", frame_count = 12, next_active = "loop", next_inactive = "drain" },
	{ name = "loop", frame_count = 36, next_active = "loop", next_inactive = "drain" },
	{ name = "drain", frame_count = 36, next_active = "fill-1", next_inactive = "idle" },
	{ name = "drain-short", frame_count = 16, next_active = "fill-1", next_inactive = "idle" },
}

local M = {}

---Gets the animation of Angel's barreling pump.
---@param tint? Color
---@return Animation4Way
---@nodiscard
local function get_animation(tint)
	---@type Animation[]
	local layers = {
		util.sprite_load(PATH, {
			priority = "high",
			scale = 0.5,
		}),
	}

	if tint then
		layers[#layers + 1] = util.sprite_load(FOLDER .. "mask", {
			priority = "high",
			tint = tint,
			scale = 0.5,
		})
		layers[#layers + 1] = util.sprite_load(FOLDER .. "highlights", {
			priority = "high",
			blend_mode = "additive",
			scale = 0.5,
		})
	end

	layers[#layers + 1] = util.sprite_load(FOLDER .. "shadow", {
		priority = "high",
		draw_as_shadow = true,
		scale = 0.5,
	})

	-- Each sheet has one frame for each direction, in the order north, east, south, and west.
	return _sprites.make_4way_animation_from_spritesheet({ layers = layers })
end

---Gets the states of the working animation for Angel's barreling pump.
---@return VisualState[]
---@nodiscard
local function get_states()
	---@type VisualState[]
	local states = {}

	-- The first state must have a duration of 1. Every other state has a duration of 2 for each frame of its working
	-- visualisations, which shows 15 frames per second at the default `animation_progress` of 0.5 and a machine speed
	-- of 1.
	for _, state in pairs(STATES) do
		states[#states + 1] = {
			name = state.name,
			duration = state.frame_count and 2 * state.frame_count or 1,
			next_active = state.next_active,
			next_inactive = state.next_inactive,
		}
	end

	return states
end

---Gets the working visualisations of Angel's barreling pump.
---@return WorkingVisualisation[]
---@nodiscard
local function get_working_visualisations()
	---@type WorkingVisualisation[]
	local working_visualisations = {}

	-- The first frame of `fill-1` is drawn in the idle state, so the chamber does not change when the machine starts to
	-- work.
	working_visualisations[#working_visualisations + 1] = {
		draw_in_states = { "idle" },
		always_draw = true,
		animation = util.sprite_load(FOLDER .. "fill-1-under", {
			priority = "high",
			frame_count = 1,
			scale = 0.5,
		}),
	}

	for _, state in pairs(STATES) do
		if state.frame_count then
			-- The states after the first continue to run when the machine does not work, so each visualisation sets
			-- `always_draw` to be drawn in its state while the machine does not work.
			-- The untinted visualisation shows the chamber and the impeller with the liquid as a dark body, and holds the
			-- foam and the highlights of the surface.
			working_visualisations[#working_visualisations + 1] = {
				draw_in_states = { state.name },
				always_draw = true,
				animation = util.sprite_load(FOLDER .. state.name .. "-under", {
					priority = "high",
					frame_count = state.frame_count,
					scale = 0.5,
				}),
			}

			-- The light of the liquid is drawn in the primary color of the recipe.
			working_visualisations[#working_visualisations + 1] = {
				draw_in_states = { state.name },
				always_draw = true,
				apply_recipe_tint = "primary",
				animation = util.sprite_load(FOLDER .. state.name .. "-water", {
					priority = "high",
					frame_count = state.frame_count,
					scale = 0.5,
				}),
			}
		end
	end

	-- The animations are drawn from the north. The positions place them on the dome in each direction.
	for _, working_visualisation in pairs(working_visualisations) do
		working_visualisation.north_position = { 0, 0 }
		working_visualisation.east_position = { 0, -0.1445 }
		working_visualisation.south_position = { 0, -0.4155 }
		working_visualisation.west_position = { 0, -0.0991 }
	end

	-- The glass of the dome is drawn over the chamber in every state. The sheet has one frame for each direction, in
	-- the order north, east, south, and west.
	local glass = _sprites.make_4way_animation_from_spritesheet(util.sprite_load(FOLDER .. "glass", {
		priority = "high",
		scale = 0.5,
	}))

	working_visualisations[#working_visualisations + 1] = {
		always_draw = true,
		north_animation = glass.north,
		east_animation = glass.east,
		south_animation = glass.south,
		west_animation = glass.west,
	}

	return working_visualisations
end

---Gets the sprite sheet for the given `layer` of the circuit connector on Angel's barreling pump.
---@param layer string
---@param options? table
---@return Sprite
---@nodiscard
local function get_circuit_connector_sheet(layer, options)
	local sheet = util.sprite_load(FOLDER .. "circuit-connector-" .. layer, {
		priority = "low",
		frame_count = 4,
		scale = 0.5,
	})

	for key, value in pairs(options or {}) do
		sheet[key] = value
	end

	return sheet
end

---Gets the circuit connector of Angel's barreling pump for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
---@nodiscard
local function get_circuit_connector()
	-- Each sheet has one frame for each direction, in the order north, east, south, and west.
	return circuit_connector_definitions.create_vector({
		connector_main = get_circuit_connector_sheet("main"),
		connector_shadow = get_circuit_connector_sheet("shadow", { draw_as_shadow = true }),
		led_red = get_circuit_connector_sheet("led-red", { draw_as_glow = true }),
		led_green = get_circuit_connector_sheet("led-green", { draw_as_glow = true }),
		led_blue = get_circuit_connector_sheet("led-blue", { draw_as_glow = true }),
		wire_offsets = {
			{ red = util.by_pixel(5.88, -13.16), green = util.by_pixel(6.97, -10.57) },
			{ red = util.by_pixel(-3.93, -14.64), green = util.by_pixel(-0.24, -15.35) },
			{ red = util.by_pixel(7.45, -10.3), green = util.by_pixel(6.55, -7.67) },
			{ red = util.by_pixel(0.17, -15.17), green = util.by_pixel(3.86, -14.47) },
		},
		wire_shadow_offsets = {
			{ red = util.by_pixel(25.05, 7.17), green = util.by_pixel(26.14, 9.76) },
			{ red = util.by_pixel(15.24, 5.69), green = util.by_pixel(18.92, 4.97) },
			{ red = util.by_pixel(26.61, 10.02), green = util.by_pixel(25.72, 12.65) },
			{ red = util.by_pixel(19.33, 5.16), green = util.by_pixel(23.03, 5.86) },
		},
		light_offsets = {
			{ rg = util.by_pixel(1.08, -6.46), b = util.by_pixel(2.18, -3.86) },
			{ rg = util.by_pixel(-2.61, -5.53), b = util.by_pixel(1.09, -6.25) },
			{ rg = util.by_pixel(2.58, -5.44), b = util.by_pixel(1.68, -2.8) },
			{ rg = util.by_pixel(-1.13, -6.06), b = util.by_pixel(2.57, -5.35) },
		},
	}, {
		{
			variation = 0,
			main_offset = util.by_pixel(-38.5, 12),
			shadow_offset = util.by_pixel(-38.5, 12),
			show_shadow = true,
		},
		{
			variation = 1,
			main_offset = util.by_pixel(11.5, 27.5),
			shadow_offset = util.by_pixel(11.5, 27.5),
			show_shadow = true,
		},
		{
			variation = 2,
			main_offset = util.by_pixel(-39.5, -16.5),
			shadow_offset = util.by_pixel(-39.5, -16.5),
			show_shadow = true,
		},
		{
			variation = 3,
			main_offset = util.by_pixel(-10.5, 28),
			shadow_offset = util.by_pixel(-10.5, 28),
			show_shadow = true,
		},
	})
end

---Gets the water reflection of Angel's barreling pump.
---@return WaterReflectionDefinition
---@nodiscard
local function get_water_reflection()
	return {
		pictures = util.sprite_load(FOLDER .. "reflection", {
			priority = "extra-high",
			variation_count = 4,
			scale = 5,
		}),
		rotate = false,
		orientation_to_variation = true,
	}
end

---Gets the integration patch of Angel's barreling pump.
---@return Sprite4Way
---@nodiscard
local function get_integration_patch()
	-- The sheet has one frame for each direction, in the order north, east, south, and west.
	local integration_patch = _sprites.make_4way_animation_from_spritesheet(util.sprite_load(FOLDER .. "integration", {
		priority = "high",
		scale = 0.5,
	}))

	return integration_patch --[[@as Sprite4Way]]
end

---Gets the frozen patch of Angel's barreling pump.
---@return Sprite4Way? # The frozen patch, or `nil` when the freezing feature is disabled.
---@nodiscard
local function get_frozen_patch()
	if not feature_flags["freezing"] then
		return nil
	end

	-- The sheet has one frame for each direction, in the order north, east, south, and west.
	local frozen_patch = _sprites.make_4way_animation_from_spritesheet(util.sprite_load(FOLDER .. "frozen", {
		priority = "high",
		scale = 0.5,
	}))

	return frozen_patch --[[@as Sprite4Way]]
end

---Gets the remnants artwork of Angel's barreling pump, with its mask and highlights when a `tint` is given.
---@param tint? Color
---@return RotatedAnimationVariations
---@nodiscard
local function get_remnants(tint)
	-- Each sheet has one frame for each direction, in the order north, east, south, and west.
	---@type RotatedAnimation[]
	local layers = {
		util.sprite_load(REMNANTS_PATH, {
			direction_count = 4,
			scale = 0.5,
		}),
	}

	if tint then
		layers[#layers + 1] = util.sprite_load(REMNANTS_PATH .. "-mask", {
			direction_count = 4,
			tint = tint,
			scale = 0.5,
		})
		layers[#layers + 1] = util.sprite_load(REMNANTS_PATH .. "-highlights", {
			direction_count = 4,
			blend_mode = "additive",
			scale = 0.5,
		})
	end

	return _sprites.make_rotated_animation_variations_from_spritesheet(1, { layers = layers })
end

---Gets the corpse of Angel's barreling pump for the given `tint`, which uses the other fields of the vanilla assembling
---machine 1 remnants.
---@param tint? Color
---@return CorpseSpriteSet
---@nodiscard
local function get_corpse(tint)
	return Remnants.get_corpse("assembling-machine-1-remnants", {
		animation = get_remnants(tint),
	})
end

---Defines the options for the Angel's barreling pump sprite set.
---@class BarrelingPumpSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("BarrelingPumpSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for Angel's barreling pump.
---
---The corpse of the set draws the wreckage of the machine on the ground, with one frame for each direction of the
---machine.
---
---The artwork is designed for a scale of 0.5 on a machine that is 3 tiles square.
---@param params BarrelingPumpSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's barreling pump.
---
---#### Examples
---```lua
----- Apply the tinted sprite set to the entity.
---local barreling_pump = require("__reskins-assets-api__.assets.angels.entities.refining.barreling-pump")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = barreling_pump.get_sprite_set({ tint = tint })
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
				states = get_states(),
				working_visualisations = get_working_visualisations(),
				-- This color tints the liquid when the recipe defines no tint.
				default_recipe_tint = { primary = { r = 0.20, g = 0.45, b = 0.45 } },
				frozen_patch = get_frozen_patch(),
			},
			circuit_connector = get_circuit_connector(),
			integration_patch = get_integration_patch(),
			integration_patch_render_layer = nil,
			dying_explosion = AssemblingMachine1Explosion.get_explosion({
				tints = params.tint and {
					["assembling-machine-1-metal-particle-big"] = params.tint,
					["assembling-machine-1-metal-particle-medium"] = params.tint,
				},
			}),
			corpse = get_corpse(params.tint),
			water_reflection = get_water_reflection(),
			drawing_box_vertical_extension = 0.4,
			nominal_width = 3,
			nominal_height = 3,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-angels__/graphics/icons" })

local icon_builder = icons:tinted("barreling-pump")

---Gets the icon for Angel's barreling pump, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the icon for Angel's barreling pump as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
