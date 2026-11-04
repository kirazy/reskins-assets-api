---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")

local ASSETS_PATH = _defines.assets_source.bobs_assets .. "/graphics/entity/laser-beams/"

local M = {}

---The lens of a laser, which selects the color of its beam.
---@alias LaserBeamLens "amethyst"|"diamond"|"emerald"|"glass"|"ruby"|"sapphire"|"topaz"

local LaserBeamLens = V.one_of({ "amethyst", "diamond", "emerald", "glass", "ruby", "sapphire", "topaz" })

---The tint of the light that the beam of each lens casts on the ground.
---@type table<LaserBeamLens, Color>
local ground_light_tints = {
	amethyst = util.color("#1E0D80") --[[@as Color]],
	diamond = util.color("#F9F9F9") --[[@as Color]],
	emerald = util.color("#0D802A") --[[@as Color]],
	glass = util.color("#4F4F4F") --[[@as Color]],
	ruby = util.color("#800223") --[[@as Color]],
	sapphire = util.color("#023B80") --[[@as Color]],
	topaz = util.color("#80590D") --[[@as Color]],
}

---Gets the beam body segment for the given `lens`.
---@param lens LaserBeamLens
---@return Animation
local function get_body(lens)
	return {
		layers = {
			{
				filename = ASSETS_PATH .. lens .. "/laser-" .. lens .. "-body.png",
				flags = { "trilinear-filtering" },
				line_length = 8,
				width = 64,
				height = 12,
				frame_count = 8,
				scale = 0.5,
				animation_speed = 0.5,
				blend_mode = "additive",
			},
			{
				filename = ASSETS_PATH .. "base/laser-body-light.png",
				draw_as_light = true,
				flags = { "light" },
				line_length = 8,
				width = 64,
				height = 12,
				frame_count = 8,
				scale = 0.5,
				animation_speed = 0.5,
			},
		},
	}
end

---Gets the beam tail segment for the given `lens`.
---@param lens LaserBeamLens
---@return Animation
local function get_tail(lens)
	return {
		layers = {
			{
				filename = ASSETS_PATH .. lens .. "/laser-" .. lens .. "-end.png",
				flags = { "trilinear-filtering" },
				width = 110,
				height = 62,
				frame_count = 8,
				shift = util.by_pixel(11.5, 1),
				scale = 0.5,
				animation_speed = 0.5,
				blend_mode = "additive",
			},
			{
				filename = ASSETS_PATH .. "base/laser-end-light.png",
				draw_as_light = true,
				flags = { "light" },
				width = 110,
				height = 62,
				frame_count = 8,
				shift = util.by_pixel(11.5, 1),
				scale = 0.5,
				animation_speed = 0.5,
			},
		},
	}
end

---Gets the light that the beam of the given `lens` casts on the ground.
---@param lens LaserBeamLens
---@return BeamAnimationSet
local function get_ground(lens)
	local tint = ground_light_tints[lens]

	return {
		head = {
			filename = ASSETS_PATH .. "base/laser-ground-light-head.png",
			draw_as_light = true,
			flags = { "light" },
			line_length = 1,
			width = 256,
			height = 256,
			repeat_count = 8,
			scale = 0.5,
			shift = util.by_pixel(-32, 0),
			animation_speed = 0.5,
			tint = util.copy(tint),
		},
		tail = {
			filename = ASSETS_PATH .. "base/laser-ground-light-tail.png",
			draw_as_light = true,
			flags = { "light" },
			line_length = 1,
			width = 256,
			height = 256,
			repeat_count = 8,
			scale = 0.5,
			shift = util.by_pixel(32, 0),
			animation_speed = 0.5,
			tint = util.copy(tint),
		},
		body = {
			{
				filename = ASSETS_PATH .. "base/laser-ground-light-body.png",
				draw_as_light = true,
				flags = { "light" },
				line_length = 1,
				width = 64,
				height = 256,
				repeat_count = 8,
				scale = 0.5,
				animation_speed = 0.5,
				tint = util.copy(tint),
			},
		},
	}
end

---Defines the options for the graphics set of the laser beams.
---@class LaserBeamGraphicsSetParams
---The lens of the laser, which selects the color of its beam.
---@field lens LaserBeamLens

local check_get_graphics_set = V.signature("get_graphics_set", {
	{ "params", V.class("LaserBeamGraphicsSetParams", { lens = LaserBeamLens }):strict() },
})

---Gets the graphics set for the laser beam of the lens given by `params`.
---
---The graphics set is assigned to the `graphics_set` of a `BeamPrototype`. The result is a new table on each call.
---@param params LaserBeamGraphicsSetParams The options for the graphics set.
---@return BeamGraphicsSet # The graphics set of the laser beam.
---
---#### Examples
---```lua
----- Draw the beam of the sapphire laser.
---local laser_beam = require("__reskins-assets-api__.assets.base.entities.laser-beam")
---
---data.raw["beam"]["bob-laser-beam-sapphire"].graphics_set = laser_beam.get_graphics_set({ lens = "sapphire" })
---```
---@throws When `params.lens` is not one of `"amethyst"`, `"diamond"`, `"emerald"`, `"glass"`, `"ruby"`, `"sapphire"`, or `"topaz"`.
---@nodiscard
function M.get_graphics_set(params)
	check_get_graphics_set(params)

	---@type BeamGraphicsSet
	local graphics_set = {
		beam = {
			head = get_body(params.lens),
			tail = get_tail(params.lens),
			body = { get_body(params.lens) },
		},
		ground = get_ground(params.lens),
	}

	return graphics_set
end

return M
