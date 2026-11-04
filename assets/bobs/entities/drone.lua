---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Entities

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local IconBuilderFactory = require("api.icon-builder-factory")

local BASE_PATH = "__base__/graphics/entity/tank/"
local ASSETS_BOBS_PATH = "__reskins-assets-bobs__/graphics/entity/drone/"

local M = {}

---Gets the stripes of the four sheets that start with the given `path`, for an animation of 2 frames and 64
---directions.
---@param path string The path of the sheets, to which the number of the sheet and `.png` are appended.
---@param width_in_frames 1|2 The number of frames in each sheet. A sheet of 1 frame is drawn for both frames.
---@return Stripe[]
local function get_stripes(path, width_in_frames)
	---@type Stripe[]
	local stripes = {}
	for index = 1, 4 do
		stripes[index] = { filename = path .. index .. ".png", width_in_frames = width_in_frames, height_in_frames = 16 }
	end

	return width_in_frames == 2 and stripes or util.multiplystripes(2, stripes)
end

---Gets the stripes that draw the single picture of the given `filename` in each frame and direction of an animation
---of 2 frames and 64 directions.
---@param filename string
---@return Stripe[]
local function get_repeated_stripes(filename)
	---@type Stripe[]
	local stripes = {}
	for index = 1, 128 do
		stripes[index] = { filename = filename, width_in_frames = 1, height_in_frames = 1 }
	end

	return stripes
end

---Gets the animation of the drone.
---@param tint? Color
---@return RotatedAnimation
local function get_animation(tint)
	---@type RotatedAnimation[]
	local layers = {
		{
			width = 270,
			height = 212,
			frame_count = 2,
			direction_count = 64,
			shift = util.by_pixel(0, -10),
			animation_speed = 8,
			max_advance = 1,
			stripes = get_stripes(BASE_PATH .. "tank-base-", 2),
			scale = 0.5,
		},
	}

	if tint then
		layers[#layers + 1] = {
			width = 270,
			height = 212,
			frame_count = 2,
			direction_count = 64,
			shift = util.by_pixel(0, -10),
			max_advance = 1,
			tint = tint,
			stripes = get_stripes(ASSETS_BOBS_PATH .. "drone-mask-", 1),
			scale = 0.5,
		}
		layers[#layers + 1] = {
			width = 270,
			height = 212,
			frame_count = 2,
			direction_count = 64,
			shift = util.by_pixel(0, -10),
			max_advance = 1,
			blend_mode = "additive",
			stripes = get_stripes(ASSETS_BOBS_PATH .. "drone-highlights-", 1),
			scale = 0.5,
		}
	end

	layers[#layers + 1] = {
		width = 98,
		height = 166,
		frame_count = 2,
		direction_count = 64,
		shift = util.by_pixel(0, -10),
		max_advance = 1,
		stripes = get_repeated_stripes(ASSETS_BOBS_PATH .. "drone-top.png"),
		scale = 0.5,
	}
	layers[#layers + 1] = {
		width = 98,
		height = 166,
		frame_count = 2,
		direction_count = 64,
		shift = util.by_pixel(0, -10),
		max_advance = 1,
		tint = tint,
		draw_as_glow = true,
		stripes = get_repeated_stripes(ASSETS_BOBS_PATH .. "drone-top-light.png"),
		scale = 0.5,
	}
	layers[#layers + 1] = {
		width = 98,
		height = 166,
		frame_count = 2,
		direction_count = 64,
		shift = util.by_pixel(0, -10),
		max_advance = 1,
		draw_as_glow = true,
		blend_mode = "additive-soft",
		stripes = get_repeated_stripes(ASSETS_BOBS_PATH .. "drone-top-light-core.png"),
		scale = 0.5,
	}
	layers[#layers + 1] = {
		width = 302,
		height = 194,
		frame_count = 2,
		direction_count = 64,
		shift = util.by_pixel(22.5, 7),
		max_advance = 1,
		draw_as_shadow = true,
		stripes = get_stripes(BASE_PATH .. "tank-base-shadow-", 1),
		scale = 0.5,
	}

	return { layers = layers }
end

---Gets the animation of the drone remnants.
---@param tint? Color
---@return RotatedAnimation
local function get_corpse_animation(tint)
	local remnants_path = ASSETS_BOBS_PATH .. "remnants/"

	---@type RotatedAnimation[]
	local layers = {
		{
			filename = remnants_path .. "drone-remnants.png",
			width = 414,
			height = 380,
			line_length = 1,
			direction_count = 4,
			shift = util.by_pixel(4, 0.5),
			scale = 0.5,
		},
	}

	if tint then
		layers[#layers + 1] = {
			filename = remnants_path .. "drone-remnants-mask.png",
			width = 414,
			height = 380,
			line_length = 1,
			direction_count = 4,
			shift = util.by_pixel(4, 0.5),
			tint = tint,
			scale = 0.5,
		}
		layers[#layers + 1] = {
			filename = remnants_path .. "drone-remnants-highlights.png",
			width = 414,
			height = 380,
			line_length = 1,
			direction_count = 4,
			shift = util.by_pixel(4, 0.5),
			blend_mode = "additive",
			scale = 0.5,
		}
	end

	return { layers = layers }
end

---Defines the options for the drone sprite set.
---@class DroneSpriteSetParams
---The color to tint the artwork. When `nil`, the mask and highlights layers are omitted from the set, and the light
---on the top of the drone is not tinted.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("DroneSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for the drones.
---
---The artwork is drawn at the size of the vanilla tank, and is scaled to the size of each drone when it is applied.
---@param params DroneSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<UnitSpriteSet> # The sprite set definition for the drones.
---
---#### Examples
---```lua
---local drone = require("__reskins-assets-api__.assets.bobs.entities.drone")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = drone.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@throws When `params.tint` is not a `Color`.
---@nodiscard
function M.get_sprite_set(params)
	check_get_sprite_set(params)

	---@type SpriteSetDefinition<UnitSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.unit_sprite_set,
		set = {
			run_animation = get_animation(params.tint),
			attack_animation = get_animation(params.tint),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = { animation = get_corpse_animation(params.tint) },
			water_reflection = nil,
			nominal_width = 1.8,
			nominal_height = 2.6,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-bobs__/graphics/icons" })

---Gets the icon for the drones, in the tints given by `params`.
M.get_icon = icons:tinted("drone"):build("get_icon")

return M
