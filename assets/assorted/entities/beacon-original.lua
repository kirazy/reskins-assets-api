---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Assorted.Entities

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local IconBuilderFactory = require("api.icon-builder-factory")
local BeaconExplosion = require("assets.base.explosions.beacon")

local M = {}

local FOLDER = _defines.assets_source.assorted_assets .. "/graphics/entity/beacon-original/beacon-original-"

---Gets the housing of the classic beacon for the given `tint`.
---@param tint? Color The color of the mask. When `nil`, the mask and highlights are omitted.
---@return AnimationElement
---@nodiscard
local function get_housing_animation_element(tint)
	---@type Animation[]
	local layers = {
		{
			filename = FOLDER .. "base.png",
			width = 232,
			height = 186,
			shift = util.by_pixel(11, 1.5),
			scale = 0.5,
		},
	}

	if tint then
		layers[#layers + 1] = {
			filename = FOLDER .. "mask.png",
			width = 232,
			height = 186,
			tint = tint,
			shift = util.by_pixel(11, 1.5),
			scale = 0.5,
		}
		layers[#layers + 1] = {
			filename = FOLDER .. "highlights.png",
			width = 232,
			height = 186,
			blend_mode = "additive",
			shift = util.by_pixel(11, 1.5),
			scale = 0.5,
		}
	end

	-- Shadows are always appended last.
	layers[#layers + 1] = {
		filename = FOLDER .. "base-shadow.png",
		width = 232,
		height = 186,
		draw_as_shadow = true,
		shift = util.by_pixel(11, 1.5),
		scale = 0.5,
	}

	---@type AnimationElement
	return {
		render_layer = "lower-object-above-shadow",
		always_draw = true,
		animation = { layers = layers },
	}
end

---Gets the antenna of the classic beacon.
---@return AnimationElement
---@nodiscard
local function get_antenna_animation_element()
	---@type AnimationElement
	return {
		render_layer = "object",
		always_draw = true,
		animation = {
			layers = {
				{
					filename = FOLDER .. "antenna.png",
					width = 108,
					height = 100,
					line_length = 8,
					frame_count = 32,
					animation_speed = 0.5,
					shift = util.by_pixel(-1, -55),
					scale = 0.5,
				},
				{
					filename = FOLDER .. "antenna-shadow.png",
					width = 126,
					height = 98,
					line_length = 8,
					frame_count = 32,
					animation_speed = 0.5,
					draw_as_shadow = true,
					shift = util.by_pixel(100.5, 15.5),
					scale = 0.5,
				},
			},
		},
	}
end

---Gets the water reflection of the classic beacon.
---@return WaterReflectionDefinition
---@nodiscard
local function get_water_reflection()
	return {
		pictures = {
			filename = FOLDER .. "reflection.png",
			priority = "extra-high",
			width = 24,
			height = 28,
			shift = util.by_pixel(0, 55),
			variation_count = 1,
			scale = 5,
		},
		rotate = false,
		orientation_to_variation = false,
	}
end

---Defines the options for the classic beacon sprite set.
---@class BeaconOriginalSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("BeaconOriginalSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for the classic beacon.
---
---The set draws no module slots, and the beacon shows its modules as icons.
---@param params BeaconOriginalSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<BeaconSpriteSet> # The sprite set definition for the classic beacon.
---
---#### Examples
---```lua
----- Apply the classic beacon sprite set to a beacon.
---local beacon = require("__reskins-assets-api__.assets.assorted.entities.beacon-original")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = beacon.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@throws When `params` defines an unrecognized field.
---@throws When `params.tint` is not a `Color`.
---@nodiscard
function M.get_sprite_set(params)
	check_get_sprite_set(params)

	---@type SpriteSetDefinition<BeaconSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.beacon_sprite_set,
		set = {
			graphics_set = {
				animation_list = {
					get_housing_animation_element(params.tint),
					get_antenna_animation_element(),
				},
				module_icons_suppressed = false,
			},
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = BeaconExplosion.get_explosion({
				tints = params.tint and { ["beacon-metal-particle-small"] = params.tint },
			}),
			corpse = _defines.generic_remnants,
			water_reflection = get_water_reflection(),
			drawing_box_vertical_extension = 0.7,
			nominal_width = 3,
			nominal_height = 3,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.assorted_assets .. "/graphics/icons" })

local icon_builder = icons:tinted("beacon-original")

---Gets the icon for the classic beacon, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the icon for the classic beacon as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
