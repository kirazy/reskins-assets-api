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
---@return Animation4Way
local function get_structure(tint)
	local assets_path = "__reskins-assets-base__/graphics/entity/splitter/"

	---@param direction_name string
	---@param width integer
	---@param height integer
	---@param shift Vector
	---@return Animation
	local function make_direction(direction_name, width, height, shift)
		local layers = {
			{
				filename = assets_path .. "splitter-" .. direction_name .. "-base.png",
				priority = "extra-high",
				width = width,
				height = height,
				frame_count = 32,
				line_length = 8,
				shift = shift,
				scale = 0.5,
			},
		}

		if tint then
			table.insert(layers, {
				filename = assets_path .. "splitter-" .. direction_name .. "-mask.png",
				priority = "extra-high",
				width = width,
				height = height,
				frame_count = 32,
				line_length = 8,
				shift = shift,
				tint = tint,
				scale = 0.5,
			})
			table.insert(layers, {
				filename = assets_path .. "splitter-" .. direction_name .. "-highlights.png",
				priority = "extra-high",
				width = width,
				height = height,
				frame_count = 32,
				line_length = 8,
				shift = shift,
				blend_mode = "additive-soft",
				scale = 0.5,
			})
		end

		return { layers = layers }
	end

	---@type Animation4Way
	return {
		north = make_direction("north", 160, 70, util.by_pixel(7, 0)),
		east = make_direction("east", 90, 84, util.by_pixel(4, 13)),
		south = make_direction("south", 164, 64, util.by_pixel(4, 0)),
		west = make_direction("west", 94, 86, util.by_pixel(5, 12)),
	}
end

---@param tint Color?
---@return Animation4Way
local function get_structure_patch(tint)
	local assets_path = "__reskins-assets-base__/graphics/entity/splitter/"

	---@param direction_name string
	---@param width integer
	---@param height integer
	---@param shift Vector
	---@return Animation
	local function make_patch_direction(direction_name, width, height, shift)
		local layers = {
			{
				filename = assets_path .. "splitter-" .. direction_name .. "-top_patch-base.png",
				priority = "extra-high",
				width = width,
				height = height,
				frame_count = 32,
				line_length = 8,
				shift = shift,
				scale = 0.5,
			},
		}

		if tint then
			table.insert(layers, {
				filename = assets_path .. "splitter-" .. direction_name .. "-top_patch-mask.png",
				priority = "extra-high",
				width = width,
				height = height,
				frame_count = 32,
				line_length = 8,
				shift = shift,
				tint = tint,
				scale = 0.5,
			})
			table.insert(layers, {
				filename = assets_path .. "splitter-" .. direction_name .. "-top_patch-highlights.png",
				priority = "extra-high",
				width = width,
				height = height,
				frame_count = 32,
				line_length = 8,
				shift = shift,
				blend_mode = "additive-soft",
				scale = 0.5,
			})
		end

		return { layers = layers }
	end

	---@type Animation4Way
	return {
		north = util.empty_sprite(),
		east = make_patch_direction("east", 90, 104, util.by_pixel(4, -20)),
		south = util.empty_sprite(),
		west = make_patch_direction("west", 94, 96, util.by_pixel(5, -18)),
	}
end

---@param tint Color?
---@return RotatedAnimationVariations
local function get_corpse_animation(tint)
	local assets_path = "__reskins-assets-base__/graphics/entity/splitter/"

	local layers = {
		{
			filename = assets_path .. "remnants/splitter-remnants-base.png",
			width = 190,
			height = 190,
			direction_count = 4,
			shift = util.by_pixel(3.5, 1.5),
			scale = 0.5,
		},
	}

	if tint then
		table.insert(layers, {
			filename = assets_path .. "remnants/splitter-remnants-mask.png",
			width = 190,
			height = 190,
			direction_count = 4,
			shift = util.by_pixel(3.5, 1.5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(layers, {
			filename = assets_path .. "remnants/splitter-remnants-highlights.png",
			width = 190,
			height = 190,
			direction_count = 4,
			shift = util.by_pixel(3.5, 1.5),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return _sprites.make_rotated_animation_variations_from_spritesheet(1, { layers = layers })
end

---@class SplitterSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?
---The belt artwork to draw.
---@field belt_sprite BeltSprites

---Gets the sprite set for the vanilla splitter.
---@param params SplitterSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<TransportBeltSpriteSet>
---
---#### Examples
---```lua
---local splitter = require("__reskins-assets-api__.assets.base.entities.splitter")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = splitter.get_sprite_set({ tint = tint, belt_sprite = belt_sprite })
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
			structure_patch = get_structure_patch(params.tint),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = { animation = get_corpse_animation(params.tint) },
			water_reflection = nil,
			nominal_width = 1.8,
			nominal_height = 1,
		},
	}

	return definition
end

local check_get_icon = V.signature("get_icon", {
	{ "tint", Common.color:optional() },
})

---Gets the icon for the vanilla splitter, in the given `tint`.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(tint)
	check_get_icon(tint)

	local folder = "__reskins-assets-base__/graphics/icons/splitter/splitter-icon-"

	---@type SafeIconData[]
	local icon = { { icon = folder .. "base.png", icon_size = 64, scale = 0.5 } }

	if tint then
		table.insert(icon, { icon = folder .. "mask.png", icon_size = 64, scale = 0.5, tint = tint })
		table.insert(icon, { icon = folder .. "highlights.png", icon_size = 64, scale = 0.5, tint = { 1, 1, 1, 0 } })
	end

	return icon
end

return M
