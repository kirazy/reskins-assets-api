---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.Assets.Base
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local IconBuilderFactory = require("api.icon-builder-factory")
local ActiveProviderChestExplosion = require("assets.base.explosions.active-provider-chest")
local BufferChestExplosion = require("assets.base.explosions.buffer-chest")
local PassiveProviderChestExplosion = require("assets.base.explosions.passive-provider-chest")
local RequesterChestExplosion = require("assets.base.explosions.requester-chest")
local StorageChestExplosion = require("assets.base.explosions.storage-chest")
local Remnants = require("assets.base.remnants")

local BASE_PATH = "__base__/graphics/entity/logistic-chest/"
local ASSETS_BOBS_PATH = "__reskins-assets-bobs__/graphics/entity/chest-logistic/"

local M = {}

---The logistic mode of a logistic chest, which selects the artwork of the base game on which the chest is drawn.
---@alias ChestLogisticMode "active-provider"|"passive-provider"|"storage"|"buffer"|"requester"

---The material of a logistic chest, which selects the artwork drawn over the artwork of the base game.
---@alias ChestLogisticMaterial "brass"|"titanium"

local ChestLogisticMode = V.one_of({ "active-provider", "passive-provider", "storage", "buffer", "requester" })
local ChestLogisticMaterial = V.one_of({ "brass", "titanium" })

---The tint of the medium metal particles in the dying explosion for each material.
---@type table<ChestLogisticMaterial, Color>
local material_tints = {
	["brass"] = util.color("#f9c854"),
	["titanium"] = util.color("#adadb2"),
}

-- The module in `assets.base.explosions` for each logistic mode.
local explosion_modules = {
	["active-provider"] = ActiveProviderChestExplosion,
	["passive-provider"] = PassiveProviderChestExplosion,
	["storage"] = StorageChestExplosion,
	["buffer"] = BufferChestExplosion,
	["requester"] = RequesterChestExplosion,
}

---Gets the animation of the robot door for the given `logistic_mode` and `material`.
---@param logistic_mode ChestLogisticMode
---@param material ChestLogisticMaterial
---@return Animation
local function get_robot_door_animation(logistic_mode, material)
	return {
		layers = {
			{
				filename = BASE_PATH .. logistic_mode .. "-chest.png",
				priority = "extra-high",
				width = 66,
				height = 74,
				frame_count = 7,
				shift = util.by_pixel(0, -2),
				scale = 0.5,
			},
			{
				filename = ASSETS_BOBS_PATH .. "chest-logistic-" .. material .. ".png",
				priority = "extra-high",
				width = 66,
				height = 74,
				frame_count = 7,
				shift = util.by_pixel(0, -2),
				scale = 0.5,
			},
			{
				filename = BASE_PATH .. "logistic-chest-shadow.png",
				priority = "extra-high",
				width = 112,
				height = 46,
				repeat_count = 7,
				shift = util.by_pixel(12, 4.5),
				draw_as_shadow = true,
				scale = 0.5,
			},
		},
	}
end

---Gets the animation of the logistic chest remnants for the given `logistic_mode` and `material`.
---@param logistic_mode ChestLogisticMode
---@param material ChestLogisticMaterial
---@return RotatedAnimation
local function get_corpse_animation(logistic_mode, material)
	return {
		layers = {
			{
				filename = BASE_PATH .. "remnants/" .. logistic_mode .. "-chest-remnants.png",
				line_length = 1,
				width = 116,
				height = 82,
				direction_count = 1,
				shift = util.by_pixel(10, -3),
				scale = 0.5,
			},
			{
				filename = ASSETS_BOBS_PATH .. "remnants/chest-logistic-" .. material .. "-remnants.png",
				line_length = 1,
				width = 116,
				height = 82,
				direction_count = 1,
				shift = util.by_pixel(10, -3),
				scale = 0.5,
			},
		},
	}
end

---Gets the dying explosion for the given `logistic_mode`, with the medium metal particles in the tint of the given
---`material`.
---@param logistic_mode ChestLogisticMode
---@param material ChestLogisticMaterial
---@return ExplosionSpriteSet
local function get_dying_explosion(logistic_mode, material)
	local particle_name = logistic_mode .. "-chest-metal-particle-medium"

	return explosion_modules[logistic_mode].get_explosion({
		tints = { [particle_name] = util.copy(material_tints[material]) },
	})
end

---Gets the corpse of the logistic chest for the given `logistic_mode` and `material`, with the other fields of the
---vanilla remnants of the chest of `logistic_mode`.
---@param logistic_mode ChestLogisticMode
---@param material ChestLogisticMaterial
---@return CorpseSpriteSet
local function get_corpse(logistic_mode, material)
	local name = (logistic_mode .. "-chest-remnants") --[[@as BaseRemnantsID]]

	return Remnants.get_corpse(name, { animation = get_corpse_animation(logistic_mode, material) })
end

---Gets the circuit connector of the logistic chest.
---@return CircuitConnectorDefinition[]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 26,
			main_offset = util.by_pixel(3, 5.5),
			shadow_offset = util.by_pixel(7.5, 7.5),
			show_shadow = true,
		},
	})
end

---Gets the water reflection of the logistic chest.
---@return WaterReflectionDefinition
local function get_water_reflection()
	return {
		pictures = {
			filename = "__base__/graphics/entity/wooden-chest/chest-reflection.png",
			width = 13,
			height = 20,
			scale = 5,
		},
		rotate = false,
	}
end

---Defines the options for the logistic chest sprite set.
---@class ChestLogisticSpriteSetParams
---The logistic mode of the chest, which selects the artwork of the base game on which the chest is drawn.
---@field logistic_mode ChestLogisticMode
---The material of the chest, which selects the artwork drawn over the artwork of the base game.
---@field material ChestLogisticMaterial

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("ChestLogisticSpriteSetParams", {
			logistic_mode = ChestLogisticMode,
			material = ChestLogisticMaterial,
		}):strict(),
	},
})

---Gets the sprite set for the logistic chest.
---@param params ChestLogisticSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<LogisticContainerSpriteSet> # The sprite set definition for the logistic chest.
---
---#### Examples
---```lua
---local chest_logistic = require("__reskins-assets-api__.assets.base.entities.chest-logistic")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = chest_logistic.get_sprite_set({ logistic_mode = "requester", material = "brass" })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@throws When `params` defines an unrecognized field.
---@throws When `params.logistic_mode` is not a `ChestLogisticMode`.
---@throws When `params.material` is not a `ChestLogisticMaterial`.
---@nodiscard
function M.get_sprite_set(params)
	check_get_sprite_set(params)

	---@type SpriteSetDefinition<LogisticContainerSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.logistic_container_sprite_set,
		set = {
			picture = nil,
			robot_door = { animation = get_robot_door_animation(params.logistic_mode, params.material) },
			circuit_connector = get_circuit_connector(),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = get_dying_explosion(params.logistic_mode, params.material),
			corpse = get_corpse(params.logistic_mode, params.material),
			water_reflection = get_water_reflection(),
			nominal_width = 1,
			nominal_height = 1,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-bobs__/graphics/icons" })

local icon_builder = icons
	:layers("chest-logistic")
	:keyed("logistic_mode", ChestLogisticMode, { IconBuilderFactory.role.base })
	:keyed("material", ChestLogisticMaterial, { IconBuilderFactory.role.mask })
	:base()
	:layer(IconBuilderFactory.role.mask)

---Gets the icon for a logistic chest of the `logistic_mode` and `material` given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the icon for a logistic chest of the `logistic_mode` and `material` given by `params` as an `IconComposition`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
