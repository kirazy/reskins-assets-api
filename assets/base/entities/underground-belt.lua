---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local _belts = require("assets.base.entities.transport-belt")

local _sprites = require("__reskins-sprite-utils__.sprites")

local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")

local M = {}

---@param tint Color?
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
				blend_mode = "additive-soft",
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
	}
end

---@param tint Color?
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
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return _sprites.make_rotated_animation_variations_from_spritesheet(1, { layers = layers })
end

---@class UndergroundBeltSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set rather than drawn
---untinted.
---@field tint Color?
---The belt artwork to draw.
---@field belt_sprite BeltSprites

---Gets the sprite set for the vanilla underground belt.
---@param params UndergroundBeltSpriteSetParams # The options the sprite set is drawn with.
---@return SpriteSetDefinition<TransportBeltSpriteSet>
---
---### Examples
---```lua
---local underground_belt = require("__reskins-assets-api__.assets.base.entities.underground-belt")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = underground_belt.get_sprite_set({ tint = tint, belt_sprite = belt_sprite })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set(params)
	---@type SpriteSetDefinition<TransportBeltSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.transport_belt_sprite_set,
		set = {
			belt_animation_set = _belts.get_belt_animation_set(params.tint, params.belt_sprite),
			structure = get_structure(params.tint),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = { animation = get_corpse_animation(params.tint) },
			water_reflection = nil,
			nominal_width = 1,
			nominal_height = 1,
		},
	}

	return definition
end

local check_get_icon = V.signature("get_icon", {
	{ "tint", Common.color:optional() },
})

---Gets the icon for the vanilla underground belt, in the given `tint`.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(tint)
	check_get_icon(tint)

	local folder = "__reskins-assets-base__/graphics/icons/underground-belt/underground-belt-icon-"

	---@type SafeIconData[]
	local icon = { { icon = folder .. "base.png", icon_size = 64, scale = 0.5 } }

	if tint then
		table.insert(icon, { icon = folder .. "mask.png", icon_size = 64, scale = 0.5, tint = tint })
		table.insert(icon, { icon = folder .. "highlights.png", icon_size = 64, scale = 0.5, tint = { 1, 1, 1, 0 } })
	end

	return icon
end

return M
