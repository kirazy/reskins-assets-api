---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local _belts = require("assets.base.entities.transport-belt")

local _sprites = require("__reskins-sprite-utils__.sprites")
local IconBuilderFactory = require("api.icon-builder-factory")
local UndergroundBeltExplosion = require("assets.base.explosions.underground-belt")
local Remnants = require("assets.base.remnants")

local M = {}

---Gets one frozen patch of the underground belt structure, from the row of the sheet at the given `y`, or `nil` when
---the freezing feature is not active.
---@param y integer
---@return Sprite4Way?
local function get_frozen_patch(y)
	if not (feature_flags["freezing"] and mods["space-age"]) then
		return nil
	end

	return {
		sheet = {
			filename = "__space-age__/graphics/entity/frozen/underground-belt/underground-belt-structure.png",
			priority = "extra-high",
			width = 192,
			height = 192,
			y = y,
			scale = 0.5,
		},
	}
end

---@param tint? Color
---@return table
local function get_structure(tint)
	local assets_path = "__reskins-assets-base__/graphics/entity/underground-belt/"

	-- Builds one direction entry. The base layer uses no -base suffix: underground-belt-structure.png.
	-- y_offset selects the row in the spritesheet (each row is 192px tall).
	---@param y_offset integer
	---@return table
	local function make_direction(y_offset)
		local sheets = {
			{
				filename = assets_path .. "underground-belt-structure.png",
				priority = "extra-high",
				width = 192,
				height = 192,
				y = y_offset,
				scale = 0.5,
			},
		}

		if tint then
			table.insert(sheets, {
				filename = assets_path .. "underground-belt-structure-mask.png",
				priority = "extra-high",
				width = 192,
				height = 192,
				y = y_offset,
				tint = tint,
				scale = 0.5,
			})
			table.insert(sheets, {
				filename = assets_path .. "underground-belt-structure-highlights.png",
				priority = "extra-high",
				width = 192,
				height = 192,
				y = y_offset,
				blend_mode = "additive",
				scale = 0.5,
			})
		end

		return { sheets = sheets }
	end

	return {
		direction_out = make_direction(0),
		direction_in = make_direction(192),
		direction_out_side_loading = make_direction(384),
		direction_in_side_loading = make_direction(576),
		back_patch = {
			sheet = {
				filename = "__base__/graphics/entity/express-underground-belt/express-underground-belt-structure-back-patch.png",
				priority = "extra-high",
				width = 192,
				height = 192,
				scale = 0.5,
			},
		},
		front_patch = {
			sheet = {
				filename = "__base__/graphics/entity/express-underground-belt/express-underground-belt-structure-front-patch.png",
				priority = "extra-high",
				width = 192,
				height = 192,
				scale = 0.5,
			},
		},
		frozen_patch_in = get_frozen_patch(192),
		frozen_patch_out = get_frozen_patch(0),
	}
end

---@param tint? Color
---@return RotatedAnimationVariations
local function get_corpse_animation(tint)
	local assets_path = "__reskins-assets-base__/graphics/entity/underground-belt/"

	local layers = {
		{
			filename = assets_path .. "remnants/underground-belt-remnants-base.png",
			width = 156,
			height = 144,
			direction_count = 8,
			shift = util.by_pixel(10.5, 3),
			scale = 0.5,
		},
	}

	if tint then
		table.insert(layers, {
			filename = assets_path .. "remnants/underground-belt-remnants-mask.png",
			width = 156,
			height = 144,
			direction_count = 8,
			shift = util.by_pixel(10.5, 3),
			tint = tint,
			scale = 0.5,
		})
		table.insert(layers, {
			filename = assets_path .. "remnants/underground-belt-remnants-highlights.png",
			width = 156,
			height = 144,
			direction_count = 8,
			shift = util.by_pixel(10.5, 3),
			blend_mode = "additive",
			scale = 0.5,
		})
	end

	return _sprites.make_rotated_animation_variations_from_spritesheet(1, { layers = layers })
end

---Defines the options for the vanilla underground belt sprite set.
---@class UndergroundBeltSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color
---The belt artwork to use.
---@field belt_sprite BeltSprites

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("UndergroundBeltSpriteSetParams", {
			tint = Common.color:optional(),
			belt_sprite = V.one_of(_defines.belt_sprites),
		}):strict(),
	},
})

---Gets the sprite set for the vanilla underground belt.
---@param params UndergroundBeltSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<UndergroundBeltSpriteSet> # The sprite set definition for the vanilla underground belt.
---
---#### Examples
---```lua
---local underground_belt = require("__reskins-assets-api__.assets.base.entities.underground-belt")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = underground_belt.get_sprite_set({ tint = tint, belt_sprite = belt_sprite })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@throws When `params` defines an unrecognized field.
---@throws When `params.tint` is not a `Color`.
---@throws When `params.belt_sprite` is not a `BeltSprites`.
---@nodiscard
function M.get_sprite_set(params)
	check_get_sprite_set(params)

	---@type SpriteSetDefinition<UndergroundBeltSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.underground_belt_sprite_set,
		set = {
			belt_animation_set = _belts.get_belt_animation_set(params.tint, params.belt_sprite),
			structure = get_structure(params.tint),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = UndergroundBeltExplosion.get_explosion({
				tints = params.tint and {
					["underground-belt-metal-particle-small"] = params.tint,
					["underground-belt-metal-particle-medium-yellow"] = params.tint,
				},
			}),
			corpse = Remnants.get_corpse("underground-belt-remnants", { animation = get_corpse_animation(params.tint) }),
			water_reflection = nil,
			nominal_width = 1,
			nominal_height = 1,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-base__/graphics/icons" })

local icon_builder = icons:tinted("underground-belt")

---Gets the icon for the vanilla underground belt, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the icon for the vanilla underground belt as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
