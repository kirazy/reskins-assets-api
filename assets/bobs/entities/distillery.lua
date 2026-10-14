---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Entities

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local M = {}

---Defines the options for the Bob's distillery sprite set.
---@class DistillerySpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

---Gets the sprite set for Bob's distillery.
---
---The set defines its nominal dimensions only. Its `graphics_set` is empty, and no artwork is drawn for the
---distillery yet.
---@param params DistillerySpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Bob's distillery.
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

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-bobs__/graphics/icons" })

---Gets the icon for Bob's distillery, in the tints given by `params`.
M.get_icon = icons:tinted("distillery"):build("get_icon")

return M
