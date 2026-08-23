---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators

---@namespace Reskins.Assets.Base.Entities

local _sprites = require("__reskins-sprite-utils__.sprites")
local _defines = require("api.defines")

local M = {}

local base_path = "__reskins-assets-base__/graphics/entity/"
local bobs_path = "__reskins-assets-bobs__/graphics/entity/"

-- Static sprite builder functions

---Builds the arm (`hand_base_picture`) sprite layers.
---
---All inserter variants share the same base arm sprite. Filter variants append an
---additional tint-colored mask + highlights overlay from `inserter-filter/arm/`.
---Bulk-filter has no arm overlay (no arm subfolder in `inserter-bulk-filter/`).
---@param tint Color?
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
			blend_mode = "additive-soft",
			scale = 0.25,
		})

		-- Filter arm overlay — only for non-bulk filter variants.
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
				blend_mode = "additive-soft",
				scale = 0.25,
			})
		end
	end

	return { layers = layers }
end

---Builds the arm shadow (`hand_base_shadow`).
---
---Shared by all inserter variants.
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

---Builds an open or closed hand sprite (`hand_open_picture` / `hand_closed_picture`).
---
---Base hand is sourced from `inserter/hand/` for standard/long/filter variants, and
---from `inserter-bulk/hand/` for bulk variants. Filter variants append a state-agnostic
---mask + highlights overlay (the same pair of files is applied to both open and closed
---states, as the filter overlay is not state-dependent). Bulk-filter appends overlays from
---`inserter-bulk-filter/hand/`.
---@param tint Color?
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
				blend_mode = "additive-soft",
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
				blend_mode = "additive-soft",
				scale = 0.25,
			})
		end

		-- Filter hand overlay — state-agnostic: same overlay file for both open and closed.
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
				blend_mode = "additive-soft",
				scale = 0.25,
			})
		end

		-- Bulk-filter hand overlay (prefix is intentionally "inserter-filter-bulk-", not "inserter-bulk-filter-").
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
				blend_mode = "additive-soft",
				scale = 0.25,
			})
		end
	end

	return { layers = layers }
end

---Builds an open or closed hand shadow (`hand_open_shadow` / `hand_closed_shadow`).
---
---Non-bulk variants share shadows from `inserter/shadows/`. Bulk variants use
---`inserter-bulk/shadows/`. Both are in `reskins-assets-base`.
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

---Builds the platform sprite sheets (`platform_picture`).
---
---All variants share the same platform base sprites. The result uses `sheets` (plural)
---to accommodate base, optional mask/highlights, and shadow layers.
---@param tint Color?
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
			blend_mode = "additive-soft",
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

---Builds the corpse remnant animation.
---
---Remnant sprites are sourced per variant:
---  - `"inserter"` / `"inserter-long"` → `inserter/remnants/` in `reskins-assets-base`
---  - `"inserter-filter"` / `"inserter-filter-long"` → `inserter-filter/remnants/` in `reskins-assets-bobs`
---  - `"inserter-bulk"` → `inserter-bulk/remnants/` in `reskins-assets-base`
---  - `"inserter-bulk-filter"` → `inserter-bulk-filter/remnants/` in `reskins-assets-bobs`
---    (file prefix is `inserter-filter-bulk-`, not `inserter-bulk-filter-`)
---@param tint Color?
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
			blend_mode = "additive-soft",
			direction_count = 1,
			shift = util.by_pixel(3, -1.5),
			scale = 0.5,
		})
	end

	return _sprites.make_rotated_animation_variations_from_spritesheet(4, { layers = layers })
end

-- Class methods

---@alias InserterVariants
--- | "inserter"
--- | "inserter-long"
--- | "inserter-filter"
--- | "inserter-filter-long"
--- | "inserter-bulk"
--- | "inserter-bulk-filter"

---@class InserterGraphicsParams
---@field tint Color?
---@field variant InserterVariants

---@class InserterSpriteSetParams
---@field tint Color?
---@field variant InserterVariants

---Produces the sprite set for the vanilla and Bob's tinted inserters.
---
---The old pack declared no nominal dimensions; an inserter's 1x1 footprint is used
---here, so scaling has a baseline to work from.
---@param params InserterSpriteSetParams
---@return SpriteSetDefinition<InserterSpriteSet>
---@nodiscard
function M.get(params)
	local variant = params.variant or "inserter"
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
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = { animation = get_corpse_animation(tint, variant) },
			water_reflection = nil,
			nominal_width = 1,
			nominal_height = 1,
		},
	}

	return definition
end

return M
