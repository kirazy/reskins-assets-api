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
local SplitterExplosion = require("assets.base.explosions.splitter")

local M = {}

local FOLDER = _defines.assets_source.assorted_assets
	.. "/graphics/entity/vanilla-loader-1x2/vanilla-loader-1x2-structure-"

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
		width = 212,
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
---@param y integer
---@return Sprite4Way
local function get_direction(tint, y)
	local sheets = { get_sheet("base", y) }

	if tint then
		sheets[#sheets + 1] = get_sheet("mask", y, { tint = tint })
		sheets[#sheets + 1] = get_sheet("highlights", y, { blend_mode = "additive" })
	end

	sheets[#sheets + 1] = get_sheet("shadow", y, { draw_as_shadow = true })

	return { sheets = sheets }
end

---Gets the structure of the loader for the given `tint`.
---@param tint? Color
---@return LoaderStructure
local function get_structure(tint)
	return {
		direction_in = get_direction(tint, 0),
		direction_out = get_direction(tint, 192),
		back_patch = { sheet = get_sheet("back-patch", 0) },
		front_patch = { sheet = get_sheet("front-patch", 0) },
	}
end

---Defines the options for the 1 x 2 vanilla loader sprite set.
---@class VanillaLoader1x2SpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color
---The belt artwork to use.
---@field belt_sprite BeltSprites

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("VanillaLoader1x2SpriteSetParams", {
			tint = Common.color:optional(),
			belt_sprite = V.one_of(_defines.belt_sprites),
		}):strict(),
	},
})

---Gets the sprite set for the 1 x 2 vanilla loader.
---
---The loader takes the belt animation set of the transport belt for the given `params`, the corpse `small-remnants`,
---and the dying explosion of the vanilla splitter with its medium and big metal particles in `params.tint`.
---@param params VanillaLoader1x2SpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<LoaderSpriteSet> # The sprite set definition for the 1 x 2 vanilla loader.
---
---#### Examples
---```lua
----- Apply the 1 x 2 vanilla loader sprite set to a loader.
---local vanilla_loader = require("__reskins-assets-api__.assets.assorted.entities.vanilla-loader-1x2")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = vanilla_loader.get_sprite_set({ tint = tint, belt_sprite = belt_sprite })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@throws When `params` defines an unrecognized field.
---@throws When `params.tint` is not a `Color`.
---@throws When `params.belt_sprite` is not a `BeltSprites`.
---@nodiscard
function M.get_sprite_set(params)
	check_get_sprite_set(params)

	---@type SpriteSetDefinition<LoaderSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.loader_sprite_set,
		set = {
			belt_animation_set = TransportBelt.get_belt_animation_set(params.tint, params.belt_sprite),
			structure = get_structure(params.tint),
			structure_render_layer = "object",
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = SplitterExplosion.get_explosion({
				tints = params.tint and {
					["splitter-metal-particle-medium"] = params.tint,
					["splitter-metal-particle-big"] = params.tint,
				},
			}),
			corpse = "small-remnants",
			water_reflection = nil,
			nominal_width = 1,
			nominal_height = 2,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-assorted__/graphics/icons" })

---Gets the icon for the 1 x 2 vanilla loader, in the tints given by `params`.
M.get_icon = icons:tinted("vanilla-loader-1x2"):build("get_icon")

return M
