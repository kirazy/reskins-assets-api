---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Entities

local _defines = require("api.defines")
local IconCatalog = require("api.icon-catalog")

local M = {}

---@class DistillerySpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?

---Gets the sprite set for Bob's distillery.
---
---The set carries its nominal dimensions only; its `graphics_set` is empty and no artwork is
---drawn for this family yet.
---@param params DistillerySpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---
---#### Examples
---```lua
---local distillery = require("__reskins-assets-api__.assets.bobs.entities.distillery")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = distillery.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set(params)
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

local icons = IconCatalog:create({ folder = "__reskins-assets-bobs__/graphics/icons" })

---Gets the icon for Bob's distillery, in the tints given by `params`.
M.get_icon = icons:tinted("distillery"):build("get_icon")

return M
