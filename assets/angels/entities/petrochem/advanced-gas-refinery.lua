---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")
local _sprites = require("__reskins-sprite-utils__.sprites")
local _pipes = require("assets.base.entities.pipe-pictures")

local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")

local M = {}

---@param tint Color?
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint)
	local layers = {
		-- Base
		{
			filename = "__angelspetrochemgraphics__/graphics/entity/advanced-gas-refinery/advanced-gas-refinery-base.png",
			priority = "extra-high",
			width = 462,
			height = 657,
			shift = util.by_pixel(0, -42),
			scale = 0.5,
		},
		-- Shadow
		{
			filename = "__angelspetrochemgraphics__/graphics/entity/advanced-gas-refinery/advanced-gas-refinery-shadow.png",
			priority = "extra-high",
			vertically_oriented = true,
			width = 655,
			height = 454,
			shift = util.by_pixel(48.5, 9.5),
			draw_as_shadow = true,
			scale = 0.5,
		},
	}

	if tint then
		table.insert(layers, {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/gas-refinery-advanced/gas-refinery-advanced-mask.png",
			priority = "extra-high",
			width = 462,
			height = 657,
			shift = util.by_pixel(0, -42),
			tint = tint,
			scale = 0.5,
		})
		table.insert(layers, {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/gas-refinery-advanced/gas-refinery-advanced-highlights.png",
			priority = "extra-high",
			width = 462,
			height = 657,
			shift = util.by_pixel(0, -42),
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
				north_position = util.by_pixel(-89, -136.5),
				east_position = util.by_pixel(34.5, -207.5),
				south_position = util.by_pixel(90.5, -94),
				west_position = util.by_pixel(-16, -35),
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
				fadeout = true,
				-- Convert this to use make4way
				north_animation = {
					filename = "__angelspetrochemgraphics__/graphics/entity/advanced-gas-refinery/advanced-gas-refinery-light.png",
					priority = "high",
					width = 462,
					height = 657,
					shift = util.by_pixel(0, -42),
					blend_mode = "additive-soft",
					draw_as_glow = true,
					scale = 0.5,
				},
				east_animation = {
					filename = "__angelspetrochemgraphics__/graphics/entity/advanced-gas-refinery/advanced-gas-refinery-light.png",
					priority = "high",
					width = 462,
					height = 657,
					x = 462,
					shift = util.by_pixel(0, -42),
					blend_mode = "additive-soft",
					draw_as_glow = true,
					scale = 0.5,
				},
				south_animation = {
					filename = "__angelspetrochemgraphics__/graphics/entity/advanced-gas-refinery/advanced-gas-refinery-light.png",
					priority = "high",
					width = 462,
					height = 657,
					x = 924,
					shift = util.by_pixel(0, -42),
					blend_mode = "additive-soft",
					draw_as_glow = true,
					scale = 0.5,
				},
				west_animation = {
					filename = "__angelspetrochemgraphics__/graphics/entity/advanced-gas-refinery/advanced-gas-refinery-light.png",
					priority = "high",
					width = 462,
					height = 657,
					x = 1386,
					shift = util.by_pixel(0, -42),
					blend_mode = "additive-soft",
					draw_as_glow = true,
					scale = 0.5,
				},
			},
			{
				always_draw = true,
				north_animation = {
					layers = {
						_pipes.vertical_pipe_shadow({ -1, -3 }),
						(_pipes.vertical_pipe_shadow({ 3, -3 })),
					},
				},
				south_animation = {
					layers = {
						_pipes.vertical_pipe_shadow({ -3, 3 }),
						_pipes.vertical_pipe_shadow({ -1, 3 }),
						(_pipes.vertical_pipe_shadow({ 1, 3 })),
					},
				},
			},
		},
	}

	return graphics_set
end

---@class AdvancedGasRefinerySpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?

---Gets the sprite set for Angel's advanced gas refinery.
---@param params AdvancedGasRefinerySpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---
---#### Examples
---```lua
---local advanced_gas_refinery = require("__reskins-assets-api__.assets.angels.entities.petrochem.advanced-gas-refinery")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = advanced_gas_refinery.get_sprite_set({ tint = tint })
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

---Gets the icon for Angel's advanced gas refinery, in the given `tint`.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(tint)
	check_get_icon(tint)

	local folder = "__reskins-assets-angels__/graphics/icons/gas-refinery-advanced/gas-refinery-advanced-icon-"

	---@type SafeIconData[]
	local icon = { { icon = folder .. "base.png", icon_size = 64, scale = 0.5 } }

	if tint then
		table.insert(icon, { icon = folder .. "mask.png", icon_size = 64, scale = 0.5, tint = tint })
		table.insert(icon, { icon = folder .. "highlights.png", icon_size = 64, scale = 0.5, tint = { 1, 1, 1, 0 } })
	end

	return icon
end

return M
