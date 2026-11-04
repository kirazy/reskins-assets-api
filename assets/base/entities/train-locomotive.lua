---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local IconBuilderFactory = require("api.icon-builder-factory")
local LocomotiveExplosion = require("assets.base.explosions.locomotive")
local Remnants = require("assets.base.remnants")

local M = {}

---Gets the animation of the locomotive remnants.
---@return RotatedAnimation
local function get_corpse_animation()
	return {
		layers = {
			{
				filename = "__base__/graphics/entity/locomotive/remnants/locomotive-base-remnants.png",
				line_length = 1,
				width = 460,
				height = 436,
				direction_count = 8,
				shift = util.by_pixel(4, 0.5),
				scale = 0.5,
			},
			{
				priority = "low",
				filename = "__base__/graphics/entity/locomotive/remnants/mask/locomotive-remnants-mask.png",
				width = 390,
				height = 292,
				apply_runtime_tint = true,
				tint_as_overlay = true,
				direction_count = 8,
				shift = util.by_pixel(0, 2),
				scale = 0.5,
			},
		},
	}
end

---Gets the corpse of the locomotive, which duplicates the vanilla locomotive remnants.
---@return CorpseSpriteSet
local function get_corpse()
	return Remnants.get_corpse("locomotive-remnants", { animation = get_corpse_animation() })
end

---Defines the options for the locomotive sprite set.
---@class TrainLocomotiveSpriteSetParams
---The color to tint the medium metal particles of the dying explosion. When `nil`, the tint of the base game is used.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("TrainLocomotiveSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for the dying explosion and the corpse of a locomotive.
---@param params TrainLocomotiveSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<EntityWithHealthSpriteSet> # The sprite set definition for the locomotive.
---
---#### Examples
---```lua
---local train_locomotive = require("__reskins-assets-api__.assets.base.entities.train-locomotive")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = train_locomotive.get_sprite_set({ tint = tint })
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
			dying_explosion = LocomotiveExplosion.get_explosion({
				tints = params.tint and { ["locomotive-metal-particle-medium"] = params.tint },
			}),
			corpse = get_corpse(),
			nominal_width = 2,
			nominal_height = 6,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-base__/graphics/icons" })
local icon_builder = icons:tinted("train-locomotive")

---Gets the icon for a locomotive, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the icon for a locomotive as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
