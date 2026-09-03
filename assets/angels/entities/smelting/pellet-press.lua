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
				filename = "__angelssmeltinggraphics__/graphics/entity/pellet-press/pellet-press-base.png",
				priority = "extra-high",
				width = 200,
				height = 199,
				line_length = 10,
				frame_count = 60,
				animation_speed = 0.5,
				shift = util.by_pixel(0, 0),
				scale = 0.5,
			},
			-- Shadow
			{
				filename = "__angelssmeltinggraphics__/graphics/entity/pellet-press/pellet-press-shadow.png",
				priority = "extra-high",
				width = 246,
				height = 132,
				line_length = 6,
				frame_count = 60,
				animation_speed = 0.5,
				draw_as_shadow = true,
				shift = util.by_pixel(12, 17),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/pellet-press/pellet-press-mask.png",
			priority = "extra-high",
			width = 200,
			height = 199,
			line_length = 10,
			frame_count = 60,
			animation_speed = 0.5,
			shift = util.by_pixel(0, 0),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/pellet-press/pellet-press-highlights.png",
			priority = "extra-high",
			width = 200,
			height = 199,
			line_length = 10,
			frame_count = 60,
			animation_speed = 0.5,
			shift = util.by_pixel(0, 0),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = animation,
		working_visualisations = {},
	}

	return graphics_set
end

---@class PelletPressSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?

---Gets the sprite set for Angel's pellet press.
---@param params PelletPressSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---
---#### Examples
---```lua
---local pellet_press = require("__reskins-assets-api__.assets.angels.entities.smelting.pellet-press")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = pellet_press.get_sprite_set({ tint = tint })
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

---Gets the icon for Angel's pellet press, in the given `tint`.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(tint)
	check_get_icon(tint)

	local folder = "__reskins-assets-angels__/graphics/icons/pellet-press/pellet-press-"

	---@type SafeIconData[]
	local icon = { { icon = folder .. "base.png", icon_size = 64, scale = 0.5 } }

	if tint then
		table.insert(icon, { icon = folder .. "mask.png", icon_size = 64, scale = 0.5, tint = tint })
		table.insert(icon, { icon = folder .. "highlights.png", icon_size = 64, scale = 0.5, tint = { 1, 1, 1, 0 } })
	end

	return icon
end

return M
