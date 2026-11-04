---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Entities

local _defines = require("api.defines")
local _pipes = require("assets.base.entities.pipe-pictures")

local IconBuilderFactory = require("api.icon-builder-factory")

local M = {}

---@param tint? Color
---@return StorageTankPictures
local function get_pictures(tint)
	local base_path = _defines.assets_source.base .. "/graphics/entity/storage-tank/"
	local pipe_path = _defines.assets_source.base .. "/graphics/entity/pipe/"
	local bobs_assets_path = _defines.assets_source.bobs_assets .. "/graphics/entity/storage-tank-all-corners/"

	local sheets = {
		{
			filename = bobs_assets_path .. "storage-tank-all-corners-base.png",
			priority = "extra-high",
			frames = 1,
			width = 219,
			height = 215,
			shift = util.by_pixel(-0.25, 3.75),
			scale = 0.5,
		},
	}

	if tint then
		table.insert(sheets, {
			filename = bobs_assets_path .. "storage-tank-all-corners-mask.png",
			priority = "extra-high",
			frames = 1,
			width = 219,
			height = 215,
			shift = util.by_pixel(-0.25, 3.75),
			tint = tint,
			scale = 0.5,
		})
		table.insert(sheets, {
			filename = bobs_assets_path .. "storage-tank-all-corners-highlights.png",
			priority = "extra-high",
			frames = 1,
			width = 219,
			height = 215,
			shift = util.by_pixel(-0.25, 3.75),
			blend_mode = "additive",
			scale = 0.5,
		})
	end

	table.insert(sheets, {
		filename = base_path .. "storage-tank-shadow.png",
		priority = "extra-high",
		frames = 2,
		width = 291,
		height = 153,
		shift = util.by_pixel(29.75, 22.25),
		scale = 0.5,
		draw_as_shadow = true,
	})

	---@type StorageTankPictures
	local pictures = {
		picture = { sheets = sheets },
		fluid_background = {
			filename = base_path .. "fluid-background.png",
			priority = "extra-high",
			width = 32,
			height = 15,
		},
		window_background = {
			filename = base_path .. "window-background.png",
			priority = "extra-high",
			width = 34,
			height = 48,
			scale = 0.5,
		},
		flow_sprite = {
			filename = pipe_path .. "fluid-flow-low-temperature.png",
			priority = "extra-high",
			width = 160,
			height = 20,
		},
		gas_flow = {
			filename = pipe_path .. "steam.png",
			priority = "extra-high",
			line_length = 10,
			width = 48,
			height = 30,
			frame_count = 60,
			animation_speed = 0.25,
			scale = 0.5,
		},
	}

	if feature_flags["freezing"] and mods["space-age"] then
		pictures.frozen_patch = {
			sheets = {
				{
					filename = bobs_assets_path .. "storage-tank-all-corners-frozen.png",
					priority = "extra-high",
					frames = 1,
					width = 219,
					height = 215,
					shift = util.by_pixel(-0.25, 3.75),
					scale = 0.5,
				},
			},
		}
	end

	return pictures
end

---@param tint? Color
---@return RotatedAnimation
local function get_corpse_animation(tint)
	local base_path = _defines.assets_source.base .. "/graphics/entity/storage-tank/remnants/"
	local assets_path = _defines.assets_source.base_assets .. "/graphics/entity/storage-tank/remnants/"

	---@type RotatedAnimation
	local animation = {
		layers = {
			{
				filename = base_path .. "storage-tank-remnants.png",
				width = 426,
				height = 282,
				shift = util.by_pixel(27, 21),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "storage-tank-remnants-mask.png",
			width = 426,
			height = 282,
			shift = util.by_pixel(27, 21),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "storage-tank-remnants-highlights.png",
			width = 426,
			height = 282,
			shift = util.by_pixel(27, 21),
			blend_mode = "additive",
			scale = 0.5,
		})
	end

	return animation
end

---@return WaterReflectionDefinition
local function get_water_reflection()
	return {
		pictures = {
			filename = "__base__/graphics/entity/storage-tank/storage-tank-reflection.png",
			priority = "extra-high",
			width = 24,
			height = 24,
			shift = util.by_pixel(5, 35),
			variation_count = 1,
			scale = 5,
		},
		rotate = false,
		orientation_to_variation = false,
	}
end

---Gets the circuit connector of the storage tank for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 27,
			main_offset = util.by_pixel(33.5, 18.5),
			shadow_offset = util.by_pixel(33.5, 18.5),
			show_shadow = false,
		},
		{
			variation = 25,
			main_offset = util.by_pixel(-33.5, 19.5),
			shadow_offset = util.by_pixel(-33.5, 19.5),
			show_shadow = false,
		},
		{
			variation = 27,
			main_offset = util.by_pixel(33.5, 18.5),
			shadow_offset = util.by_pixel(33.5, 18.5),
			show_shadow = false,
		},
		{
			variation = 25,
			main_offset = util.by_pixel(-33.5, 19.5),
			shadow_offset = util.by_pixel(-33.5, 19.5),
			show_shadow = false,
		},
	})
end

---Defines the options for the four-way storage tank sprite set.
---@class StorageTankAllCornersSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

---Gets the sprite set for the four-way storage tank.
---@param params StorageTankAllCornersSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<StorageTankSpriteSet> # The sprite set definition for the four-way storage tank.
---
---#### Examples
---```lua
---local storage_tank_all_corners = require("__reskins-assets-api__.assets.bobs.entities.storage-tank-all-corners")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = storage_tank_all_corners.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set(params)
	---@type SpriteSetDefinition<StorageTankSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.storage_tank_sprite_set,
		set = {
			pictures = get_pictures(params.tint),
			window_bounding_box = { { -0.125, 0.6875 }, { 0.1875, 1.1875 } },
			circuit_connector = get_circuit_connector(),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = { animation = get_corpse_animation(params.tint) },
			water_reflection = get_water_reflection(),
			nominal_width = 3,
			nominal_height = 3,
		},
	}

	return definition
end

local bobs_icons = IconBuilderFactory:create({ folder = "__reskins-assets-bobs__/graphics/icons" })

---Gets the icon for a storage tank with a connection on every corner, in the tints given by `params`.
M.get_icon = bobs_icons:tinted("storage-tank-all-corners"):build("get_icon")

return M
