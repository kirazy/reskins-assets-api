---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local _belts = require("assets.base.entities.transport-belt")

local _sprites = require("__reskins-sprite-utils__.sprites")

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
---@field tint Color?
---@field belt_sprite BeltSprites

---Produces the sprite set for the vanilla underground belt.
---@param params UndergroundBeltSpriteSetParams
---@return SpriteSetDefinition<TransportBeltSpriteSet>
---@nodiscard
function M.get(params)
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

return M
