---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Entities

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local M = {}

---Defines the options for the Bob's plasma turret sprite set.
---@class TurretPlasmaSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

---Gets the sprite set for Bob's plasma turret.
---
---The set defines its nominal dimensions only. No artwork is drawn for this turret yet.
---@param params TurretPlasmaSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<TurretSpriteSet> # The sprite set definition for Bob's plasma turret.
---
---#### Examples
---```lua
---local turret_plasma = require("__reskins-assets-api__.assets.bobs.entities.turret-plasma")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = turret_plasma.get_sprite_set({ tint = tint })
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
			nominal_width = 3,
			nominal_height = 3,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-bobs__/graphics/icons" })

---Gets the icon for Bob's plasma turret, in the tints given by `params`.
M.get_icon = icons:tinted("turret-plasma"):build("get_icon")

return M
