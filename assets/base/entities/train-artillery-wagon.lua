---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local IconBuilderFactory = require("api.icon-builder-factory")
local ArtilleryWagonExplosion = require("assets.base.explosions.artillery-wagon")

local M = {}

---Gets the animation of the artillery wagon remnants.
---@return RotatedAnimation
local function get_corpse_animation()
	return {
		filename = "__base__/graphics/entity/artillery-wagon/remnants/artillery-wagon-remnants.png",
		line_length = 1,
		width = 458,
		height = 464,
		direction_count = 8,
		shift = util.by_pixel(1, -0.5),
		scale = 0.5,
	}
end

---Gets the corpse of the artillery wagon, which duplicates the vanilla artillery wagon remnants.
---@return CorpseSpriteSet
local function get_corpse()
	return {
		flags = { "placeable-neutral", "building-direction-8-way", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "train-transport-remnants",
		order = "a-i-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
		animation = get_corpse_animation(),
	}
end

---Defines the options for the artillery wagon sprite set.
---@class TrainArtilleryWagonSpriteSetParams
---The color to tint the big yellow metal particles of the dying explosion. When `nil`, the tint of the base game is
---used.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("TrainArtilleryWagonSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for the dying explosion and the corpse of an artillery wagon.
---@param params TrainArtilleryWagonSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<EntityWithHealthSpriteSet> # The sprite set definition for the artillery wagon.
---
---#### Examples
---```lua
---local train_artillery_wagon = require("__reskins-assets-api__.assets.base.entities.train-artillery-wagon")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = train_artillery_wagon.get_sprite_set({ tint = tint })
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
			dying_explosion = ArtilleryWagonExplosion.get_explosion({
				tints = params.tint and { ["artillery-wagon-metal-particle-big-yellow"] = params.tint },
			}),
			corpse = get_corpse(),
			nominal_width = 2,
			nominal_height = 6,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-base__/graphics/icons" })

---Gets the icon for an artillery wagon, in the tints given by `params`.
M.get_icon = icons:tinted("train-artillery-wagon"):build("get_icon")

return M
