---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")
local IconCatalog = require("api.icon-catalog")

local M = {}

---@param tint Color?
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint)
	local animation = {
		layers = {
			-- Base
			{
				filename = "__angelssmeltinggraphics__/graphics/entity/powder-mixer/powder-mixer-base.png",
				priority = "extra-high",
				width = 138,
				height = 170,
				line_length = 4,
				frame_count = 4,
				animation_speed = 0.5,
				shift = util.by_pixel(0.5, -9.5),
				scale = 0.5,
			},
			-- Shadow
			{
				filename = "__angelssmeltinggraphics__/graphics/entity/powder-mixer/powder-mixer-shadow.png",
				priority = "extra-high",
				width = 183,
				height = 99,
				repeat_count = 4,
				animation_speed = 0.5,
				draw_as_shadow = true,
				shift = util.by_pixel(13, 9),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/powder-mixer/powder-mixer-mask.png",
			priority = "extra-high",
			width = 138,
			height = 170,
			line_length = 4,
			frame_count = 4,
			animation_speed = 0.5,
			shift = util.by_pixel(0.5, -9.5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/powder-mixer/powder-mixer-highlights.png",
			priority = "extra-high",
			width = 138,
			height = 170,
			line_length = 4,
			frame_count = 4,
			animation_speed = 0.5,
			shift = util.by_pixel(0.5, -9.5),
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

---@class PowderMixerSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?

---Gets the sprite set for Angel's powder mixer.
---@param params PowderMixerSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---
---#### Examples
---```lua
---local powder_mixer = require("__reskins-assets-api__.assets.angels.entities.smelting.powder-mixer")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = powder_mixer.get_sprite_set({ tint = tint })
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
			nominal_width = 2,
			nominal_height = 2,
		},
	}

	return definition
end

local icons = IconCatalog:create({ folder = "__reskins-assets-angels__/graphics/icons" })

---Gets the icon for Angel's powder mixer, in the tints given by `params`.
M.get_icon = icons:tinted("powder-mixer"):build("get_icon")

return M
