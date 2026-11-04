---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Assorted.Entities

local _defines = require("api.defines")
local _sprites = require("__reskins-sprite-utils__.sprites")
local IconBuilderFactory = require("api.icon-builder-factory")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local Remnants = require("assets.base.remnants")

local M = {}

local heat_pipe_material = V.one_of({ "base", "aluminum-invar", "silver-aluminum", "silver-titanium", "gold-copper" })

---@param pipe_material "base"|"aluminum-invar"|"silver-aluminum"|"silver-titanium"|"gold-copper"
---@return string
---@private
local function get_pipe_path(pipe_material)
	return "__reskins-assets-assorted__/graphics/entity/heat-exchanger-original/heat-pipes/" .. pipe_material .. "/"
end

---@param tint? Color
---@param pipe_material "base"|"aluminum-invar"|"silver-aluminum"|"silver-titanium"|"gold-copper"
---@return BoilerPictureSet
local function get_picture_set(tint, pipe_material)
	local assets_path = "__reskins-assets-assorted__/graphics/entity/heat-exchanger-original/"
	local pipe_path = get_pipe_path(pipe_material)

	---@type Animation
	local north = {
		layers = {
			{
				filename = assets_path .. "heat-exchanger-north-idle-base.png",
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
				filename = assets_path .. "heat-exchanger-east-idle-base.png",
				priority = "extra-high",
				width = 211,
				height = 301,
				shift = util.by_pixel(-1.75, 1.25),
				scale = 0.5,
			},
		},
	}

	---@type Animation
	local south = {
		layers = {
			{
				filename = assets_path .. "heat-exchanger-south-idle-base.png",
				priority = "extra-high",
				width = 260,
				height = 201,
				shift = util.by_pixel(4, 10.75),
				scale = 0.5,
			},
		},
	}

	---@type Animation
	local west = {
		layers = {
			{
				filename = assets_path .. "heat-exchanger-west-idle-base.png",
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
			filename = assets_path .. "heat-exchanger-north-idle-mask.png",
			priority = "extra-high",
			width = 269,
			height = 221,
			shift = util.by_pixel(-1.25, 5.25),
			tint = tint,
			scale = 0.5,
		})
		table.insert(north.layers--[[@cast -?]], {
			filename = assets_path .. "heat-exchanger-north-idle-highlights.png",
			priority = "extra-high",
			width = 269,
			height = 221,
			shift = util.by_pixel(-1.25, 5.25),
			blend_mode = "additive",
			scale = 0.5,
		})

		table.insert(east.layers--[[@cast -?]], {
			filename = assets_path .. "heat-exchanger-east-idle-mask.png",
			priority = "extra-high",
			width = 211,
			height = 301,
			shift = util.by_pixel(-1.75, 1.25),
			tint = tint,
			scale = 0.5,
		})
		table.insert(east.layers--[[@cast -?]], {
			filename = assets_path .. "heat-exchanger-east-idle-highlights.png",
			priority = "extra-high",
			width = 211,
			height = 301,
			shift = util.by_pixel(-1.75, 1.25),
			blend_mode = "additive",
			scale = 0.5,
		})

		table.insert(south.layers--[[@cast -?]], {
			filename = assets_path .. "heat-exchanger-south-idle-mask.png",
			priority = "extra-high",
			width = 260,
			height = 201,
			shift = util.by_pixel(4, 10.75),
			tint = tint,
			scale = 0.5,
		})
		table.insert(south.layers--[[@cast -?]], {
			filename = assets_path .. "heat-exchanger-south-idle-highlights.png",
			priority = "extra-high",
			width = 260,
			height = 201,
			shift = util.by_pixel(4, 10.75),
			blend_mode = "additive",
			scale = 0.5,
		})

		table.insert(west.layers--[[@cast -?]], {
			filename = assets_path .. "heat-exchanger-west-idle-mask.png",
			priority = "extra-high",
			width = 196,
			height = 273,
			shift = util.by_pixel(1.5, 7.75),
			tint = tint,
			scale = 0.5,
		})
		table.insert(west.layers--[[@cast -?]], {
			filename = assets_path .. "heat-exchanger-west-idle-highlights.png",
			priority = "extra-high",
			width = 196,
			height = 273,
			shift = util.by_pixel(1.5, 7.75),
			blend_mode = "additive",
			scale = 0.5,
		})
	end

	-- Pipe overlay is always appended regardless of tint.
	table.insert(north.layers--[[@cast -?]], {
		filename = pipe_path .. "heat-pipe-north-idle.png",
		priority = "extra-high",
		width = 269,
		height = 221,
		shift = util.by_pixel(-1.25, 5.25),
		scale = 0.5,
	})
	table.insert(east.layers--[[@cast -?]], {
		filename = pipe_path .. "heat-pipe-east-idle.png",
		priority = "extra-high",
		width = 211,
		height = 301,
		shift = util.by_pixel(-1.75, 1.25),
		scale = 0.5,
	})
	table.insert(south.layers--[[@cast -?]], {
		filename = pipe_path .. "heat-pipe-south-idle.png",
		priority = "extra-high",
		width = 260,
		height = 201,
		shift = util.by_pixel(4, 10.75),
		scale = 0.5,
	})
	table.insert(west.layers--[[@cast -?]], {
		filename = pipe_path .. "heat-pipe-west-idle.png",
		priority = "extra-high",
		width = 196,
		height = 273,
		shift = util.by_pixel(1.5, 7.75),
		scale = 0.5,
	})

	-- Shadows are always appended last.
	table.insert(north.layers--[[@cast -?]], {
		filename = assets_path .. "heat-exchanger-north-shadow.png",
		priority = "extra-high",
		width = 274,
		height = 164,
		shift = util.by_pixel(20.5, 9),
		draw_as_shadow = true,
		scale = 0.5,
	})
	table.insert(east.layers--[[@cast -?]], {
		filename = assets_path .. "heat-exchanger-east-shadow.png",
		priority = "extra-high",
		width = 184,
		height = 194,
		shift = util.by_pixel(30, 9.5),
		draw_as_shadow = true,
		scale = 0.5,
	})
	table.insert(south.layers--[[@cast -?]], {
		filename = assets_path .. "heat-exchanger-south-shadow.png",
		priority = "extra-high",
		width = 311,
		height = 131,
		shift = util.by_pixel(29.75, 15.75),
		draw_as_shadow = true,
		scale = 0.5,
	})
	table.insert(west.layers--[[@cast -?]], {
		filename = assets_path .. "heat-exchanger-west-shadow.png",
		priority = "extra-high",
		width = 206,
		height = 218,
		shift = util.by_pixel(19.5, 6.5),
		draw_as_shadow = true,
		scale = 0.5,
	})

	---@type BoilerPictureSet
	local picture_set = {
		north = { structure = north },
		east = { structure = east },
		south = { structure = south },
		west = { structure = west },
	}

	return picture_set
end

---@param pipe_material "base"|"aluminum-invar"|"silver-aluminum"|"silver-titanium"|"gold-copper"
---@return Animation4Way
local function get_pipe_covers(pipe_material)
	local pipe_path = get_pipe_path(pipe_material)

	return _sprites.make_4way_animation_from_spritesheet({
		filename = pipe_path .. "heat-pipe-endings.png",
		width = 64,
		height = 64,
		direction_count = 4,
		scale = 0.5,
	})
end

---@return Animation4Way
local function get_heat_pipe_covers()
	return _sprites.make_4way_animation_from_spritesheet(apply_heat_pipe_glow({
		filename = get_pipe_path("base") .. "heat-pipe-endings-heated.png",
		width = 64,
		height = 64,
		direction_count = 4,
		scale = 0.5,
	}))
end

---@return Sprite4Way
local function get_heat_picture()
	local pipe_path = get_pipe_path("base")

	---@param direction "north"|"east"|"south"|"west"
	---@param width integer
	---@param height integer
	---@param shift Vector
	---@return Sprite
	local function get_direction(direction, width, height, shift)
		return {
			layers = {
				apply_heat_pipe_glow({
					filename = pipe_path .. "heat-pipe-" .. direction .. "-heated.png",
					priority = "extra-high",
					width = width,
					height = height,
					shift = shift,
					scale = 0.5,
				}),
			},
		}
	end

	return {
		north = get_direction("north", 44, 96, util.by_pixel(-0.5, 8.5)),
		east = get_direction("east", 80, 80, util.by_pixel(-21, -13)),
		south = get_direction("south", 28, 40, util.by_pixel(-1, -30)),
		west = get_direction("west", 64, 76, util.by_pixel(23, -13)),
	}
end

---@param tint? Color
---@param pipe_material "base"|"aluminum-invar"|"silver-aluminum"|"silver-titanium"|"gold-copper"
---@return RotatedAnimation
local function get_corpse_animation(tint, pipe_material)
	local assets_path = "__reskins-assets-assorted__/graphics/entity/heat-exchanger-original/remnants/"
	local pipe_path = get_pipe_path(pipe_material)

	---@type RotatedAnimation
	local animation = {
		layers = {
			{
				filename = assets_path .. "heat-exchanger-remnants-base.png",
				width = 272,
				height = 262,
				direction_count = 4,
				shift = util.by_pixel(0.5, 8),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "heat-exchanger-remnants-mask.png",
			width = 272,
			height = 262,
			direction_count = 4,
			shift = util.by_pixel(0.5, 8),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "heat-exchanger-remnants-highlights.png",
			width = 272,
			height = 262,
			direction_count = 4,
			shift = util.by_pixel(0.5, 8),
			blend_mode = "additive",
			scale = 0.5,
		})
	end

	-- Pipe remnant is always appended regardless of tint.
	table.insert(animation.layers--[[@cast -?]], {
		filename = pipe_path .. "heat-pipe-remnants-base.png",
		width = 272,
		height = 262,
		direction_count = 4,
		shift = util.by_pixel(0.5, 8),
		scale = 0.5,
	})

	return animation
end

---Gets the water reflection of the original heat exchanger.
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

---Gets the circuit connector of the original heat exchanger for each direction, which is the circuit connector of the
---boiler.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 2,
			main_offset = util.by_pixel(0, -22),
			shadow_offset = util.by_pixel(0, -22),
			show_shadow = false,
		},
		{
			variation = 0,
			main_offset = util.by_pixel(7, -23),
			shadow_offset = util.by_pixel(7, -23),
			show_shadow = false,
		},
		{
			variation = 6,
			main_offset = util.by_pixel(0, -12),
			shadow_offset = util.by_pixel(0, -12),
			show_shadow = false,
		},
		{
			variation = 4,
			main_offset = util.by_pixel(-7, -24),
			shadow_offset = util.by_pixel(-7, -24),
			show_shadow = false,
		},
	})
end

---Defines the options for the original heat exchanger sprite set.
---@class HeatExchangerSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color
---The material from which the pipes are built.
---@field pipe_material "base"|"aluminum-invar"|"silver-aluminum"|"silver-titanium"|"gold-copper"

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("HeatExchangerSpriteSetParams", {
			tint = Common.color:optional(),
			pipe_material = heat_pipe_material,
		}):strict(),
	},
})

---Gets the sprite set for the original heat exchanger.
---@param params HeatExchangerSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<BoilerSpriteSet> # The sprite set definition for the original heat exchanger.
---
---#### Examples
---```lua
---local heat_exchanger = require("__reskins-assets-api__.assets.assorted.entities.heat-exchanger-original")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = heat_exchanger.get_sprite_set({ tint = tint, pipe_material = pipe_material })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@throws When `params` defines an unrecognized field.
---@throws When `params.tint` is not a `Color`.
---@throws When `params.pipe_material` is not one of `"base"`, `"aluminum-invar"`, `"silver-aluminum"`, `"silver-titanium"`, or `"gold-copper"`.
---@nodiscard
function M.get_sprite_set(params)
	check_get_sprite_set(params)

	---@type SpriteSetDefinition<BoilerSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.boiler_sprite_set,
		set = {
			fire_flicker_enabled = true,
			fire_glow_flicker_enabled = true,
			pictures = get_picture_set(params.tint, params.pipe_material),
			heat_buffers = {
				{
					pipe_covers = get_pipe_covers(params.pipe_material) --[[@as Sprite4Way]],
					heat_pipe_covers = get_heat_pipe_covers() --[[@as Sprite4Way]],
					heat_picture = get_heat_picture(),
				},
			},
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = Remnants.get_corpse(
				"heat-exchanger-remnants",
				{ animation = get_corpse_animation(params.tint, params.pipe_material) }
			),
			water_reflection = get_water_reflection(),
			circuit_connector = get_circuit_connector(),
			nominal_width = 3,
			nominal_height = 2,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-assorted__/graphics/icons" })

---Gets the icon for an original heat exchanger with the given `pipe_material` and in the tints given by `params`.
---
---Every heat exchanger shares one mask and one highlights layer, only the base layer differs by material.
M.get_icon = icons
	:tinted("heat-exchanger-original")
	:keyed("pipe_material", heat_pipe_material, { IconBuilderFactory.role.base })
	:build("get_icon")

return M
