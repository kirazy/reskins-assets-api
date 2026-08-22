---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")

local M = {}

---@class PumpjackSpriteSetParams
---@field tint Color?

---Produces the sprite set for the vanilla pumpjack.
---
---Placeholder: the old pack carried nothing but its footprint, so this producer
---carries no sprites either. It exists so the family has a home to grow into.
---@param params PumpjackSpriteSetParams
---@return SpriteSetDefinition<MiningDrillSpriteSet>
---@nodiscard
function M.get(params)
	---@type SpriteSetDefinition<MiningDrillSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.mining_drill_sprite_set,
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
