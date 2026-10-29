-- cspell: words heatex
---@diagnostic disable: generic-constraint-mismatch

---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local _sprites = require("__reskins-sprite-utils__.sprites")
local IconBuilderFactory = require("api.icon-builder-factory")
local V = require("__reskins-sprite-utils__.validation")

local M = {}

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
	local pipe_path = get_pipe_path(pipe_material)

	local assets_path = "__reskins-assets-base__/graphics/entity/heat-exchanger/"
	local base_path = "__base__/graphics/entity/heat-exchanger/"

	---@type Animation
	local north_structure = {
		layers = {
			util.sprite_load(base_path .. "heatex-N-idle", {
				priority = "extra-high",
				scale = 0.5,
			}),
			util.sprite_load(base_path .. "heatex-N-shadow", {
				priority = "extra-high",
				scale = 0.5,
				draw_as_shadow = true,
			}),
		},
	}

	---@type Animation
	local east_structure = {
		layers = {
			util.sprite_load(base_path .. "heatex-E-idle", {
				priority = "extra-high",
				scale = 0.5,
			}),
			util.sprite_load(base_path .. "heatex-E-shadow", {
				priority = "extra-high",
				scale = 0.5,
				draw_as_shadow = true,
			}),
		},
	}

	---@type Animation
	local south_structure = {
		layers = {
			util.sprite_load(base_path .. "heatex-S-idle", {
				priority = "extra-high",
				scale = 0.5,
			}),
			util.sprite_load(base_path .. "heatex-S-shadow", {
				priority = "extra-high",
				scale = 0.5,
				draw_as_shadow = true,
			}),
		},
	}

	---@type Animation
	local west_structure = {
		layers = {
			util.sprite_load(base_path .. "heatex-W-idle", {
				priority = "extra-high",
				scale = 0.5,
			}),
			util.sprite_load(base_path .. "heatex-W-shadow", {
				priority = "extra-high",
				scale = 0.5,
				draw_as_shadow = true,
			}),
		},
	}

	if tint then
		table.insert(
			north_structure.layers --[[@cast -?]],
			util.sprite_load(assets_path .. "heat-exchanger-north-idle-mask", {
				priority = "extra-high",
				tint = tint,
				scale = 0.5,
			})
		)
		table.insert(
			north_structure.layers --[[@cast -?]],
			util.sprite_load(assets_path .. "heat-exchanger-north-idle-highlights", {
				priority = "extra-high",
				blend_mode = "additive-soft",
				scale = 0.5,
			})
		)

		table.insert(
			east_structure.layers --[[@cast -?]],
			util.sprite_load(assets_path .. "heat-exchanger-east-idle-mask", {
				priority = "extra-high",
				tint = tint,
				scale = 0.5,
			})
		)
		table.insert(
			east_structure.layers --[[@cast -?]],
			util.sprite_load(assets_path .. "heat-exchanger-east-idle-highlights", {
				priority = "extra-high",
				blend_mode = "additive-soft",
				scale = 0.5,
			})
		)

		table.insert(
			south_structure.layers --[[@cast -?]],
			util.sprite_load(assets_path .. "heat-exchanger-south-idle-mask", {
				priority = "extra-high",
				tint = tint,
				scale = 0.5,
			})
		)
		table.insert(
			south_structure.layers --[[@cast -?]],
			util.sprite_load(assets_path .. "heat-exchanger-south-idle-highlights", {
				priority = "extra-high",
				blend_mode = "additive-soft",
				scale = 0.5,
			})
		)

		table.insert(
			west_structure.layers --[[@cast -?]],
			util.sprite_load(assets_path .. "heat-exchanger-west-idle-mask", {
				priority = "extra-high",
				tint = tint,
				scale = 0.5,
			})
		)
		table.insert(
			west_structure.layers --[[@cast -?]],
			util.sprite_load(assets_path .. "heat-exchanger-west-idle-highlights", {
				priority = "extra-high",
				blend_mode = "additive-soft",
				scale = 0.5,
			})
		)
	end

	-- Pipe overlay is always appended regardless of tint.
	table.insert(north_structure.layers--[[@cast -?]], {
		filename = pipe_path .. "heat-pipe-north-idle.png",
		priority = "extra-high",
		width = 269,
		height = 221,
		shift = util.by_pixel(-1.25, 5.25),
		scale = 0.5,
	})
	table.insert(east_structure.layers--[[@cast -?]], {
		filename = pipe_path .. "heat-pipe-east-idle.png",
		priority = "extra-high",
		width = 211,
		height = 301,
		shift = util.by_pixel(-1.75, 1.25),
		scale = 0.5,
	})
	table.insert(south_structure.layers--[[@cast -?]], {
		filename = pipe_path .. "heat-pipe-south-idle.png",
		priority = "extra-high",
		width = 260,
		height = 201,
		shift = util.by_pixel(4, 10.75),
		scale = 0.5,
	})
	table.insert(west_structure.layers--[[@cast -?]], {
		filename = pipe_path .. "heat-pipe-west-idle.png",
		priority = "extra-high",
		width = 196,
		height = 273,
		shift = util.by_pixel(1.5, 7.75),
		scale = 0.5,
	})

	---@type BoilerPictureSet
	local picture_set = {
		north = {
			structure = north_structure,
			fire = util.sprite_load(base_path .. "heatex-N-fluid", {
				draw_as_glow = true,
				priority = "extra-high",
				frame_count = 32,
				animation_speed = 0.5,
				blend_mode = "additive",
				scale = 0.5,
			}),
		},
		east = {
			structure = east_structure,
			fire = util.sprite_load(base_path .. "heatex-E-fluid", {
				draw_as_glow = true,
				priority = "extra-high",
				frame_count = 32,
				animation_speed = 0.5,
				blend_mode = "additive",
				scale = 0.5,
			}),
		},
		south = {
			structure = south_structure,
			fire = util.sprite_load(base_path .. "heatex-S-fluid", {
				draw_as_glow = true,
				priority = "extra-high",
				frame_count = 32,
				animation_speed = 0.5,
				blend_mode = "additive",
				scale = 0.5,
			}),
		},
		west = {
			structure = west_structure,
			fire = util.sprite_load(base_path .. "heatex-W-fluid", {
				draw_as_glow = true,
				priority = "extra-high",
				frame_count = 32,
				animation_speed = 0.5,
				blend_mode = "additive",
				scale = 0.5,
			}),
		},
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
	})--[[@as Animation4Way]]
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
			blend_mode = "additive-soft",
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

---Defines the options for the original heat exchanger sprite set.
---@class HeatExchangerSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color
---The material from which the pipes are built.
---@field pipe_material "base"|"aluminum-invar"|"silver-aluminum"|"silver-titanium"|"gold-copper"

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
---@nodiscard
function M.get_sprite_set(params)
	-- FIXME: the pipe covers ride on `fluid_boxes`, which the boiler applicator does not
	-- consume yet. See the fluid box FIXME in `api/applicators/boiler.lua`.
	---@type SpriteSetDefinition<BoilerSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.boiler_sprite_set,
		set = {
			pictures = get_picture_set(params.tint, params.pipe_material),
			-- FIXME: This needs to apply only to heat-style energy source fluid boxes, not all fluid boxes.
			-- fluid_boxes = {
			-- 	{
			-- 		pipe_covers = get_pipe_covers(params.pipe_material) --[[@as Sprite4Way]],
			-- 	},
			-- },
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = { animation = get_corpse_animation(params.tint, params.pipe_material) },
			water_reflection = nil,
			nominal_width = 3,
			nominal_height = 2,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-assorted__/graphics/icons" })

local heat_pipe_material = V.one_of({ "base", "aluminum-invar", "silver-aluminum", "silver-titanium", "gold-copper" })

---Gets the icon for an original heat exchanger with the given `pipe_material` and in the tints given by `params`.
---
---Every heat exchanger shares one mask and one highlights layer, only the base layer differs by material.
M.get_icon = icons
	:tinted("heat-exchanger-original")
	:keyed("pipe_material", heat_pipe_material, { IconBuilderFactory.role.base })
	:build("get_icon")

return M
