---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.Assets.Base
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _sprites = require("__reskins-sprite-utils__.sprites")
local _defines = require("api.defines")

local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local BulkInserterExplosion = require("assets.base.explosions.bulk-inserter")
local InserterExplosion = require("assets.base.explosions.inserter")
local Remnants = require("assets.base.remnants")

local M = {}

-- Presets that use bulk-type hand shadows from `inserter-bulk/shadows/` and the dying explosion of the bulk inserter.
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

-- The tint of the medium metal particles in the dying explosion for each preset that has one. The dying explosion of an
-- inserter with any other preset is not modified.
local particle_tints = {
	["inserter-express"] = util.color("30d79c"),
	["inserter-express-bulk"] = util.color("2dcd3f"),
}

-- The vanilla remnants that give the corpse of each preset its fields other than the artwork. A preset drawn from a
-- vanilla inserter takes the remnants of that inserter, a bulk preset takes the bulk inserter remnants, and any other
-- preset takes the inserter remnants.
---@type table<InserterPreset, BaseRemnantsID>
local remnants_names = {
	["inserter"] = "inserter-remnants",
	["inserter-burner"] = "burner-inserter-remnants",
	["inserter-fast"] = "fast-inserter-remnants",
	["inserter-express"] = "inserter-remnants",
	["inserter-filter"] = "inserter-remnants",
	["inserter-express-filter"] = "inserter-remnants",
	["inserter-long-handed"] = "long-handed-inserter-remnants",
	["inserter-bulk"] = "bulk-inserter-remnants",
	["inserter-express-bulk"] = "bulk-inserter-remnants",
	["inserter-bulk-filter"] = "bulk-inserter-remnants",
	["inserter-express-bulk-filter"] = "bulk-inserter-remnants",
}

local bobs_path = "__reskins-assets-bobs__/graphics/entity/inserters/"
local base_path = "__reskins-assets-base__/graphics/entity/"

---A preset inserter type. Each value names one subfolder in `reskins-assets-bobs/graphics/entity/inserters/`.
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

local InserterPresetName = V.one_of({
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
})

---Gets the arm sprite, `hand_base_picture`, for the given `preset`.
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

---Gets the arm shadow, `hand_base_shadow`.
---
---All preset inserters share the arm shadow, which is from `reskins-assets-base`.
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
---When `is_long` is `true`, the `-long` variant of the hand sprite is selected. Only the presets in
---`long_capable_presets` have it.
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

---Gets the open or closed hand shadow, `hand_open_shadow` or `hand_closed_shadow`.
---
---Non-bulk presets use `inserter/shadows/`; bulk presets use `inserter-bulk/shadows/`. Both are in
---`reskins-assets-base`.
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

---Gets the platform sprite sheets, `platform_picture`.
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

---Gets the corpse remnant animation.
---
---Each preset has its own remnant artwork, a single sheet, located at
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
---@param preset InserterPreset
---@param hand_state "open"|"closed"
---@return Sprite
local function get_hand_frozen(preset, hand_state)
	local is_bulk = bulk_presets[preset] == true

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

---Gets the dying explosion for the given `preset`, with the medium metal particles in the tint of the preset.
---@param preset InserterPreset
---@return ExplosionSpriteSet? # The dying explosion, or `nil` when the preset has no particle tint.
local function get_dying_explosion(preset)
	local tint = particle_tints[preset]
	if not tint then
		return nil
	end

	if bulk_presets[preset] then
		return BulkInserterExplosion.get_explosion({
			tints = { ["bulk-inserter-metal-particle-medium"] = util.copy(tint) },
		})
	end

	return InserterExplosion.get_explosion({ tints = { ["inserter-metal-particle-medium"] = util.copy(tint) } })
end

---Gets the corpse of the inserter for the given `preset`, with the other fields of the vanilla remnants in
---`remnants_names`.
---@param preset InserterPreset
---@return CorpseSpriteSet
local function get_corpse(preset)
	return Remnants.get_corpse(remnants_names[preset], { animation = get_corpse_animation(preset) })
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

---Defines the options for the preset (untinted) inserters sprite set.
---@class InserterPresetSpriteSetParams
---The preset to use.
---@field preset InserterPreset
---When `true`, indicates that the inserter has long-arm hands. Only the non-bulk presets other than
---`"inserter-long-handed"` have them.
---@field is_long? boolean

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("InserterPresetSpriteSetParams", {
			preset = InserterPresetName,
			is_long = V.boolean():optional(),
		})
			:strict()
			:where(function(value)
				return not value.is_long or long_capable_presets[value.preset] == true
			end, "sets 'is_long' for a preset that has no long hands"),
	},
})

---Gets the sprite set for the preset (untinted) inserters.
---@param params InserterPresetSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<InserterSpriteSet> # The sprite set definition for the preset (untinted) inserters.
---
---#### Examples
---```lua
---local inserter_preset = require("__reskins-assets-api__.assets.base.entities.inserter-preset")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = inserter_preset.get_sprite_set({ preset = preset })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@throws When `params.preset` is not an `InserterPreset`.
---@throws When `params.is_long` is not a boolean.
---@throws When `params.is_long` is `true` for a preset that has no long hands.
---@throws When `params` defines an unrecognized field.
---@nodiscard
function M.get_sprite_set(params)
	check_get_sprite_set(params)

	local preset = params.preset
	local is_long = params.is_long or false

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
			circuit_connector = get_circuit_connector(),
			light_flicker = get_light_flicker(),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = get_dying_explosion(preset),
			corpse = get_corpse(preset),
			water_reflection = nil,
			nominal_width = 0.8,
			nominal_height = 0.8,
		},
	}

	if feature_flags["freezing"] and mods["space-age"] then
		definition.set.hand_base_frozen = get_arm_frozen()
		definition.set.hand_open_frozen = get_hand_frozen(preset, "open")
		definition.set.hand_closed_frozen = get_hand_frozen(preset, "closed")
		definition.set.platform_frozen = get_platform_frozen()
	end

	return definition
end

local check_get_icon = V.signature("get_icon", {
	{ "preset", InserterPresetName },
})

---Gets the icon for the given preset inserter.
---
---The preset inserters are untinted.
---@param preset InserterPreset The preset of the icon.
---@return SafeIconData[] # The icon.
---@nodiscard
function M.get_icon(preset)
	check_get_icon(preset)

	-- The artwork leads with the qualifier: `inserter-express-bulk` is `express-bulk-inserter`.
	local qualifier = preset:match("^inserter%-(.+)$")
	local name = qualifier and qualifier .. "-inserter" or "inserter"

	return {
		{ icon = "__reskins-assets-bobs__/graphics/icons/inserters/" .. name .. ".png", icon_size = 64, scale = 0.5 },
	}
end

return M
