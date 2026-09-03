---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")

local _defines = require("api.defines")
local IconCatalog = require("api.icon-catalog")

local M = {}

---@param tint Color?
---@param fire_tint Color?
---@return BoilerPictureSet
local function get_picture_set(tint, fire_tint)
	local base_path = "__base__/graphics/entity/boiler/"
	local assets_base_path = "__reskins-assets-base__/graphics/entity/boiler/"

	---@type Animation
	local north = {
		layers = {
			{
				filename = base_path .. "boiler-N-idle.png",
				priority = "extra-high",
				width = 269,
				height = 221,
				shift = util.by_pixel(-1.25, 5.25),
				scale = 0.5,
			},
		},
	}

	---@type Animation
	local east = {
		layers = {
			{
				filename = base_path .. "boiler-E-idle.png",
				priority = "extra-high",
				width = 216,
				height = 301,
				shift = util.by_pixel(-3, 1.25),
				scale = 0.5,
			},
		},
	}

	---@type Animation
	local south = {
		layers = {
			{
				filename = base_path .. "boiler-S-idle.png",
				priority = "extra-high",
				width = 260,
				height = 192,
				shift = util.by_pixel(4, 13),
				scale = 0.5,
			},
		},
	}

	---@type Animation
	local west = {
		layers = {
			{
				filename = base_path .. "boiler-W-idle.png",
				priority = "extra-high",
				width = 196,
				height = 273,
				shift = util.by_pixel(1.5, 7.75),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(north.layers--[[@cast -?]], {
			filename = assets_base_path .. "boiler-north-idle-mask.png",
			priority = "extra-high",
			width = 269,
			height = 221,
			shift = util.by_pixel(-1.25, 5.25),
			tint = tint,
			scale = 0.5,
		})
		table.insert(north.layers--[[@cast -?]], {
			filename = assets_base_path .. "boiler-north-idle-highlights.png",
			priority = "extra-high",
			width = 269,
			height = 221,
			shift = util.by_pixel(-1.25, 5.25),
			blend_mode = "additive-soft",
			scale = 0.5,
		})

		table.insert(east.layers--[[@cast -?]], {
			filename = assets_base_path .. "boiler-east-idle-mask.png",
			priority = "extra-high",
			width = 216,
			height = 301,
			shift = util.by_pixel(-3, 1.25),
			tint = tint,
			scale = 0.5,
		})
		table.insert(east.layers--[[@cast -?]], {
			filename = assets_base_path .. "boiler-east-idle-highlights.png",
			priority = "extra-high",
			width = 216,
			height = 301,
			shift = util.by_pixel(-3, 1.25),
			blend_mode = "additive-soft",
			scale = 0.5,
		})

		table.insert(south.layers--[[@cast -?]], {
			filename = assets_base_path .. "boiler-south-idle-mask.png",
			priority = "extra-high",
			width = 260,
			height = 192,
			shift = util.by_pixel(4, 13),
			tint = tint,
			scale = 0.5,
		})
		table.insert(south.layers--[[@cast -?]], {
			filename = assets_base_path .. "boiler-south-idle-highlights.png",
			priority = "extra-high",
			width = 260,
			height = 192,
			shift = util.by_pixel(4, 13),
			blend_mode = "additive-soft",
			scale = 0.5,
		})

		table.insert(west.layers--[[@cast -?]], {
			filename = assets_base_path .. "boiler-west-idle-mask.png",
			priority = "extra-high",
			width = 196,
			height = 273,
			shift = util.by_pixel(1.5, 7.75),
			tint = tint,
			scale = 0.5,
		})
		table.insert(west.layers--[[@cast -?]], {
			filename = assets_base_path .. "boiler-west-idle-highlights.png",
			priority = "extra-high",
			width = 196,
			height = 273,
			shift = util.by_pixel(1.5, 7.75),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	-- Shadows are always appended last.
	table.insert(north.layers--[[@cast -?]], {
		filename = base_path .. "boiler-N-shadow.png",
		priority = "extra-high",
		width = 274,
		height = 164,
		shift = util.by_pixel(20.5, 9),
		draw_as_shadow = true,
		scale = 0.5,
	})
	table.insert(east.layers--[[@cast -?]], {
		filename = base_path .. "boiler-E-shadow.png",
		priority = "extra-high",
		width = 184,
		height = 194,
		shift = util.by_pixel(30, 9.5),
		draw_as_shadow = true,
		scale = 0.5,
	})
	table.insert(south.layers--[[@cast -?]], {
		filename = base_path .. "boiler-S-shadow.png",
		priority = "extra-high",
		width = 311,
		height = 131,
		shift = util.by_pixel(29.75, 15.75),
		draw_as_shadow = true,
		scale = 0.5,
	})
	table.insert(west.layers--[[@cast -?]], {
		filename = base_path .. "boiler-W-shadow.png",
		priority = "extra-high",
		width = 206,
		height = 218,
		shift = util.by_pixel(19.5, 6.5),
		draw_as_shadow = true,
		scale = 0.5,
	})

	---@type BoilerPictureSet
	local picture_set = {
		north = {
			structure = north,
			fire = {
				filename = fire_tint and assets_base_path .. "boiler-north-fire.png" or base_path .. "boiler-N-fire.png",
				draw_as_glow = true,
				tint = fire_tint,
				tint_as_overlay = fire_tint ~= nil,
				priority = "extra-high",
				frame_count = 64,
				line_length = 8,
				width = 26,
				height = 26,
				animation_speed = 0.5,
				shift = util.by_pixel(0, -8.5),
				scale = 0.5,
			},
			fire_glow = {
				filename = fire_tint and assets_base_path .. "boiler-north-light.png" or base_path .. "boiler-N-light.png",
				draw_as_glow = true,
				tint = fire_tint,
				tint_as_overlay = fire_tint ~= nil,
				priority = "extra-high",
				width = 200,
				height = 173,
				shift = util.by_pixel(-1, -6.75),
				blend_mode = "additive",
				scale = 0.5,
			},
		},
		east = {
			structure = east,
			patch = {
				filename = "__base__/graphics/entity/boiler/boiler-E-patch.png",
				width = 6,
				height = 36,
				shift = util.by_pixel(33.5, -13.5),
				scale = 0.5,
			},
			fire = {
				filename = fire_tint and assets_base_path .. "boiler-east-fire.png" or base_path .. "boiler-E-fire.png",
				draw_as_glow = true,
				tint = fire_tint,
				tint_as_overlay = fire_tint ~= nil,
				priority = "extra-high",
				frame_count = 64,
				line_length = 8,
				width = 28,
				height = 28,
				animation_speed = 0.5,
				shift = util.by_pixel(-9.5, -22),
				scale = 0.5,
			},
			fire_glow = {
				filename = fire_tint and assets_base_path .. "boiler-east-light.png" or base_path .. "boiler-E-light.png",
				draw_as_glow = true,
				tint = fire_tint,
				tint_as_overlay = fire_tint ~= nil,
				priority = "extra-high",
				width = 139,
				height = 244,
				shift = util.by_pixel(0.25, -13),
				blend_mode = "additive",
				scale = 0.5,
			},
		},
		south = {
			structure = south,
			fire = {
				filename = fire_tint and assets_base_path .. "boiler-south-fire.png" or base_path .. "boiler-S-fire.png",
				draw_as_glow = true,
				tint = fire_tint,
				tint_as_overlay = fire_tint ~= nil,
				priority = "extra-high",
				frame_count = 64,
				line_length = 8,
				width = 26,
				height = 16,
				animation_speed = 0.5,
				shift = util.by_pixel(-1, -26.5),
				scale = 0.5,
			},
			fire_glow = {
				filename = fire_tint and assets_base_path .. "boiler-south-light.png" or base_path .. "boiler-S-light.png",
				draw_as_glow = true,
				tint = fire_tint,
				tint_as_overlay = fire_tint ~= nil,
				priority = "extra-high",
				width = 200,
				height = 162,
				shift = util.by_pixel(1, 5.5),
				blend_mode = "additive",
				scale = 0.5,
			},
		},
		west = {
			structure = west,
			fire = {
				filename = fire_tint and assets_base_path .. "boiler-west-fire.png" or base_path .. "boiler-W-fire.png",
				draw_as_glow = true,
				tint = fire_tint,
				tint_as_overlay = fire_tint ~= nil,
				priority = "extra-high",
				frame_count = 64,
				line_length = 8,
				width = 30,
				height = 29,
				animation_speed = 0.5,
				shift = util.by_pixel(13, -23.25),
				scale = 0.5,
			},
			fire_glow = {
				filename = fire_tint and assets_base_path .. "boiler-west-light.png" or base_path .. "boiler-W-light.png",
				draw_as_glow = true,
				tint = fire_tint,
				tint_as_overlay = fire_tint ~= nil,
				priority = "extra-high",
				width = 136,
				height = 217,
				shift = util.by_pixel(2, -6.25),
				blend_mode = "additive",
				scale = 0.5,
			},
		},
	}

	return picture_set
end

---@param tint Color?
---@return RotatedAnimationVariations
local function get_corpse_animation(tint)
	local assets_path = "__reskins-assets-base__/graphics/entity/boiler/remnants/"

	---@type RotatedAnimation
	local animation = {
		layers = {
			{
				filename = "__base__/graphics/entity/boiler/remnants/boiler-remnants.png",
				width = 274,
				height = 220,
				direction_count = 4,
				shift = util.by_pixel(-0.5, -3),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "boiler-remnants-mask.png",
			width = 274,
			height = 220,
			direction_count = 4,
			shift = util.by_pixel(-0.5, -3),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "boiler-remnants-highlights.png",
			width = 274,
			height = 220,
			direction_count = 4,
			shift = util.by_pixel(-0.5, -3),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return animation
end

---@return WaterReflectionDefinition
local function get_water_reflection()
	return {
		pictures = {
			filename = "__base__/graphics/entity/boiler/boiler-reflection.png",
			priority = "extra-high",
			width = 28,
			height = 32,
			shift = util.by_pixel(5, 30),
			variation_count = 4,
			scale = 5,
		},
		rotate = false,
		orientation_to_variation = true,
	}
end

---@class BoilerSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?
---The color to tint the fire. When `nil`, the base game's fire artwork is drawn instead.
---@field fire_tint Color?
---Whether the fire flickers. Defaults to `true`.
---@field fire_flicker_enabled boolean?
---Whether the fire glow flickers. Defaults to `true`.
---@field fire_glow_flicker_enabled boolean?

local check_params = V.signature("get_sprite_set", {
	{
		"params",
		V.shape({
			tint = Common.color:optional(),
			fire_tint = Common.color:optional(),
			fire_flicker_enabled = V.boolean():optional(),
			fire_glow_flicker_enabled = V.boolean():optional(),
		}),
	},
})

---Gets the sprite set for a standard boiler.
---@param params BoilerSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<BoilerSpriteSet>
---
---#### Examples
---```lua
---local boiler = require("__reskins-assets-api__.assets.base.entities.boiler")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = boiler.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(boiler_entity, sprite_set)
---
----- Automatically adapts to prototypes other than boilers:
---applicators.apply_sprite_set(assembling_machine_entity, sprite_set)
---```
---@throws Thrown when `params.tint` or `params.fire_tint` is not a `Color`.
---@throws Thrown when `params.fire_flicker_enabled` or `params.fire_glow_flicker_enabled` is not a boolean.
---@nodiscard
function M.get_sprite_set(params)
	check_params(params)

	---@type SpriteSetDefinition<BoilerSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.boiler_sprite_set,
		set = {
			fire_flicker_enabled = params.fire_flicker_enabled ~= false,
			fire_glow_flicker_enabled = params.fire_glow_flicker_enabled ~= false,
			-- TODO: we need to a) setup the sprites with tintable pipes, and b) take pipe tints
			pictures = get_picture_set(params.tint, params.fire_tint),
			fluid_boxes = nil,
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil, -- FIXME: type this and then build it out.
			corpse = { animation = get_corpse_animation(params.tint) },
			water_reflection = get_water_reflection(),
			nominal_width = 3,
			nominal_height = 2,
		},
	}

	return definition
end

local base_icons = IconCatalog:create({ folder = "__reskins-assets-base__/graphics/icons" })
local bobs_icons = IconCatalog:create({ folder = "__reskins-assets-bobs__/graphics/icons" })

---Gets the icon for a standard boiler, in the tints given by `params`. Without `fire_tint`, the
---fire of the base layer shows through.
M.get_icon = base_icons:tinted("boiler"):tinted_part("fire", "fire_tint"):build("get_icon")

---Gets the icon for a fluid-burning boiler, in the tints given by `params`. Without `fire_tint`,
---the fire of the base layer shows through.
M.get_fluid_icon = bobs_icons:tinted("boiler-oil"):tinted_part("fire", "fire_tint"):build("get_fluid_icon")

return M
