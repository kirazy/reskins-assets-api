---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local IconBuilderFactory = require("api.icon-builder-factory")
local TankExplosion = require("assets.base.explosions.tank")

local M = {}

---Gets the animation of the tank remnants.
---@return RotatedAnimation
local function get_corpse_animation()
	return {
		layers = {
			{
				filename = "__base__/graphics/entity/tank/remnants/tank-remnants.png",
				line_length = 1,
				width = 414,
				height = 380,
				direction_count = 4,
				shift = util.by_pixel(4, 0.5),
				scale = 0.5,
			},
			{
				priority = "low",
				filename = "__base__/graphics/entity/tank/remnants/mask/tank-remnants-mask.png",
				width = 250,
				height = 218,
				apply_runtime_tint = true,
				direction_count = 4,
				shift = util.by_pixel(6.5, -1.5),
				scale = 0.5,
			},
		},
	}
end

---Gets the corpse of the tank, which duplicates the vanilla tank remnants.
---@return CorpseSpriteSet
local function get_corpse()
	return {
		flags = { "placeable-neutral", "building-direction-8-way", "not-on-map" },
		hidden_in_factoriopedia = true,
		subgroup = "transport-remnants",
		order = "a-k-a",
		selectable_in_game = false,
		time_before_removed = 60 * 60 * 15,
		final_render_layer = "remnants",
		remove_on_tile_placement = false,
		animation = get_corpse_animation(),
	}
end

---Defines the options for the tank sprite set.
---@class TankSpriteSetParams
---The color to tint the medium metal particles of the dying explosion. When `nil`, the tint of the base game is used.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("TankSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for the dying explosion and the corpse of a tank.
---@param params TankSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<EntityWithHealthSpriteSet> # The sprite set definition for the tank.
---
---#### Examples
---```lua
---local tank = require("__reskins-assets-api__.assets.base.entities.tank")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = tank.get_sprite_set({ tint = tint })
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
			dying_explosion = TankExplosion.get_explosion({
				tints = params.tint and { ["tank-metal-particle-medium"] = params.tint },
			}),
			corpse = get_corpse(),
			nominal_width = 1.8,
			nominal_height = 2.6,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-base__/graphics/icons" })

---Gets the icon for the vanilla tank, in the tints given by `params`.
M.get_icon = icons:tinted("tank"):build("get_icon")

return M
