---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")
local _sprites = require("__reskins-sprite-utils__.sprites")

local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")

local M = {}

---@param tint Color?
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint)
	local layers = {
		-- Base
		{
			filename = "__angelspetrochemgraphics__/graphics/entity/gas-refinery/gas-refinery-base.png",
			priority = "extra-high",
			width = 334,
			height = 553,
			shift = util.by_pixel(0, -48),
			scale = 0.5,
		},
		-- Shadow
		{
			filename = "__angelspetrochemgraphics__/graphics/entity/gas-refinery/gas-refinery-shadow.png",
			priority = "extra-high",
			width = 508,
			height = 338,
			shift = util.by_pixel(43.5, 6.5),
			draw_as_shadow = true,
			scale = 0.5,
		},
	}

	if tint then
		table.insert(layers, {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/gas-refinery/gas-refinery-mask.png",
			priority = "extra-high",
			width = 334,
			height = 553,
			shift = util.by_pixel(0, -48),
			tint = tint,
			scale = 0.5,
		})
		table.insert(layers, {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/gas-refinery/gas-refinery-highlights.png",
			priority = "extra-high",
			width = 334,
			height = 553,
			shift = util.by_pixel(0, -48),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = _sprites.make_4way_animation_from_spritesheet({ layers = layers }) --[[@as Animation4Way]],
		working_visualisations = {
			{
				fadeout = true,
				constant_speed = true,
				north_position = util.by_pixel(-57.5, -152.5),
				east_position = util.by_pixel(49.5, -189.5),
				south_position = util.by_pixel(59, -69),
				west_position = util.by_pixel(-50, -62.5),
				animation = {
					filename = "__base__/graphics/entity/oil-refinery/oil-refinery-fire.png",
					line_length = 10,
					width = 40,
					height = 81,
					frame_count = 60,
					animation_speed = 0.75,
					draw_as_glow = true,
					scale = 0.5,
				},
			},
			{
				-- FIXME: Use make4way
				fadeout = true,
				north_animation = {
					filename = "__angelspetrochemgraphics__/graphics/entity/gas-refinery/gas-refinery-light.png",
					priority = "extra-high",
					width = 334,
					height = 553,
					frame_count = 1,
					shift = util.by_pixel(0, -48),
					blend_mode = "additive-soft",
					draw_as_glow = true,
					scale = 0.5,
				},
				east_animation = {
					filename = "__angelspetrochemgraphics__/graphics/entity/gas-refinery/gas-refinery-light.png",
					priority = "extra-high",
					width = 334,
					height = 553,
					x = 334,
					frame_count = 1,
					shift = util.by_pixel(0, -48),
					blend_mode = "additive-soft",
					draw_as_glow = true,
					scale = 0.5,
				},
				south_animation = {
					filename = "__angelspetrochemgraphics__/graphics/entity/gas-refinery/gas-refinery-light.png",
					priority = "extra-high",
					width = 334,
					height = 553,
					x = 668,
					frame_count = 1,
					shift = util.by_pixel(0, -48),
					blend_mode = "additive-soft",
					draw_as_glow = true,
					scale = 0.5,
				},
				west_animation = {
					filename = "__angelspetrochemgraphics__/graphics/entity/gas-refinery/gas-refinery-light.png",
					priority = "extra-high",
					width = 334,
					height = 553,
					x = 1002,
					frame_count = 1,
					shift = util.by_pixel(0, -48),
					blend_mode = "additive-soft",
					draw_as_glow = true,
					scale = 0.5,
				},
			},
			{
				-- FIXME: Use vertical pipe shadow
				always_draw = true,
				north_animation = {
					layers = {
						{
							draw_as_shadow = true,
							filename = "__angelspetrochemgraphics__/graphics/entity/gas-refinery/vertical-pipe-shadow-patch.png",
							priority = "high",
							width = 128,
							height = 128,
							repeat_count = 36,
							shift = { -2, -2 },
							scale = 0.5,
						},
						{
							draw_as_shadow = true,
							filename = "__angelspetrochemgraphics__/graphics/entity/gas-refinery/vertical-pipe-shadow-patch.png",
							priority = "high",
							width = 128,
							height = 128,
							repeat_count = 36,
							shift = { 0, -2 },
							scale = 0.5,
						},
						{
							draw_as_shadow = true,
							filename = "__angelspetrochemgraphics__/graphics/entity/gas-refinery/vertical-pipe-shadow-patch.png",
							priority = "high",
							width = 128,
							height = 128,
							repeat_count = 36,
							shift = { 2, -2 },
							scale = 0.5,
						},
					},
				},
				-- FIXME: Use vertical pipe shadow
				south_animation = {
					layers = {
						{
							draw_as_shadow = true,
							filename = "__angelspetrochemgraphics__/graphics/entity/gas-refinery/vertical-pipe-shadow-patch.png",
							priority = "high",
							width = 128,
							height = 128,
							repeat_count = 36,
							shift = { -2, 2 },
							scale = 0.5,
						},
						{
							draw_as_shadow = true,
							filename = "__angelspetrochemgraphics__/graphics/entity/gas-refinery/vertical-pipe-shadow-patch.png",
							priority = "high",
							width = 128,
							height = 128,
							repeat_count = 36,
							shift = { 0, 2 },
							scale = 0.5,
						},
						{
							draw_as_shadow = true,
							filename = "__angelspetrochemgraphics__/graphics/entity/gas-refinery/vertical-pipe-shadow-patch.png",
							priority = "high",
							width = 128,
							height = 128,
							repeat_count = 36,
							shift = { 2, 2 },
							scale = 0.5,
						},
					},
				},
			},
		},
	}

	return graphics_set
end

---@class GasRefinerySpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?

---Gets the sprite set for Angel's gas refinery.
---@param params GasRefinerySpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---
---#### Examples
---```lua
---local gas_refinery = require("__reskins-assets-api__.assets.angels.entities.petrochem.gas-refinery")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = gas_refinery.get_sprite_set({ tint = tint })
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

---Gets the icon for Angel's gas refinery, in the given `tint`.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(tint)
	check_get_icon(tint)

	local folder = "__reskins-assets-angels__/graphics/icons/gas-refinery/gas-refinery-icon-"

	---@type SafeIconData[]
	local icon = { { icon = folder .. "base.png", icon_size = 64, scale = 0.5 } }

	if tint then
		table.insert(icon, { icon = folder .. "mask.png", icon_size = 64, scale = 0.5, tint = tint })
		table.insert(icon, { icon = folder .. "highlights.png", icon_size = 64, scale = 0.5, tint = { 1, 1, 1, 0 } })
	end

	return icon
end

return M
