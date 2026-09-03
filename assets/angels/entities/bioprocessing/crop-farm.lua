---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Entities

local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local _defines = require("api.defines")
local IconCatalog = require("api.icon-catalog")

local M = {}

local check_get_graphics_set = V.signature("get_graphics_set", {
	{ "tint", Common.color:optional() },
	{ "variant", V.one_of({ "basic", "temperate", "desert", "swamp" }) },
})

---@param tint Color?
---@param variant "basic"|"temperate"|"desert"|"swamp"
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint, variant)
	check_get_graphics_set(tint, variant)

	local variant_data = {
		basic = {
			field_filename = "__angelsbioprocessinggraphics__/graphics/entity/crop-farm/field-basic.png",
			animation_filename = "__angelsbioprocessinggraphics__/graphics/entity/crop-farm/field-animation-1.png",
			animation_speed = 0.005,
		},
		temperate = {
			field_filename = "__angelsbioprocessinggraphics__/graphics/entity/crop-farm/field-temperate.png",
			animation_filename = "__angelsbioprocessinggraphics__/graphics/entity/crop-farm/field-animation-2.png",
			animation_speed = 0.01,
		},
		desert = {
			field_filename = "__angelsbioprocessinggraphics__/graphics/entity/crop-farm/field-desert.png",
			animation_filename = "__angelsbioprocessinggraphics__/graphics/entity/crop-farm/field-animation-3.png",
			animation_speed = 0.01,
		},
		swamp = {
			field_filename = "__angelsbioprocessinggraphics__/graphics/entity/crop-farm/field-water.png",
			animation_filename = "__angelsbioprocessinggraphics__/graphics/entity/crop-farm/field-animation-4.png",
			animation_speed = 0.01,
		},
	}

	local data = variant_data[variant]

	local working_visualisations = {
		{
			apply_recipe_tint = "primary",
			animation = {
				filename = data.animation_filename,
				line_length = 6,
				frame_count = 36,
				width = 224,
				height = 224,
				shift = { 0, 0 },
				animation_speed = data.animation_speed,
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
						filename = "__reskins-assets-angels__/graphics/entity/field/field-mask.png",
						priority = "extra-high",
						width = 224,
						height = 224,
						shift = { 0, 0 },
						tint = tint,
					},
					-- Highlights
					{
						filename = "__reskins-assets-angels__/graphics/entity/field/field-highlights.png",
						priority = "extra-high",
						width = 224,
						height = 224,
						shift = { 0, 0 },
						blend_mode = "additive-soft",
					},
				},
			},
		})
	end

	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = {
			layers = {
				{
					filename = "__angelsbioprocessinggraphics__/graphics/entity/crop-farm/farm-base.png",
					width = 224,
					height = 224,
					line_length = 1,
					frame_count = 1,
					shift = { 0, 0 },
				},
				{
					filename = data.field_filename,
					width = 224,
					height = 224,
					line_length = 1,
					frame_count = 1,
					shift = { 0, 0 },
				},
			},
		},
		working_visualisations = working_visualisations,
	}

	return graphics_set
end

---@class CropFarmSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?
---The variant to draw.
---@field variant "basic"|"temperate"|"desert"|"swamp"

---Gets the sprite set for Angel's crop farm.
---@param params CropFarmSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---
---#### Examples
---```lua
---local crop_farm = require("__reskins-assets-api__.assets.angels.entities.bioprocessing.crop-farm")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = crop_farm.get_sprite_set({ tint = tint, variant = variant })
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
			nominal_width = 5,
			nominal_height = 5,
		},
	}

	return definition
end

local icons = IconCatalog:create({ folder = "__reskins-assets-angels__/graphics/icons" })

---Gets the icon for Angel's crop farm of the `variant` and in the tints given by `params`.
M.get_icon = IconCatalog.dispatch("variant", { "basic", "temperate", "desert", "swamp" }, "get_icon", function(key)
	-- The basic farm's artwork is filed under the bare field name.
	return icons:tinted(key == "basic" and "field" or "field-" .. key)
end)

return M
