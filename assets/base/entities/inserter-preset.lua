---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _sprites = require("__reskins-sprite-utils__.sprites")
local _defines = require("api.defines")

local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")

local M = {}

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
-- Class methods
-- ---------------------------------------------------------------------------

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

-- ---------------------------------------------------------------------------
-- Static sprite builder functions
-- ---------------------------------------------------------------------------

---Builds the arm (`hand_base_picture`) sprite.
---@param preset InserterPreset
---@return table
local function get_arm_picture(preset)
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
---When `is_long` is `true`, selects the `-long` variant of the hand sprite (only valid
---for presets listed in `long_capable_presets`).
---@param preset InserterPreset
---@param hand_state "open"|"closed"
---@param is_long boolean
---@return table
local function get_hand_picture(preset, hand_state, is_long)
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
local function get_hand_shadow(preset, hand_state)
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
local function get_platform_picture(preset)
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
---@return RotatedAnimationVariations
local function get_corpse_animation(preset)
	return _sprites.make_rotated_animation_variations_from_spritesheet(4, {
		filename = bobs_path .. preset .. "/remnants/" .. preset .. "-remnants.png",
		width = 134,
		height = 94,
		direction_count = 1,
		shift = util.by_pixel(3, -1.5),
		scale = 0.5,
	})
end

---@class InserterPresetSpriteSetParams
---The preset to draw.
---@field preset InserterPreset
---Whether the inserter wears its long-arm hands. Only the non-bulk presets other than `"inserter-long-handed"`
---draw them.
---@field is_long boolean?

---Gets the sprite set for Bob's preset (untinted) inserters.
---@param params InserterPresetSpriteSetParams # The options the sprite set is drawn with.
---@return SpriteSetDefinition<InserterSpriteSet>
---
---### Examples
---```lua
---local inserter_preset = require("__reskins-assets-api__.assets.base.entities.inserter-preset")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = inserter_preset.get_sprite_set({ preset = preset })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set(params)
	local preset = params.preset
	local is_long = params.is_long or false

	-- Validate: bulk presets and inserter-long-handed do not support is_long.
	if is_long and not long_capable_presets[preset] then
		if not reskins_suppress_errors then
			error(
				"InserterPresetSpriteSet: 'is_long' is not valid for preset '"
					.. tostring(preset)
					.. "'. Only non-bulk presets (excluding 'inserter-long-handed') support long-arm variants."
			)
		end
		is_long = false
	end

	---@type SpriteSetDefinition<InserterSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.inserter_sprite_set,
		set = {
			hand_base_picture = get_arm_picture(preset),
			hand_base_shadow = get_arm_shadow(),
			hand_open_picture = get_hand_picture(preset, "open", is_long),
			hand_closed_picture = get_hand_picture(preset, "closed", is_long),
			hand_open_shadow = get_hand_shadow(preset, "open"),
			hand_closed_shadow = get_hand_shadow(preset, "closed"),
			platform_picture = get_platform_picture(preset),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = { animation = get_corpse_animation(preset) },
			water_reflection = nil,
			nominal_width = 1,
			nominal_height = 1,
		},
	}

	return definition
end

local check_get_icon = V.signature("get_icon", {
	{
		"preset",
		V.one_of({
			"inserter",
			"inserter-burner",
			"inserter-fast",
			"inserter-express",
			"inserter-filter",
			"inserter-express-filter",
			"inserter-long-handed",
			"inserter-bulk",
			"inserter-express-bulk",
			"inserter-bulk-filter",
			"inserter-express-bulk-filter",
		}),
	},
})

---Gets the icon for the given preset inserter.
---
---### Remarks
---The preset inserters are untinted. `inserter.get_icon` is the tinted counterpart.
---
---@param preset InserterPreset # The preset the icon is drawn for.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(preset)
	check_get_icon(preset)

	-- The artwork leads with the qualifier: `inserter-express-bulk` is `express-bulk-inserter-icon`.
	local qualifier = preset:match("^inserter%-(.+)$")
	local name = qualifier and qualifier .. "-inserter-icon" or "inserter-icon"

	return {
		{ icon = "__reskins-assets-bobs__/graphics/icons/inserters/" .. name .. ".png", icon_size = 64, scale = 0.5 },
	}
end

return M
