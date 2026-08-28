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
	local working_visualisations = {
		{
			animation = {
				filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-refugium/bio-refugium-puffer.png",
				width = 224,
				height = 256,
				line_length = 6,
				frame_count = 36,
				shift = { 0, -0.5 },
				animation_speed = 36 / 60,
			},
		},
	}

	if tint then
		table.insert(working_visualisations, {
			always_draw = true,
			animation = {
				layers = {
					-- Base patch
					{
						filename = "__reskins-assets-angels__/graphics/entity/refugium-puffer/refugium-puffer-base-patch.png",
						priority = "extra-high",
						width = 224,
						height = 256,
						shift = { 0, -0.5 },
					},
					-- Mask
					{
						filename = "__reskins-assets-angels__/graphics/entity/refugium-puffer/refugium-puffer-mask.png",
						priority = "extra-high",
						width = 224,
						height = 256,
						shift = { 0, -0.5 },
						tint = tint,
					},
					-- Highlights
					{
						filename = "__reskins-assets-angels__/graphics/entity/refugium-puffer/refugium-puffer-highlights.png",
						priority = "extra-high",
						width = 224,
						height = 256,
						shift = { 0, -0.5 },
						blend_mode = "additive-soft",
					},
				},
			},
		})
	end

	---@type CraftingMachineGraphicsSet
	return {
		animation = {
			filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-refugium/bio-refugium-puffer-off.png",
			width = 224,
			height = 256,
			line_length = 1,
			frame_count = 1,
			shift = { 0, -0.5 },
			animation_speed = 0.5,
		},
		working_visualisations = working_visualisations,
	}
end

---@class RefugiumPufferSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set rather than drawn
---untinted.
---@field tint Color?

---Gets the sprite set for Angel's puffer refugium.
---@param params RefugiumPufferSpriteSetParams # The options the sprite set is drawn with.
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---
---### Examples
---```lua
---local refugium_puffer = require("__reskins-assets-api__.assets.angels.entities.bioprocessing.refugium-puffer")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = refugium_puffer.get_sprite_set({ tint = tint })
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
			nominal_width = 5,
			nominal_height = 5,
		},
	}

	return definition
end

local check_get_icon = V.signature("get_icon", {
	{ "tint", Common.color:optional() },
})

---Gets the icon for Angel's puffer refugium, in the given `tint`.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(tint)
	check_get_icon(tint)

	local folder = "__reskins-assets-angels__/graphics/icons/refugium-puffer/refugium-puffer-icon-"

	---@type SafeIconData[]
	local icon = { { icon = folder .. "base.png", icon_size = 64, scale = 0.5 } }

	if tint then
		table.insert(icon, { icon = folder .. "mask.png", icon_size = 64, scale = 0.5, tint = tint })
		table.insert(icon, { icon = folder .. "highlights.png", icon_size = 64, scale = 0.5, tint = { 1, 1, 1, 0 } })
	end

	return icon
end

return M
