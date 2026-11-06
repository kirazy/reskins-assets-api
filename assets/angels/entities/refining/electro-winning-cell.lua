---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local IconBuilderFactory = require("api.icon-builder-factory")
local AssemblingMachine1Explosion = require("assets.base.explosions.assembling-machine-1")

local ASSETS_ANGELS_PATH = "__reskins-assets-angels__/graphics/entity/electro-winning-cell/"

local M = {}

---Gets the animation of Angel's electro-winning cell.
---@param tint? Color
---@return Animation
local function get_animation(tint)
	local layers = {
		{
			-- cspell: disable-next-line
			filename = "__angelsrefininggraphics__/graphics/entity/electro-whinning-cell/electro-whinning-cell.png",
			priority = "extra-high",
			width = 224,
			height = 224,
			frame_count = 36,
			line_length = 6,
			shift = { 0, 0 },
			animation_speed = 0.5,
		},
	}

	if tint then
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "electro-winning-cell-mask.png",
			priority = "extra-high",
			width = 224,
			height = 224,
			repeat_count = 36,
			shift = { 0, 0 },
			animation_speed = 0.5,
			tint = tint,
		}
		layers[#layers + 1] = {
			filename = ASSETS_ANGELS_PATH .. "electro-winning-cell-highlights.png",
			priority = "extra-high",
			width = 224,
			height = 224,
			repeat_count = 36,
			shift = { 0, 0 },
			animation_speed = 0.5,
			blend_mode = "additive",
		}
	end

	return { layers = layers }
end

---Gets the graphics for the fluid boxes of Angel's electro-winning cell.
---@return FluidBoxGraphics
local function get_fluid_box_graphics()
	-- The ore-floatation-cell picture set is used only for the electro-winning-cell entity.
	return {
		pipe_picture = {
			north = {
				filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/pipe-north.png",
				priority = "extra-high",
				width = 48,
				height = 48,
				shift = { 0.01, 0.95 },
			},
			east = {
				filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/pipe-east.png",
				priority = "extra-high",
				width = 40,
				height = 45,
				shift = { -0.71875, 0.1 },
			},
			south = {
				filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/pipe-south.png",
				priority = "extra-high",
				width = 34,
				height = 39,
				shift = { 0, -0.75 },
			},
			west = {
				filename = "__angelsrefininggraphics__/graphics/entity/ore-floatation-cell/pipe-west.png",
				priority = "extra-high",
				width = 40,
				height = 45,
				shift = { 0.78125, 0.01 },
			},
		},
	}
end

---Defines the options for the Angel's electro-winning cell sprite set.
---@class ElectroWinningCellSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("ElectroWinningCellSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for Angel's electro-winning cell.
---@param params ElectroWinningCellSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's electro-winning cell.
---
---#### Examples
---```lua
---local electro_winning_cell = require("__reskins-assets-api__.assets.angels.entities.refining.electro-winning-cell")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = electro_winning_cell.get_sprite_set({ tint = tint })
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
			graphics_set = { animation = get_animation(params.tint) },
			fluid_boxes = { get_fluid_box_graphics() },
			use_mirroring = true,
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = AssemblingMachine1Explosion.get_explosion({
				tints = params.tint and {
					["assembling-machine-1-metal-particle-big"] = params.tint,
					["assembling-machine-1-metal-particle-medium"] = params.tint,
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

local icon_builder = icons:tinted("electro-winning-cell")

---Gets the icon for Angel's electro-winning cell, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the icon for Angel's electro-winning cell as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
