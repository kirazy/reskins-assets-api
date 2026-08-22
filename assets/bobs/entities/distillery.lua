---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators

---@namespace Reskins.Assets.Bobs.Entities

local _defines = require("api.defines")

local M = {}

---@class DistillerySpriteSetParams
---@field tint Color?

---Produces the sprite set for Bob's distillery.
---
---Placeholder: the old pack carried nothing but its footprint, so this producer
---carries no sprites either. It exists so the family has a home to grow into.
---Its `graphics_set` is empty for the same reason.
---@param params DistillerySpriteSetParams
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---@nodiscard
function M.get(params)
	---@type SpriteSetDefinition<CraftingMachineSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.crafting_machine_sprite_set,
		set = {
			graphics_set = {},
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

return M
