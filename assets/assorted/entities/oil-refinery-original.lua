---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Assorted.Entities

local _defines = require("api.defines")
local _sprites = require("__reskins-sprite-utils__.sprites")
local IconBuilderFactory = require("api.icon-builder-factory")
local OilRefineryExplosion = require("assets.base.explosions.oil-refinery")
local Remnants = require("assets.base.remnants")

local M = {}

-- Setup inheritance.

---Gets the working visualisations of the original oil refinery: the fire of the flare stack and the light of the
---windows.
---@return WorkingVisualisation[]
local function get_working_visualisations()
	local assets_path = _defines.assets_source.assorted_assets .. "/graphics/entity/oil-refinery-original/"

	---Gets the light of the windows from the frame of the sprite sheet at the given `x`.
	---@param x integer
	---@return Animation
	local function get_light(x)
		return {
			filename = assets_path .. "oil-refinery-light.png",
			width = 321,
			height = 205,
			x = x,
			blend_mode = "additive",
			draw_as_glow = true,
			shift = util.by_pixel(-1, -50),
			scale = 0.5,
		}
	end

	return {
		{
			fadeout = true,
			constant_speed = true,
			north_position = util.by_pixel(34, -65),
			east_position = util.by_pixel(-52, -61),
			south_position = util.by_pixel(-59, -82),
			west_position = util.by_pixel(57, -58),
			animation = {
				filename = assets_path .. "oil-refinery-fire.png",
				line_length = 10,
				width = 40,
				height = 81,
				frame_count = 60,
				animation_speed = 0.75,
				scale = 0.5,
				draw_as_glow = true,
				shift = util.by_pixel(0, -14.25),
			},
		},
		{
			fadeout = true,
			north_animation = get_light(0),
			east_animation = get_light(321),
			south_animation = get_light(321 * 2),
			west_animation = get_light(321 * 3),
		},
	}
end

---Gets the frozen patch of the original oil refinery.
---@return Sprite4Way? # The frozen patch, or `nil` when the freezing feature is disabled.
local function get_frozen_patch()
	if not feature_flags["freezing"] then
		return nil
	end

	---@type Sprite
	local sheet = {
		filename = _defines.assets_source.assorted_assets .. "/graphics/entity/oil-refinery-original/oil-refinery-frozen.png",
		priority = "high",
		width = 386,
		height = 430,
		shift = util.by_pixel(0, -7.5),
		scale = 0.5,
	}

	return _sprites.make_4way_animation_from_spritesheet(sheet) --[[@as Sprite4Way]]
end

---@param tint? Color
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint)
	local assets_path = _defines.assets_source.assorted_assets .. "/graphics/entity/oil-refinery-original/"

	---@type Animation[]
	local layers = {
		{
			filename = assets_path .. "oil-refinery-base.png",
			priority = "high",
			width = 386,
			height = 430,
			shift = util.by_pixel(0, -7.5),
			scale = 0.5,
		},
	}

	if tint then
		table.insert(layers, {
			filename = assets_path .. "oil-refinery-mask.png",
			priority = "high",
			width = 386,
			height = 430,
			shift = util.by_pixel(0, -7.5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(layers, {
			filename = assets_path .. "oil-refinery-highlights.png",
			priority = "high",
			width = 386,
			height = 430,
			shift = util.by_pixel(0, -7.5),
			blend_mode = "additive",
			scale = 0.5,
		})
	end

	table.insert(layers, {
		filename = assets_path .. "oil-refinery-shadow.png",
		width = 674,
		height = 426,
		shift = util.by_pixel(82.5, 26.5),
		draw_as_shadow = true,
		scale = 0.5,
	})

	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = _sprites.make_4way_animation_from_spritesheet({ layers = layers }) --[[@as Animation4Way]],
		working_visualisations = get_working_visualisations(),
		frozen_patch = get_frozen_patch(),
	}

	return graphics_set
end

---@param tint? Color
---@return RotatedAnimationVariations
local function get_corpse_animation(tint)
	local assets_path = _defines.assets_source.assorted_assets .. "/graphics/entity/oil-refinery-original/remnants/"

	---@type RotatedAnimation
	local animation = {
		layers = {
			{
				filename = assets_path .. "oil-refinery-remnants-base.png",
				width = 467,
				height = 415,
				direction_count = 1,
				shift = util.by_pixel(-0.25, -0.25),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "oil-refinery-remnants-mask.png",
			width = 467,
			height = 415,
			direction_count = 1,
			shift = util.by_pixel(-0.25, -0.25),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "oil-refinery-remnants-highlights.png",
			width = 467,
			height = 415,
			direction_count = 1,
			shift = util.by_pixel(-0.25, -0.25),
			blend_mode = "additive",
			scale = 0.5,
		})
	end

	return animation
end

---Gets the water reflection of the original oil refinery.
---@return WaterReflectionDefinition
local function get_water_reflection()
	return {
		pictures = {
			filename = _defines.assets_source.assorted_assets
				.. "/graphics/entity/oil-refinery-original/oil-refinery-reflection.png",
			priority = "extra-high",
			width = 40,
			height = 48,
			shift = util.by_pixel(5, 95),
			variation_count = 4,
			scale = 5,
		},
		rotate = false,
		orientation_to_variation = true,
	}
end

---Gets the circuit connector of the original oil refinery for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 17,
			main_offset = util.by_pixel(-45, -29.5),
			shadow_offset = util.by_pixel(48.5, 11),
			show_shadow = true,
		},
		{
			variation = 19,
			main_offset = util.by_pixel(29.5, -24),
			shadow_offset = util.by_pixel(81, 53),
			show_shadow = true,
		},
		{
			variation = 19,
			main_offset = util.by_pixel(29.5, -24),
			shadow_offset = util.by_pixel(82.5, 65.5),
			show_shadow = true,
		},
		{
			variation = 17,
			main_offset = util.by_pixel(-8, -35.5),
			shadow_offset = util.by_pixel(86.5, 77.5),
			show_shadow = true,
		},
	})
end

---Defines the options for the original oil refinery sprite set.
---@class OilRefinerySpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

---Gets the sprite set for the original oil refinery.
---@param params OilRefinerySpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for the original oil refinery.
---
---#### Examples
---```lua
---local oil_refinery = require("__reskins-assets-api__.assets.assorted.entities.oil-refinery-original")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = oil_refinery.get_sprite_set({ tint = tint })
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
			dying_explosion = OilRefineryExplosion.get_explosion({
				tints = params.tint and {
					["oil-refinery-metal-particle-big-tint"] = params.tint,
					["oil-refinery-metal-particle-medium"] = params.tint,
				},
			}),
			corpse = Remnants.get_corpse("oil-refinery-remnants", { animation = get_corpse_animation(params.tint) }),
			water_reflection = get_water_reflection(),
			circuit_connector = get_circuit_connector(),
			drawing_box_vertical_extension = 0.3,
			nominal_width = 5,
			nominal_height = 5,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-base__/graphics/icons" })

---Gets the icon for the vanilla oil refinery, in the tints given by `params`.
M.get_icon = icons:tinted("oil-refinery"):build("get_icon")

return M
