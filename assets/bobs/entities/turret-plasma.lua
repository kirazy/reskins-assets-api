---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators

---@namespace Reskins.Assets.Bobs.Entities

local _defines = require("api.defines")

local M = {}

---@class TurretPlasmaSpriteSetParams
---@field tint Color?

---Produces the sprite set for Bob's plasma turret.
---
---Placeholder: the old pack carried nothing but its footprint, so this producer
---carries no sprites either. It exists so the family has a home to grow into.
---@param params TurretPlasmaSpriteSetParams
---@return SpriteSetDefinition<TurretSpriteSet>
---@nodiscard
function M.get(params)
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

return M
