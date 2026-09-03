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
	local layers = {
		-- Shadow
		{
			filename = "__angelsbioprocessinggraphics__/graphics/entity/trees/bio-arboretum-shadow.png",
			width = 224,
			height = 256,
			shift = { 0, -0.50 },
		},
		-- Base
		{
			filename = "__angelsbioprocessinggraphics__/graphics/entity/trees/bio-arboretum-base.png",
			width = 224,
			height = 256,
			shift = { 0, -0.50 },
		},
	}

	if tint then
		table.insert(layers, {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/arboretum/arboretum-mask.png",
			priority = "extra-high",
			width = 224,
			height = 256,
			shift = { 0, -0.5 },
			tint = tint,
		})
		table.insert(layers, {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/arboretum/arboretum-highlights.png",
			priority = "extra-high",
			width = 224,
			height = 256,
			shift = { 0, -0.5 },
			blend_mode = "additive-soft",
		})
	end

	table.insert(layers, {
		-- Pipes
		filename = "__angelsbioprocessinggraphics__/graphics/entity/trees/bio-arboretum-pipes.png",
		width = 224,
		height = 256,
		shift = { 0, -0.50 },
	})
	table.insert(layers, {
		-- Off state
		filename = "__angelsbioprocessinggraphics__/graphics/entity/trees/bio-arboretum-off.png",
		width = 224,
		height = 256,
		shift = { 0, -0.50 },
	})

	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = { layers = layers },
		working_visualisations = {
			{
				apply_recipe_tint = "primary",
				animation = {
					filename = "__angelsbioprocessinggraphics__/graphics/entity/trees/bio-arboretum-on.png",
					blend_mode = "additive",
					width = 224,
					height = 256,
					line_length = 1,
					frame_count = 1,
					shift = { 0, -0.50 },
				},
				light = { intensity = 1, size = 8, color = { r = 0.5, g = 1.0, b = 0.5 } },
			},
		},
	}

	return graphics_set
end

---@class ArboretumSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?

---Gets the sprite set for Angel's arboretum.
---@param params ArboretumSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---
---#### Examples
---```lua
---local arboretum = require("__reskins-assets-api__.assets.angels.entities.bioprocessing.arboretum")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = arboretum.get_sprite_set({ tint = tint })
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

local icons = IconCatalog:create({ folder = "__reskins-assets-angels__/graphics/icons" })

---Gets the icon for Angel's arboretum, in the tints given by `params`.
M.get_icon = icons:tinted("arboretum"):build("get_icon")

return M
