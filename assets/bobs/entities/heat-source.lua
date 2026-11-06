---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.Assets.Base.Entities
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Entities

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local EnergySources = require("api.energy-sources")
local IconBuilderFactory = require("api.icon-builder-factory")
local AssemblingMachineOriginal = require("assets.assorted.entities.assembling-machine-original")
local NuclearReactorExplosion = require("assets.base.explosions.nuclear-reactor")

local ASSETS_BOBS_PATH = "__reskins-assets-bobs__/graphics/entity/heat-source/"

local M = {}

local HeatPipeMaterial = V.one_of({ "base", "aluminum-invar", "silver-aluminum", "silver-titanium", "gold-copper" })

---The variant of a heat source, which selects the artwork of its fire. The variant `"burner"` burns fuel items, and the
---variant `"fluid"` burns fluids.
---@alias HeatSourceVariant "burner"|"fluid"

local HeatSourceVariant = V.one_of({ "burner", "fluid" })

---Gets one layer of the picture of the heat source, from the file with the given `filename`.
---@param filename string
---@return Sprite
local function get_picture_layer(filename)
	return {
		filename = filename,
		priority = "high",
		width = 84,
		height = 66,
		scale = 1.5,
		shift = { 0.4375 * 1.5, 0.03125 * 1.5 },
	}
end

---Gets the picture of the heat source.
---@param tint? Color
---@return Sprite
local function get_picture(tint)
	local layers = { get_picture_layer(ASSETS_BOBS_PATH .. "heat-source-base.png") }

	if tint then
		local mask = get_picture_layer(ASSETS_BOBS_PATH .. "heat-source-mask.png")
		mask.tint = tint
		layers[#layers + 1] = mask

		local highlights = get_picture_layer(ASSETS_BOBS_PATH .. "heat-source-highlights.png")
		highlights.blend_mode = "additive"
		layers[#layers + 1] = highlights
	end

	local shadow = get_picture_layer(ASSETS_BOBS_PATH .. "heat-source-shadow.png")
	shadow.draw_as_shadow = true
	layers[#layers + 1] = shadow

	return { layers = layers }
end

---Gets the connection patches of the heat source for the given `pipe_material`.
---@param pipe_material HeatPipeMaterial
---@param is_connected boolean
---@return SpriteVariations
local function get_connection_patches(pipe_material, is_connected)
	return {
		sheet = {
			filename = ASSETS_BOBS_PATH .. "heat-source-connect-patches-" .. pipe_material .. ".png",
			width = 64,
			height = 64,
			y = (not is_connected) and 64 or nil,
			variation_count = 12,
			scale = 0.5,
		},
	}
end

---Gets a flame of the fluid heat source, from the file with the given `filename`.
---@param filename string
---@param width integer
---@param shift_x double
---@return Animation
local function get_fluid_flame(filename, width, shift_x)
	return {
		filename = filename,
		priority = "high",
		width = width,
		height = 38,
		frame_count = 12,
		scale = 2 / 3,
		draw_as_glow = true,
		shift = { shift_x, 0.671875 * 1.5 },
	}
end

---Gets the fire of the heat source for the given `variant`.
---@param variant HeatSourceVariant
---@return Animation
local function get_working_light_picture(variant)
	if variant == "fluid" then
		return {
			layers = {
				get_fluid_flame(ASSETS_BOBS_PATH .. "heat-source-fire-fluid-1.png", 22, -0.40625 * 1.5),
				get_fluid_flame(ASSETS_BOBS_PATH .. "heat-source-fire-fluid-2.png", 17, 0.40625 * 1.5),
			},
		}
	end

	return {
		filename = ASSETS_BOBS_PATH .. "heat-source-fire-burner.png",
		priority = "high",
		width = 36,
		height = 19,
		frame_count = 12,
		scale = 1.5,
		draw_as_glow = true,
		shift = { -0.03125 * 1.5, 0.671875 * 1.5 },
	}
end

---Gets the graphics set of the heat source for the given `variant` and `pipe_material`.
---@param tint? Color
---@param variant HeatSourceVariant
---@param pipe_material HeatPipeMaterial
---@return ReactorGraphicsSet
local function get_graphics_set(tint, variant, pipe_material)
	---@type ReactorGraphicsSet
	---@diagnostic disable-next-line: missing-fields
	local graphics_set = {
		picture = get_picture(tint),
		working_light_picture = get_working_light_picture(variant),
		lower_layer_picture = {
			filename = ASSETS_BOBS_PATH .. "heat-source-base-pipes-" .. pipe_material .. ".png",
			width = 192,
			height = 192,
			scale = 0.5,
			shift = { -0.03125, -0.1875 },
		},
		connection_patches_connected = get_connection_patches(pipe_material, true),
		connection_patches_disconnected = get_connection_patches(pipe_material, false),
	}

	return graphics_set
end

---Gets the graphics of the fluid box of a fluid energy source.
---@param tint? Color
---@return FluidBoxGraphics
local function get_fluid_box_graphics(tint)
	return {
		pipe_picture = AssemblingMachineOriginal.get_pipe_pictures({ tint = tint }),
		secondary_draw_orders = {
			north = -1,
		},
	}
end

---Gets the circuit connector of the heat source.
---@return CircuitConnectorDefinition
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_single(universal_connector_template, {
		variation = 26,
		main_offset = util.by_pixel(10, -20),
		shadow_offset = util.by_pixel(32, 0),
		show_shadow = false,
	})
end

---Defines the options for the heat source sprite set.
---@class HeatSourceSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color
---The variant of the heat source.
---@field variant HeatSourceVariant
---The material from which the heat pipes are built.
---@field pipe_material HeatPipeMaterial

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("HeatSourceSpriteSetParams", {
			tint = Common.color:optional(),
			variant = HeatSourceVariant,
			pipe_material = HeatPipeMaterial,
		}):strict(),
	},
})

---Gets the sprite set for the heat source.
---@param params HeatSourceSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<ReactorSpriteSet> # The sprite set definition for the heat source.
---
---#### Examples
---```lua
---local heat_source = require("__reskins-assets-api__.assets.bobs.entities.heat-source")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = heat_source.get_sprite_set({ tint = tint, variant = "fluid", pipe_material = "aluminum-invar" })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@throws When `params` defines an unrecognized field.
---@throws When `params.variant` is not a `HeatSourceVariant`.
---@throws When `params.pipe_material` is not a `HeatPipeMaterial`.
---@throws When `params.tint` is not a `Color`.
---@nodiscard
function M.get_sprite_set(params)
	check_get_sprite_set(params)

	---@type SpriteSetDefinition<ReactorSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.reactor_sprite_set,
		set = {
			graphics_set = get_graphics_set(params.tint, params.variant, params.pipe_material),
			use_fuel_glow_color = false,
			light = nil,
			light_flicker = EnergySources.get_zeroed_light_flicker(),
			circuit_connector = get_circuit_connector(),
			fluid_boxes = { get_fluid_box_graphics(params.tint) },
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = NuclearReactorExplosion.get_explosion({
				tints = params.tint and {
					["nuclear-reactor-metal-particle-big"] = params.tint,
					["nuclear-reactor-metal-particle-medium"] = params.tint,
				},
			}),
			corpse = _defines.generic_remnants,
			water_reflection = nil,
			nominal_width = 3,
			nominal_height = 3,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-bobs__/graphics/icons" })

local VARIANTS = { "burner", "fluid" }

---Gets the builder of the icon of the heat source of the given `variant`.
---@param variant HeatSourceVariant
---@return IconBuilder<{ base_tint?: Color, tint?: Color }>
local function get_icon_builder(variant)
	return icons:tinted("heat-source-" .. variant)
end

---Gets the icon for a heat source of the `variant` and in the tints given by `params`.
M.get_icon = IconBuilderFactory.dispatch("variant", VARIANTS, "get_icon", get_icon_builder)

---Gets the icon for a heat source of the `variant` as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition =
	IconBuilderFactory.dispatch_composition("variant", VARIANTS, "get_icon_composition", get_icon_builder)

return M
