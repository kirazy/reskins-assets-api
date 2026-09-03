---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")

local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")

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

local check_get_icon = V.signature("get_icon", {
	{ "tint", Common.color:optional() },
})

---Gets the icon for the vanilla artillery turret, in the given `tint`.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(tint)
	check_get_icon(tint)

	local folder = "__reskins-assets-base__/graphics/icons/turret-artillery/turret-artillery-"

	---@type SafeIconData[]
	local icon = { { icon = folder .. "base.png", icon_size = 64, scale = 0.5 } }

	if tint then
		table.insert(icon, { icon = folder .. "mask.png", icon_size = 64, scale = 0.5, tint = tint })
		table.insert(icon, { icon = folder .. "highlights.png", icon_size = 64, scale = 0.5, tint = { 1, 1, 1, 0 } })
	end

	return icon
end

return M
