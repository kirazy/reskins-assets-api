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
	local working_visualisations = {
		{
			animation = {
				filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-refugium/bio-refugium-puffer.png",
				width = 224,
				height = 256,
				line_length = 6,
				frame_count = 36,
				shift = { 0, -0.5 },
				animation_speed = 36 / 60,
			},
		},
	}

	if tint then
		table.insert(working_visualisations, {
			always_draw = true,
			animation = {
				layers = {
					{
						filename = "__reskins-assets-angels__/graphics/entity/refugium-puffer/refugium-puffer-base-patch.png",
						priority = "extra-high",
						width = 224,
						height = 256,
						shift = { 0, -0.5 },
					},
					{
						filename = "__reskins-assets-angels__/graphics/entity/refugium-puffer/refugium-puffer-mask.png",
						priority = "extra-high",
						width = 224,
						height = 256,
						shift = { 0, -0.5 },
						tint = tint,
					},
					{
						filename = "__reskins-assets-angels__/graphics/entity/refugium-puffer/refugium-puffer-highlights.png",
						priority = "extra-high",
						width = 224,
						height = 256,
						shift = { 0, -0.5 },
						blend_mode = "additive-soft",
					},
				},
			},
		})
	end

	---@type CraftingMachineGraphicsSet
	return {
		animation = {
			filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-refugium/bio-refugium-puffer-off.png",
			width = 224,
			height = 256,
			line_length = 1,
			frame_count = 1,
			shift = { 0, -0.5 },
			animation_speed = 0.5,
		},
		working_visualisations = working_visualisations,
	}
end

---Defines the options for the Angel's puffer refugium sprite set.
---@class RefugiumPufferSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

---Gets the sprite set for Angel's puffer refugium.
---@param params RefugiumPufferSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's puffer refugium.
---
---#### Examples
---```lua
---local refugium_puffer = require("__reskins-assets-api__.assets.angels.entities.bioprocessing.refugium-puffer")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = refugium_puffer.get_sprite_set({ tint = tint })
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

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-angels__/graphics/icons" })

---Gets the icon for Angel's puffer refugium, in the tints given by `params`.
M.get_icon = icons:tinted("refugium-puffer"):build("get_icon")

return M
