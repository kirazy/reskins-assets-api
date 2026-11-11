---@diagnostic disable: generic-constraint-mismatch
---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Assorted.Entities

local _defines = require("api.defines")
local _sprites = require("__reskins-sprite-utils__.sprites")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local IconBuilderFactory = require("api.icon-builder-factory")
local Remnants = require("assets.base.remnants")

local M = {}

local FOLDER = _defines.assets_source.assorted_assets .. "/graphics/entity/wind-turbine/wind-turbine-"
local REMNANTS_FOLDER = _defines.assets_source.assorted_assets .. "/graphics/entity/wind-turbine/remnants/wind-turbine-"

-- The number of frames in which the rotor turns through one third of a revolution.
local ROTOR_FRAME_COUNT = 24

-- The number of variations of the remnants. Each file of the remnants holds them from top to bottom.
local REMNANTS_VARIATION_COUNT = 4

---Defines the orientation of the rotor of the wind turbine, an integer between 1 and 8.
---
---The rotor is turned 22.5 degrees clockwise from north at 1, and 45 degrees further for each step.
---@alias WindTurbineRotorOrientation 1|2|3|4|5|6|7|8

local rotor_orientation = V.one_of({ 1, 2, 3, 4, 5, 6, 7, 8 })

---Gets the layers of the artwork with the given `name`, with its mask and highlights when a `tint` is given.
---@param name string
---@param tint? Color
---@param frame_count? integer When `nil`, each layer draws the first frame of its file.
---@return Animation[]
---@nodiscard
local function get_tinted_layers(name, tint, frame_count)
	---@type Animation[]
	local layers = {
		util.sprite_load(FOLDER .. name, {
			priority = "high",
			frame_count = frame_count,
			scale = 0.5,
		}),
	}

	if tint then
		layers[#layers + 1] = util.sprite_load(FOLDER .. name .. "-mask", {
			priority = "high",
			frame_count = frame_count,
			tint = tint,
			scale = 0.5,
		})
		layers[#layers + 1] = util.sprite_load(FOLDER .. name .. "-highlights", {
			priority = "high",
			frame_count = frame_count,
			blend_mode = "additive",
			scale = 0.5,
		})
	end

	return layers
end

---Gets the shadow layer of the artwork with the given `name`.
---@param name string
---@param frame_count? integer When `nil`, the layer draws the first frame of its file.
---@return Animation
---@nodiscard
local function get_shadow_layer(name, frame_count)
	return util.sprite_load(FOLDER .. name .. "-shadow", {
		priority = "high",
		frame_count = frame_count,
		draw_as_shadow = true,
		scale = 0.5,
	})
end

---Gets the picture of the wind turbine for the given `tint`.
---@param tint? Color
---@param orientation? WindTurbineRotorOrientation When `nil`, the picture has no rotor.
---@return Sprite
---@nodiscard
local function get_picture(tint, orientation)
	local layers = get_tinted_layers("base", tint)

	if orientation then
		for _, layer in pairs(get_tinted_layers("rotor-" .. orientation, tint)) do
			layers[#layers + 1] = layer
		end
	end

	-- Shadows are always appended last.
	layers[#layers + 1] = get_shadow_layer("base")
	if orientation then
		layers[#layers + 1] = get_shadow_layer("rotor-" .. orientation)
	end

	---@type Sprite
	return {
		layers = layers --[[@as (Sprite[])]],
	}
end

---Gets the variations of the remnants artwork with the given `name`, with its mask and highlights when a `tint` is
---given.
---@param name "base"|"top"
---@param tint? Color
---@return RotatedAnimationVariations
---@nodiscard
local function get_remnants_variations(name, tint)
	local path = REMNANTS_FOLDER .. name .. "-remnants"

	---@type RotatedAnimation[]
	local layers = {
		util.sprite_load(path, {
			direction_count = 1,
			scale = 0.5,
		}),
	}

	if tint then
		layers[#layers + 1] = util.sprite_load(path .. "-mask", {
			direction_count = 1,
			tint = tint,
			scale = 0.5,
		})
		layers[#layers + 1] = util.sprite_load(path .. "-highlights", {
			direction_count = 1,
			blend_mode = "additive",
			scale = 0.5,
		})
	end

	return _sprites.make_rotated_animation_variations_from_spritesheet(REMNANTS_VARIATION_COUNT, { layers = layers })
end

---Gets the corpse of the wind turbine for the given `tint`, which uses the other fields of the vanilla big electric
---pole remnants.
---@param tint? Color
---@return CorpseSpriteSet
---@nodiscard
local function get_corpse(tint)
	return Remnants.get_corpse("big-electric-pole-remnants", {
		animation = get_remnants_variations("base", tint),
		animation_overlay = get_remnants_variations("top", tint),
	})
end

---Gets the water reflection of the wind turbine.
---@param use_nacelle_reflection? boolean When `true`, the reflection shows the tower and the nacelle, with one variation for each `WindTurbineRotorOrientation` in order; otherwise, the reflection shows the tower.
---@return WaterReflectionDefinition
---@nodiscard
local function get_water_reflection(use_nacelle_reflection)
	if use_nacelle_reflection then
		return {
			pictures = util.sprite_load(FOLDER .. "reflection", {
				priority = "extra-high",
				variation_count = 8,
				scale = 5,
			}),
			rotate = false,
			orientation_to_variation = true,
		}
	end

	return {
		pictures = util.sprite_load(FOLDER .. "tower-reflection", {
			priority = "extra-high",
			variation_count = 1,
			scale = 5,
		}),
		rotate = false,
		orientation_to_variation = false,
	}
end

---Defines the options for the wind turbine sprite set.
---@class WindTurbineSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color
---The orientation of a rotor that is drawn at rest on the tower. When `nil`, the set draws the base of the tower with
---no rotor.
---@field rotor_orientation? WindTurbineRotorOrientation
---When `true`, indicates that the water reflection shows the nacelle on the tower, with a variation for each
---orientation of the entity. Default `false`.
---@field use_nacelle_reflection? boolean

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("WindTurbineSpriteSetParams", {
			tint = Common.color:optional(),
			rotor_orientation = rotor_orientation:optional(),
			use_nacelle_reflection = V.boolean():optional(),
		}):strict(),
	},
})

---Gets the sprite set for the wind turbine.
---
---The set draws the base of the tower, up to the height at which the rotor animation begins. The upper tower, the
---nacelle, and the blades are drawn by the animation from `get_rotor_animation`, and their shadow by the animation from
---`get_rotor_shadow_animation`, each at the position of the entity.
---
---The corpse of the set has four variations. Each draws the foot of the tower and its wreckage on the ground, and three
---draw a broken tower that stands on the foot.
---
---The water reflection of the set shows the whole tower, with no nacelle and no blades. With
---`params.use_nacelle_reflection`, it shows the nacelle on the tower as well, in eight variations, and the game draws
---the variation that matches the orientation of the entity. The first variation is the first
---`WindTurbineRotorOrientation`, for an entity that faces north.
---
---The artwork is designed for a scale of 0.5 on the smallest wind turbine, which is 2.8 tiles wide.
---
---#### Parameters
---@param params WindTurbineSpriteSetParams The options for the sprite set.
---
---#### Returns
---@return SpriteSetDefinition<ElectricEnergyInterfaceSpriteSet> # The sprite set definition for the wind turbine.
---
---#### Examples
---```lua
----- Draw the base of the tower on the entity, and create the animation of the rotor for one orientation.
---local Applicators = require("__reskins-assets-api__.api.applicators")
---local WindTurbine = require("__reskins-assets-api__.assets.assorted.entities.wind-turbine")
---
---Applicators.apply_sprite_set(entity, WindTurbine.get_sprite_set({ tint = tint }))
---
---data:extend({
---    {
---        type = "animation",
---        name = "wind-turbine-rotor-1",
---        layers = WindTurbine.get_rotor_animation({ orientation = 1, tint = tint }).layers,
---    },
---})
---```
---@throws When `params` defines an unrecognized field.
---@throws When `params.tint` is not a `Color`.
---@throws When `params.rotor_orientation` is not an integer between 1 and 8.
---@throws When `params.use_nacelle_reflection` is not a boolean.
---@see get_rotor_animation
---@see get_rotor_shadow_animation
---@nodiscard
function M.get_sprite_set(params)
	check_get_sprite_set(params)

	---@type SpriteSetDefinition<ElectricEnergyInterfaceSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.electric_energy_interface_sprite_set,
		set = {
			picture = get_picture(params.tint, params.rotor_orientation),
			pictures = nil,
			animation = nil,
			animations = nil,
			light = nil,
			integration_patch = util.sprite_load(FOLDER .. "integration", {
				priority = "high",
				scale = 0.5,
			}),
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = get_corpse(params.tint),
			water_reflection = get_water_reflection(params.use_nacelle_reflection),
			drawing_box_vertical_extension = params.rotor_orientation and 12.5 or 1.75,
			nominal_width = 2.8,
			nominal_height = 2.8,
		},
	}

	return definition
end

---Defines the options for the rotor animation of the wind turbine.
---@class WindTurbineRotorAnimationParams
---The orientation of the rotor.
---@field orientation WindTurbineRotorOrientation
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the animation.
---@field tint? Color

local check_get_rotor_animation = V.signature("get_rotor_animation", {
	{
		"params",
		V.class("WindTurbineRotorAnimationParams", {
			orientation = rotor_orientation,
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the animation of the upper tower, the nacelle, and the blades of the wind turbine for the given orientation.
---
---The blades turn clockwise through one third of a revolution in 24 frames, after which the animation repeats. The
---animation is drawn at the position of the entity, at a scale of 0.5.
---
---#### Parameters
---@param params WindTurbineRotorAnimationParams The options for the animation.
---
---#### Returns
---@return Animation # The animation.
---@throws When `params` defines an unrecognized field.
---@throws When `params.orientation` is not an integer between 1 and 8.
---@throws When `params.tint` is not a `Color`.
---@see get_rotor_shadow_animation
---@nodiscard
function M.get_rotor_animation(params)
	check_get_rotor_animation(params)

	---@type Animation
	return { layers = get_tinted_layers("rotor-" .. params.orientation, params.tint, ROTOR_FRAME_COUNT) }
end

---Defines the options for the rotor shadow animation of the wind turbine.
---@class WindTurbineRotorShadowAnimationParams
---The orientation of the rotor.
---@field orientation WindTurbineRotorOrientation

local check_get_rotor_shadow_animation = V.signature("get_rotor_shadow_animation", {
	{
		"params",
		V.class("WindTurbineRotorShadowAnimationParams", {
			orientation = rotor_orientation,
		}):strict(),
	},
})

---Gets the animation of the shadow that the nacelle and the blades of the wind turbine cast for the given orientation.
---
---The animation has the frames of the animation from `get_rotor_animation` and is drawn at the position of the entity,
---at a scale of 0.5. The shadow of the tower is in the sprite set.
---
---#### Parameters
---@param params WindTurbineRotorShadowAnimationParams The options for the animation.
---
---#### Returns
---@return Animation # The animation.
---@throws When `params` defines an unrecognized field.
---@throws When `params.orientation` is not an integer between 1 and 8.
---@see get_rotor_animation
---@nodiscard
function M.get_rotor_shadow_animation(params)
	check_get_rotor_shadow_animation(params)

	---@type Animation
	return { layers = { get_shadow_layer("rotor-" .. params.orientation, ROTOR_FRAME_COUNT) } }
end

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.assorted_assets .. "/graphics/icons" })

local icon_builder = icons:tinted("wind-turbine")

---Gets the icon for the wind turbine, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the icon for the wind turbine as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
