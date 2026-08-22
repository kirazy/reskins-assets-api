---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")

local M = {}

---@param tint Color?
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint)
	---@type WorkingVisualisation[]
	local working_visualisations = {
		{
			always_draw = true,
			animation = {
				layers = {
					{
						filename = "__angelssmeltinggraphics__/graphics/entity/strand-casting-machine/strand-casting-machine-idle-state.png",
						priority = "high",
						width = 329,
						height = 392,
						shift = util.by_pixel(0, -16.5),
						scale = 0.5,
					},
					{
						filename = "__angelssmeltinggraphics__/graphics/entity/strand-casting-machine/strand-casting-machine-shadow.png",
						priority = "high",
						width = 444,
						height = 311,
						draw_as_shadow = true,
						shift = util.by_pixel(29.5, 3.5),
						scale = 0.5,
					},
				},
			},
		},
		{
			apply_recipe_tint = "primary",
			always_draw = true,
			animation = {
				filename = "__angelssmeltinggraphics__/graphics/entity/strand-casting-machine/strand-casting-machine-recipe-mask.png",
				priority = "high",
				width = 329,
				height = 392,
				shift = util.by_pixel(0, -16.5),
				scale = 0.5,
			},
		},
		{
			fadeout = true,
			animation = {
				filename = "__angelssmeltinggraphics__/graphics/entity/strand-casting-machine/strand-casting-machine-working-animation.png",
				priority = "high",
				width = 329,
				height = 392,
				line_length = 6,
				frame_count = 24,
				animation_speed = 0.5,
				shift = util.by_pixel(0, -16.5),
				scale = 0.5,
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
						filename = "__reskins-assets-angels__/graphics/entity/strand-casting-machine/strand-casting-machine-mask.png",
						priority = "extra-high",
						width = 329,
						height = 392,
						shift = util.by_pixel(0, -16.5),
						tint = tint,
						scale = 0.5,
					},
					-- Highlights
					{
						filename = "__reskins-assets-angels__/graphics/entity/strand-casting-machine/strand-casting-machine-highlights.png",
						priority = "extra-high",
						width = 329,
						height = 392,
						shift = util.by_pixel(0, -16.5),
						blend_mode = "additive-soft",
						scale = 0.5,
					},
				},
			},
		})
	end

	table.insert(working_visualisations, {
		fadeout = true,
		animation = {
			filename = "__angelssmeltinggraphics__/graphics/entity/strand-casting-machine/strand-casting-machine-light.png",
			priority = "high",
			width = 329,
			height = 392,
			line_length = 6,
			frame_count = 24,
			animation_speed = 0.5,
			shift = util.by_pixel(0, -16.5),
			draw_as_light = true,
			scale = 0.5,
		},
	})

	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		working_visualisations = working_visualisations,
	}

	return graphics_set
end

---@class StrandCastingMachineSpriteSetParams
---@field tint Color?

---Produces the sprite set for Angel's strand casting machine.
---@param params StrandCastingMachineSpriteSetParams
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
			nominal_width = 5,
			nominal_height = 5,
		},
	}

	return definition
end

return M
