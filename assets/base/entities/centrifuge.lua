---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _sprites = require("__reskins-sprite-utils__.sprites")
local _defines = require("api.defines")

local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")

local M = {}

---@param tint Color?
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint)
	local assets_path = "__reskins-assets-base__/graphics/entity/centrifuge/"

	---@type Animation
	local idle_animation = {
		layers = {
			-- Centrifuge C — no tint layers; C sub-assembly is always unmodified base-game appearance
			{
				filename = "__base__/graphics/entity/centrifuge/centrifuge-C.png",
				priority = "high",
				scale = 0.5,
				line_length = 8,
				width = 237,
				height = 214,
				frame_count = 64,
				shift = util.by_pixel(-0.25, -26.5),
			},
			{
				filename = "__base__/graphics/entity/centrifuge/centrifuge-C-shadow.png",
				priority = "high",
				draw_as_shadow = true,
				scale = 0.5,
				line_length = 8,
				width = 279,
				height = 152,
				frame_count = 64,
				shift = util.by_pixel(16.75, -10),
			},
			-- Centrifuge B — base
			{
				filename = "__base__/graphics/entity/centrifuge/centrifuge-B.png",
				priority = "high",
				scale = 0.5,
				line_length = 8,
				width = 156,
				height = 234,
				frame_count = 64,
				shift = util.by_pixel(23, 6.5),
			},
		},
	}

	if tint then
		-- Centrifuge B — mask and highlights
		table.insert(idle_animation.layers--[[@cast -?]], {
			filename = assets_path .. "centrifuge-b-mask.png",
			priority = "high",
			tint = tint,
			scale = 0.5,
			line_length = 8,
			width = 156,
			height = 234,
			frame_count = 64,
			shift = util.by_pixel(23, 6.5),
		})
		table.insert(idle_animation.layers--[[@cast -?]], {
			filename = assets_path .. "centrifuge-b-highlights.png",
			priority = "high",
			blend_mode = "additive-soft",
			scale = 0.5,
			line_length = 8,
			width = 156,
			height = 234,
			frame_count = 64,
			shift = util.by_pixel(23, 6.5),
		})
	end

	-- Centrifuge B — shadow
	table.insert(idle_animation.layers--[[@cast -?]], {
		filename = "__base__/graphics/entity/centrifuge/centrifuge-B-shadow.png",
		priority = "high",
		draw_as_shadow = true,
		scale = 0.5,
		line_length = 8,
		width = 251,
		height = 149,
		frame_count = 64,
		shift = util.by_pixel(63.25, 15.25),
	})

	-- Centrifuge A — base
	table.insert(idle_animation.layers--[[@cast -?]], {
		filename = "__base__/graphics/entity/centrifuge/centrifuge-A.png",
		priority = "high",
		scale = 0.5,
		line_length = 8,
		width = 139,
		height = 246,
		frame_count = 64,
		shift = util.by_pixel(-26.25, 3.5),
	})

	if tint then
		-- Centrifuge A — mask and highlights
		table.insert(idle_animation.layers--[[@cast -?]], {
			filename = assets_path .. "centrifuge-a-mask.png",
			priority = "high",
			tint = tint,
			scale = 0.5,
			line_length = 8,
			width = 139,
			height = 246,
			frame_count = 64,
			shift = util.by_pixel(-26.25, 3.5),
		})
		table.insert(idle_animation.layers--[[@cast -?]], {
			filename = assets_path .. "centrifuge-a-highlights.png",
			priority = "high",
			blend_mode = "additive-soft",
			scale = 0.5,
			line_length = 8,
			width = 139,
			height = 246,
			frame_count = 64,
			shift = util.by_pixel(-26.25, 3.5),
		})
	end

	-- Centrifuge A — shadow
	table.insert(idle_animation.layers--[[@cast -?]], {
		filename = "__base__/graphics/entity/centrifuge/centrifuge-A-shadow.png",
		priority = "high",
		draw_as_shadow = true,
		scale = 0.5,
		line_length = 8,
		width = 230,
		height = 124,
		frame_count = 64,
		shift = util.by_pixel(8.5, 23.5),
	})

	---@type WorkingVisualisation[]
	local working_visualisations = {
		-- Area light
		{
			effect = "uranium-glow",
			apply_recipe_tint = "primary",
			fadeout = true,
			light = { intensity = 0.1, size = 9.9, shift = { 0.0, 0.0 }, color = { r = 0.0, g = 1.0, b = 0.0 } },
		},
		-- Working lights — three sub-assembly glow layers
		{
			effect = "uranium-glow",
			fadeout = true,
			apply_recipe_tint = "primary",
			animation = {
				layers = {
					-- Centrifuge C
					{
						filename = assets_path .. "lights/centrifuge-c-light.png",
						priority = "high",
						scale = 0.5,
						blend_mode = "additive",
						line_length = 8,
						width = 190,
						height = 207,
						frame_count = 64,
						shift = util.by_pixel(0, -27.25),
						draw_as_glow = true,
					},
					-- Centrifuge B
					{
						filename = assets_path .. "lights/centrifuge-b-light.png",
						priority = "high",
						scale = 0.5,
						blend_mode = "additive",
						line_length = 8,
						width = 131,
						height = 206,
						frame_count = 64,
						shift = util.by_pixel(16.75, 0.5),
						draw_as_glow = true,
					},
					-- Centrifuge A
					{
						filename = assets_path .. "lights/centrifuge-a-light.png",
						priority = "high",
						scale = 0.5,
						blend_mode = "additive",
						line_length = 8,
						width = 108,
						height = 197,
						frame_count = 64,
						shift = util.by_pixel(-23.5, -1.75),
						draw_as_glow = true,
					},
				},
			},
		},
	}

	return {
		always_draw_idle_animation = true,
		idle_animation = idle_animation,
		working_visualisations = working_visualisations,
	}
end

---@param tint Color?
---@return RotatedAnimationVariations
local function get_corpse_animation(tint)
	local assets_path = "__reskins-assets-base__/graphics/entity/centrifuge/"

	local layers = {
		-- Base
		{
			filename = "__base__/graphics/entity/centrifuge/remnants/centrifuge-remnants.png",
			width = 286,
			height = 284,
			direction_count = 1,
			shift = util.by_pixel(7, 4),
			scale = 0.5,
		},
	}

	if tint then
		-- Mask
		table.insert(layers, {
			filename = assets_path .. "remnants/centrifuge-remnants-mask.png",
			width = 286,
			height = 284,
			direction_count = 1,
			shift = util.by_pixel(7, 4),
			tint = tint,
			scale = 0.5,
		})
		-- Highlights
		table.insert(layers, {
			filename = assets_path .. "remnants/centrifuge-remnants-highlights.png",
			width = 286,
			height = 284,
			direction_count = 1,
			shift = util.by_pixel(7, 4),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return _sprites.make_rotated_animation_variations_from_spritesheet(1, { layers = layers })
end

---@class CentrifugeSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set rather than drawn
---untinted.
---@field tint Color?

---Gets the sprite set for the vanilla centrifuge.
---@param params CentrifugeSpriteSetParams # The options the sprite set is drawn with.
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---
---### Examples
---```lua
---local centrifuge = require("__reskins-assets-api__.assets.base.entities.centrifuge")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = centrifuge.get_sprite_set({ tint = tint })
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
			corpse = { animation = get_corpse_animation(params.tint) },
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

---Gets the icon for the vanilla centrifuge, in the given `tint`.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(tint)
	check_get_icon(tint)

	local folder = "__reskins-assets-base__/graphics/icons/centrifuge/centrifuge-icon-"

	---@type SafeIconData[]
	local icon = { { icon = folder .. "base.png", icon_size = 64, scale = 0.5 } }

	if tint then
		table.insert(icon, { icon = folder .. "mask.png", icon_size = 64, scale = 0.5, tint = tint })
		table.insert(icon, { icon = folder .. "highlights.png", icon_size = 64, scale = 0.5, tint = { 1, 1, 1, 0 } })
	end

	return icon
end

return M
