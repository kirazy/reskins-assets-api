---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")

local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")

local _sprites = require("__reskins-sprite-utils__.sprites")

local M = {}

-- The horsehead is drawn the same whether the base beneath it is flipped or not.
---@param params PumpjackSpriteSetParams
---@return Animation[]
---@nodiscard
local function get_horsehead_layers(params)
	local folder = "__reskins-assets-base__/graphics/entity/pumpjack/"
	local animation_speed = params.animation_speed or 0.5

	-- Without a body color to paint, the horsehead falls back to the artwork that carries its own.
	local body = params.base_tint and "pumpjack-tintable-horsehead.png" or "pumpjack-horsehead.png"

	---@type Animation[]
	local layers = {
		{
			filename = folder .. body,
			priority = "high",
			animation_speed = animation_speed,
			scale = 0.5,
			line_length = 8,
			width = 206,
			height = 172,
			frame_count = 40,
			shift = util.by_pixel(-4.5, -29),
		},
	}

	if params.base_tint then
		table.insert(layers, {
			filename = folder .. "pumpjack-tintable-horsehead-mask.png",
			priority = "high",
			animation_speed = animation_speed,
			scale = 0.5,
			line_length = 8,
			width = 206,
			height = 172,
			frame_count = 40,
			tint = params.base_tint,
			shift = util.by_pixel(-4.5, -29),
		})
		table.insert(layers, {
			filename = folder .. "pumpjack-tintable-horsehead-highlights.png",
			priority = "high",
			animation_speed = animation_speed,
			scale = 0.5,
			line_length = 8,
			width = 206,
			height = 172,
			frame_count = 40,
			blend_mode = "additive-soft",
			shift = util.by_pixel(-4.5, -29),
		})
	end

	if params.tint then
		table.insert(layers, {
			filename = folder .. "pumpjack-horsehead-stripe-mask.png",
			priority = "high",
			animation_speed = animation_speed,
			scale = 0.5,
			line_length = 8,
			width = 206,
			height = 172,
			frame_count = 40,
			tint = params.tint,
			shift = util.by_pixel(-4.5, -29),
		})
		table.insert(layers, {
			filename = folder .. "pumpjack-horsehead-stripe-highlights.png",
			priority = "high",
			animation_speed = animation_speed,
			scale = 0.5,
			line_length = 8,
			width = 206,
			height = 172,
			frame_count = 40,
			blend_mode = "additive-soft",
			shift = util.by_pixel(-4.5, -29),
		})
	end

	if params.accent_tint then
		table.insert(layers, {
			filename = folder .. "pumpjack-horsehead-accent-mask.png",
			priority = "high",
			animation_speed = animation_speed,
			scale = 0.5,
			line_length = 8,
			width = 206,
			height = 172,
			frame_count = 40,
			tint = params.accent_tint,
			shift = util.by_pixel(-4.5, -29),
		})
		table.insert(layers, {
			filename = folder .. "pumpjack-horsehead-accent-highlights.png",
			priority = "high",
			animation_speed = animation_speed,
			scale = 0.5,
			line_length = 8,
			width = 206,
			height = 172,
			frame_count = 40,
			blend_mode = "additive-soft",
			shift = util.by_pixel(-4.5, -29),
		})
	end

	-- Shadows are always appended last.
	table.insert(layers, {
		filename = folder .. "pumpjack-horsehead-shadow.png",
		priority = "high",
		animation_speed = animation_speed,
		draw_as_shadow = true,
		scale = 0.5,
		line_length = 8,
		width = 292,
		height = 78,
		frame_count = 40,
		shift = util.by_pixel(17.75, 14.5),
	})

	return layers
end

---@param params PumpjackSpriteSetParams
---@param is_flipped boolean When `true`, draws the base the pumpjack presents when mirrored.
---@return Animation[]
---@nodiscard
local function get_base_layers(params, is_flipped)
	local folder = "__reskins-assets-base__/graphics/entity/pumpjack/"
	local flipped = is_flipped and "-flipped" or ""

	-- Without a body color to paint, the base falls back to the artwork that carries its own.
	local body = params.base_tint and "pumpjack-tintable-base" or "pumpjack-base"

	---@type Animation[]
	local layers = {
		{
			filename = folder .. body .. flipped .. ".png",
			priority = "extra-high",
			width = 261,
			height = 273,
			shift = util.by_pixel(-2.25, -4.75),
			scale = 0.5,
		},
	}

	if params.base_tint then
		table.insert(layers, {
			filename = folder .. "pumpjack-tintable-base-mask" .. flipped .. ".png",
			priority = "extra-high",
			width = 261,
			height = 273,
			tint = params.base_tint,
			shift = util.by_pixel(-2.25, -4.75),
			scale = 0.5,
		})
		table.insert(layers, {
			filename = folder .. "pumpjack-tintable-base-highlights" .. flipped .. ".png",
			priority = "extra-high",
			width = 261,
			height = 273,
			blend_mode = "additive-soft",
			shift = util.by_pixel(-2.25, -4.75),
			scale = 0.5,
		})
	end

	if params.accent_tint then
		table.insert(layers, {
			filename = folder .. "pumpjack-base-accent-mask" .. flipped .. ".png",
			priority = "extra-high",
			width = 261,
			height = 273,
			tint = params.accent_tint,
			shift = util.by_pixel(-2.25, -4.75),
			scale = 0.5,
		})
		table.insert(layers, {
			filename = folder .. "pumpjack-base-accent-highlights" .. flipped .. ".png",
			priority = "extra-high",
			width = 261,
			height = 273,
			blend_mode = "additive-soft",
			shift = util.by_pixel(-2.25, -4.75),
			scale = 0.5,
		})
	end

	-- Shadows are always appended last.
	table.insert(layers, {
		filename = folder .. "pumpjack-base" .. flipped .. "-shadow.png",
		width = 261,
		height = 273,
		draw_as_shadow = true,
		shift = util.by_pixel(-2, -5),
		scale = 0.5,
	})

	return layers
end

---@param params PumpjackSpriteSetParams
---@param is_flipped boolean When `true`, draws the base the pumpjack presents when mirrored.
---@return MiningDrillGraphicsSet
---@nodiscard
local function get_graphics_set(params, is_flipped)
	---@type MiningDrillGraphicsSet
	local graphics_set = {
		animation = { north = { layers = get_horsehead_layers(params) } },
		working_visualisations = {
			_sprites.make_4way_working_visualisations_from_spritesheet({
				always_draw = true,
				secondary_draw_order = -1,
				animation = { layers = get_base_layers(params, is_flipped) },
			}),
		},
	}

	return graphics_set
end

local function translate_graphics_set_to_legacy(params)
	local standard = get_graphics_set(params, false)
	local flipped = get_graphics_set(params, true)

	---@type MiningDrillGraphicsSet
	local graphics_set = {
		animation = standard.animation,
		working_visualisations = {
			{
				always_draw = true,
				secondary_draw_order = -1,
				---@diagnostic disable-next-line: need-check-nil
				north_animation = standard.working_visualisations[1].north_animation,
				---@diagnostic disable-next-line: need-check-nil
				east_animation = flipped.working_visualisations[1].east_animation,
				---@diagnostic disable-next-line: need-check-nil
				south_animation = standard.working_visualisations[1].south_animation,
				---@diagnostic disable-next-line: need-check-nil
				west_animation = flipped.working_visualisations[1].west_animation,
			},
		},
	}

	return graphics_set
end

-- The remnants take one tint where the entity takes three; no artwork is drawn for the body and
-- accent colors yet.
---@param base_layer FileName The file the remnants' base layer is drawn from.
---@param tint Color? The color to tint the mask.
---@return RotatedAnimationVariations
---@nodiscard
local function get_corpse_animation(base_layer, tint)
	local remnants_folder = "__reskins-assets-base__/graphics/entity/pumpjack/remnants/"

	---@type RotatedAnimation
	local animation = {
		layers = {
			{
				filename = base_layer,
				width = 274,
				height = 284,
				direction_count = 1,
				shift = util.by_pixel(0, 3.5),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = remnants_folder .. "pumpjack-remnants-mask.png",
			width = 274,
			height = 284,
			direction_count = 1,
			shift = util.by_pixel(0, 3.5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = remnants_folder .. "pumpjack-remnants-highlights.png",
			width = 274,
			height = 284,
			direction_count = 1,
			shift = util.by_pixel(0, 3.5),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return _sprites.make_rotated_animation_variations_from_spritesheet(2, animation)
end

---@class PumpjackSpriteSetParams
---The color to tint the stripe running the length of the horsehead, and the remnants. When `nil`, the
---tintable layers are omitted from the set.
---@field tint Color?
---The color to tint the pumpjack's body. When `nil`, the pumpjack is drawn in the base game's own colors
---instead.
---@field base_tint Color?
---The color to tint the pumpjack's accents. When `nil`, the tintable layers are omitted from the set rather
---than drawn untinted.
---@field accent_tint Color?
---The speed the horsehead rocks at. Defaults to `0.5`.
---@field animation_speed double?

local params_shape = V.shape({
	tint = Common.color:optional(),
	base_tint = Common.color:optional(),
	accent_tint = Common.color:optional(),
	animation_speed = Common.positive_number:optional(),
})

---@param params PumpjackSpriteSetParams
---@param corpse_base_layer FileName The file the remnants' base layer is drawn from.
---@return SpriteSetDefinition<MiningDrillSpriteSet>
---@nodiscard
local function get_definition(params, corpse_base_layer)
	---@type SpriteSetDefinition<MiningDrillSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.mining_drill_sprite_set,
		set = {
			wet_mining_graphics_set = nil,
			wet_mining_graphics_set_flipped = nil,
			radius_visualisation_picture = {
				filename = "__base__/graphics/entity/pumpjack/pumpjack-radius-visualization.png",
				width = 12,
				height = 12,
			},
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = { animation = get_corpse_animation(corpse_base_layer, params.tint) },
			water_reflection = nil,
			nominal_width = 3,
			nominal_height = 3,
		},
	}

	if helpers.compare_versions(mods["base"], "2.1.0") >= 0 then
		definition.set.graphics_set = get_graphics_set(params, false)
		definition.set.graphics_set_flipped = get_graphics_set(params, true)
	else
		definition.set.graphics_set = translate_graphics_set_to_legacy(params)
	end

	return definition
end

local check_get_sprite_set = V.signature("get_sprite_set", {
	{ "params", params_shape },
})

---Gets the sprite set for the vanilla pumpjack.
---@param params PumpjackSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<MiningDrillSpriteSet>
---
---#### Examples
---```lua
---local pumpjack = require("__reskins-assets-api__.assets.base.entities.pumpjack")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = pumpjack.get_sprite_set({ tint = tint, base_tint = base_tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set(params)
	check_get_sprite_set(params)

	return get_definition(params, "__base__/graphics/entity/pumpjack/remnants/pumpjack-remnants.png")
end

local check_get_water_sprite_set = V.signature("get_water_sprite_set", {
	{ "params", params_shape },
})

---Gets the sprite set for a water pumpjack.
---@param params PumpjackSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<MiningDrillSpriteSet>
---
---#### Examples
---```lua
---local pumpjack = require("__reskins-assets-api__.assets.base.entities.pumpjack")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = pumpjack.get_water_sprite_set({ tint = tint, base_tint = water_tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_water_sprite_set(params)
	check_get_water_sprite_set(params)

	return get_definition(
		params,
		"__reskins-assets-bobs__/graphics/entity/pumpjack-water/remnants/pumpjack-water-remnants-base.png"
	)
end

---@param prefix string The path the layers are filed under, up to the `-base`/`-mask`/`-highlights` suffix.
---@param tint Color? The color to tint the mask.
---@return SafeIconData[]
---@nodiscard
local function get_tinted_layers(prefix, tint)
	local layers = { { icon = prefix .. "base.png", icon_size = 64, scale = 0.5 } }

	if tint then
		table.insert(layers, { icon = prefix .. "mask.png", icon_size = 64, scale = 0.5, tint = tint })
		table.insert(layers, { icon = prefix .. "highlights.png", icon_size = 64, scale = 0.5, tint = { 1, 1, 1, 0 } })
	end

	return layers
end

local check_get_icon = V.signature("get_icon", {
	{ "tint", Common.color:optional() },
})

---Gets the icon for the vanilla pumpjack, in the given `tint`.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(tint)
	check_get_icon(tint)

	return get_tinted_layers("__reskins-assets-base__/graphics/icons/pumpjack/pumpjack-icon-", tint)
end

local check_get_water_icon = V.signature("get_water_icon", {
	{ "tint", Common.color:optional() },
})

---Gets the icon for a water pumpjack, in the given `tint`.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_water_icon(tint)
	check_get_water_icon(tint)

	return get_tinted_layers("__reskins-assets-bobs__/graphics/icons/pumpjack-water/pumpjack-water-icon-", tint)
end

return M
