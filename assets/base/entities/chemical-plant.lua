---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local _sprites = require("__reskins-sprite-utils__.sprites")
local IconCatalog = require("api.icon-catalog")

local M = {}

---Returns the standard vanilla working visualisations for the chemical plant.
---
---All entries reference `__base__` paths and are passed through verbatim — no tint is applied.
---@return WorkingVisualisation[]
---@private
local function get_working_visualisations()
	return {
		{
			apply_recipe_tint = "primary",
			north_animation = {
				filename = "__base__/graphics/entity/chemical-plant/chemical-plant-liquid-north.png",
				frame_count = 24,
				line_length = 6,
				width = 66,
				height = 44,
				shift = util.by_pixel(23, 15),
				scale = 0.5,
			},
			east_animation = {
				filename = "__base__/graphics/entity/chemical-plant/chemical-plant-liquid-east.png",
				frame_count = 24,
				line_length = 6,
				width = 70,
				height = 36,
				shift = util.by_pixel(0, 22),
				scale = 0.5,
			},
			south_animation = {
				filename = "__base__/graphics/entity/chemical-plant/chemical-plant-liquid-south.png",
				frame_count = 24,
				line_length = 6,
				width = 66,
				height = 42,
				shift = util.by_pixel(0, 17),
				scale = 0.5,
			},
			west_animation = {
				filename = "__base__/graphics/entity/chemical-plant/chemical-plant-liquid-west.png",
				frame_count = 24,
				line_length = 6,
				width = 74,
				height = 36,
				shift = util.by_pixel(-10, 13),
				scale = 0.5,
			},
		},
		{
			apply_recipe_tint = "secondary",
			north_animation = {
				filename = "__base__/graphics/entity/chemical-plant/chemical-plant-foam-north.png",
				frame_count = 24,
				line_length = 6,
				width = 62,
				height = 42,
				shift = util.by_pixel(24, 15),
				scale = 0.5,
			},
			east_animation = {
				filename = "__base__/graphics/entity/chemical-plant/chemical-plant-foam-east.png",
				frame_count = 24,
				line_length = 6,
				width = 68,
				height = 36,
				shift = util.by_pixel(0, 22),
				scale = 0.5,
			},
			south_animation = {
				filename = "__base__/graphics/entity/chemical-plant/chemical-plant-foam-south.png",
				frame_count = 24,
				line_length = 6,
				width = 60,
				height = 40,
				shift = util.by_pixel(1, 17),
				scale = 0.5,
			},
			west_animation = {
				filename = "__base__/graphics/entity/chemical-plant/chemical-plant-foam-west.png",
				frame_count = 24,
				line_length = 6,
				width = 68,
				height = 28,
				shift = util.by_pixel(-9, 15),
				scale = 0.5,
			},
		},
		{
			apply_recipe_tint = "tertiary",
			fadeout = true,
			constant_speed = true,
			north_position = util.by_pixel_hr(-30, -161),
			east_position = util.by_pixel_hr(29, -150),
			south_position = util.by_pixel_hr(12, -134),
			west_position = util.by_pixel_hr(-32, -130),
			render_layer = "wires",
			animation = {
				filename = "__base__/graphics/entity/chemical-plant/chemical-plant-smoke-outer.png",
				frame_count = 47,
				line_length = 16,
				width = 90,
				height = 188,
				animation_speed = 0.5,
				shift = util.by_pixel(-2, -40),
				scale = 0.5,
			},
		},
		{
			apply_recipe_tint = "quaternary",
			fadeout = true,
			constant_speed = true,
			north_position = util.by_pixel_hr(-30, -161),
			east_position = util.by_pixel_hr(29, -150),
			south_position = util.by_pixel_hr(12, -134),
			west_position = util.by_pixel_hr(-32, -130),
			render_layer = "wires",
			animation = {
				filename = "__base__/graphics/entity/chemical-plant/chemical-plant-smoke-inner.png",
				frame_count = 47,
				line_length = 16,
				width = 40,
				height = 84,
				animation_speed = 0.5,
				shift = util.by_pixel(0, -14),
				scale = 0.5,
			},
		},
	}
end

---@param tint Color?
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint)
	local assets_path = _defines.assets_source.base_assets .. "/graphics/entity/chemical-plant/"

	---@type Animation[]
	local layers = {
		-- Base
		{
			filename = assets_path .. "chemical-plant-base.png",
			priority = "high",
			width = 220,
			height = 292,
			frame_count = 24,
			line_length = 12,
			shift = util.by_pixel(0.5, -9),
			scale = 0.5,
		},
	}

	if tint then
		table.insert(layers, {
			filename = assets_path .. "chemical-plant-mask.png",
			priority = "high",
			width = 220,
			height = 292,
			frame_count = 24,
			line_length = 12,
			shift = util.by_pixel(0.5, -9),
			tint = tint,
			scale = 0.5,
		})
		table.insert(layers, {
			filename = assets_path .. "chemical-plant-highlights.png",
			priority = "high",
			width = 220,
			height = 292,
			frame_count = 24,
			line_length = 12,
			shift = util.by_pixel(0.5, -9),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	-- Shadow
	table.insert(layers, {
		filename = "__base__/graphics/entity/chemical-plant/chemical-plant-shadow.png",
		width = 312,
		height = 222,
		repeat_count = 24,
		shift = util.by_pixel(27, 6),
		draw_as_shadow = true,
		scale = 0.5,
	})

	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = _sprites.make_4way_animation_from_spritesheet({ layers = layers }) --[[@as Animation4Way]],
		working_visualisations = get_working_visualisations(),
	}

	return graphics_set
end
---@param tint Color?
---@return RotatedAnimationVariations
local function get_corpse_animation(tint)
	local assets_path = _defines.assets_source.base_assets .. "/graphics/entity/chemical-plant/remnants/"

	---@type RotatedAnimationVariations
	local animation = {
		layers = {
			{
				filename = assets_path .. "chemical-plant-remnants-base.png",
				width = 446,
				height = 342,
				direction_count = 1,
				shift = util.by_pixel(16, -5.5),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "chemical-plant-remnants-mask.png",
			width = 446,
			height = 342,
			direction_count = 1,
			shift = util.by_pixel(16, -5.5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "chemical-plant-remnants-highlights.png",
			width = 446,
			height = 342,
			direction_count = 1,
			shift = util.by_pixel(16, -5.5),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return animation
end

---@class ChemicalPlantSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?

---Gets the sprite set for the vanilla chemical plant.
---@param params ChemicalPlantSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---
---#### Examples
---```lua
---local chemical_plant = require("__reskins-assets-api__.assets.base.entities.chemical-plant")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = chemical_plant.get_sprite_set({ tint = tint })
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
			corpse = { animation = get_corpse_animation(params.tint) },
			water_reflection = nil,
			nominal_width = 3,
			nominal_height = 3,
		},
	}

	return definition
end

local icons = IconCatalog:create({ folder = "__reskins-assets-base__/graphics/icons" })

---Gets the icon for the vanilla chemical plant, in the tints given by `params`.
M.get_icon = icons:tinted("chemical-plant"):build("get_icon")

return M
