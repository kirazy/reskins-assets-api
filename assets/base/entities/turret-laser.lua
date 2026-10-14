---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local M = {}

---Defines the options for the vanilla laser turret sprite set.
---@class TurretLaserSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

---Gets the sprite set for the vanilla laser turret.
---
---The set defines its nominal dimensions only. No artwork is drawn for this turret yet.
---@param params TurretLaserSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<TurretSpriteSet> # The sprite set definition for the vanilla laser turret.
---
---#### Examples
---```lua
---local turret_laser = require("__reskins-assets-api__.assets.base.entities.turret-laser")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = turret_laser.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set(params)
	---@type SpriteSetDefinition<TurretSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.turret_sprite_set,
		set = {
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = nil,
			water_reflection = nil,
			nominal_width = 2,
			nominal_height = 2,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-base__/graphics/icons" })

---Gets the icon for the vanilla laser turret, in the tints given by `params`.
M.get_icon = icons:tinted("turret-laser"):build("get_icon")

return M
