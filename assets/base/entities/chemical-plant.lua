---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local _sprites = require("__reskins-sprite-utils__.sprites")
local IconBuilderFactory = require("api.icon-builder-factory")
local ChemicalPlantExplosion = require("assets.base.explosions.chemical-plant")
local Remnants = require("assets.base.remnants")

local M = {}

---Gets the standard vanilla working visualisations for the chemical plant.
---
---All entries reference `__base__` paths and are passed through verbatim. No tint is applied.
---@return WorkingVisualisation[]
---@private
local function get_working_visualisations()
	return {
		{
			apply_recipe_tint = "primary",
			north_animation = {
				filename = "__base__/graphics/entity/chemical-plant/chemical-plant-liquid-north.png",
				frame_count = 24,
				line_length = 6,
				width = 66,
				height = 44,
				shift = util.by_pixel(23, 15),
				scale = 0.5,
			},
			east_animation = {
				filename = "__base__/graphics/entity/chemical-plant/chemical-plant-liquid-east.png",
				frame_count = 24,
				line_length = 6,
				width = 70,
				height = 36,
				shift = util.by_pixel(0, 22),
				scale = 0.5,
			},
			south_animation = {
				filename = "__base__/graphics/entity/chemical-plant/chemical-plant-liquid-south.png",
				frame_count = 24,
				line_length = 6,
				width = 66,
				height = 42,
				shift = util.by_pixel(0, 17),
				scale = 0.5,
			},
			west_animation = {
				filename = "__base__/graphics/entity/chemical-plant/chemical-plant-liquid-west.png",
				frame_count = 24,
				line_length = 6,
				width = 74,
				height = 36,
				shift = util.by_pixel(-10, 13),
				scale = 0.5,
			},
		},
		{
			apply_recipe_tint = "secondary",
			north_animation = {
				filename = "__base__/graphics/entity/chemical-plant/chemical-plant-foam-north.png",
				frame_count = 24,
				line_length = 6,
				width = 62,
				height = 42,
				shift = util.by_pixel(24, 15),
				scale = 0.5,
			},
			east_animation = {
				filename = "__base__/graphics/entity/chemical-plant/chemical-plant-foam-east.png",
				frame_count = 24,
				line_length = 6,
				width = 68,
				height = 36,
				shift = util.by_pixel(0, 22),
				scale = 0.5,
			},
			south_animation = {
				filename = "__base__/graphics/entity/chemical-plant/chemical-plant-foam-south.png",
				frame_count = 24,
				line_length = 6,
				width = 60,
				height = 40,
				shift = util.by_pixel(1, 17),
				scale = 0.5,
			},
			west_animation = {
				filename = "__base__/graphics/entity/chemical-plant/chemical-plant-foam-west.png",
				frame_count = 24,
				line_length = 6,
				width = 68,
				height = 28,
				shift = util.by_pixel(-9, 15),
				scale = 0.5,
			},
		},
		{
			apply_recipe_tint = "tertiary",
			fadeout = true,
			constant_speed = true,
			north_position = util.by_pixel_hr(-30, -161),
			east_position = util.by_pixel_hr(29, -150),
			south_position = util.by_pixel_hr(12, -134),
			west_position = util.by_pixel_hr(-32, -130),
			render_layer = "wires",
			animation = {
				filename = "__base__/graphics/entity/chemical-plant/chemical-plant-smoke-outer.png",
				frame_count = 47,
				line_length = 16,
				width = 90,
				height = 188,
				animation_speed = 0.5,
				shift = util.by_pixel(-2, -40),
				scale = 0.5,
			},
		},
		{
			apply_recipe_tint = "quaternary",
			fadeout = true,
			constant_speed = true,
			north_position = util.by_pixel_hr(-30, -161),
			east_position = util.by_pixel_hr(29, -150),
			south_position = util.by_pixel_hr(12, -134),
			west_position = util.by_pixel_hr(-32, -130),
			render_layer = "wires",
			animation = {
				filename = "__base__/graphics/entity/chemical-plant/chemical-plant-smoke-inner.png",
				frame_count = 47,
				line_length = 16,
				width = 40,
				height = 84,
				animation_speed = 0.5,
				shift = util.by_pixel(0, -14),
				scale = 0.5,
			},
		},
	}
end

---Gets the frozen patch of the chemical plant for each direction.
---@return Sprite4Way
local function get_frozen_patch()
	local filename = "__space-age__/graphics/entity/frozen/chemical-plant/chemical-plant-frozen.png"

	---@type Sprite4Way
	local frozen_patch = {}
	for index, direction in pairs({ "north", "east", "south", "west" }) do
		frozen_patch[direction] = {
			filename = filename,
			priority = "high",
			x = 220 * (index - 1),
			width = 220,
			height = 292,
			shift = util.by_pixel(0.5, -9),
			scale = 0.5,
		}
	end

	return frozen_patch
end

---@param tint? Color
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint)
	local assets_path = _defines.assets_source.base_assets .. "/graphics/entity/chemical-plant/"

	---@type Animation[]
	local layers = {
		{
			filename = assets_path .. "chemical-plant-base.png",
			priority = "high",
			width = 220,
			height = 292,
			frame_count = 24,
			line_length = 12,
			shift = util.by_pixel(0.5, -9),
			scale = 0.5,
		},
	}

	if tint then
		table.insert(layers, {
			filename = assets_path .. "chemical-plant-mask.png",
			priority = "high",
			width = 220,
			height = 292,
			frame_count = 24,
			line_length = 12,
			shift = util.by_pixel(0.5, -9),
			tint = tint,
			scale = 0.5,
		})
		table.insert(layers, {
			filename = assets_path .. "chemical-plant-highlights.png",
			priority = "high",
			width = 220,
			height = 292,
			frame_count = 24,
			line_length = 12,
			shift = util.by_pixel(0.5, -9),
			blend_mode = "additive",
			scale = 0.5,
		})
	end

	table.insert(layers, {
		filename = "__base__/graphics/entity/chemical-plant/chemical-plant-shadow.png",
		width = 312,
		height = 222,
		repeat_count = 24,
		shift = util.by_pixel(27, 6),
		draw_as_shadow = true,
		scale = 0.5,
	})

	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = _sprites.make_4way_animation_from_spritesheet({ layers = layers }) --[[@as Animation4Way]],
		working_visualisations = get_working_visualisations(),
	}

	if feature_flags["freezing"] and mods["space-age"] then
		graphics_set.frozen_patch = get_frozen_patch()
	end

	return graphics_set
end

---Gets the circuit connector of the chemical plant for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 2,
			main_offset = util.by_pixel(16.5, -20),
			shadow_offset = util.by_pixel(12.5 + 16.5 - 3, 18.5 - 20),
			show_shadow = true,
		},
		{
			variation = 7,
			main_offset = util.by_pixel(3, 0),
			shadow_offset = util.by_pixel(12.5, 18.5),
			show_shadow = true,
		},
		{
			variation = 6,
			main_offset = util.by_pixel(-15, -2.5),
			shadow_offset = util.by_pixel(12.5 - 15 - 3, 18.5 - 2.5),
			show_shadow = true,
		},
		{
			variation = 30,
			main_offset = util.by_pixel(-12.5, -14.5),
			shadow_offset = util.by_pixel(12.5 - 12.5 - 3, 18.5 - 14.5),
			show_shadow = true,
		},
	})
end

---Gets the water reflection of the chemical plant.
---@return WaterReflectionDefinition
local function get_water_reflection()
	return {
		pictures = {
			filename = "__base__/graphics/entity/chemical-plant/chemical-plant-reflection.png",
			priority = "extra-high",
			width = 28,
			height = 36,
			shift = util.by_pixel(5, 60),
			variation_count = 4,
			scale = 5,
		},
		rotate = false,
		orientation_to_variation = true,
	}
end
---@param tint? Color
---@return RotatedAnimationVariations
local function get_corpse_animation(tint)
	local assets_path = _defines.assets_source.base_assets .. "/graphics/entity/chemical-plant/remnants/"

	---@type RotatedAnimationVariations
	local animation = {
		layers = {
			{
				filename = assets_path .. "chemical-plant-remnants-base.png",
				width = 446,
				height = 342,
				direction_count = 1,
				shift = util.by_pixel(16, -5.5),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "chemical-plant-remnants-mask.png",
			width = 446,
			height = 342,
			direction_count = 1,
			shift = util.by_pixel(16, -5.5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "chemical-plant-remnants-highlights.png",
			width = 446,
			height = 342,
			direction_count = 1,
			shift = util.by_pixel(16, -5.5),
			blend_mode = "additive",
			scale = 0.5,
		})
	end

	return animation
end

---Defines the options for the vanilla chemical plant sprite set.
---@class ChemicalPlantSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

---Gets the sprite set for the vanilla chemical plant.
---@param params ChemicalPlantSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for the vanilla chemical plant.
---
---#### Examples
---```lua
---local chemical_plant = require("__reskins-assets-api__.assets.base.entities.chemical-plant")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = chemical_plant.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set(params)
	---@type SpriteSetDefinition<CraftingMachineSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.crafting_machine_sprite_set,
		set = {
			graphics_set = get_graphics_set(params.tint),
			circuit_connector = get_circuit_connector(),
			use_mirroring = true,
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = ChemicalPlantExplosion.get_explosion({
				tints = params.tint and {
					["chemical-plant-metal-particle-big"] = params.tint,
					["chemical-plant-metal-particle-medium"] = params.tint,
				},
			}),
			corpse = Remnants.get_corpse("chemical-plant-remnants", { animation = get_corpse_animation(params.tint) }),
			water_reflection = get_water_reflection(),
			drawing_box_vertical_extension = 0.4,
			nominal_width = 3,
			nominal_height = 3,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-base__/graphics/icons" })

---Gets the icon for the vanilla chemical plant, in the tints given by `params`.
M.get_icon = icons:tinted("chemical-plant"):build("get_icon")

return M
