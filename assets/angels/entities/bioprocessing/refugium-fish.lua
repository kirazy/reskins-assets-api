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
local function get_graphics_set(tint, variant)
	local working_visualisations = {
		{
			animation = {
				filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-refugium/bio-refugium-fish.png",
				width = 288,
				height = 288,
				line_length = 7,
				frame_count = 49,
				shift = { 0, 0 },
				animation_speed = 49 / 90,
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
						filename = "__reskins-assets-angels__/graphics/entity/refugium-fish/refugium-fish-mask.png",
						priority = "extra-high",
						width = 288,
						height = 288,
						shift = { 0, 0 },
						tint = tint,
					},
					-- Highlights
					{
						filename = "__reskins-assets-angels__/graphics/entity/refugium-fish/refugium-fish-highlights.png",
						priority = "extra-high",
						width = 288,
						height = 288,
						shift = { 0, 0 },
						blend_mode = "additive-soft",
					},
				},
			},
		})
	end

	---@type CraftingMachineGraphicsSet
	return {
		animation = {
			layers = {
				{
					filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-refugium/bio-refugium-fish-shadow.png",
					width = 288,
					height = 288,
					line_length = 1,
					frame_count = 1,
					shift = { 0, 0 },
				},
				{
					filename = "__angelsbioprocessinggraphics__/graphics/entity/bio-refugium/bio-refugium-fish-off.png",
					width = 288,
					height = 288,
					line_length = 1,
					frame_count = 1,
					shift = { 0, 0 },
				},
			},
		},
		working_visualisations = working_visualisations,
	}
end

---@class RefugiumFishSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?

---Gets the sprite set for Angel's fish refugium.
---@param params RefugiumFishSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---
---#### Examples
---```lua
---local refugium_fish = require("__reskins-assets-api__.assets.angels.entities.bioprocessing.refugium-fish")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = refugium_fish.get_sprite_set({ tint = tint })
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

local icons = IconCatalog:create({ folder = "__reskins-assets-angels__/graphics/icons" })

---Gets the icon for Angel's fish refugium, in the tints given by `params`.
M.get_icon = icons:tinted("refugium-fish"):build("get_icon")

return M
