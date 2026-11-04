---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local IconBuilderFactory = require("api.icon-builder-factory")
local CargoWagonExplosion = require("assets.base.explosions.cargo-wagon")
local Remnants = require("assets.base.remnants")

local M = {}

---Gets the animation of the cargo wagon remnants.
---@return RotatedAnimation
local function get_corpse_animation()
	return {
		filename = "__base__/graphics/entity/cargo-wagon/remnants/cargo-wagon-remnants.png",
		line_length = 1,
		width = 494,
		height = 484,
		direction_count = 8,
		shift = util.by_pixel(1.5, 6),
		scale = 0.5,
	}
end

---Gets the corpse of the cargo wagon, which duplicates the vanilla cargo wagon remnants.
---@return CorpseSpriteSet
local function get_corpse()
	return Remnants.get_corpse("cargo-wagon-remnants", { animation = get_corpse_animation() })
end

---Defines the options for the cargo wagon sprite set.
---@class TrainCargoWagonSpriteSetParams
---The color to tint the small metal particles of the dying explosion. When `nil`, the tint of the base game is used.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("TrainCargoWagonSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for the dying explosion and the corpse of a cargo wagon.
---@param params TrainCargoWagonSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<EntityWithHealthSpriteSet> # The sprite set definition for the cargo wagon.
---
---#### Examples
---```lua
---local train_cargo_wagon = require("__reskins-assets-api__.assets.base.entities.train-cargo-wagon")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = train_cargo_wagon.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@throws When `params` defines an unrecognized field.
---@throws When `params.tint` is not a `Color`.
---@nodiscard
function M.get_sprite_set(params)
	check_get_sprite_set(params)

	---@type SpriteSetDefinition<EntityWithHealthSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.entity_with_health_sprite_set,
		set = {
			dying_explosion = CargoWagonExplosion.get_explosion({
				tints = params.tint and { ["cargo-wagon-metal-particle-small"] = params.tint },
			}),
			corpse = get_corpse(),
			nominal_width = 2,
			nominal_height = 6,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-base__/graphics/icons" })
local icon_builder = icons:tinted("train-cargo-wagon")

---Gets the icon for a cargo wagon, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the icon for a cargo wagon as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
