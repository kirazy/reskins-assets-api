---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local IconBuilderFactory = require("api.icon-builder-factory")
local OilRefineryExplosion = require("assets.base.explosions.oil-refinery")

local ASSETS_ANGELS_PATH = "__reskins-assets-angels__/graphics/entity/"

local M = {}

---The logistic mode of Angel's logistic warehouse, which selects the artwork of the warehouse.
---@alias WarehouseLogisticMode "active-provider"|"buffer"|"passive-provider"|"requester"|"storage"

local WarehouseLogisticMode = V.one_of({ "active-provider", "buffer", "passive-provider", "requester", "storage" })

---The tint of the `metal-particle-big-tint` and `metal-particle-medium` particles in the dying explosion of Angel's
---warehouse.
---@type Color
local WAREHOUSE_TINT = util.color("#403630")

---The tint of the `metal-particle-big-tint` and `metal-particle-medium` particles in the dying explosion for each
---logistic mode.
---@type table<WarehouseLogisticMode, Color>
local logistic_mode_tints = {
	["active-provider"] = util.color("#760fd6"),
	["buffer"] = util.color("#00bf13"),
	["passive-provider"] = util.color("#ff0000"),
	["requester"] = util.color("#227dae"),
	["storage"] = util.color("#ba7713"),
}

---Gets the picture of Angel's warehouse.
---@return Sprite
local function get_picture()
	return {
		layers = {
			{
				filename = ASSETS_ANGELS_PATH .. "warehouse/warehouse.png",
				priority = "extra-high",
				width = 391,
				height = 446,
				shift = util.by_pixel(-0.5, -15),
				scale = 0.5,
			},
			{
				filename = ASSETS_ANGELS_PATH .. "warehouse/warehouse-shadow.png",
				priority = "extra-high",
				width = 592,
				height = 276,
				shift = util.by_pixel(52.5, 30.5),
				draw_as_shadow = true,
				scale = 0.5,
			},
		},
	}
end

---Gets the picture of Angel's logistic warehouse for the given `logistic_mode`.
---@param logistic_mode WarehouseLogisticMode
---@return Sprite
local function get_logistic_picture(logistic_mode)
	return {
		layers = {
			{
				filename = ASSETS_ANGELS_PATH .. "warehouse-logistic/warehouse-logistic-" .. logistic_mode .. ".png",
				priority = "extra-high",
				width = 391,
				height = 446,
				shift = util.by_pixel(-0.5, -15),
				scale = 0.5,
			},
			{
				filename = ASSETS_ANGELS_PATH .. "warehouse-logistic/warehouse-logistic-shadow.png",
				priority = "extra-high",
				width = 592,
				height = 276,
				shift = util.by_pixel(52.5, 30.5),
				draw_as_shadow = true,
				scale = 0.5,
			},
			{
				filename = ASSETS_ANGELS_PATH .. "warehouse-logistic/warehouse-logistic-light.png",
				priority = "extra-high",
				width = 9,
				height = 28,
				shift = util.by_pixel(71.5, -104),
				draw_as_light = true,
				scale = 0.5,
			},
		},
	}
end

---Gets the circuit connector of Angel's warehouse.
---@return CircuitConnectorDefinition[]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 4,
			main_offset = util.by_pixel(-4.625, 14.25),
			shadow_offset = util.by_pixel(-4.625, 14.25),
			show_shadow = true,
		},
	})
end

---Gets the dying explosion of Angel's warehouse, with the `metal-particle-big-tint` and `metal-particle-medium`
---particles in the given `tint`.
---@param tint Color
---@return ExplosionSpriteSet
local function get_dying_explosion(tint)
	return OilRefineryExplosion.get_explosion({
		tints = {
			["oil-refinery-metal-particle-big-tint"] = util.copy(tint),
			["oil-refinery-metal-particle-medium"] = util.copy(tint),
		},
	})
end

---Gets the sprite set for Angel's warehouse.
---@return SpriteSetDefinition<ContainerSpriteSet> # The sprite set definition for Angel's warehouse.
---
---#### Examples
---```lua
---local warehouse = require("__reskins-assets-api__.assets.angels.entities.assorted.warehouse")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = warehouse.get_sprite_set()
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set()
	---@type SpriteSetDefinition<ContainerSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.container_sprite_set,
		set = {
			picture = get_picture(),
			circuit_connector = get_circuit_connector(),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = get_dying_explosion(WAREHOUSE_TINT),
			corpse = _defines.generic_remnants,
			water_reflection = nil,
			nominal_width = 6,
			nominal_height = 6,
		},
	}

	return definition
end

---Defines the options for the Angel's logistic warehouse sprite set.
---@class WarehouseLogisticSpriteSetParams
---The logistic mode of the warehouse, which selects the artwork of the warehouse and the tint of the
---`metal-particle-big-tint` and `metal-particle-medium` particles in its dying explosion.
---@field logistic_mode WarehouseLogisticMode

local check_get_logistic_sprite_set = V.signature("get_logistic_sprite_set", {
	{
		"params",
		V.class("WarehouseLogisticSpriteSetParams", {
			logistic_mode = WarehouseLogisticMode,
		}):strict(),
	},
})

---Gets the sprite set for Angel's logistic warehouse.
---@param params WarehouseLogisticSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<LogisticContainerSpriteSet> # The sprite set definition for Angel's logistic warehouse.
---
---#### Examples
---```lua
---local warehouse = require("__reskins-assets-api__.assets.angels.entities.assorted.warehouse")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = warehouse.get_logistic_sprite_set({ logistic_mode = "requester" })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@throws When `params` defines an unrecognized field.
---@throws When `params.logistic_mode` is not a `WarehouseLogisticMode`.
---@nodiscard
function M.get_logistic_sprite_set(params)
	check_get_logistic_sprite_set(params)

	---@type SpriteSetDefinition<LogisticContainerSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.logistic_container_sprite_set,
		set = {
			picture = get_logistic_picture(params.logistic_mode),
			robot_door = { animation = nil },
			circuit_connector = get_circuit_connector(),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = get_dying_explosion(logistic_mode_tints[params.logistic_mode]),
			corpse = _defines.generic_remnants,
			water_reflection = nil,
			nominal_width = 6,
			nominal_height = 6,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-angels__/graphics/icons" })

---Gets the icon for Angel's warehouse.
M.get_icon = icons:layers("warehouse"):base():build("get_icon")

---Gets the icon for Angel's logistic warehouse of the `logistic_mode` given by `params`.
M.get_logistic_icon =
	icons:layers("warehouse-logistic"):keyed("logistic_mode", WarehouseLogisticMode):base():build("get_logistic_icon")

return M
