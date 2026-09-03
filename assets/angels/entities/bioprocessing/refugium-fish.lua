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
local function get_graphics_set(tint, variant)
	local working_visualisations = {
		{
			animation = {
				filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-refugium/bio-refugium-fish.png",
				width = 288,
				height = 288,
				line_length = 7,
				frame_count = 49,
				shift = { 0, 0 },
				animation_speed = 49 / 90,
			},
		},
	}

	if tint then
		table.insert(working_visualisations, {
			always_draw = true,
			animation = {
				layers = {
					-- Mask
					{
						filename = "__reskins-assets-angels__/graphics/entity/refugium-fish/refugium-fish-mask.png",
						priority = "extra-high",
						width = 288,
						height = 288,
						shift = { 0, 0 },
						tint = tint,
					},
					-- Highlights
					{
						filename = "__reskins-assets-angels__/graphics/entity/refugium-fish/refugium-fish-highlights.png",
						priority = "extra-high",
						width = 288,
						height = 288,
						shift = { 0, 0 },
						blend_mode = "additive-soft",
					},
				},
			},
		})
	end

	---@type CraftingMachineGraphicsSet
	return {
		animation = {
			layers = {
				{
					filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-refugium/bio-refugium-fish-shadow.png",
					width = 288,
					height = 288,
					line_length = 1,
					frame_count = 1,
					shift = { 0, 0 },
				},
				{
					filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-refugium/bio-refugium-fish-off.png",
					width = 288,
					height = 288,
					line_length = 1,
					frame_count = 1,
					shift = { 0, 0 },
				},
			},
		},
		working_visualisations = working_visualisations,
	}
end

---@class RefugiumFishSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?

---Gets the sprite set for Angel's fish refugium.
---@param params RefugiumFishSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---
---#### Examples
---```lua
---local refugium_fish = require("__reskins-assets-api__.assets.angels.entities.bioprocessing.refugium-fish")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = refugium_fish.get_sprite_set({ tint = tint })
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
			nominal_width = 7,
			nominal_height = 7,
		},
	}

	return definition
end

local check_get_icon = V.signature("get_icon", {
	{ "tint", Common.color:optional() },
})

---Gets the icon for Angel's fish refugium, in the given `tint`.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(tint)
	check_get_icon(tint)

	local folder = "__reskins-assets-angels__/graphics/icons/refugium-fish/refugium-fish-"

	---@type SafeIconData[]
	local icon = { { icon = folder .. "base.png", icon_size = 64, scale = 0.5 } }

	if tint then
		table.insert(icon, { icon = folder .. "mask.png", icon_size = 64, scale = 0.5, tint = tint })
		table.insert(icon, { icon = folder .. "highlights.png", icon_size = 64, scale = 0.5, tint = { 1, 1, 1, 0 } })
	end

	return icon
end

return M
