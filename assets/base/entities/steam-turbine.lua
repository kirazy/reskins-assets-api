---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")

local V = require("__reskins-sprite-utils__.validation")
local IconBuilderFactory = require("api.icon-builder-factory")
local SteamTurbineExplosion = require("assets.base.explosions.steam-turbine")
local Remnants = require("assets.base.remnants")

local M = {}

---@param tint? Color
---@return Animation
local function get_horizontal_animation(tint)
	local base_path = "__base__/graphics/entity/steam-turbine/"
	local assets_path = "__reskins-assets-base__/graphics/entity/steam-turbine/"

	---@type Animation
	local animation = {
		layers = {
			{
				filename = base_path .. "steam-turbine-H.png",
				width = 320,
				height = 245,
				frame_count = 8,
				line_length = 4,
				shift = util.by_pixel(0, -2.75),
				run_mode = "backward",
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "steam-turbine-horizontal-mask.png",
			width = 320,
			height = 245,
			repeat_count = 8,
			shift = util.by_pixel(0, -2.75),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "steam-turbine-horizontal-highlights.png",
			width = 320,
			height = 245,
			repeat_count = 8,
			shift = util.by_pixel(0, -2.75),
			blend_mode = "additive",
			scale = 0.5,
		})
	end

	table.insert(animation.layers--[[@cast -?]], {
		filename = base_path .. "steam-turbine-H-shadow.png",
		width = 435,
		height = 150,
		repeat_count = 8,
		shift = util.by_pixel(28.5, 18),
		run_mode = "backward",
		draw_as_shadow = true,
		scale = 0.5,
	})

	return animation
end

---@param tint? Color
---@return Animation
local function get_vertical_animation(tint)
	local base_path = "__base__/graphics/entity/steam-turbine/"
	local assets_path = "__reskins-assets-base__/graphics/entity/steam-turbine/"

	---@type Animation
	local animation = {
		layers = {
			{
				filename = base_path .. "steam-turbine-V.png",
				width = 217,
				height = 374,
				frame_count = 8,
				line_length = 4,
				shift = util.by_pixel(4.75, 0),
				run_mode = "backward",
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "steam-turbine-vertical-mask.png",
			width = 217,
			height = 347,
			repeat_count = 8,
			shift = util.by_pixel(4.75, 6.75),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "steam-turbine-vertical-highlights.png",
			width = 217,
			height = 347,
			repeat_count = 8,
			shift = util.by_pixel(4.75, 6.75),
			blend_mode = "additive",
			scale = 0.5,
		})
	end

	table.insert(animation.layers--[[@cast -?]], {
		filename = base_path .. "steam-turbine-V-shadow.png",
		width = 302,
		height = 260,
		repeat_count = 8,
		shift = util.by_pixel(39.5, 24.5),
		run_mode = "backward",
		draw_as_shadow = true,
		scale = 0.5,
	})

	return animation
end

---@param tint? Color
---@return GeneratorPictureSet
local function get_generator_pictures(tint)
	local pictures = {
		north = {
			animation = get_vertical_animation(tint),
		},
		east = {
			animation = get_horizontal_animation(tint),
		},
	}

	if feature_flags["freezing"] and mods["space-age"] then
		pictures.north.frozen_patch = {
			filename = "__space-age__/graphics/entity/frozen/steam-turbine/steam-turbine-V.png",
			width = 217,
			height = 347,
			shift = util.by_pixel(4.75, 6.75),
			scale = 0.5,
		}
		pictures.east.frozen_patch = {
			filename = "__space-age__/graphics/entity/frozen/steam-turbine/steam-turbine-H.png",
			width = 320,
			height = 245,
			shift = util.by_pixel(0, -2.75),
			scale = 0.5,
		}
	end

	return pictures
end

---@param tint? Color
---@return RotatedAnimation
local function get_corpse_animation(tint)
	local assets_path = "__reskins-assets-base__/graphics/entity/steam-turbine/remnants/"

	---@type RotatedAnimation
	local animation = {
		layers = {
			{
				filename = "__base__/graphics/entity/steam-turbine/remnants/steam-turbine-remnants.png",
				width = 460,
				height = 408,
				direction_count = 4,
				shift = util.by_pixel(6, 0),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "steam-turbine-remnants-mask.png",
			width = 460,
			height = 408,
			direction_count = 4,
			shift = util.by_pixel(6, 0),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "steam-turbine-remnants-highlights.png",
			width = 460,
			height = 408,
			direction_count = 4,
			shift = util.by_pixel(6, 0),
			blend_mode = "additive",
			scale = 0.5,
		})
	end

	return animation
end

---@return WaterReflectionDefinition
local function get_water_reflection()
	return {
		pictures = {
			filename = "__base__/graphics/entity/steam-turbine/steam-turbine-reflection.png",
			priority = "extra-high",
			width = 40,
			height = 36,
			shift = util.by_pixel(0, 50),
			variation_count = 2,
			repeat_count = 2,
			scale = 5,
		},
		rotate = false,
		orientation_to_variation = true,
	}
end

---Defines the options for the vanilla steam turbine sprite set.
---@class SteamTurbineSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

---Gets the sprite set for the vanilla steam turbine.
---@param params SteamTurbineSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<GeneratorSpriteSet> # The sprite set definition for the vanilla steam turbine.
---
---#### Examples
---```lua
---local steam_turbine = require("__reskins-assets-api__.assets.base.entities.steam-turbine")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = steam_turbine.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set(params)
	---@type SpriteSetDefinition<GeneratorSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.generator_sprite_set,
		set = {
			two_direction_only = true,
			pictures = get_generator_pictures(params.tint),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = SteamTurbineExplosion.get_explosion({
				tints = params.tint and {
					["steam-turbine-metal-particle-big"] = params.tint,
					["steam-turbine-metal-particle-medium"] = params.tint,
				},
			}),
			corpse = Remnants.get_corpse("steam-turbine-remnants", { animation = get_corpse_animation(params.tint) }),
			water_reflection = get_water_reflection(),
			nominal_width = 3,
			nominal_height = 5,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-base__/graphics/icons" })

local icon_builder = icons:tinted("steam-turbine")

---Gets the icon for the vanilla steam turbine, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the icon for the vanilla steam turbine as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
