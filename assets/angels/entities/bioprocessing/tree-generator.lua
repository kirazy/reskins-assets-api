---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")

local IconCatalog = require("api.icon-catalog")

local M = {}

---@param tint Color?
---@param variant "temperate"|"desert"|"swamp"
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint, variant)
	local variant_filenames = {
		temperate = "__angelsbioprocessinggraphics__/graphics/entity/trees/bio-generator-1.png",
		swamp = "__angelsbioprocessinggraphics__/graphics/entity/trees/bio-generator-2.png",
		desert = "__angelsbioprocessinggraphics__/graphics/entity/trees/bio-generator-3.png",
	}

	local layers = {
		{
			filename = "__angelsbioprocessinggraphics__/graphics/entity/trees/bio-generator-shadow.png",
			width = 160,
			height = 160,
			line_length = 1,
			frame_count = 1,
			shift = { 0, 0 },
		},
		{
			filename = "__angelsbioprocessinggraphics__/graphics/entity/trees/bio-generator-base.png",
			width = 160,
			height = 160,
			line_length = 1,
			frame_count = 1,
			shift = { 0, 0 },
		},
		{
			filename = "__angelsbioprocessinggraphics__/graphics/entity/trees/bio-generator-pipes.png",
			width = 160,
			height = 160,
			line_length = 1,
			frame_count = 1,
			shift = { 0, 0 },
		},
		{
			filename = variant_filenames[variant],
			width = 160,
			height = 160,
			line_length = 1,
			frame_count = 1,
			shift = { 0, 0 },
		},
		{
			filename = "__angelsbioprocessinggraphics__/graphics/entity/trees/bio-generator-top.png",
			width = 160,
			height = 160,
			line_length = 1,
			frame_count = 1,
			shift = { 0, 0 },
		},
	}

	if tint then
		table.insert(layers, {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/tree-generator/tree-generator-mask.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			shift = { 0, 0 },
			tint = tint,
		})
		table.insert(layers, {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/tree-generator/tree-generator-highlights.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			shift = { 0, 0 },
			blend_mode = "additive-soft",
		})
	end

	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = { layers = layers },
		working_visualisations = {
			{
				fadeout = true,
				animation = {
					filename = "__angelsbioprocessinggraphics__/graphics/entity/trees/bio-generator-top-on.png",
					priority = "extra-high",
					width = 160,
					height = 160,
					shift = { 0, 0 },
					draw_as_glow = true,
				},
				light = { intensity = 4, size = 4, color = { r = 0.5, g = 1.0, b = 0.5 } },
			},
		},
	}

	return graphics_set
end

---@class TreeGeneratorSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?
---The variant to draw.
---@field variant "temperate"|"desert"|"swamp"

---Gets the sprite set for Angel's tree generator.
---@param params TreeGeneratorSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---
---#### Examples
---```lua
---local tree_generator = require("__reskins-assets-api__.assets.angels.entities.bioprocessing.tree-generator")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = tree_generator.get_sprite_set({ tint = tint, variant = variant })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set(params)
	---@type SpriteSetDefinition<CraftingMachineSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.crafting_machine_sprite_set,
		set = {
			graphics_set = get_graphics_set(params.tint, params.variant),
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

local icons = IconCatalog:create({ folder = "__reskins-assets-angels__/graphics/icons" })

---Gets the icon for Angel's tree generator of the `variant` and in the tints given by `params`.
M.get_icon = IconCatalog.dispatch("variant", { "temperate", "desert", "swamp" }, "get_icon", function(variant)
	return icons:tinted("tree-generator-" .. variant)
end)

return M
