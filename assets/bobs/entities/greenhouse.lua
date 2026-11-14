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

local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")

local ASSETS_BOBS_PATH = "__reskins-assets-bobs__/graphics/entity/greenhouse/"
local BASE_LAB_PATH = "__base__/graphics/entity/lab/"

---The colors of glass in which the greenhouse is drawn, besides its green glass.
local GLASS_COLORS = { "cyan", "pink" }

local M = {}

---Gets the path to the greenhouse sheet in the given `glass` for the given `role`.
---@param glass? "cyan"|"pink" The color of the glass. When `nil`, the sheet with the green glass is used.
---@param role "base"|"lit"|"light" The role of the sheet.
---@return string
local function get_filename(glass, role)
	return ASSETS_BOBS_PATH .. "greenhouse-" .. (glass and glass .. "-" or "") .. role .. ".png"
end

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

---Adds the mask and highlights of the lab in the given `tint` to the layers of each direction in the given `animation`
---in place, after the layer at `index`.
---@param animation Animation4Way The animation, with layers for each direction.
---@param index integer The position of the layer after which the mask and highlights are added.
---@param tint? Color The color of the mask. When `nil`, the given `animation` is returned and is not modified.
---@return Animation4Way # The given `animation`.
local function with_mask(animation, index, tint)
	if not tint then
		return animation
	end

	for _, direction in pairs({ "north", "east", "south", "west" }) do
		local layers = animation[direction].layers
		for offset, layer in pairs(Lab.get_mask_layers({ tint = tint })) do
			table.insert(layers, index + offset, layer)
		end
	end

	return animation
end

---Gets the animation of the greenhouse for each direction.
---@param glass? "cyan"|"pink"
---@param tint? Color
---@return Animation4Way
local function get_animation(glass, tint)
	local base = _sprites.make_4way_animation_from_spritesheet({
		filename = get_filename(glass, "base"),
		width = 194,
		height = 192,
		shift = util.by_pixel(0, 0),
		scale = 0.5,
	})

	return with_mask({
		north = { layers = { base.north, get_shadow() } },
		east = { layers = { base.east, get_shadow() } },
		south = { layers = { base.south, get_shadow() } },
		west = { layers = { base.west, get_shadow() } },
	}, 1, tint)
end

---Gets the working visualisation of the lit greenhouse and its light, with the mask and highlights of the lab in the
---given `tint` drawn over the lit greenhouse.
---@param glass? "cyan"|"pink"
---@param tint? Color
---@return WorkingVisualisation
local function get_lights_working_visualisation(glass, tint)
	local lit = _sprites.make_4way_animation_from_spritesheet({
		filename = get_filename(glass, "lit"),
		width = 194,
		height = 192,
		shift = util.by_pixel(0, 0),
		scale = 0.5,
	})
	local light = _sprites.make_4way_animation_from_spritesheet({
		filename = get_filename(glass, "light"),
		width = 194,
		height = 192,
		draw_as_light = true,
		shift = util.by_pixel(0, 0),
		scale = 0.5,
	})

	-- The lit greenhouse covers the animation and the mask in it.
	local animation = with_mask({
		north = { layers = { lit.north, light.north } },
		east = { layers = { lit.east, light.east } },
		south = { layers = { lit.south, light.south } },
		west = { layers = { lit.west, light.west } },
	}, 1, tint)

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
---@param glass? "cyan"|"pink"
---@param tint? Color
---@return CraftingMachineGraphicsSet
local function get_graphics_set(glass, tint)
	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = get_animation(glass, tint),
		working_visualisations = {
			get_lights_working_visualisation(glass, tint),
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

---Gets the graphics for the fluid box of the greenhouse, which has no pipe pictures.
---@return FluidBoxGraphics
local function get_fluid_box_graphics()
	return {
		pipe_connections = { { direction = defines.direction.north } },
		secondary_draw_orders = { north = -1, east = 3, south = 3, west = 3 },
	}
end

---Defines the options for the greenhouse sprite set.
---@class GreenhouseSpriteSetParams
---The color of the glass, such as `"cyan"` for `greenhouse-cyan-base.png`. When `nil`, the green glass is used.
---@field glass? "cyan"|"pink"
---The color to tint the mask of the lab drawn over the artwork, the remnants, and the metal particles of the dying
---explosion. When `nil`, the mask is omitted from the set and the remnants and particles are not tinted.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("GreenhouseSpriteSetParams", {
			glass = V.one_of(GLASS_COLORS):optional(),
			tint = Common.color:optional(),
		})
			:strict()
			:optional(),
	},
})

---Gets the sprite set for the greenhouse, with the glass given by `params` and the mask of the lab in the tint given by
---`params`.
---
---The frozen patch is included when the freezing feature is enabled and Space Age is loaded.
---@param params? GreenhouseSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for the greenhouse.
---
---#### Examples
---```lua
----- Draw the greenhouse in cyan glass, with the mask of the lab in red.
---local greenhouse = require("__reskins-assets-api__.assets.bobs.entities.greenhouse")
---local applicators = require("__reskins-assets-api__.api.applicators")
---local tint = { r = 0.9, g = 0.2, b = 0.2 }
---
---local sprite_set = greenhouse.get_sprite_set({ glass = "cyan", tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@throws When `params` defines an unrecognized field.
---@throws When `params.glass` is not a color of glass in which the greenhouse is drawn.
---@throws When `params.tint` is not a `Color`.
---@nodiscard
function M.get_sprite_set(params)
	check_get_sprite_set(params)

	local glass = params and params.glass
	local tint = params and params.tint

	---@type SpriteSetDefinition<CraftingMachineSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.crafting_machine_sprite_set,
		set = {
			graphics_set = get_graphics_set(glass, tint),
			circuit_connector = get_circuit_connector(),
			fluid_boxes = { get_fluid_box_graphics() },
			integration_patch = get_integration_patch(),
			integration_patch_render_layer = nil,
			dying_explosion = LabExplosion.get_explosion({
				tints = tint and { ["lab-metal-particle-big"] = tint },
			}),
			corpse = Lab.get_sprite_set({ tint = tint }).set.corpse,
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

local get_base_icon_composition = icon_builder:build_composition("get_icon_composition")
local get_glass_icon_composition = icons
	:layers("greenhouse")
	:base()
	:keyed("glass", V.one_of(GLASS_COLORS), { "base" })
	:build_composition("get_icon_composition")

---Defines the options for the greenhouse icon.
---@class GreenhouseIconParams
---The color of the glass, such as `"cyan"` for `greenhouse-cyan-base.png`. When `nil`, the green glass is used.
---@field glass? "cyan"|"pink"
---The color to tint the mask of the lab drawn over the icon. When `nil`, the mask is omitted.
---@field tint? Color

local check_get_icon_composition = V.signature("get_icon_composition", {
	{
		"params",
		V.class("GreenhouseIconParams", {
			glass = V.one_of(GLASS_COLORS):optional(),
			tint = Common.color:optional(),
		})
			:strict()
			:optional(),
	},
})

---Gets the icon for the greenhouse as an `IconComposition`, with the glass given by `params` and the mask of the lab in
---the tint given by `params`.
---@param params? GreenhouseIconParams The options for the icon.
---@return IconComposition # The icon.
---@throws When `params` defines an unrecognized field.
---@throws When `params.glass` is not a color of glass in which the icon is drawn.
---@throws When `params.tint` is not a `Color`.
---@nodiscard
function M.get_icon_composition(params)
	check_get_icon_composition(params)

	local composition = params and params.glass and get_glass_icon_composition({ glass = params.glass })
		or get_base_icon_composition()
	if params and params.tint then
		composition = composition:add_canvas(Lab.get_mask_icon_composition({ tint = params.tint }))
	end

	return composition
end

return M
