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
local BoilerExplosion = require("assets.base.explosions.boiler")

local ASSETS_ANGELS_PATH = "__reskins-assets-angels__/graphics/entity/boiler-electric/"

local M = {}

---Gets the animation of Angel's electric boiler.
---@param tint? Color
---@return Animation4Way
local function get_animation(tint)
	local layers = {
		{
			filename = ASSETS_ANGELS_PATH .. "boiler-electric-base.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			shift = { 0, 0 },
		},
	}

	if tint then
		table.insert(layers, {
			filename = ASSETS_ANGELS_PATH .. "boiler-electric-mask.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			shift = { 0, 0 },
			tint = tint,
		})
		table.insert(layers, {
			filename = ASSETS_ANGELS_PATH .. "boiler-electric-highlights.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			shift = { 0, 0 },
			blend_mode = "additive",
		})
	end

	return _sprites.make_4way_animation_from_spritesheet({ layers = layers }) --[[@as Animation4Way]]
end

---Gets the working visualisations of Angel's electric boiler.
---@return WorkingVisualisation[]
local function get_working_visualisations()
	local working_lights = _sprites.make_4way_animation_from_spritesheet({
		filename = ASSETS_ANGELS_PATH .. "boiler-electric-working-lights.png",
		priority = "extra-high",
		width = 160,
		height = 160,
		shift = { 0, 0 },
		blend_mode = "additive",
		draw_as_glow = true,
	}) --[[@as Animation4Way]]

	return {
		{
			fadeout = true,
			effect = "uranium-glow",
			north_animation = working_lights.north,
			east_animation = working_lights.east,
			south_animation = working_lights.south,
			west_animation = working_lights.west,
		},
	}
end

---Gets the circuit connector of Angel's electric boiler for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 2,
			main_offset = util.by_pixel(-37.25, -28.5),
			shadow_offset = util.by_pixel(-37.25, -28.5),
			show_shadow = true,
		},
		{
			variation = 15,
			main_offset = util.by_pixel(10.875, -55.5),
			shadow_offset = util.by_pixel(10.875, -55.5),
			show_shadow = true,
		},
		{
			variation = 2,
			main_offset = util.by_pixel(-37.25, -28.5),
			shadow_offset = util.by_pixel(-37.25, -28.5),
			show_shadow = true,
		},
		{
			variation = 15,
			main_offset = util.by_pixel(10.875, -55.5),
			shadow_offset = util.by_pixel(10.875, -55.5),
			show_shadow = true,
		},
	})
end

---Defines the options for the Angel's electric boiler sprite set.
---@class ElectricBoilerSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("ElectricBoilerSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for Angel's electric boiler.
---@param params ElectricBoilerSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's electric boiler.
---
---#### Examples
---```lua
---local electric_boiler = require("__reskins-assets-api__.assets.angels.entities.petrochem.electric-boiler")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = electric_boiler.get_sprite_set({ tint = tint })
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
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = BoilerExplosion.get_explosion({
				tints = params.tint and {
					["boiler-metal-particle-big"] = params.tint,
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

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-angels__/graphics/icons" })

---Gets the icon for Angel's electric boiler, in the tints given by `params`.
M.get_icon = icons:tinted("boiler-electric"):build("get_icon")

return M
