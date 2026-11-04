---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Assorted.Entities

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local IconBuilderFactory = require("api.icon-builder-factory")
local TransportBelt = require("assets.base.entities.transport-belt")

local M = {}

local FOLDER = _defines.assets_source.assorted_assets .. "/graphics/entity/vanilla-loader-1x1/vanilla-loader-1x1-"

---Gets one sheet of the loader structure, from the file with the given `suffix`, at the row of the sheet at the given
---`y`.
---@param suffix string The suffix of the file name of the sheet.
---@param y integer The vertical position of the row in the sheet, in pixels.
---@param fields? table The other fields of the sheet.
---@return SpriteSheet
local function get_sheet(suffix, y, fields)
	local sheet = {
		filename = FOLDER .. suffix .. ".png",
		priority = "extra-high",
		width = 192,
		height = 192,
		y = y,
		scale = 0.5,
	}

	for key, value in pairs(fields or {}) do
		sheet[key] = value
	end

	return sheet
end

---Gets the structure of the loader in one direction, from the row of the sheets at the given `y`.
---@param tint? Color
---@param is_filter boolean
---@param y integer
---@return Sprite4Way
local function get_direction(tint, is_filter, y)
	local sheets = { get_sheet(is_filter and "filter-structure-base" or "structure-base", y) }

	if tint then
		sheets[#sheets + 1] = get_sheet("structure-mask", y, { tint = tint })
		sheets[#sheets + 1] = get_sheet("structure-highlights", y, { blend_mode = "additive" })
	end

	sheets[#sheets + 1] = get_sheet("structure-shadow", y, { draw_as_shadow = true })

	return { sheets = sheets }
end

---Defines the options for the 1 x 1 vanilla loader sprite set.
---@class VanillaLoader1x1SpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color
---The belt artwork to use.
---@field belt_sprite BeltSprites
---When `true`, indicates that the loader draws the structure of a filter loader. Default `false`.
---@field is_filter? boolean

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("VanillaLoader1x1SpriteSetParams", {
			tint = Common.color:optional(),
			belt_sprite = V.one_of(_defines.belt_sprites),
			is_filter = V.boolean():optional(),
		}):strict(),
	},
})

---Gets the sprite set for the 1 x 1 vanilla loader.
---
---The loader takes the belt animation set of the transport belt for the given `params`. The corpse of the loader is not
---modified.
---@param params VanillaLoader1x1SpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<LoaderSpriteSet> # The sprite set definition for the 1 x 1 vanilla loader.
---
---#### Examples
---```lua
----- Apply the 1 x 1 vanilla loader sprite set to a filter loader.
---local vanilla_loader = require("__reskins-assets-api__.assets.assorted.entities.vanilla-loader-1x1")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = vanilla_loader.get_sprite_set({ tint = tint, belt_sprite = belt_sprite, is_filter = true })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@throws When `params` defines an unrecognized field.
---@throws When `params.tint` is not a `Color`.
---@throws When `params.belt_sprite` is not a `BeltSprites`.
---@throws When `params.is_filter` is not a boolean.
---@nodiscard
function M.get_sprite_set(params)
	check_get_sprite_set(params)

	local is_filter = params.is_filter == true

	---@type SpriteSetDefinition<LoaderSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.loader_sprite_set,
		set = {
			belt_animation_set = TransportBelt.get_belt_animation_set(params.tint, params.belt_sprite),
			structure = {
				direction_in = get_direction(params.tint, is_filter, 0),
				direction_out = get_direction(params.tint, is_filter, 192),
			},
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = nil,
			water_reflection = nil,
			nominal_width = 1,
			nominal_height = 1,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-assorted__/graphics/icons" })

---Gets the icon for the 1 x 1 vanilla loader, in the tints given by `params`.
M.get_icon = icons:tinted("vanilla-loader-1x1"):build("get_icon")

---Gets the icon for the 1 x 1 vanilla filter loader, in the tints given by `params`.
M.get_filter_icon = icons
	:layers("vanilla-loader-1x1")
	:base({ part = "filter" })
	:mask()
	:highlights({ requires = "tint" })
	:build("get_filter_icon")

return M
