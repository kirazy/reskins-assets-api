---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local IconBuilderFactory = require("api.icon-builder-factory")
local StorageTankExplosion = require("assets.base.explosions.storage-tank")

local ASSETS_ANGELS_PATH = "__reskins-assets-angels__/graphics/entity/"

local M = {}

---The logistic mode of Angel's logistic big chest, which selects the artwork of the chest.
---@alias BigChestLogisticMode "active-provider"|"buffer"|"passive-provider"|"requester"|"storage"

local BigChestLogisticMode = V.one_of({ "active-provider", "buffer", "passive-provider", "requester", "storage" })

---The tint of the big metal particles in the dying explosion of Angel's big chest.
---@type Color
local BIG_CHEST_TINT = util.color("#403630")

---The tint of the big metal particles in the dying explosion for each logistic mode.
---@type table<BigChestLogisticMode, Color>
local logistic_mode_tints = {
	["active-provider"] = util.color("#760fd6"),
	["buffer"] = util.color("#00bf13"),
	["passive-provider"] = util.color("#ff0000"),
	["requester"] = util.color("#227dae"),
	["storage"] = util.color("#ba7713"),
}

---Gets the picture of Angel's big chest.
---@return Sprite
local function get_picture()
	return {
		layers = {
			{
				filename = ASSETS_ANGELS_PATH .. "big-chest/big-chest.png",
				priority = "extra-high",
				width = 135,
				height = 169,
				shift = util.by_pixel(-0.5, -10),
				scale = 0.5,
			},
			{
				filename = ASSETS_ANGELS_PATH .. "big-chest/big-chest-shadow.png",
				priority = "extra-high",
				width = 209,
				height = 97,
				shift = util.by_pixel(18.5, 8.5),
				draw_as_shadow = true,
				scale = 0.5,
			},
		},
	}
end

---Gets the picture of Angel's logistic big chest for the given `logistic_mode`.
---@param logistic_mode BigChestLogisticMode
---@return Sprite
local function get_logistic_picture(logistic_mode)
	return {
		layers = {
			{
				filename = ASSETS_ANGELS_PATH .. "big-chest-logistic/big-chest-logistic-" .. logistic_mode .. ".png",
				priority = "extra-high",
				width = 135,
				height = 169,
				shift = util.by_pixel(-0.5, -10.5),
				scale = 0.5,
			},
			{
				filename = ASSETS_ANGELS_PATH .. "big-chest-logistic/big-chest-logistic-shadow.png",
				priority = "extra-high",
				width = 209,
				height = 97,
				shift = util.by_pixel(18.5, 8.5),
				draw_as_shadow = true,
				scale = 0.5,
			},
			{
				filename = ASSETS_ANGELS_PATH .. "big-chest-logistic/big-chest-logistic-light.png",
				priority = "extra-high",
				width = 5,
				height = 15,
				shift = util.by_pixel(20.5, -41.5),
				draw_as_light = true,
				scale = 0.5,
			},
		},
	}
end

---Gets the circuit connector of Angel's big chest.
---@return CircuitConnectorDefinition[]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 5,
			main_offset = util.by_pixel(13, 1.625),
			shadow_offset = util.by_pixel(13, 1.625),
			show_shadow = true,
		},
	})
end

---Gets the dying explosion of Angel's big chest, with the big metal particles in the given `tint`.
---@param tint Color
---@return ExplosionSpriteSet
local function get_dying_explosion(tint)
	return StorageTankExplosion.get_explosion({
		tints = { ["storage-tank-metal-particle-big"] = util.copy(tint) },
	})
end

---Gets the sprite set for Angel's big chest.
---@return SpriteSetDefinition<ContainerSpriteSet> # The sprite set definition for Angel's big chest.
---
---#### Examples
---```lua
---local big_chest = require("__reskins-assets-api__.assets.angels.entities.assorted.big-chest")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = big_chest.get_sprite_set()
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
			dying_explosion = get_dying_explosion(BIG_CHEST_TINT),
			corpse = _defines.generic_remnants,
			water_reflection = nil,
			nominal_width = 2,
			nominal_height = 2,
		},
	}

	return definition
end

---Defines the options for the Angel's logistic big chest sprite set.
---@class BigChestLogisticSpriteSetParams
---The logistic mode of the chest, which selects the artwork of the chest and the tint of the big metal particles in its
---dying explosion.
---@field logistic_mode BigChestLogisticMode

local check_get_logistic_sprite_set = V.signature("get_logistic_sprite_set", {
	{
		"params",
		V.class("BigChestLogisticSpriteSetParams", {
			logistic_mode = BigChestLogisticMode,
		}):strict(),
	},
})

---Gets the sprite set for Angel's logistic big chest.
---@param params BigChestLogisticSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<LogisticContainerSpriteSet> # The sprite set definition for Angel's logistic big chest.
---
---#### Examples
---```lua
---local big_chest = require("__reskins-assets-api__.assets.angels.entities.assorted.big-chest")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = big_chest.get_logistic_sprite_set({ logistic_mode = "requester" })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@throws When `params` defines an unrecognized field.
---@throws When `params.logistic_mode` is not a `BigChestLogisticMode`.
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
			nominal_width = 2,
			nominal_height = 2,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-angels__/graphics/icons" })

local icon_builder = icons:layers("big-chest"):base()

---Gets the icon for Angel's big chest.
M.get_icon = icon_builder:build("get_icon")

---Gets the icon for Angel's big chest as an `IconComposition`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

---Gets the icon for Angel's logistic big chest of the `logistic_mode` given by `params`.
M.get_logistic_icon =
	icons:layers("big-chest-logistic"):keyed("logistic_mode", BigChestLogisticMode):base():build("get_logistic_icon")

return M
