---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Entities

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")
local RoboportExplosion = require("assets.base.explosions.roboport")

local ASSETS_BOBS_PATH = "__reskins-assets-bobs__/graphics/entity/robo-zone-interface/"
local ICONS_FOLDER = "__reskins-assets-bobs__/graphics/icons"

local M = {}

---Gets the graphics set of the logistic zone interface.
---@return RoboportGraphicsSet
local function get_graphics_set()
	---@type RoboportGraphicsSet
	local graphics_set = {
		base = {
			filename = ASSETS_BOBS_PATH .. "robo-zone-interface.png",
			width = 64,
			height = 70,
			shift = util.by_pixel(0, -4),
			scale = 0.5,
		},
		base_animation = {
			layers = {
				{
					filename = "__reskins-assets-bobs__/graphics/entity/roboport/antennas/roboport-1-base-animation.png",
					priority = "medium",
					width = 83,
					height = 59,
					frame_count = 8,
					animation_speed = 0.5,
					shift = util.by_pixel(1, -21),
					scale = 0.5,
				},
				{
					filename = ASSETS_BOBS_PATH .. "robo-zone-interface-shadow.png",
					priority = "medium",
					width = 106,
					height = 69,
					frame_count = 8,
					animation_speed = 0.5,
					shift = util.by_pixel(11.5, 1.5),
					draw_as_shadow = true,
					scale = 0.5,
				},
			},
		},
		recharging_animation = {
			filename = "__base__/graphics/entity/roboport/roboport-recharging.png",
			draw_as_glow = true,
			priority = "high",
			width = 37,
			height = 35,
			frame_count = 16,
			scale = 1.5,
			animation_speed = 0.5,
		},
		recharging_light = { intensity = 0.4, size = 5 },
		spawn_and_station_height = 0.33,
	}

	return graphics_set
end

---Gets the circuit connector of the logistic zone interface.
---@return CircuitConnectorDefinition
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_single(universal_connector_template, {
		variation = 26,
		main_offset = util.by_pixel(-0.5, -6),
		shadow_offset = util.by_pixel(1.5, 9.5),
		show_shadow = false,
	})
end

---Gets the sprite set for the logistic zone interface.
---@return SpriteSetDefinition<RoboportSpriteSet> # The sprite set definition for the logistic zone interface.
---
---#### Examples
---```lua
---local robo_zone_interface = require("__reskins-assets-api__.assets.bobs.entities.robo-zone-interface")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = robo_zone_interface.get_sprite_set()
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set()
	---@type SpriteSetDefinition<RoboportSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.roboport_sprite_set,
		set = {
			graphics_set = get_graphics_set(),
			circuit_connector = get_circuit_connector(),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = RoboportExplosion.get_explosion(),
			corpse = _defines.generic_remnants,
			water_reflection = nil,
			nominal_width = 1,
			nominal_height = 1,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = ICONS_FOLDER })

---Gets the icon for the logistic zone interface.
M.get_icon = icons:flat("robo-zone-interface"):build("get_icon")

return M
