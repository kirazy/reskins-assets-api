---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")

local V = require("__reskins-sprite-utils__.validation")
local IconBuilderFactory = require("api.icon-builder-factory")
local SteamEngineExplosion = require("assets.base.explosions.steam-engine")

local M = {}

---@param tint? Color
---@return Animation
local function get_horizontal_animation(tint)
	local base_path = "__base__/graphics/entity/steam-engine/"
	local assets_path = "__reskins-assets-base__/graphics/entity/steam-engine/"

	---@type Animation
	local animation = {
		layers = {
			{
				filename = base_path .. "steam-engine-H.png",
				width = 352,
				height = 257,
				frame_count = 32,
				line_length = 8,
				shift = util.by_pixel(1, -4.75),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "steam-engine-horizontal-mask.png",
			width = 352,
			height = 257,
			frame_count = 32,
			line_length = 8,
			shift = util.by_pixel(1, -4.75),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "steam-engine-horizontal-highlights.png",
			width = 352,
			height = 257,
			frame_count = 32,
			line_length = 8,
			shift = util.by_pixel(1, -4.75),
			blend_mode = "additive",
			scale = 0.5,
		})
	end

	table.insert(animation.layers--[[@cast -?]], {
		filename = base_path .. "steam-engine-H-shadow.png",
		width = 508,
		height = 160,
		frame_count = 32,
		line_length = 8,
		shift = util.by_pixel(48, 24),
		draw_as_shadow = true,
		scale = 0.5,
	})

	return animation
end

---@param tint? Color
---@return Animation
local function get_vertical_animation(tint)
	local base_path = "__base__/graphics/entity/steam-engine/"
	local assets_path = "__reskins-assets-base__/graphics/entity/steam-engine/"

	---@type Animation
	local animation = {
		layers = {
			{
				filename = base_path .. "steam-engine-V.png",
				width = 225,
				height = 391,
				frame_count = 32,
				line_length = 8,
				shift = util.by_pixel(4.75, -6.25),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "steam-engine-vertical-mask.png",
			width = 225,
			height = 391,
			frame_count = 32,
			line_length = 8,
			shift = util.by_pixel(4.75, -6.25),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "steam-engine-vertical-highlights.png",
			width = 225,
			height = 391,
			frame_count = 32,
			line_length = 8,
			shift = util.by_pixel(4.75, -6.25),
			blend_mode = "additive",
			scale = 0.5,
		})
	end

	table.insert(animation.layers--[[@cast -?]], {
		filename = base_path .. "steam-engine-V-shadow.png",
		width = 330,
		height = 307,
		frame_count = 32,
		line_length = 8,
		shift = util.by_pixel(40.5, 9.25),
		draw_as_shadow = true,
		scale = 0.5,
	})

	return animation
end

---@param tint? Color
---@return GeneratorPictureSet
local function get_generator_pictures(tint)
	return {
		north = {
			animation = get_vertical_animation(tint),
		},
		east = {
			animation = get_horizontal_animation(tint),
		},
	}
end

---@param tint? Color
---@return RotatedAnimation
local function get_corpse_animation(tint)
	local assets_path = "__reskins-assets-base__/graphics/entity/steam-engine/remnants/"

	---@type RotatedAnimation
	local animation = {
		layers = {
			{
				filename = "__base__/graphics/entity/steam-engine/remnants/steam-engine-remnants.png",
				width = 462,
				height = 386,
				direction_count = 4,
				shift = util.by_pixel(17, 6.5),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "steam-engine-remnants-mask.png",
			width = 462,
			height = 386,
			direction_count = 4,
			shift = util.by_pixel(17, 6.5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "steam-engine-remnants-highlights.png",
			width = 462,
			height = 386,
			direction_count = 4,
			shift = util.by_pixel(17, 6.5),
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
			filename = "__base__/graphics/entity/steam-engine/steam-engine-reflection.png",
			priority = "extra-high",
			width = 40,
			height = 44,
			shift = util.by_pixel(0, 55),
			variation_count = 2,
			repeat_count = 2,
			scale = 5,
		},
		rotate = false,
		orientation_to_variation = true,
	}
end

---Defines the options for the vanilla steam engine sprite set.
---@class SteamEngineSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

---Gets the sprite set for the vanilla steam engine.
---@param params SteamEngineSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<GeneratorSpriteSet> # The sprite set definition for the vanilla steam engine.
---
---#### Examples
---```lua
---local steam_engine = require("__reskins-assets-api__.assets.base.entities.steam-engine")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = steam_engine.get_sprite_set({ tint = tint })
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
			dying_explosion = SteamEngineExplosion.get_explosion({
				tints = params.tint and {
					["steam-engine-metal-particle-big"] = params.tint,
					["steam-engine-metal-particle-medium"] = params.tint,
				},
			}),
			corpse = { animation = get_corpse_animation(params.tint) },
			water_reflection = get_water_reflection(),
			nominal_width = 3,
			nominal_height = 5,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-base__/graphics/icons" })

---Gets the icon for the vanilla steam engine, in the tints given by `params`.
M.get_icon = icons:tinted("steam-engine"):build("get_icon")

return M
