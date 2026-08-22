---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")

local M = {}

---The sprite data a `artillery_turret_sprite_set`-tagged `SpriteSetDefinition` carries.
---
---Provisional: no applicator consumes this shape yet. When one is written, this
---declaration moves to it, the way `BoilerSpriteSet` lives in `api/applicators/boiler.lua`.
---@class (exact) TurretArtillerySpriteSet : EntityWithHealthSpriteSet

---@class TurretArtillerySpriteSetParams
---@field tint Color?

---Produces the sprite set for the vanilla artillery turret.
---
---Placeholder: the old pack carried nothing but its footprint, so this producer
---carries no sprites either. It exists so the family has a home to grow into.
---
---`ArtilleryTurretPrototype` descends from `EntityWithOwnerPrototype`, not
---`TurretPrototype`, so it takes its own sprite set type rather than sharing
---`turret_sprite_set`.
---@param params TurretArtillerySpriteSetParams
---@return SpriteSetDefinition<TurretArtillerySpriteSet>
---@nodiscard
function M.get(params)
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

return M
