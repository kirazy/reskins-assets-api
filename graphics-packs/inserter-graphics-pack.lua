local _defines = require("api.defines")
local GraphicsPackBase = require("graphics-pack-base")

---@class InserterGraphicsPack:GraphicsPackBase
---@field hand_base_picture table
---@field hand_base_shadow table
---@field hand_open_picture table
---@field hand_closed_picture table
---@field hand_open_shadow table
---@field hand_closed_shadow table
---@field platform_picture table
local InserterGraphicsPack = {}
InserterGraphicsPack.__index = InserterGraphicsPack

-- Set up inheritance.
setmetatable(InserterGraphicsPack, {
	__index = GraphicsPackBase,
})

---@class InserterGraphicsParams
---@field tint data.Color?
---@field variant "inserter"|"inserter-long"|"inserter-filter"|"inserter-filter-long"|"inserter-bulk"|"inserter-bulk-filter"

local base_path = "__reskins-assets-base__/graphics/entity/"
local bobs_path = "__reskins-assets-bobs__/graphics/entity/"

-- ---------------------------------------------------------------------------
-- Static sprite builder functions
-- ---------------------------------------------------------------------------

---Builds the arm (`hand_base_picture`) sprite layers.
---
---All inserter variants share the same base arm sprite. Filter variants append an
---additional tint-colored mask + highlights overlay from `inserter-filter/arm/`.
---Bulk-filter has no arm overlay (no arm subfolder in `inserter-bulk-filter/`).
---@param tint data.Color?
---@param variant "inserter"|"inserter-long"|"inserter-filter"|"inserter-filter-long"|"inserter-bulk"|"inserter-bulk-filter"
---@return table
function InserterGraphicsPack.get_arm_picture(tint, variant)
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
function InserterGraphicsPack.get_arm_shadow()
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
---@param tint data.Color?
---@param variant "inserter"|"inserter-long"|"inserter-filter"|"inserter-filter-long"|"inserter-bulk"|"inserter-bulk-filter"
---@param hand_state "open"|"closed"
---@return table
function InserterGraphicsPack.get_hand_picture(tint, variant, hand_state)
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
function InserterGraphicsPack.get_hand_shadow(variant, hand_state)
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
---@param tint data.Color?
---@return table
function InserterGraphicsPack.get_platform_picture(tint)
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
---@param tint data.Color?
---@param variant "inserter"|"inserter-long"|"inserter-filter"|"inserter-filter-long"|"inserter-bulk"|"inserter-bulk-filter"
---@return data.RotatedAnimationVariations
function InserterGraphicsPack.get_corpse_animation(tint, variant)
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

	return make_rotated_animation_variations_from_sheet(4, { layers = layers })
end

-- ---------------------------------------------------------------------------
-- Class methods
-- ---------------------------------------------------------------------------

---@param params InserterGraphicsParams
---@return InserterGraphicsPack
---@nodiscard
function InserterGraphicsPack:configure(params)
	local variant = params.variant or "inserter"
	local tint = params.tint

	local is_filter = (variant == "inserter-filter"
		or variant == "inserter-filter-long"
		or variant == "inserter-bulk-filter")

	local required_assets = { [_defines.assets.base_assets] = true }
	if is_filter then
		required_assets[_defines.assets.bobs_assets] = true
	end

	local instance = GraphicsPackBase.configure(self, {
		tint = tint,
		remnants = InserterGraphicsPack.get_corpse_animation(tint, variant),
		required_assets = required_assets,
	}) --[[@as InserterGraphicsPack]]

	instance.hand_base_picture = InserterGraphicsPack.get_arm_picture(tint, variant)
	instance.hand_base_shadow = InserterGraphicsPack.get_arm_shadow()
	instance.hand_open_picture = InserterGraphicsPack.get_hand_picture(tint, variant, "open")
	instance.hand_closed_picture = InserterGraphicsPack.get_hand_picture(tint, variant, "closed")
	instance.hand_open_shadow = InserterGraphicsPack.get_hand_shadow(variant, "open")
	instance.hand_closed_shadow = InserterGraphicsPack.get_hand_shadow(variant, "closed")
	instance.platform_picture = InserterGraphicsPack.get_platform_picture(tint)

	setmetatable(instance, InserterGraphicsPack)
	return instance
end

---Applies a copy of the graphics pack to the specified `prototype`.
---
---Assigns `hand_base_picture`, `hand_base_shadow`, `hand_open_picture`,
---`hand_closed_picture`, `hand_open_shadow`, `hand_closed_shadow`, and
---`platform_picture` directly on the prototype (inserters do not use `graphics_set`).
---@param prototype data.InserterPrototype
function InserterGraphicsPack:apply_to_entity(prototype)
	assert(prototype, "'prototype' must not be nil")
	assert(type(prototype) == "table", "'prototype' must be a table")

	prototype.hand_base_picture = util.copy(self.hand_base_picture)
	prototype.hand_base_shadow = util.copy(self.hand_base_shadow)
	prototype.hand_open_picture = util.copy(self.hand_open_picture)
	prototype.hand_closed_picture = util.copy(self.hand_closed_picture)
	prototype.hand_open_shadow = util.copy(self.hand_open_shadow)
	prototype.hand_closed_shadow = util.copy(self.hand_closed_shadow)
	prototype.platform_picture = util.copy(self.platform_picture)
end

return InserterGraphicsPack
