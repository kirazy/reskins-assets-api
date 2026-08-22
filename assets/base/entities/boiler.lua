---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")

local M = {}

---@param tint Color?
---@return BoilerPictureSet
local function get_picture_set(tint)
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
				filename = "__base__/graphics/entity/boiler/boiler-N-fire.png",
				draw_as_glow = true,
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
				filename = "__base__/graphics/entity/boiler/boiler-N-light.png",
				draw_as_glow = true,
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
				filename = "__base__/graphics/entity/boiler/boiler-E-fire.png",
				draw_as_glow = true,
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
				filename = "__base__/graphics/entity/boiler/boiler-E-light.png",
				draw_as_glow = true,
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
				filename = "__base__/graphics/entity/boiler/boiler-S-fire.png",
				draw_as_glow = true,
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
				filename = "__base__/graphics/entity/boiler/boiler-S-light.png",
				draw_as_glow = true,
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
				filename = "__base__/graphics/entity/boiler/boiler-W-fire.png",
				draw_as_glow = true,
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
				filename = "__base__/graphics/entity/boiler/boiler-W-light.png",
				draw_as_glow = true,
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
---@return RotatedAnimation
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

-- FIXME: need to take a param to control the flame type used. COuld package as e.g. "light_style"
-- or something and set both the flicker enabled properties and the corresponding fire animation
-- based on e.g. "fire" or "blue", or w.e

---@class BoilerSpriteSetParams
---@field tint Color?
---@field fire_flicker_enabled boolean?
---@field fire_glow_flicker_enabled boolean?

---Produces the sprite set for a standard boiler.
---
---A pure function of `params`. `entity_sprites` is tagged `boiler_picture_set`; applying it to a
---non-boiler target (e.g. an assembling machine) works through `graphics-packs.apply` as long as
---a conversion path to that target's native shape is registered — see
---`graphics-packs.converters.boiler-picture-set-to-crafting-machine-graphics-set` for the one that
---makes the assembling-machine case work.
---
---### Examples
---```lua
---local boiler = require("assets.base.entities.boiler")
---local apply = require("graphics-packs.apply")
---
---local sprites = boiler.get({ tint = tint })
---
----- standard case: applied to an actual boiler
---apply.apply(boiler_entity, sprites.entity_sprites)
---
----- the original motivating unconventional case: boiler sprites on an assembling machine
---apply.apply(assembling_machine_entity, sprites.entity_sprites)
---```
---@param params BoilerSpriteSetParams
---@return SpriteSetDefinition<BoilerSpriteSet>
---@nodiscard
function M.get(params)
	---@type SpriteSetDefinition<BoilerSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.boiler_sprite_set,
		set = {
			fire_flicker_enabled = params.fire_flicker_enabled ~= false,
			fire_glow_flicker_enabled = params.fire_glow_flicker_enabled ~= false,
			-- FIXME: we need to a) setup the sprites with tintable pipes, and b) take pipe tints
			pictures = get_picture_set(params.tint),
			fluid_boxes = {}, -- Fluid boxes on this are strictly the standard pipe covers and nothing else.
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil, -- FIXME: type this and then build it out.
			corpse = get_corpse_animation(params.tint),
			water_reflection = nil, -- FIXME: set this.
			nominal_width = 3,
			nominal_height = 2,
		},

		-- NOTE: The "oil boiler" version of this is just this + assembling machine pipe pictures in the fluid boxes...
	}

	return definition
end

return M
