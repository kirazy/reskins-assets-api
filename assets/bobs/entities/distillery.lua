---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Entities

local _defines = require("api.defines")
local _sprites = require("__reskins-sprite-utils__.sprites")
local IconBuilderFactory = require("api.icon-builder-factory")

local ASSETS_BOBS_PATH = "__reskins-assets-bobs__/graphics/entity/distillery/"

local M = {}

---@return Sprite4Way
local function get_frozen_patch()
	return _sprites.make_4way_animation_from_spritesheet({
		filename = ASSETS_BOBS_PATH .. "distillery-frozen.png",
		width = 148,
		height = 192,
		shift = util.by_pixel(0, 0),
		scale = 0.5,
	}) --[[@as Sprite4Way]]
end

---@param tint? Color
---@return Animation4Way
local function get_animation(tint)
	local source_layers = {
		{
			filename = ASSETS_BOBS_PATH .. "distillery-base.png",
			width = 148,
			height = 192,
			shift = util.by_pixel(0, 0),
			scale = 0.5,
		},
		{
			filename = ASSETS_BOBS_PATH .. "distillery-shadow.png",
			width = 192,
			height = 134,
			draw_as_shadow = true,
			shift = util.by_pixel(16, 1.5),
			scale = 0.5,
		},
	}

	if tint then
		source_layers[#source_layers + 1] = {
			filename = ASSETS_BOBS_PATH .. "distillery-mask.png",
			width = 148,
			height = 192,
			tint = tint,
			shift = util.by_pixel(0, 0),
			scale = 0.5,
		}
		source_layers[#source_layers + 1] = {
			filename = ASSETS_BOBS_PATH .. "distillery-highlights.png",
			width = 148,
			height = 192,
			blend_mode = "additive",
			shift = util.by_pixel(0, 0),
			scale = 0.5,
		}
	end

	return _sprites.make_4way_animation_from_spritesheet({ layers = source_layers })
end

local function get_lights_working_visualisation()
	return {
		effect = "uranium-glow",
		fadeout = true,
		north_position = util.by_pixel(-7.5, -9),
		east_position = util.by_pixel(10, -9),
		south_position = util.by_pixel(8, 3.5),
		west_position = util.by_pixel(-10, 3),
		north_animation = {
			filename = ASSETS_BOBS_PATH .. "distillery-light-north.png",
			width = 66,
			height = 62,
			draw_as_glow = true,
			scale = 0.5,
		},
		east_animation = {
			filename = ASSETS_BOBS_PATH .. "distillery-light-east.png",
			width = 68,
			height = 60,
			draw_as_glow = true,
			scale = 0.5,
		},
		south_animation = {
			filename = ASSETS_BOBS_PATH .. "distillery-light-south.png",
			width = 66,
			height = 64,
			draw_as_glow = true,
			scale = 0.5,
		},
		west_animation = {
			filename = ASSETS_BOBS_PATH .. "distillery-light-west.png",
			width = 66,
			height = 58,
			draw_as_glow = true,
			scale = 0.5,
		},
	}
end

---@param tint? Color
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint)
	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = get_animation(tint),
		working_visualisations = {
			get_lights_working_visualisation(),
		},
	}

	if feature_flags["freezing"] then
		graphics_set.frozen_patch = get_frozen_patch()
	end

	return graphics_set
end

---@param tint? Color
---@return CraftingMachineGraphicsSet
local function get_graphics_set_flipped(tint)
	local animation = get_animation(tint)
	local working_visualisation = get_lights_working_visualisation()

	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = {
			north = animation.south,
			east = animation.west,
			south = animation.north,
			west = animation.east,
		},
		working_visualisations = {
			{
				effect = working_visualisation.effect,
				fadeout = working_visualisation.fadeout,
				north_position = working_visualisation.south_position,
				north_animation = working_visualisation.south_animation,
				east_position = working_visualisation.west_position,
				east_animation = working_visualisation.west_animation,
				south_position = working_visualisation.north_position,
				south_animation = working_visualisation.north_animation,
				west_position = working_visualisation.east_position,
				west_animation = working_visualisation.east_animation,
			},
		},
	}

	if feature_flags["freezing"] then
		local frozen_patch = get_frozen_patch()
		graphics_set.frozen_patch = {
			north = frozen_patch.south,
			east = frozen_patch.west,
			south = frozen_patch.north,
			west = frozen_patch.east,
		}
	end

	return graphics_set
end

---@return WaterReflectionDefinition
local function get_water_reflection()
	return {
		pictures = {
			filename = ASSETS_BOBS_PATH .. "distillery-reflection.png",
			priority = "extra-high",
			width = 28,
			height = 36,
			shift = util.by_pixel(10 / 3, 35),
			variation_count = 4,
			scale = 10 / 3,
		},
		rotate = false,
		orientation_to_variation = true,
	}
end

---Defines the options for the distillery sprite set.
---@class DistillerySpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

---Gets the sprite set for the distillery.
---
---The set defines its nominal dimensions only. Its `graphics_set` is empty, and no artwork is drawn for the
---distillery yet.
---@param params DistillerySpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for the distillery.
---
---#### Examples
---```lua
---local distillery = require("__reskins-assets-api__.assets.bobs.entities.distillery")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = distillery.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set(params)
	---@type SpriteSetDefinition<CraftingMachineSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.crafting_machine_sprite_set,
		set = {
			graphics_set = get_graphics_set(params.tint),
			graphics_set_flipped = get_graphics_set_flipped(params.tint),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = nil,
			water_reflection = get_water_reflection(),
			nominal_width = 2,
			nominal_height = 2,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-bobs__/graphics/icons" })

---Gets the icon for the distillery, in the tints given by `params`.
M.get_icon = icons:tinted("distillery"):build("get_icon")

return M
