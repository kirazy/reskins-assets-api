---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local IconBuilderFactory = require("api.icon-builder-factory")
local OilRefineryExplosion = require("assets.base.explosions.oil-refinery")

local SMELTING_GRAPHICS_PATH = "__angelssmeltinggraphics__/graphics/entity/sintering-oven/"
local ASSETS_ANGELS_PATH = "__reskins-assets-angels__/graphics/entity/sintering-oven/"

local M = {}

---Gets the animation of Angel's sintering oven.
---@param tint? Color
---@return Animation
local function get_animation(tint)
	local layers = {
		{
			filename = SMELTING_GRAPHICS_PATH .. "sintering-oven-base.png",
			priority = "extra-high",
			width = 326,
			height = 350,
			shift = util.by_pixel(-1, -6.5),
			scale = 0.5,
		},
		{
			filename = SMELTING_GRAPHICS_PATH .. "sintering-oven-shadow.png",
			priority = "extra-high",
			width = 424,
			height = 227,
			shift = util.by_pixel(23, 28),
			draw_as_shadow = true,
			scale = 0.5,
		},
	}

	if tint then
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "sintering-oven-mask.png",
			priority = "extra-high",
			width = 326,
			height = 350,
			shift = util.by_pixel(-1, -6.5),
			tint = tint,
			scale = 0.5,
		}
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "sintering-oven-highlights.png",
			priority = "extra-high",
			width = 326,
			height = 350,
			shift = util.by_pixel(-1, -6.5),
			blend_mode = "additive",
			scale = 0.5,
		}
	end

	return { layers = layers }
end

---Gets the working visualisations of Angel's sintering oven.
---@return WorkingVisualisation[]
local function get_working_visualisations()
	return {
		{
			fadeout = true,
			effect = "uranium-glow",
			animation = {
				filename = SMELTING_GRAPHICS_PATH .. "sintering-oven-glow.png",
				priority = "high",
				width = 326,
				height = 350,
				blend_mode = "additive",
				shift = util.by_pixel(-1, -6.5),
				draw_as_glow = true,
				scale = 0.5,
			},
		},
		{
			fadeout = true,
			effect = "uranium-glow",
			animation = {
				filename = SMELTING_GRAPHICS_PATH .. "sintering-oven-light.png",
				priority = "high",
				width = 326,
				height = 350,
				shift = util.by_pixel(-1, -6.5),
				draw_as_light = true,
				scale = 0.5,
			},
		},
	}
end

---Defines the options for the Angel's sintering oven sprite set.
---@class SinteringOvenSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("SinteringOvenSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for Angel's sintering oven.
---@param params SinteringOvenSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's sintering oven.
---
---#### Examples
---```lua
---local sintering_oven = require("__reskins-assets-api__.assets.angels.entities.smelting.sintering-oven")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = sintering_oven.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@throws When `params` defines an unrecognized field.
---@throws When `params.tint` is not a `Color`.
---@nodiscard
function M.get_sprite_set(params)
	check_get_sprite_set(params)

	---@type SpriteSetDefinition<CraftingMachineSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.crafting_machine_sprite_set,
		set = {
			graphics_set = {
				animation = get_animation(params.tint),
				working_visualisations = get_working_visualisations(),
			},
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = OilRefineryExplosion.get_explosion({
				tints = params.tint and {
					["oil-refinery-metal-particle-big-tint"] = params.tint,
					["oil-refinery-metal-particle-medium"] = params.tint,
				},
			}),
			corpse = _defines.generic_remnants,
			water_reflection = nil,
			nominal_width = 5,
			nominal_height = 5,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-angels__/graphics/icons" })

local icon_builder = icons:tinted("sintering-oven")

---Gets the icon for Angel's sintering oven, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the icon for Angel's sintering oven as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
