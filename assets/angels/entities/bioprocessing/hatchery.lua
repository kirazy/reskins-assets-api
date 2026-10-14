---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local M = {}

---@param tint? Color
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint)
	local animation = {
		layers = {
			{
				filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-hatchery/bio-hatchery-off.png",
				priority = "extra-high",
				width = 160,
				height = 160,
				shift = { 0, 0 },
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = "__reskins-assets-angels__/graphics/entity/hatchery/hatchery-idle-mask.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			shift = { 0, 0 },
			tint = tint,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = "__reskins-assets-angels__/graphics/entity/hatchery/hatchery-idle-highlights.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			shift = { 0, 0 },
			blend_mode = "additive-soft",
		})
	end

	local working_visualisations = {}

	if tint then
		table.insert(working_visualisations, {
			animation = {
				layers = {
					{
						filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-hatchery/bio-hatchery-animation.png",
						priority = "extra-high",
						width = 160,
						height = 160,
						frame_count = 25,
						line_length = 5,
						shift = { 0, 0 },
						animation_speed = 0.35,
					},
					{
						filename = "__reskins-assets-angels__/graphics/entity/hatchery/hatchery-working-mask.png",
						priority = "extra-high",
						width = 160,
						height = 160,
						frame_count = 25,
						line_length = 5,
						shift = { 0, 0 },
						animation_speed = 0.35,
						tint = tint,
					},
					{
						filename = "__reskins-assets-angels__/graphics/entity/hatchery/hatchery-working-highlights.png",
						priority = "extra-high",
						width = 160,
						height = 160,
						frame_count = 25,
						line_length = 5,
						shift = { 0, 0 },
						animation_speed = 0.35,
						blend_mode = "additive-soft",
					},
				},
			},
		})
	end

	-- The shadow layer is always drawn and is always required.
	table.insert(working_visualisations, {
		always_draw = true,
		animation = {
			filename = "__reskins-assets-angels__/graphics/entity/hatchery/hatchery-shadow.png",
			width = 160,
			height = 160,
			shift = { 0, 0 },
			draw_as_shadow = true,
		},
	})

	table.insert(working_visualisations, {
		fadeout = true,
		animation = {
			filename = "__reskins-assets-angels__/graphics/entity/hatchery/hatchery-working-light.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			frame_count = 25,
			line_length = 5,
			shift = { 0, 0 },
			animation_speed = 0.35,
			draw_as_light = true,
		},
	})

	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = animation,
		working_visualisations = working_visualisations,
	}

	return graphics_set
end

---Defines the options for the Angel's hatchery sprite set.
---@class HatcherySpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

---Gets the sprite set for Angel's hatchery.
---@param params HatcherySpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's hatchery.
---
---#### Examples
---```lua
---local hatchery = require("__reskins-assets-api__.assets.angels.entities.bioprocessing.hatchery")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = hatchery.get_sprite_set({ tint = tint })
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

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-angels__/graphics/icons" })

---Gets the icon for Angel's hatchery, in the tints given by `params`.
M.get_icon = icons:tinted("hatchery"):build("get_icon")

return M
