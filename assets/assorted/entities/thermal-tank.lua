---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Assorted.Entities

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local IconBuilderFactory = require("api.icon-builder-factory")
local StorageTankExplosion = require("assets.base.explosions.storage-tank")

local M = {}

local FOLDER = _defines.assets_source.assorted_assets .. "/graphics/entity/thermal-tank/thermal-tank-"
local NULLIUS_PATH = "__nullius__/graphics/entity/thermaltank/"

---Gets the picture of the thermal tank for the given `tint`.
---@param tint? Color The color of the mask. When `nil`, the mask and highlights are omitted.
---@return Sprite
---@nodiscard
local function get_picture(tint)
	---@type Sprite[]
	local layers = {
		{
			filename = FOLDER .. "base.png",
			priority = "extra-high",
			width = 180,
			height = 180,
			shift = { 0.3, -0.3 },
			scale = 0.73,
		},
	}

	if tint then
		layers[#layers + 1] = {
			filename = FOLDER .. "mask.png",
			priority = "extra-high",
			width = 180,
			height = 180,
			shift = { 0.3, -0.3 },
			tint = tint,
			scale = 0.73,
		}
		layers[#layers + 1] = {
			filename = FOLDER .. "highlights.png",
			priority = "extra-high",
			width = 180,
			height = 180,
			shift = { 0.3, -0.3 },
			blend_mode = "additive",
			scale = 0.73,
		}
	end

	-- Shadows are always appended last.
	layers[#layers + 1] = {
		filename = NULLIUS_PATH .. "thermaltank-shadow.png",
		priority = "extra-high",
		width = 230,
		height = 180,
		shift = { 0.3, -0.3 },
		draw_as_shadow = true,
		scale = 0.73,
	}

	---@type Sprite
	return { layers = layers }
end

---Defines the options for the thermal tank sprite set.
---@class ThermalTankSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("ThermalTankSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for the thermal tank, a reactor that stores heat.
---
---The shadow layer is drawn from `__nullius__`, so the set can be applied only when Nullius is loaded. The set draws
---the picture of the reactor and has no connection patches or working light.
---@param params ThermalTankSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<ReactorSpriteSet> # The sprite set definition for the thermal tank.
---
---#### Examples
---```lua
----- Draw the thermal tank as the picture of a reactor.
---local thermal_tank = require("__reskins-assets-api__.assets.assorted.entities.thermal-tank")
---
---local sprite_set = thermal_tank.get_sprite_set({ tint = tint })
---reactor.picture = util.copy(sprite_set.set.graphics_set.picture)
---```
---@throws When `params` defines an unrecognized field.
---@throws When `params.tint` is not a `Color`.
---@nodiscard
function M.get_sprite_set(params)
	check_get_sprite_set(params)

	---@type SpriteSetDefinition<ReactorSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.reactor_sprite_set,
		set = {
			---@diagnostic disable-next-line: missing-fields
			graphics_set = {
				picture = get_picture(params.tint),
			},
			use_fuel_glow_color = false,
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = StorageTankExplosion.get_explosion({
				tints = params.tint and {
					["storage-tank-metal-particle-big"] = params.tint,
					["storage-tank-metal-particle-medium"] = params.tint,
				},
			}),
			corpse = _defines.generic_remnants,
			water_reflection = nil,
			nominal_width = 3,
			nominal_height = 3,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.assorted_assets .. "/graphics/icons" })

local icon_builder = icons:tinted("thermal-tank")

---Gets the icon for the thermal tank, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the icon for the thermal tank as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
