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

local REFINING_GRAPHICS_PATH = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/"
local ASSETS_ANGELS_PATH = "__reskins-assets-angels__/graphics/entity/ore-flotation-cell/"

local M = {}

---Gets the animation of Angel's ore flotation cell for the given `direction`.
---@param direction "north"|"east"
---@return Animation
local function get_direction_animation(direction)
	-- Each sheet draws the north direction on the left and the east direction on the right.
	local column = direction == "east" and 1 or 0

	return {
		layers = {
			{
				filename = REFINING_GRAPHICS_PATH .. "ore-flotation-cell-base.png",
				priority = "extra-high",
				width = 333,
				height = 363,
				x = 333 * column,
				shift = util.by_pixel_hr(-1, -1),
				scale = 0.5,
			},
			{
				filename = REFINING_GRAPHICS_PATH .. "ore-flotation-cell-shadow.png",
				priority = "extra-high",
				width = 390,
				height = 326,
				x = 390 * column,
				shift = util.by_pixel_hr(29, 18),
				draw_as_shadow = true,
				scale = 0.5,
			},
		},
	}
end

---Gets the animation of Angel's ore flotation cell.
---@return Animation4Way
local function get_animation()
	-- The south and west directions draw the artwork of the north and east directions.
	return {
		north = get_direction_animation("north"),
		east = get_direction_animation("east"),
		south = get_direction_animation("north"),
		west = get_direction_animation("east"),
	}
end

---Gets the animation of Angel's ore flotation cell from the working visualisation sheet with the given `name`.
---@param name "idle"|"base"|"water-tintable"|"froth-tintable"
---@param frame_count 32|64
---@return Animation
local function get_working_animation(name, frame_count)
	return {
		filename = REFINING_GRAPHICS_PATH .. "ore-flotation-cell-animation-" .. name .. ".png",
		priority = "extra-high",
		width = 166,
		height = 117,
		frame_count = frame_count,
		line_length = 8,
		shift = util.by_pixel_hr(62, 5),
		scale = 0.5,
	}
end

---Gets the pipe cover overlay of Angel's ore flotation cell for the given `direction`.
---@param direction "north"|"east"
---@return Animation
local function get_pipe_cover_overlay(direction)
	return {
		filename = REFINING_GRAPHICS_PATH .. "ore-flotation-cell-pipe-cover-overlays.png",
		priority = "extra-high",
		width = 333,
		height = 363,
		x = direction == "east" and 333 or 0,
		shift = util.by_pixel_hr(-1, -1),
		scale = 0.5,
	}
end

---Gets the shadow patch of the vertical pipe of Angel's ore flotation cell.
---@return Animation
local function get_vertical_pipe_shadow_patch()
	return {
		filename = REFINING_GRAPHICS_PATH .. "vertical-pipe-shadow-patch.png",
		priority = "high",
		width = 128,
		height = 128,
		repeat_count = 36,
		draw_as_shadow = true,
		shift = { 0, -2 },
		scale = 0.5,
	}
end

---Gets the working visualisations of Angel's ore flotation cell.
---@param tint? Color
---@return WorkingVisualisation[]
local function get_working_visualisations(tint)
	---@type WorkingVisualisation[]
	local working_visualisations = {
		{
			always_draw = true,
			animation = get_working_animation("idle", 32),
		},
		{
			fadeout = true,
			animation = get_working_animation("base", 64),
		},
		{
			fadeout = true,
			apply_recipe_tint = "primary",
			animation = get_working_animation("water-tintable", 64),
		},
		{
			fadeout = true,
			apply_recipe_tint = "secondary",
			animation = get_working_animation("froth-tintable", 64),
		},
	}

	if tint then
		working_visualisations[#working_visualisations + 1] = {
			always_draw = true,
			animation = {
				layers = {
					{
						filename = ASSETS_ANGELS_PATH .. "ore-flotation-cell-mask.png",
						priority = "extra-high",
						width = 333,
						height = 363,
						shift = util.by_pixel_hr(-1, -1),
						tint = tint,
						scale = 0.5,
					},
					{
						filename = ASSETS_ANGELS_PATH .. "ore-flotation-cell-highlights.png",
						priority = "extra-high",
						width = 333,
						height = 363,
						shift = util.by_pixel_hr(-1, -1),
						blend_mode = "additive",
						scale = 0.5,
					},
				},
			},
		}
	end

	working_visualisations[#working_visualisations + 1] = {
		always_draw = true,
		render_layer = "higher-object-under",
		north_animation = get_pipe_cover_overlay("north"),
		east_animation = get_pipe_cover_overlay("east"),
		south_animation = get_pipe_cover_overlay("north"),
		west_animation = get_pipe_cover_overlay("east"),
	}

	working_visualisations[#working_visualisations + 1] = {
		always_draw = true,
		north_animation = get_vertical_pipe_shadow_patch(),
		south_animation = get_vertical_pipe_shadow_patch(),
	}

	return working_visualisations
end

---Gets the circuit connector of Angel's ore flotation cell for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 27,
			main_offset = util.by_pixel(-25.375, 10.875),
			shadow_offset = util.by_pixel(-25.375, 10.875),
			show_shadow = true,
		},
		{
			variation = 27,
			main_offset = util.by_pixel(-25.375, 10.875),
			shadow_offset = util.by_pixel(-25.375, 10.875),
			show_shadow = true,
		},
		{
			variation = 27,
			main_offset = util.by_pixel(-25.375, 10.875),
			shadow_offset = util.by_pixel(-25.375, 10.875),
			show_shadow = true,
		},
		{
			variation = 27,
			main_offset = util.by_pixel(-25.375, 10.875),
			shadow_offset = util.by_pixel(-25.375, 10.875),
			show_shadow = true,
		},
	})
end

---Defines the options for the Angel's ore flotation cell sprite set.
---@class OreFlotationCellSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("OreFlotationCellSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for Angel's ore flotation cell.
---@param params OreFlotationCellSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's ore flotation cell.
---
---#### Examples
---```lua
---local ore_flotation_cell = require("__reskins-assets-api__.assets.angels.entities.refining.ore-flotation-cell")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = ore_flotation_cell.get_sprite_set({ tint = tint })
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
				animation = get_animation(),
				working_visualisations = get_working_visualisations(params.tint),
			},
			circuit_connector = get_circuit_connector(),
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

---Gets the icon for Angel's ore flotation cell, in the tints given by `params`.
M.get_icon = icons:tinted("ore-flotation-cell"):build("get_icon")

return M
