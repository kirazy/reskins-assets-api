---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Entities

local _defines = require("api.defines")
local _sprites = require("__reskins-sprite-utils__.sprites")
local IconBuilderFactory = require("api.icon-builder-factory")
local WallExplosion = require("assets.base.explosions.wall")
local Remnants = require("assets.base.remnants")

local ASSETS_BOBS_PATH = "__reskins-assets-bobs__/graphics/entity/reinforced-wall/"
local BASE_PATH = "__base__/graphics/entity/wall/"

---The tint of the stone particles of the dying explosion, by the name of the particle.
---@type table<ParticleID, Color>
local particle_tints = {
	["wall-stone-particle-medium"] = util.color("#9584ab") --[[@as Color]],
	["wall-stone-particle-small"] = util.color("#a793bf") --[[@as Color]],
	["wall-stone-particle-tiny"] = util.color("#a793bf") --[[@as Color]],
}

local M = {}

---Gets the sprite variations of the wall for the arrangement of the given `name`.
---@param name string The name of the arrangement in the file names, such as `"corner-left"`.
---@param variation_count integer The number of variations on the sheet of the sprite.
---@param sprite { width: integer, height: integer, shift: Vector } The size of one variation of the sprite, and its shift.
---@param shadow { width: integer, height: integer, shift: Vector } The size and shift of the shadow, which is repeated for each variation.
---@return SpriteVariations
local function get_variations(name, variation_count, sprite, shadow)
	return {
		layers = {
			{
				filename = ASSETS_BOBS_PATH .. "reinforced-wall-" .. name .. ".png",
				priority = "extra-high",
				width = sprite.width,
				height = sprite.height,
				variation_count = variation_count,
				line_length = variation_count,
				shift = sprite.shift,
				scale = 0.5,
			},
			{
				filename = ASSETS_BOBS_PATH .. "shadows/reinforced-wall-" .. name .. "-shadow.png",
				priority = "extra-high",
				width = shadow.width,
				height = shadow.height,
				repeat_count = variation_count,
				shift = shadow.shift,
				draw_as_shadow = true,
				scale = 0.5,
			},
		},
	}
end

---Gets the sprites of the wall.
---@return WallPictures
local function get_pictures()
	return {
		single = get_variations(
			"single",
			2,
			{ width = 64, height = 86, shift = util.by_pixel(0, -5) },
			{ width = 98, height = 60, shift = util.by_pixel(10, 17) }
		),
		straight_vertical = get_variations(
			"vertical",
			5,
			{ width = 64, height = 134, shift = util.by_pixel(0, 8) },
			{ width = 98, height = 110, shift = util.by_pixel(10, 29) }
		),
		straight_horizontal = get_variations(
			"horizontal",
			6,
			{ width = 64, height = 92, shift = util.by_pixel(0, -2) },
			{ width = 124, height = 68, shift = util.by_pixel(14, 15) }
		),
		corner_right_down = get_variations(
			"corner-right",
			2,
			{ width = 64, height = 128, shift = util.by_pixel(0, 7) },
			{ width = 124, height = 120, shift = util.by_pixel(17, 28) }
		),
		corner_left_down = get_variations(
			"corner-left",
			2,
			{ width = 64, height = 134, shift = util.by_pixel(0, 7) },
			{ width = 102, height = 120, shift = util.by_pixel(9, 28) }
		),
		t_up = get_variations(
			"t",
			4,
			{ width = 64, height = 134, shift = util.by_pixel(0, 7) },
			{ width = 124, height = 120, shift = util.by_pixel(14, 28) }
		),
		ending_right = get_variations(
			"ending-right",
			2,
			{ width = 64, height = 92, shift = util.by_pixel(0, -3) },
			{ width = 124, height = 68, shift = util.by_pixel(17, 15) }
		),
		ending_left = get_variations(
			"ending-left",
			2,
			{ width = 64, height = 92, shift = util.by_pixel(0, -3) },
			{ width = 102, height = 68, shift = util.by_pixel(9, 15) }
		),
		filling = {
			filename = ASSETS_BOBS_PATH .. "reinforced-wall-filling.png",
			priority = "extra-high",
			width = 48,
			height = 56,
			variation_count = 8,
			line_length = 8,
			shift = util.by_pixel(0, -1),
			scale = 0.5,
		},
		water_connection_patch = {
			sheets = {
				{
					filename = ASSETS_BOBS_PATH .. "reinforced-wall-patch.png",
					priority = "extra-high",
					width = 116,
					height = 128,
					shift = util.by_pixel(0, -2),
					scale = 0.5,
				},
				{
					filename = ASSETS_BOBS_PATH .. "shadows/reinforced-wall-patch-shadow.png",
					priority = "extra-high",
					width = 144,
					height = 100,
					shift = util.by_pixel(9, 15),
					draw_as_shadow = true,
					scale = 0.5,
				},
			},
		},
		gate_connection_patch = {
			sheets = {
				{
					filename = ASSETS_BOBS_PATH .. "reinforced-wall-gate.png",
					priority = "extra-high",
					width = 82,
					height = 108,
					shift = util.by_pixel(0, -7),
					scale = 0.5,
				},
				{
					filename = ASSETS_BOBS_PATH .. "shadows/reinforced-wall-gate-shadow.png",
					priority = "extra-high",
					width = 130,
					height = 78,
					shift = util.by_pixel(14, 18),
					draw_as_shadow = true,
					scale = 0.5,
				},
			},
		},
	}
end

---Gets the diode sprite in the given `color`, for each direction.
---@param color "green"|"red"
---@return Sprite4Way
local function get_diode(color)
	return {
		sheet = {
			filename = BASE_PATH .. "wall-diode-" .. color .. ".png",
			priority = "extra-high",
			width = 72,
			height = 44,
			draw_as_glow = true,
			shift = util.by_pixel(-1, -23),
			scale = 0.5,
		},
	}
end

---Gets the diode light in the given `color` at the given `shift`.
---@param color "green"|"red"
---@param shift Vector
---@return LightDefinition
local function get_diode_light(color, shift)
	return {
		minimum_darkness = 0.3,
		color = color == "green" and { g = 1 } or { r = 1 },
		shift = shift,
		size = 1,
		intensity = 0.3,
	}
end

---Gets the circuit connector of the wall.
---@return CircuitConnectorDefinition
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_single(universal_connector_template, {
		variation = 6,
		main_offset = util.by_pixel(0, -16.5),
		shadow_offset = util.by_pixel(27, 29),
		show_shadow = false,
	})
end

---Gets the sprite that shows the connection of the wall to a gate.
---@return Sprite
local function get_connected_gate_visualization()
	return {
		filename = "__core__/graphics/arrows/underground-lines.png",
		priority = "high",
		width = 64,
		height = 64,
		scale = 0.5,
	}
end

---Gets the water reflection of the wall.
---@return WaterReflectionDefinition
local function get_water_reflection()
	return {
		pictures = {
			filename = BASE_PATH .. "wall-reflection.png",
			width = 13,
			height = 30,
			scale = 5,
		},
		rotate = false,
	}
end

---Gets the animation of the wall remnants.
---@return RotatedAnimationVariations
local function get_corpse_animation()
	return _sprites.make_rotated_animation_variations_from_spritesheet(4, {
		filename = ASSETS_BOBS_PATH .. "remnants/reinforced-wall-remnants.png",
		line_length = 1,
		width = 118,
		height = 114,
		direction_count = 2,
		shift = util.by_pixel(3, 7.5),
		scale = 0.5,
	})
end

---Gets the sprite set for the reinforced wall.
---@return SpriteSetDefinition<WallSpriteSet> # The sprite set definition for the reinforced wall.
---
---#### Examples
---```lua
---local reinforced_wall = require("__reskins-assets-api__.assets.bobs.entities.reinforced-wall")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = reinforced_wall.get_sprite_set()
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set()
	---@type SpriteSetDefinition<WallSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.wall_sprite_set,
		set = {
			pictures = get_pictures(),
			circuit_connector = get_circuit_connector(),
			connected_gate_visualization = get_connected_gate_visualization(),
			wall_diode_green = get_diode("green"),
			wall_diode_green_light_top = get_diode_light("green", util.by_pixel(0, -30)),
			wall_diode_green_light_right = get_diode_light("green", util.by_pixel(12, -23)),
			wall_diode_green_light_bottom = get_diode_light("green", util.by_pixel(0, -17)),
			wall_diode_green_light_left = get_diode_light("green", util.by_pixel(-12, -23)),
			wall_diode_red = get_diode("red"),
			wall_diode_red_light_top = get_diode_light("red", util.by_pixel(0, -30)),
			wall_diode_red_light_right = get_diode_light("red", util.by_pixel(12, -23)),
			wall_diode_red_light_bottom = get_diode_light("red", util.by_pixel(0, -17)),
			wall_diode_red_light_left = get_diode_light("red", util.by_pixel(-12, -23)),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = WallExplosion.get_explosion({ tints = util.copy(particle_tints) }),
			corpse = Remnants.get_corpse("wall-remnants", { animation = get_corpse_animation() }),
			water_reflection = get_water_reflection(),
			nominal_width = 1,
			nominal_height = 1,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-bobs__/graphics/icons" })

---Gets the icon for the reinforced wall.
M.get_icon = icons:flat("reinforced-wall"):build("get_icon")

return M
