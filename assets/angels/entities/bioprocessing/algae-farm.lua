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
				filename = "__angelsbioprocessinggraphics__/graphics/entity/algae-farm/algae-farm.png",
				priority = "extra-high",
				width = 288,
				height = 288,
				line_length = 6,
				frame_count = 36,
				shift = { 0, 0 },
				animation_speed = 0.4,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/algae-farm/algae-farm-mask.png",
			priority = "extra-high",
			width = 288,
			height = 288,
			repeat_count = 36,
			shift = { 0, 0 },
			animation_speed = 0.4,
			tint = tint,
		})
		table.insert(animation.layers--[[@cast -?]], {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/algae-farm/algae-farm-highlights.png",
			priority = "extra-high",
			width = 288,
			height = 288,
			repeat_count = 36,
			shift = { 0, 0 },
			animation_speed = 0.4,
			blend_mode = "additive-soft",
		})
	end

	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = animation,
		working_visualisations = {
			{
				animation = {
					filename = "__angelsbioprocessinggraphics__/graphics/entity/algae-farm/water-splash.png",
					line_length = 5,
					frame_count = 10,
					width = 92,
					height = 99,
					scale = 0.4,
					shift = { -1.4, 0 },
					animation_speed = 0.2,
					run_mode = "forward",
				},
				light = { intensity = 0.4, size = 6 },
			},
		},
	}

	return graphics_set
end

---@class AlgaeFarmSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set rather than drawn
---untinted.
---@field tint Color?

---Gets the sprite set for Angel's algae farm.
---@param params AlgaeFarmSpriteSetParams # The options the sprite set is drawn with.
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---
---### Examples
---```lua
---local algae_farm = require("__reskins-assets-api__.assets.angels.entities.bioprocessing.algae-farm")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = algae_farm.get_sprite_set({ tint = tint })
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

---Gets the icon for Angel's algae farm, in the given `tint`.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(tint)
	check_get_icon(tint)

	local folder = "__reskins-assets-angels__/graphics/icons/algae-farm/algae-farm-icon-"

	---@type SafeIconData[]
	local icon = { { icon = folder .. "base.png", icon_size = 64, scale = 0.5 } }

	if tint then
		table.insert(icon, { icon = folder .. "mask.png", icon_size = 64, scale = 0.5, tint = tint })
		table.insert(icon, { icon = folder .. "highlights.png", icon_size = 64, scale = 0.5, tint = { 1, 1, 1, 0 } })
	end

	return icon
end

return M
