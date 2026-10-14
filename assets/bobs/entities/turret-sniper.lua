---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Entities

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local M = {}

---Defines the options for the Bob's sniper turret sprite set.
---@class TurretSniperSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

---Gets the sprite set for Bob's sniper turret.
---
---The set defines its nominal dimensions only. No artwork is drawn for this turret yet.
---@param params TurretSniperSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<TurretSpriteSet> # The sprite set definition for Bob's sniper turret.
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

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-bobs__/graphics/icons" })

---Gets the icon for Bob's sniper turret, in the tints given by `params`.
M.get_icon = icons:tinted("turret-sniper"):build("get_icon")

return M
