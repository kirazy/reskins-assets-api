---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local IconCatalog = require("api.icon-catalog")

local M = {}

---The sprite data of a `SpriteSetDefinition` of type `artillery_turret_sprite_set`.
---
---Provisional: no applicator consumes this shape yet. When one is written, this
---declaration moves to it, the way `BoilerSpriteSet` lives in `api/applicators/boiler.lua`.
---@class (exact) TurretArtillerySpriteSet : EntityWithHealthSpriteSet

---@class TurretArtillerySpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?

---Gets the sprite set for the vanilla artillery turret.
---
---The set carries its nominal dimensions only; no artwork is drawn for this family yet.
---@param params TurretArtillerySpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<TurretArtillerySpriteSet>
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

local icons = IconCatalog:create({ folder = "__reskins-assets-base__/graphics/icons" })

---Gets the icon for the vanilla artillery turret, in the tints given by `params`.
M.get_icon = icons:tinted("turret-artillery"):build("get_icon")

return M
