local _defines = require("api.defines")
local GraphicsPackBase = require("graphics-pack-base")

---@class InserterPresetGraphicsPack:GraphicsPackBase
---@field hand_base_picture table
---@field hand_base_shadow table
---@field hand_open_picture table
---@field hand_closed_picture table
---@field hand_open_shadow table
---@field hand_closed_shadow table
---@field platform_picture table
local InserterPresetGraphicsPack = {}
InserterPresetGraphicsPack.__index = InserterPresetGraphicsPack

-- Set up inheritance.
setmetatable(InserterPresetGraphicsPack, {
	__index = GraphicsPackBase,
})

---Preset inserter type — each value corresponds to one subfolder in
---`reskins-assets-bobs/graphics/entity/inserters/`.
---@alias InserterPreset
---| "inserter"
---| "inserter-burner"
---| "inserter-fast"
---| "inserter-express"
---| "inserter-filter"
---| "inserter-express-filter"
---| "inserter-long-handed"
---| "inserter-bulk"
---| "inserter-express-bulk"
---| "inserter-bulk-filter"
---| "inserter-express-bulk-filter"

---@class InserterPresetGraphicsParams
---@field preset InserterPreset
---@field is_long boolean? When `true`, selects the long-arm hand sprite variants. Only valid for non-bulk presets that are not `"inserter-long-handed"`.

-- Presets that use bulk-type hand shadows from `inserter-bulk/shadows/`.
local bulk_presets = {
	["inserter-bulk"] = true,
	["inserter-express-bulk"] = true,
	["inserter-bulk-filter"] = true,
	["inserter-express-bulk-filter"] = true,
}

-- Presets for which `is_long = true` is a valid option.
-- Bulk presets and `inserter-long-handed` do not support the `is_long` toggle.
local long_capable_presets = {
	["inserter"] = true,
	["inserter-burner"] = true,
	["inserter-fast"] = true,
	["inserter-express"] = true,
	["inserter-filter"] = true,
	["inserter-express-filter"] = true,
}

local bobs_path = "__reskins-assets-bobs__/graphics/entity/inserters/"
local base_path = "__reskins-assets-base__/graphics/entity/"

-- ---------------------------------------------------------------------------
-- Static sprite builder functions
-- ---------------------------------------------------------------------------

---Builds the arm (`hand_base_picture`) sprite.
---@param preset InserterPreset
---@return table
function InserterPresetGraphicsPack.get_arm_picture(preset)
	return {
		filename = bobs_path .. preset .. "/" .. preset .. "-arm.png",
		priority = "extra-high",
		width = 32,
		height = 136,
		flags = { "no-crop" },
		scale = 0.25,
	}
end

---Builds the arm shadow (`hand_base_shadow`).
---
---Shared by all preset inserter variants; always sourced from `reskins-assets-base`.
---@return table
function InserterPresetGraphicsPack.get_arm_shadow()
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
---When `is_long` is `true`, selects the `-long` variant of the hand sprite (only valid
---for presets listed in `long_capable_presets`).
---@param preset InserterPreset
---@param hand_state "open"|"closed"
---@param is_long boolean
---@return table
function InserterPresetGraphicsPack.get_hand_picture(preset, hand_state, is_long)
	local long_suffix = is_long and "-long" or ""
	return {
		filename = bobs_path .. preset .. "/" .. preset .. "-hand-" .. hand_state .. long_suffix .. ".png",
		priority = "extra-high",
		width = 130,
		height = 164,
		flags = { "no-crop" },
		scale = 0.25,
	}
end

---Builds an open or closed hand shadow (`hand_open_shadow` / `hand_closed_shadow`).
---
---Non-bulk presets use `inserter/shadows/`; bulk presets use `inserter-bulk/shadows/`.
---Both are in `reskins-assets-base`.
---@param preset InserterPreset
---@param hand_state "open"|"closed"
---@return table
function InserterPresetGraphicsPack.get_hand_shadow(preset, hand_state)
	local is_bulk = bulk_presets[preset] == true

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
---All presets share the same platform shadow from `reskins-assets-base`.
---@param preset InserterPreset
---@return table
function InserterPresetGraphicsPack.get_platform_picture(preset)
	return {
		sheets = {
			{
				filename = bobs_path .. preset .. "/" .. preset .. "-platform.png",
				priority = "extra-high",
				width = 106,
				height = 80,
				shift = util.by_pixel(1.75, 6.75),
				scale = 0.5,
			},
			{
				filename = base_path .. "inserter/shadows/inserter-platform-shadow.png",
				priority = "extra-high",
				width = 106,
				height = 80,
				draw_as_shadow = true,
				shift = util.by_pixel(1.75, 6.75),
				scale = 0.5,
			},
		},
	}
end

---Builds the corpse remnant animation.
---
---Each preset has its own single-sheet remnant sprite located at
---`inserters/<preset>/remnants/<preset>-remnants.png` in `reskins-assets-bobs`.
---@param preset InserterPreset
---@return data.RotatedAnimationVariations
function InserterPresetGraphicsPack.get_corpse_animation(preset)
	return make_rotated_animation_variations_from_sheet(4, {
		filename = bobs_path .. preset .. "/remnants/" .. preset .. "-remnants.png",
		width = 134,
		height = 94,
		direction_count = 1,
		shift = util.by_pixel(3, -1.5),
		scale = 0.5,
	})
end

-- ---------------------------------------------------------------------------
-- Class methods
-- ---------------------------------------------------------------------------

---@param params InserterPresetGraphicsParams
---@return InserterPresetGraphicsPack
---@nodiscard
function InserterPresetGraphicsPack:configure(params)
	local preset = params.preset
	local is_long = params.is_long or false

	-- Validate: bulk presets and inserter-long-handed do not support is_long.
	if is_long and not long_capable_presets[preset] then
		if not reskins_suppress_errors then
			error(
				"InserterPresetGraphicsPack: 'is_long' is not valid for preset '"
					.. tostring(preset)
					.. "'. Only non-bulk presets (excluding 'inserter-long-handed') support long-arm variants."
			)
		end
		is_long = false
	end

	local instance = GraphicsPackBase.configure(self, {
		tint = nil,
		remnants = InserterPresetGraphicsPack.get_corpse_animation(preset),
		required_assets = {
			[_defines.assets.bobs_assets] = true,
			[_defines.assets.base_assets] = true,
		},
	}) --[[@as InserterPresetGraphicsPack]]

	instance.hand_base_picture = InserterPresetGraphicsPack.get_arm_picture(preset)
	instance.hand_base_shadow = InserterPresetGraphicsPack.get_arm_shadow()
	instance.hand_open_picture = InserterPresetGraphicsPack.get_hand_picture(preset, "open", is_long)
	instance.hand_closed_picture = InserterPresetGraphicsPack.get_hand_picture(preset, "closed", is_long)
	instance.hand_open_shadow = InserterPresetGraphicsPack.get_hand_shadow(preset, "open")
	instance.hand_closed_shadow = InserterPresetGraphicsPack.get_hand_shadow(preset, "closed")
	instance.platform_picture = InserterPresetGraphicsPack.get_platform_picture(preset)

	setmetatable(instance, InserterPresetGraphicsPack)
	return instance
end

---Applies a copy of the graphics pack to the specified `prototype`.
---
---Assigns `hand_base_picture`, `hand_base_shadow`, `hand_open_picture`,
---`hand_closed_picture`, `hand_open_shadow`, `hand_closed_shadow`, and
---`platform_picture` directly on the prototype (inserters do not use `graphics_set`).
---@param prototype data.InserterPrototype
function InserterPresetGraphicsPack:apply_to_entity(prototype)
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

return InserterPresetGraphicsPack
