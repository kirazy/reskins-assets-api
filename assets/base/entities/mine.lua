---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local IconBuilderFactory = require("api.icon-builder-factory")

local BASE_PATH = _defines.assets_source.base .. "/graphics/entity/land-mine/"

local M = {}

---The variant of a land mine, which selects its artwork. The variant `"base"` is the land mine of the base game.
---@alias MineVariant "base"|"distractor"|"poison"|"slowdown"

local MineVariant = V.one_of({ "base", "distractor", "poison", "slowdown" })

---Gets the file path for the given `variant` and `suffix`.
---@param variant MineVariant The variant of the land mine.
---@param suffix string The end of the file name, such as `"-set"`, or an empty string.
---@return string
local function get_filename(variant, suffix)
	if variant == "base" then
		return BASE_PATH .. "land-mine" .. suffix .. ".png"
	end

	local name = "mine-" .. variant

	return _defines.assets_source.bobs_assets .. "/graphics/entity/" .. name .. "/" .. name .. suffix .. ".png"
end

---Gets the unarmed land mine sprite for the given `variant`.
---@param variant MineVariant
---@return Sprite
local function get_picture_safe(variant)
	return {
		filename = get_filename(variant, ""),
		priority = "medium",
		width = 64,
		height = 64,
		scale = 0.5,
	}
end

---Gets the armed land mine sprite for the given `variant`.
---@param variant MineVariant
---@return Sprite
local function get_picture_set(variant)
	return {
		filename = get_filename(variant, "-set"),
		priority = "medium",
		width = 64,
		height = 64,
		scale = 0.5,
	}
end

---Gets the sprite for an armed land mine of an enemy force.
---@return Sprite
local function get_picture_set_enemy()
	return {
		filename = BASE_PATH .. "land-mine-set-enemy.png",
		priority = "medium",
		width = 32,
		height = 32,
		scale = 1,
	}
end

---Gets the circuit connector of the land mine.
---@return CircuitConnectorDefinition
local function get_circuit_connector()
	return {
		points = {
			wire = { red = { -0.1, 0.3 }, green = { 0.1, 0.3 } },
			shadow = { red = { -0.1, 0.3 }, green = { 0.1, 0.3 } },
		},
	}
end

---Defines the options for the land mine sprite set.
---@class MineSpriteSetParams
---The variant of the land mine, which selects its artwork.
---@field variant MineVariant

local check_get_sprite_set = V.signature("get_sprite_set", {
	{ "params", V.class("MineSpriteSetParams", { variant = MineVariant }):strict() },
})

---Gets the sprite set for the land mines.
---
---Every variant draws the armed land mine of an enemy force from the base game.
---@param params MineSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<LandMineSpriteSet> # The sprite set definition for the land mine.
---
---#### Examples
---```lua
---local mine = require("__reskins-assets-api__.assets.base.entities.mine")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = mine.get_sprite_set({ variant = "poison" })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@throws When `params` defines an unrecognized field.
---@throws When `params.variant` is not one of `"base"`, `"distractor"`, `"poison"`, or `"slowdown"`.
---@nodiscard
function M.get_sprite_set(params)
	check_get_sprite_set(params)

	---@type SpriteSetDefinition<LandMineSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.land_mine_sprite_set,
		set = {
			picture_safe = get_picture_safe(params.variant),
			picture_set = get_picture_set(params.variant),
			picture_set_enemy = get_picture_set_enemy(),
			circuit_connector = get_circuit_connector(),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = "land-mine-explosion",
			corpse = "land-mine-remnants",
			water_reflection = nil,
			nominal_width = 1,
			nominal_height = 1,
		},
	}

	return definition
end

local VARIANTS = { "base", "distractor", "poison", "slowdown" }

---Gets the builder for the icon of the land mine for the given `variant`.
---@param variant MineVariant
---@return FlatIconBuilder<{}>
local function get_icon_builder(variant)
	if variant == "base" then
		return IconBuilderFactory:create({ folder = "__base__/graphics/icons" }):flat("land-mine")
	end

	return IconBuilderFactory:create({ folder = "__reskins-assets-bobs__/graphics/icons/mines" }):flat(variant .. "-mine")
end

---Gets the icon for the land mine of the `variant` given by `params`.
M.get_icon = IconBuilderFactory.dispatch("variant", VARIANTS, "get_icon", get_icon_builder)

---Gets the icon for the land mine of the `variant` given by `params`, as an `IconComposition`.
M.get_icon_composition =
	IconBuilderFactory.dispatch_composition("variant", VARIANTS, "get_icon_composition", get_icon_builder)

return M
