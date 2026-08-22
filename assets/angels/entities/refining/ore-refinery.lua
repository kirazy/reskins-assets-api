---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")

local M = {}

---@param tint Color?
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint)
	local animation = {
		layers = {
			-- Base
			{
				filename = "__angelsrefininggraphics__/graphics/entity/ore-refinery/ore-refinery-base.png",
				priority = "extra-high",
				width = 440,
				height = 509,
				shift = util.by_pixel(0.5, -16),
				scale = 0.5,
			},
			-- Shadow
			{
				filename = "__angelsrefininggraphics__/graphics/entity/ore-refinery/ore-refinery-shadow.png",
				priority = "extra-high",
				width = 522,
				height = 340,
				shift = util.by_pixel(21.5, 29),
				draw_as_shadow = true,
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/ore-refinery/ore-refinery-mask.png",
			priority = "extra-high",
			width = 440,
			height = 509,
			shift = util.by_pixel(0.5, -16),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/ore-refinery/ore-refinery-highlights.png",
			priority = "extra-high",
			width = 440,
			height = 509,
			shift = util.by_pixel(0.5, -16),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = animation,
		working_visualisations = {
			{
				fadeout = true,
				effect = "uranium-glow",
				animation = {
					filename = "__angelsrefininggraphics__/graphics/entity/ore-refinery/ore-refinery-lights.png",
					priority = "extra-high",
					width = 440,
					height = 509,
					shift = util.by_pixel(0.5, -16),
					draw_as_glow = true,
					blend_mode = "additive-soft",
					scale = 0.5,
				},
			},
			{
				fadeout = true,
				constant_speed = true,
				apply_recipe_tint = "primary",
				north_position = util.by_pixel_hr(-63, -255),
				east_position = util.by_pixel_hr(-63, -255),
				south_position = util.by_pixel_hr(-63, -255),
				west_position = util.by_pixel_hr(-63, -255),
				render_layer = "wires",
				animation = {
					filename = "__base__/graphics/entity/chemical-plant/chemical-plant-smoke-outer.png",
					frame_count = 47,
					line_length = 16,
					width = 90,
					height = 188,
					animation_speed = 0.5,
					shift = util.by_pixel(-2, -40),
					tint = util.color("808080"),
					scale = 0.5,
				},
			},
			{
				fadeout = true,
				constant_speed = true,
				--apply_recipe_tint = "primary",
				north_position = util.by_pixel_hr(-63, -255),
				east_position = util.by_pixel_hr(-63, -255),
				south_position = util.by_pixel_hr(-63, -255),
				west_position = util.by_pixel_hr(-63, -255),
				render_layer = "wires",
				animation = {
					filename = "__base__/graphics/entity/chemical-plant/chemical-plant-smoke-inner.png",
					frame_count = 47,
					line_length = 16,
					width = 40,
					height = 84,
					animation_speed = 0.5,
					shift = util.by_pixel(0, -14),
					tint = util.color("b3b3b3"),
					scale = 0.5 * 1.2,
				},
			},
			{
				always_draw = true,
				apply_recipe_tint = "primary",
				render_layer = "wires",
				animation = {
					filename = "__angelsrefininggraphics__/graphics/entity/ore-refinery/stack-patch-overlay.png",
					priority = "extra-high",
					width = 46,
					height = 25,
					shift = util.by_pixel_hr(-61, -246),
					scale = 0.5,
				},
			},
		},
	}

	return graphics_set
end

---@class OreRefinerySpriteSetParams
---@field tint Color?

---Produces the sprite set for Angel's ore refinery.
---@param params OreRefinerySpriteSetParams
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---@nodiscard
function M.get(params)
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

return M
