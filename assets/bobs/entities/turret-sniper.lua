---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Entities

local _defines = require("api.defines")
local IconCatalog = require("api.icon-catalog")

local M = {}

---@class TurretSniperSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?

---Gets the sprite set for Bob's sniper turret.
---
---The set carries its nominal dimensions only; no artwork is drawn for this family yet.
---@param params TurretSniperSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<TurretSpriteSet>
---
---#### Examples
---```lua
---local turret_sniper = require("__reskins-assets-api__.assets.bobs.entities.turret-sniper")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = turret_sniper.get_sprite_set({ tint = tint })
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

local icons = IconCatalog:create({ folder = "__reskins-assets-bobs__/graphics/icons" })

---Gets the icon for Bob's sniper turret, in the tints given by `params`.
M.get_icon = icons:tinted("turret-sniper"):build("get_icon")

return M
