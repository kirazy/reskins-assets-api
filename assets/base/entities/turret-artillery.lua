---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local M = {}

---Defines the sprite data of a `SpriteSetDefinition` of type `artillery_turret_sprite_set`.
---
---Provisional: no applicator consumes this sprite set type yet.
---@class (exact) TurretArtillerySpriteSet : EntityWithHealthSpriteSet

---Defines the options for the vanilla artillery turret sprite set.
---@class TurretArtillerySpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

---Gets the sprite set for the vanilla artillery turret.
---
---The set defines its nominal dimensions only. No artwork is drawn for this turret yet.
---@param params TurretArtillerySpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<TurretArtillerySpriteSet> # The sprite set definition for the vanilla artillery turret.
---
---#### Examples
---```lua
---local turret_artillery = require("__reskins-assets-api__.assets.base.entities.turret-artillery")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = turret_artillery.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set(params)
	---@type SpriteSetDefinition<TurretArtillerySpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.artillery_turret_sprite_set,
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

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-base__/graphics/icons" })

---Gets the icon for the vanilla artillery turret, in the tints given by `params`.
M.get_icon = icons:tinted("turret-artillery"):build("get_icon")

return M
