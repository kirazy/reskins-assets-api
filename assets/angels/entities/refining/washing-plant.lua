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
			-- Base
			{
				filename = "__angelsrefininggraphics__/graphics/entity/washing-plant/washing-plant.png",
				priority = "extra-high",
				width = 224,
				height = 224,
				frame_count = 25,
				line_length = 5,
				shift = { 0, 0 },
			},
			-- Base Patch
			{
				filename = "__reskins-assets-angels__/graphics/entity/washing-plant/washing-plant-base-patch.png",
				priority = "extra-high",
				width = 224,
				height = 224,
				repeat_count = 25,
				shift = { 0, 0 },
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/washing-plant/washing-plant-mask.png",
			priority = "extra-high",
			width = 224,
			height = 224,
			repeat_count = 25,
			shift = { 0, 0 },
			tint = tint,
		})
		table.insert(animation.layers--[[@cast -?]], {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/washing-plant/washing-plant-highlights.png",
			priority = "extra-high",
			width = 224,
			height = 224,
			repeat_count = 25,
			shift = { 0, 0 },
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

---@class WashingPlantSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set rather than drawn
---untinted.
---@field tint Color?

---Gets the sprite set for Angel's washing plant.
---@param params WashingPlantSpriteSetParams # The options the sprite set is drawn with.
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---
---### Examples
---```lua
---local washing_plant = require("__reskins-assets-api__.assets.angels.entities.refining.washing-plant")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = washing_plant.get_sprite_set({ tint = tint })
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
			corpse = {},
			water_reflection = nil,
			nominal_width = 5,
			nominal_height = 5,
		},
	}

	return definition
end

local check_get_icon = V.signature("get_icon", {
	{ "tint", Common.color:optional() },
})

---Gets the icon for Angel's washing plant, in the given `tint`.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(tint)
	check_get_icon(tint)

	local folder = "__reskins-assets-angels__/graphics/icons/washing-plant/washing-plant-icon-"

	---@type SafeIconData[]
	local icon = { { icon = folder .. "base.png", icon_size = 64, scale = 0.5 } }

	if tint then
		table.insert(icon, { icon = folder .. "mask.png", icon_size = 64, scale = 0.5, tint = tint })
		table.insert(icon, { icon = folder .. "highlights.png", icon_size = 64, scale = 0.5, tint = { 1, 1, 1, 0 } })
	end

	return icon
end

return M
