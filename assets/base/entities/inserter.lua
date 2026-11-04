---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _sprites = require("__reskins-sprite-utils__.sprites")
local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")

local IconBuilderFactory = require("api.icon-builder-factory")

local M = {}

local base_path = "__reskins-assets-base__/graphics/entity/"
local bobs_path = "__reskins-assets-bobs__/graphics/entity/"

---Gets the arm sprite layers, `hand_base_picture`, for the given `variant`.
---
---Every variant draws the same base arm artwork. The filter variants add a mask layer and a highlights layer from
---`inserter-filter/arm/`. The bulk filter variant adds no layer to the arm.
---@param tint? Color
---@param variant "inserter"|"inserter-long"|"inserter-filter"|"inserter-filter-long"|"inserter-bulk"|"inserter-bulk-filter"
---@return table
local function get_arm_picture(tint, variant)
	local arm_base = base_path .. "inserter/arm/"

	local layers = {
		{
			filename = arm_base .. "inserter-arm-base.png",
			priority = "extra-high",
			width = 32,
			height = 136,
			flags = { "no-crop" },
			scale = 0.25,
		},
	}

	if tint then
		table.insert(layers, {
			filename = arm_base .. "inserter-arm-mask.png",
			priority = "extra-high",
			width = 32,
			height = 136,
			flags = { "no-crop" },
			tint = tint,
			scale = 0.25,
		})
		table.insert(layers, {
			filename = arm_base .. "inserter-arm-highlights.png",
			priority = "extra-high",
			width = 32,
			height = 136,
			flags = { "no-crop" },
			blend_mode = "additive",
			scale = 0.25,
		})

		-- The filter arm overlay is used only for the non-bulk filter variants.
		if variant == "inserter-filter" or variant == "inserter-filter-long" then
			local filter_path = bobs_path .. "inserter-filter/arm/"
			table.insert(layers, {
				filename = filter_path .. "inserter-filter-arm-mask.png",
				priority = "extra-high",
				width = 32,
				height = 136,
				flags = { "no-crop" },
				tint = tint,
				scale = 0.25,
			})
			table.insert(layers, {
				filename = filter_path .. "inserter-filter-arm-highlights.png",
				priority = "extra-high",
				width = 32,
				height = 136,
				flags = { "no-crop" },
				blend_mode = "additive",
				scale = 0.25,
			})
		end
	end

	return { layers = layers }
end

---Gets the arm shadow, `hand_base_shadow`.
---
---All inserter variants share the arm shadow.
---@return table
local function get_arm_shadow()
	return {
		filename = base_path .. "inserter/shadows/inserter-arm-shadow.png",
		priority = "extra-high",
		width = 32,
		height = 136,
		flags = { "no-crop" },
		draw_as_shadow = true,
		scale = 0.25,
	}
end

---Gets the open or closed hand sprite, `hand_open_picture` or `hand_closed_picture`.
---
---The base hand is drawn from `inserter/hand/` for the standard, long, and filter variants, and from
---`inserter-bulk/hand/` for the bulk variants. The filter variants add a mask layer and a highlights layer, which use
---the same files for the open and closed states. The bulk filter variant adds the layers in
---`inserter-bulk-filter/hand/`.
---@param tint? Color
---@param variant "inserter"|"inserter-long"|"inserter-filter"|"inserter-filter-long"|"inserter-bulk"|"inserter-bulk-filter"
---@param hand_state "open"|"closed"
---@return table
local function get_hand_picture(tint, variant, hand_state)
	local is_bulk = (variant == "inserter-bulk" or variant == "inserter-bulk-filter")
	local is_long = (variant == "inserter-long" or variant == "inserter-filter-long")
	local is_filter = (variant == "inserter-filter" or variant == "inserter-filter-long")
	local is_bulk_filter = (variant == "inserter-bulk-filter")
	local long_suffix = is_long and "-long" or ""

	local hand_base_path, hand_base_file
	if is_bulk then
		hand_base_path = base_path .. "inserter-bulk/hand/"
		hand_base_file = "inserter-bulk-hand-" .. hand_state .. "-base.png"
	else
		hand_base_path = base_path .. "inserter/hand/"
		hand_base_file = "inserter-hand-" .. hand_state .. long_suffix .. "-base.png"
	end

	local layers = {
		{
			filename = hand_base_path .. hand_base_file,
			priority = "extra-high",
			width = 130,
			height = 164,
			flags = { "no-crop" },
			scale = 0.25,
		},
	}

	if tint then
		-- Base mask and highlights.
		if is_bulk then
			table.insert(layers, {
				filename = hand_base_path .. "inserter-bulk-hand-" .. hand_state .. "-mask.png",
				priority = "extra-high",
				width = 130,
				height = 164,
				flags = { "no-crop" },
				tint = tint,
				scale = 0.25,
			})
			table.insert(layers, {
				filename = hand_base_path .. "inserter-bulk-hand-" .. hand_state .. "-highlights.png",
				priority = "extra-high",
				width = 130,
				height = 164,
				flags = { "no-crop" },
				blend_mode = "additive",
				scale = 0.25,
			})
		else
			table.insert(layers, {
				filename = hand_base_path .. "inserter-hand-" .. hand_state .. long_suffix .. "-mask.png",
				priority = "extra-high",
				width = 130,
				height = 164,
				flags = { "no-crop" },
				tint = tint,
				scale = 0.25,
			})
			table.insert(layers, {
				filename = hand_base_path .. "inserter-hand-" .. hand_state .. long_suffix .. "-highlights.png",
				priority = "extra-high",
				width = 130,
				height = 164,
				flags = { "no-crop" },
				blend_mode = "additive",
				scale = 0.25,
			})
		end

		-- The filter hand overlay uses the same file for the open and closed states.
		if is_filter then
			local filter_path = bobs_path .. "inserter-filter/hand/"
			local filter_long_suffix = is_long and "-long" or ""
			table.insert(layers, {
				filename = filter_path .. "inserter-filter-hand" .. filter_long_suffix .. "-mask.png",
				priority = "extra-high",
				width = 130,
				height = 164,
				flags = { "no-crop" },
				tint = tint,
				scale = 0.25,
			})
			table.insert(layers, {
				filename = filter_path .. "inserter-filter-hand" .. filter_long_suffix .. "-highlights.png",
				priority = "extra-high",
				width = 130,
				height = 164,
				flags = { "no-crop" },
				blend_mode = "additive",
				scale = 0.25,
			})
		end

		-- Bulk-filter hand overlay. The file prefix is "inserter-filter-bulk-", in a different order from the folder name.
		if is_bulk_filter then
			local bulk_filter_path = bobs_path .. "inserter-bulk-filter/hand/"
			table.insert(layers, {
				filename = bulk_filter_path .. "inserter-filter-bulk-hand-mask.png",
				priority = "extra-high",
				width = 130,
				height = 164,
				flags = { "no-crop" },
				tint = tint,
				scale = 0.25,
			})
			table.insert(layers, {
				filename = bulk_filter_path .. "inserter-filter-bulk-hand-highlights.png",
				priority = "extra-high",
				width = 130,
				height = 164,
				flags = { "no-crop" },
				blend_mode = "additive",
				scale = 0.25,
			})
		end
	end

	return { layers = layers }
end

---Gets the open or closed hand shadow, `hand_open_shadow` or `hand_closed_shadow`.
---
---The bulk variants draw the shadows in `inserter-bulk/shadows/`, and the other variants draw the shadows in
---`inserter/shadows/`. Both folders are in `reskins-assets-base`.
---@param variant "inserter"|"inserter-long"|"inserter-filter"|"inserter-filter-long"|"inserter-bulk"|"inserter-bulk-filter"
---@param hand_state "open"|"closed"
---@return table
local function get_hand_shadow(variant, hand_state)
	local is_bulk = (variant == "inserter-bulk" or variant == "inserter-bulk-filter")

	if is_bulk then
		return {
			filename = base_path .. "inserter-bulk/shadows/inserter-bulk-hand-" .. hand_state .. "-shadow.png",
			priority = "extra-high",
			width = 130,
			height = 164,
			flags = { "no-crop" },
			draw_as_shadow = true,
			scale = 0.25,
		}
	else
		return {
			filename = base_path .. "inserter/shadows/inserter-hand-" .. hand_state .. "-shadow.png",
			priority = "extra-high",
			width = 130,
			height = 164,
			flags = { "no-crop" },
			draw_as_shadow = true,
			scale = 0.25,
		}
	end
end

---Gets the platform sprite sheets, `platform_picture`.
---
---All variants share the same platform base sprites. The `sheets` of the result are the base layer, the mask and
---highlights layers when `tint` is given, and the shadow layer.
---@param tint? Color
---@return table
local function get_platform_picture(tint)
	local platform_base = base_path .. "inserter/platform/"

	local sheets = {
		{
			filename = platform_base .. "inserter-platform-base.png",
			priority = "extra-high",
			width = 106,
			height = 80,
			shift = util.by_pixel(1.75, 6.75),
			scale = 0.5,
		},
	}

	if tint then
		table.insert(sheets, {
			filename = platform_base .. "inserter-platform-mask.png",
			priority = "extra-high",
			width = 106,
			height = 80,
			tint = tint,
			shift = util.by_pixel(1.75, 6.75),
			scale = 0.5,
		})
		table.insert(sheets, {
			filename = platform_base .. "inserter-platform-highlights.png",
			priority = "extra-high",
			width = 106,
			height = 80,
			blend_mode = "additive",
			shift = util.by_pixel(1.75, 6.75),
			scale = 0.5,
		})
	end

	table.insert(sheets, {
		filename = base_path .. "inserter/shadows/inserter-platform-shadow.png",
		priority = "extra-high",
		width = 106,
		height = 80,
		draw_as_shadow = true,
		shift = util.by_pixel(1.75, 6.75),
		scale = 0.5,
	})

	return { sheets = sheets }
end

---Gets the corpse remnant animation.
---
---Each variant draws the remnant artwork in one of these folders:
---- `inserter/remnants/` in `reskins-assets-base`, for `"inserter"` and `"inserter-long"`.
---- `inserter-filter/remnants/` in `reskins-assets-bobs`, for `"inserter-filter"` and `"inserter-filter-long"`.
---- `inserter-bulk/remnants/` in `reskins-assets-base`, for `"inserter-bulk"`.
---- `inserter-bulk-filter/remnants/` in `reskins-assets-bobs`, for `"inserter-bulk-filter"`. The names of the files in
---  this folder start with `inserter-filter-bulk-`.
---@param tint? Color
---@param variant "inserter"|"inserter-long"|"inserter-filter"|"inserter-filter-long"|"inserter-bulk"|"inserter-bulk-filter"
---@return RotatedAnimationVariations
local function get_corpse_animation(tint, variant)
	local remnants_path, prefix
	if variant == "inserter-filter" or variant == "inserter-filter-long" then
		remnants_path = bobs_path .. "inserter-filter/remnants/"
		prefix = "inserter-filter-remnants"
	elseif variant == "inserter-bulk-filter" then
		remnants_path = bobs_path .. "inserter-bulk-filter/remnants/"
		prefix = "inserter-filter-bulk-remnants"
	elseif variant == "inserter-bulk" then
		remnants_path = base_path .. "inserter-bulk/remnants/"
		prefix = "inserter-bulk-remnants"
	else
		-- "inserter" and "inserter-long" share the same remnants.
		remnants_path = base_path .. "inserter/remnants/"
		prefix = "inserter-remnants"
	end

	local layers = {
		{
			filename = remnants_path .. prefix .. "-base.png",
			width = 134,
			height = 94,
			direction_count = 1,
			shift = util.by_pixel(3, -1.5),
			scale = 0.5,
		},
	}

	if tint then
		table.insert(layers, {
			filename = remnants_path .. prefix .. "-mask.png",
			width = 134,
			height = 94,
			tint = tint,
			direction_count = 1,
			shift = util.by_pixel(3, -1.5),
			scale = 0.5,
		})
		table.insert(layers, {
			filename = remnants_path .. prefix .. "-highlights.png",
			width = 134,
			height = 94,
			blend_mode = "additive",
			direction_count = 1,
			shift = util.by_pixel(3, -1.5),
			scale = 0.5,
		})
	end

	return _sprites.make_rotated_animation_variations_from_spritesheet(4, { layers = layers })
end

---Gets the frozen arm, `hand_base_frozen`.
---@return Sprite
local function get_arm_frozen()
	return {
		filename = "__space-age__/graphics/entity/frozen/inserter/inserter-hand.png",
		priority = "extra-high",
		x = 130 * 4,
		width = 130,
		height = 136,
		scale = 0.25,
	}
end

---Gets the frozen open or closed hand, `hand_open_frozen` or `hand_closed_frozen`.
---@param variant InserterVariants
---@param hand_state "open"|"closed"
---@return Sprite
local function get_hand_frozen(variant, hand_state)
	local is_bulk = (variant == "inserter-bulk" or variant == "inserter-bulk-filter")

	-- The sheet holds the open and closed bulk hands, then the open and closed hands, then the arm.
	local x = (is_bulk and 0 or 130 * 2) + (hand_state == "closed" and 130 or 0)

	return {
		filename = "__space-age__/graphics/entity/frozen/inserter/inserter-hand.png",
		priority = "extra-high",
		x = x,
		width = 130,
		height = 164,
		scale = 0.25,
	}
end

---Gets the frozen platform, `platform_frozen`.
---@return Sprite4Way
local function get_platform_frozen()
	return {
		sheet = {
			filename = "__space-age__/graphics/entity/frozen/inserter/inserter-platform.png",
			priority = "extra-high",
			width = 105,
			height = 79,
			shift = util.by_pixel(1.5, 6.5),
			scale = 0.5,
		},
	}
end

---Gets the light flicker of the burner or fluid energy source of the inserter, which shows no light.
---@return LightFlickeringDefinition
local function get_light_flicker()
	return { color = { 0, 0, 0 } }
end

---Gets the circuit connector of the inserter for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(inserter_connector_template, {
		{ variation = 2, main_offset = { 0, 0 }, shadow_offset = { 0, 0 }, show_shadow = true, render_layer = "floor" },
		{ variation = 3, main_offset = { 0, 0 }, shadow_offset = { 0, 0 }, show_shadow = true, render_layer = "floor" },
		{ variation = 0, main_offset = { 0, 0 }, shadow_offset = { 0, 0 }, show_shadow = true, render_layer = "floor" },
		{ variation = 1, main_offset = { 0, 0 }, shadow_offset = { 0, 0 }, show_shadow = true, render_layer = "floor" },
	})
end

---The variant of the inserter artwork.
---@alias InserterVariants
---| "inserter"
---| "inserter-long"
---| "inserter-filter"
---| "inserter-filter-long"
---| "inserter-bulk"
---| "inserter-bulk-filter"

---Defines the options for the tinted inserters sprite set.
---@class InserterSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color
---The variant to use.
---@field variant InserterVariants

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("InserterSpriteSetParams", {
			tint = Common.color:optional(),
			variant = V.one_of({
				"inserter",
				"inserter-long",
				"inserter-filter",
				"inserter-filter-long",
				"inserter-bulk",
				"inserter-bulk-filter",
			}),
		}):strict(),
	},
})

---Gets the sprite set for the tinted inserters.
---@param params InserterSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<InserterSpriteSet> # The sprite set definition for the tinted inserters.
---
---#### Examples
---```lua
---local inserter = require("__reskins-assets-api__.assets.base.entities.inserter")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = inserter.get_sprite_set({ tint = tint, variant = variant })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@throws When `params.variant` is not an `InserterVariants`.
---@throws When `params.tint` is not a `Color`.
---@throws When `params` defines an unrecognized field.
---@nodiscard
function M.get_sprite_set(params)
	check_get_sprite_set(params)

	local variant = params.variant
	local tint = params.tint

	---@type SpriteSetDefinition<InserterSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.inserter_sprite_set,
		set = {
			hand_base_picture = get_arm_picture(tint, variant),
			hand_base_shadow = get_arm_shadow(),
			hand_open_picture = get_hand_picture(tint, variant, "open"),
			hand_closed_picture = get_hand_picture(tint, variant, "closed"),
			hand_open_shadow = get_hand_shadow(variant, "open"),
			hand_closed_shadow = get_hand_shadow(variant, "closed"),
			platform_picture = get_platform_picture(tint),
			circuit_connector = get_circuit_connector(),
			light_flicker = get_light_flicker(),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = { animation = get_corpse_animation(tint, variant) },
			water_reflection = nil,
			nominal_width = 0.8,
			nominal_height = 0.8,
		},
	}

	if feature_flags["freezing"] and mods["space-age"] then
		definition.set.hand_base_frozen = get_arm_frozen()
		definition.set.hand_open_frozen = get_hand_frozen(variant, "open")
		definition.set.hand_closed_frozen = get_hand_frozen(variant, "closed")
		definition.set.platform_frozen = get_platform_frozen()
	end

	return definition
end

local base_icons = IconBuilderFactory:create({ folder = "__reskins-assets-base__/graphics/icons" })
local bobs_icons = IconBuilderFactory:create({ folder = "__reskins-assets-bobs__/graphics/icons/inserters" })

---Gets the icon for a standard inserter, in the tints given by `params`.
M.get_icon = base_icons:tinted("inserter"):build("get_icon")

---Gets the icon for a filter inserter, in the tints given by `params`.
M.get_filter_icon = bobs_icons:tinted("inserter-filter"):build("get_filter_icon")

---Gets the icon for a bulk inserter, in the tints given by `params`.
M.get_bulk_icon = bobs_icons:tinted("inserter-bulk"):build("get_bulk_icon")

---Gets the icon for a bulk inserter, mirrored, in the tints given by `params`.
M.get_flipped_bulk_icon = bobs_icons:tinted("inserter-bulk-flipped"):build("get_flipped_bulk_icon")

---Gets the icon for a bulk filter inserter, in the tints given by `params`.
M.get_bulk_filter_icon = bobs_icons:tinted("inserter-bulk-filter"):build("get_bulk_filter_icon")

---Gets the icon for a bulk filter inserter, mirrored, in the tints given by `params`.
M.get_flipped_bulk_filter_icon = bobs_icons:tinted("inserter-bulk-filter-flipped"):build("get_flipped_bulk_filter_icon")

return M
