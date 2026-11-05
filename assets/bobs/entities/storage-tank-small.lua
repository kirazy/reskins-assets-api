---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Entities

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local IconBuilderFactory = require("api.icon-builder-factory")
local StorageTankExplosion = require("assets.base.explosions.storage-tank")

local ASSETS_BOBS_PATH = _defines.assets_source.bobs_assets .. "/graphics/entity/storage-tank-small/"

local M = {}

---The variant of a small storage tank, which selects its artwork. The variant `"standard"` has a pipe connection on
---each side, and the variant `"inline"` has a pipe connection on two opposite sides.
---@alias StorageTankSmallVariant "standard"|"inline"

local StorageTankSmallVariant = V.one_of({ "standard", "inline" })

---The tint of the big metal particles in the dying explosion of the small storage tank.
---@type Color
local particle_tint = util.color("#b29270") --[[@as Color]]

---Gets the sprite of the small storage tank for the given `variant`.
---@param variant StorageTankSmallVariant
---@return Sprite4Way
local function get_picture(variant)
	local name = variant == "inline" and "storage-tank-small-inline" or "storage-tank-small"
	local frames = variant == "inline" and 2 or 1

	return {
		sheets = {
			{
				filename = ASSETS_BOBS_PATH .. name .. ".png",
				priority = "extra-high",
				frames = frames,
				width = 64,
				height = 128,
				shift = util.by_pixel(0, -16),
				scale = 0.5,
			},
			{
				filename = ASSETS_BOBS_PATH .. name .. "-shadow.png",
				priority = "extra-high",
				frames = frames,
				width = 128,
				height = 64,
				shift = util.by_pixel(16, 0),
				draw_as_shadow = true,
				scale = 0.5,
			},
		},
	}
end

---Gets the pictures of the small storage tank for the given `variant`.
---@param variant StorageTankSmallVariant
---@return StorageTankPictures
local function get_pictures(variant)
	return {
		picture = get_picture(variant),
		fluid_background = {
			filename = ASSETS_BOBS_PATH .. "storage-tank-small-fluid-background.png",
			priority = "extra-high",
			width = 5,
			height = 18,
		},
		window_background = {
			filename = ASSETS_BOBS_PATH .. "storage-tank-small-window-background.png",
			priority = "extra-high",
			width = 10,
			height = 36,
			scale = 0.5,
		},
		flow_sprite = {
			filename = ASSETS_BOBS_PATH .. "storage-tank-small-fluid-flow.png",
			priority = "extra-high",
			width = 160,
			height = 10,
		},
		gas_flow = {
			filename = ASSETS_BOBS_PATH .. "storage-tank-small-steam.png",
			priority = "extra-high",
			line_length = 10,
			width = 14,
			height = 30,
			frame_count = 60,
			animation_speed = 0.25,
			scale = 0.5,
		},
	}
end

---Gets the circuit connector of the small storage tank for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 27,
			main_offset = util.by_pixel(10, -18),
			shadow_offset = util.by_pixel(6, -16),
			show_shadow = false,
		},
		{
			variation = 25,
			main_offset = util.by_pixel(-10, -18),
			shadow_offset = util.by_pixel(-6, -16),
			show_shadow = false,
		},
		{
			variation = 27,
			main_offset = util.by_pixel(10, -18),
			shadow_offset = util.by_pixel(6, -16),
			show_shadow = false,
		},
		{
			variation = 25,
			main_offset = util.by_pixel(-10, -18),
			shadow_offset = util.by_pixel(-6, -16),
			show_shadow = false,
		},
	})
end

---Gets the water reflection of the small storage tank.
---@return WaterReflectionDefinition
local function get_water_reflection()
	return {
		pictures = {
			filename = ASSETS_BOBS_PATH .. "storage-tank-small-reflection.png",
			priority = "extra-high",
			width = 8,
			height = 24,
			shift = util.by_pixel(0, 45),
			variation_count = 1,
			scale = 5,
		},
		rotate = false,
		orientation_to_variation = false,
	}
end

---Defines the options for the small storage tank sprite set.
---@class StorageTankSmallSpriteSetParams
---The variant of the small storage tank, which selects its artwork.
---@field variant StorageTankSmallVariant

local check_get_sprite_set = V.signature("get_sprite_set", {
	{ "params", V.class("StorageTankSmallSpriteSetParams", { variant = StorageTankSmallVariant }):strict() },
})

---Gets the sprite set for the small storage tank.
---@param params StorageTankSmallSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<StorageTankSpriteSet> # The sprite set definition for the small storage tank.
---
---#### Examples
---```lua
---local storage_tank_small = require("__reskins-assets-api__.assets.bobs.entities.storage-tank-small")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = storage_tank_small.get_sprite_set({ variant = "inline" })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@throws When `params` defines an unrecognized field.
---@throws When `params.variant` is not one of `"standard"` or `"inline"`.
---@nodiscard
function M.get_sprite_set(params)
	check_get_sprite_set(params)

	---@type SpriteSetDefinition<StorageTankSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.storage_tank_sprite_set,
		set = {
			pictures = get_pictures(params.variant),
			window_bounding_box = { util.by_pixel(5.5, -21.5), util.by_pixel(10.5, -3.5) } --[[@as BoundingBox]],
			circuit_connector = get_circuit_connector(),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = StorageTankExplosion.get_explosion({
				tints = { ["storage-tank-metal-particle-big"] = util.copy(particle_tint) },
			}),
			corpse = _defines.generic_remnants,
			water_reflection = get_water_reflection(),
			nominal_width = 1,
			nominal_height = 1,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-bobs__/graphics/icons" })

local VARIANTS = { "standard", "inline" }

---Gets the builder of the icon of the small storage tank of the given `variant`.
---@param variant StorageTankSmallVariant
---@return IconBuilder<{ base_tint?: Color }>
local function get_icon_builder(variant)
	if variant == "inline" then
		return icons:layers("storage-tank-small"):stem("storage-tank-small-inline"):base()
	end

	return icons:layers("storage-tank-small"):base()
end

---Gets the icon for the small storage tank of the `variant` given by `params`.
M.get_icon = IconBuilderFactory.dispatch("variant", VARIANTS, "get_icon", get_icon_builder)

---Gets the icon for the small storage tank of the `variant` given by `params`, as an `IconComposition`.
M.get_icon_composition =
	IconBuilderFactory.dispatch_composition("variant", VARIANTS, "get_icon_composition", get_icon_builder)

return M
