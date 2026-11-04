---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")
local _sprites = require("__reskins-sprite-utils__.sprites")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local IconBuilderFactory = require("api.icon-builder-factory")
local PipeExplosion = require("assets.base.explosions.pipe")
local ValveToStorageTank = require("api.converters.valve-to-storage-tank-sprite-set-transformer")

local ASSETS_ANGELS_PATH = "__reskins-assets-angels__/graphics/entity/pipe-valve/"

local M = {}

---Gets the animations of Angel's valve.
---@param tint? Color
---@return Animation4Way
local function get_animations(tint)
	local source_layers = {
		{
			filename = ASSETS_ANGELS_PATH .. "pipe-valve-base.png",
			priority = "extra-high",
			width = 128,
			height = 128,
			scale = 0.5,
		},
	}

	if tint then
		source_layers[#source_layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "pipe-valve-mask.png",
			priority = "extra-high",
			width = 128,
			height = 128,
			tint = tint,
			scale = 0.5,
		}
	end

	return _sprites.make_4way_animation_from_spritesheet({ layers = source_layers })
end

---Gets the circuit connector of Angel's inspector valve for each direction, which is the circuit connector of the
---offshore pump.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_storage_tank_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 24,
			main_offset = util.by_pixel(-16, -8.5),
			shadow_offset = util.by_pixel(-2, -0.5),
			show_shadow = false,
		},
		{
			variation = 26,
			main_offset = util.by_pixel(-7, 4.5),
			shadow_offset = util.by_pixel(-5, 14.5),
			show_shadow = true,
		},
		{
			variation = 16,
			main_offset = util.by_pixel(-13.5, -5.5),
			shadow_offset = util.by_pixel(-11.5, 9),
			show_shadow = false,
		},
		{
			variation = 26,
			main_offset = util.by_pixel(5.5, 4.5),
			shadow_offset = util.by_pixel(-15, -12.5),
			show_shadow = true,
		},
	})
end

---Gets the given valve `sprite_set` as a storage tank sprite set with the circuit connector of Angel's inspector valve.
---@param sprite_set ValveSpriteSet
---@return StorageTankSpriteSet
local function get_storage_tank_sprite_set(sprite_set)
	local storage_tank_sprite_set = ValveToStorageTank(sprite_set)
	storage_tank_sprite_set.circuit_connector = get_storage_tank_circuit_connector()

	return storage_tank_sprite_set
end

---Defines the options for the Angel's valve sprite set.
---@class PipeValveSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("PipeValveSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for Angel's valve.
---
---The sprite set can also be applied to a storage tank, which takes the animations of the valve as its pictures and the
---circuit connector of Angel's inspector valve.
---@param params PipeValveSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<ValveSpriteSet> # The sprite set definition for Angel's valve.
---
---#### Examples
---```lua
---local pipe_valve = require("__reskins-assets-api__.assets.angels.entities.petrochem.pipe-valve")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = pipe_valve.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@throws When `params` defines an unrecognized field.
---@throws When `params.tint` is not a `Color`.
---@nodiscard
function M.get_sprite_set(params)
	check_get_sprite_set(params)

	---@type SpriteSetDefinition<ValveSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.valve_sprite_set,
		set = {
			animations = get_animations(params.tint),
			frozen_patch = nil,
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = PipeExplosion.get_explosion({
				tints = params.tint and { ["pipe-metal-particle-small"] = params.tint },
			}),
			corpse = _defines.generic_remnants,
			water_reflection = nil,
			nominal_width = 1,
			nominal_height = 1,
		},
		converters = {
			[_defines.sprite_set_type.storage_tank_sprite_set] = get_storage_tank_sprite_set,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-angels__/graphics/icons" })

---Gets the icon for Angel's valve, in the tint given by `params`.
M.get_icon = icons:layers("pipe-valve"):base():mask():build("get_icon")

return M
