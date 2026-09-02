---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local _sprites = require("__reskins-sprite-utils__.sprites")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")

local M = {}

---@param pipe_material "base"|"aluminum-invar"|"silver-aluminum"|"silver-titanium"|"gold-copper"
---@return string
---@private
local function get_pipe_path(pipe_material)
	if pipe_material == "base" then
		return "__reskins-assets-base__/graphics/entity/heat-exchanger/heat-pipes/base/"
	else
		return "__reskins-assets-bobs__/graphics/entity/heat-exchanger/heat-pipes/" .. pipe_material .. "/"
	end
end

---@param tint Color?
---@param pipe_material "base"|"aluminum-invar"|"silver-aluminum"|"silver-titanium"|"gold-copper"
---@return BoilerPictureSet
local function get_picture_set(tint, pipe_material)
	local base_path = "__base__/graphics/entity/heat-exchanger/"
	local shadow_path = "__base__/graphics/entity/boiler/"
	local assets_path = "__reskins-assets-base__/graphics/entity/heat-exchanger/"
	local pipe_path = get_pipe_path(pipe_material)

	---@type Animation
	local north = {
		layers = {
			{
				filename = base_path .. "heatex-N-idle.png",
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
				filename = base_path .. "heatex-E-idle.png",
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
				filename = base_path .. "heatex-S-idle.png",
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
				filename = base_path .. "heatex-W-idle.png",
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
			blend_mode = "additive-soft",
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
			blend_mode = "additive-soft",
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
			blend_mode = "additive-soft",
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
			blend_mode = "additive-soft",
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
		filename = shadow_path .. "boiler-N-shadow.png",
		priority = "extra-high",
		width = 274,
		height = 164,
		shift = util.by_pixel(20.5, 9),
		draw_as_shadow = true,
		scale = 0.5,
	})
	table.insert(east.layers--[[@cast -?]], {
		filename = shadow_path .. "boiler-E-shadow.png",
		priority = "extra-high",
		width = 184,
		height = 194,
		shift = util.by_pixel(30, 9.5),
		draw_as_shadow = true,
		scale = 0.5,
	})
	table.insert(south.layers--[[@cast -?]], {
		filename = shadow_path .. "boiler-S-shadow.png",
		priority = "extra-high",
		width = 311,
		height = 131,
		shift = util.by_pixel(29.75, 15.75),
		draw_as_shadow = true,
		scale = 0.5,
	})
	table.insert(west.layers--[[@cast -?]], {
		filename = shadow_path .. "boiler-W-shadow.png",
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
	})--[[@as Animation4Way]]
end

---@param tint Color?
---@param pipe_material "base"|"aluminum-invar"|"silver-aluminum"|"silver-titanium"|"gold-copper"
---@return RotatedAnimation
local function get_corpse_animation(tint, pipe_material)
	local assets_path = "__reskins-assets-base__/graphics/entity/heat-exchanger/remnants/"
	local pipe_path = get_pipe_path(pipe_material)
	local pipe_remnant_filename = pipe_material == "base" and "heat-pipe-remnants.png" or "heat-pipe-remnants-base.png"

	---@type RotatedAnimation
	local animation = {
		layers = {
			{
				filename = "__base__/graphics/entity/heat-exchanger/remnants/heat-exchanger-remnants.png",
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
		filename = pipe_path .. pipe_remnant_filename,
		width = 272,
		height = 262,
		direction_count = 4,
		shift = util.by_pixel(0.5, 8),
		scale = 0.5,
	})

	return animation
end

---@class HeatExchangerSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?
---The material the pipes are built from. Defaults to iron.
---@field pipe_material "base"|"aluminum-invar"|"silver-aluminum"|"silver-titanium"|"gold-copper"

---Gets the sprite set for the vanilla heat exchanger.
---@param params HeatExchangerSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<BoilerSpriteSet>
---
---#### Examples
---```lua
---local heat_exchanger = require("__reskins-assets-api__.assets.base.entities.heat-exchanger")
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
			fluid_boxes = {
				{
					pipe_covers = get_pipe_covers(params.pipe_material) --[[@as Sprite4Way]],
				},
			},
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

local check_get_icon = V.signature("get_icon", {
	{ "pipe_material", V.one_of({ "base", "aluminum-invar", "silver-aluminum", "silver-titanium", "gold-copper" }) },
	{ "tint", Common.color:optional() },
})

---Gets the icon for a heat exchanger carrying the given `pipe_material`, in the given `tint`.
---@param pipe_material "base"|"aluminum-invar"|"silver-aluminum"|"silver-titanium"|"gold-copper" # The heat pipes the exchanger is built with.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(pipe_material, tint)
	check_get_icon(pipe_material, tint)

	local folder = "__reskins-assets-bobs__/graphics/icons/heat-exchanger/heat-exchanger-"

	---@type SafeIconData[]
	local icon = { { icon = folder .. pipe_material .. "-icon-base.png", icon_size = 64, scale = 0.5 } }

	if tint then
		table.insert(icon, { icon = folder .. "icon-mask.png", icon_size = 64, scale = 0.5, tint = tint })
		table.insert(icon, { icon = folder .. "icon-highlights.png", icon_size = 64, scale = 0.5, tint = { 1, 1, 1, 0 } })
	end

	return icon
end

return M
