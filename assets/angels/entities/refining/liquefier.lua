---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")

local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")

local M = {}

---@param tint Color?
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint)
	local animation = {
		layers = {
			{
				-- cspell: disable-next-line
				filename = "__angelsrefininggraphics__/graphics/entity/liquifier/liquifier.png",
				width = 160,
				height = 160,
				line_length = 10,
				frame_count = 30,
				shift = { 0, 0 },
				animation_speed = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/liquefier/liquefier-mask.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			repeat_count = 30,
			shift = { 0, 0 },
			animation_speed = 0.5,
			tint = tint,
		})
		table.insert(animation.layers--[[@cast -?]], {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/liquefier/liquefier-highlights.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			repeat_count = 30,
			shift = { 0, 0 },
			animation_speed = 0.5,
			blend_mode = "additive-soft",
		})
	end

	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = animation,
		working_visualisations = {},
	}

	return graphics_set
end

---@class LiquefierSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?

---Gets the sprite set for Angel's liquefier.
---@param params LiquefierSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---
---#### Examples
---```lua
---local liquefier = require("__reskins-assets-api__.assets.angels.entities.refining.liquefier")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = liquefier.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set(params)
	---@type SpriteSetDefinition<CraftingMachineSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.crafting_machine_sprite_set,
		set = {
			graphics_set = get_graphics_set(params.tint),
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

---Gets the icon for Angel's liquefier, in the given `tint`.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(tint)
	check_get_icon(tint)

	local folder = "__reskins-assets-angels__/graphics/icons/liquefier/liquefier-"

	---@type SafeIconData[]
	local icon = { { icon = folder .. "base.png", icon_size = 64, scale = 0.5 } }

	if tint then
		table.insert(icon, { icon = folder .. "mask.png", icon_size = 64, scale = 0.5, tint = tint })
		table.insert(icon, { icon = folder .. "highlights.png", icon_size = 64, scale = 0.5, tint = { 1, 1, 1, 0 } })
	end

	return icon
end

return M
