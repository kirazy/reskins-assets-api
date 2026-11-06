---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")

local _sprites = require("__reskins-sprite-utils__.sprites")
local IconBuilderFactory = require("api.icon-builder-factory")
local TransportBeltExplosion = require("assets.base.explosions.transport-belt")
local Remnants = require("assets.base.remnants")

local M = {}

local BELT_PATH = "__reskins-assets-base__/graphics/entity/transport-belt/"

-- Each belt sprite sheet has the following number of frames.
local frame_counts = {
	[_defines.belt_sprites.standard] = 16,
	[_defines.belt_sprites.fast] = 32,
	[_defines.belt_sprites.turbo] = 64,
}

---Gets one layer of the belt animation for the given `belt_sprite`, from the sheet with the given `layer` suffix.
---@param belt_sprite BeltSprites
---@param layer "base"|"mask"|"highlights"
---@param tint? Color
---@param blend_mode? BlendMode
---@return RotatedAnimation
local function get_belt_layer(belt_sprite, layer, tint, blend_mode)
	return {
		filename = BELT_PATH .. "transport-belt-" .. belt_sprite .. "-" .. layer .. ".png",
		priority = "extra-high",
		width = 128,
		height = 128,
		frame_count = frame_counts[belt_sprite],
		direction_count = 20,
		tint = tint,
		blend_mode = blend_mode,
		scale = 0.5,
	}
end

---Gets the frozen patch of the belt for the given `belt_sprite`, or `nil` when the freezing feature is not active.
---@param belt_sprite BeltSprites
---@return RotatedSprite?
local function get_frozen_patch(belt_sprite)
	if not (feature_flags["freezing"] and mods["space-age"]) then
		return nil
	end

	return {
		filename = BELT_PATH .. "transport-belt-" .. belt_sprite .. "-frozen.png",
		priority = "extra-high",
		size = 128,
		scale = 0.5,
		line_length = 1,
		direction_count = 20,
	}
end

---Gets one layer of the belt reader from the base game, from the file with the given `name`.
---@param name string
---@param render_layer RenderLayer
---@return BeltReaderLayer
local function get_belt_reader_layer(name, render_layer)
	return {
		sprites = util.sprite_load("__base__/graphics/entity/transport-belt/" .. name, {
			priority = "low",
			scale = 0.5,
			frame_count = 4,
			direction_count = 4,
		}),
		render_layer = render_layer,
	}
end

---Gets the belt reader of the base game.
---@return BeltReaderLayer[]
local function get_belt_reader()
	return {
		get_belt_reader_layer("belt-reader-top", "object"),
		get_belt_reader_layer("belt-reader-base", "transport-belt-reader"),
		get_belt_reader_layer("belt-reader-middle", "floor-mechanics"),
		get_belt_reader_layer("belt-reader-under-middle", "transport-belt-endings"),
		get_belt_reader_layer("belt-reader-bottom", "floor"),
		get_belt_reader_layer("belt-reader-shadow", "floor"),
	}
end

---Gets the belt animation set for the given `tint` and `belt_sprite`.
---
---Every transport-belt-connectable entity of a tier uses the same belt animation set, including the splitter and the
---underground belt. The set has the belt reader of the base game, and the frozen patch of the belt when the freezing
---feature is active. The turbo belt sprites alternate.
---@param tint? Color The tint of the belt. When `nil`, the tintable layers are omitted from the set.
---@param belt_sprite BeltSprites The belt sprites.
---@return TransportBeltAnimationSetWithCorners # The animation set.
---@nodiscard
function M.get_belt_animation_set(tint, belt_sprite)
	local layers = { get_belt_layer(belt_sprite, "base") }

	if tint then
		layers[#layers + 1] = get_belt_layer(belt_sprite, "mask", tint)

		-- No highlights are drawn for the turbo belt sprites.
		if belt_sprite ~= _defines.belt_sprites.turbo then
			layers[#layers + 1] = get_belt_layer(belt_sprite, "highlights", nil, "additive")
		end
	end

	return {
		animation_set = { layers = layers },
		alternate = belt_sprite == _defines.belt_sprites.turbo,
		frozen_patch = get_frozen_patch(belt_sprite),
		belt_reader = get_belt_reader(),
	}
end

---@param tint? Color
---@return RotatedAnimationVariations
local function get_corpse_animation(tint)
	local assets_path = "__reskins-assets-base__/graphics/entity/transport-belt/"

	local layers = {
		{
			filename = assets_path .. "remnants/transport-belt-remnants-base.png",
			width = 106,
			height = 102,
			direction_count = 4,
			shift = util.by_pixel(1, -0.5),
			scale = 0.5,
		},
	}

	if tint then
		table.insert(layers, {
			filename = assets_path .. "remnants/transport-belt-remnants-mask.png",
			width = 106,
			height = 102,
			direction_count = 4,
			shift = util.by_pixel(1, -0.5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(layers, {
			filename = assets_path .. "remnants/transport-belt-remnants-highlights.png",
			width = 106,
			height = 102,
			direction_count = 4,
			shift = util.by_pixel(1, -0.5),
			blend_mode = "additive",
			scale = 0.5,
		})
	end

	return _sprites.make_rotated_animation_variations_from_spritesheet(2, { layers = layers })
end

---Gets the 7 circuit connectors of the transport belt, in the order X, H, V, SE, SW, NE, and NW.
---@return CircuitConnectorDefinition[]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(belt_connector_template, {
		{ variation = 0 },
		{ variation = 1 },
		{ variation = 2 },
		{ variation = 3 },
		{ variation = 4 },
		{ variation = 5 },
		{ variation = 6 },
	})
end

---Gets the frame drawn around the transport belt when it is connected to the circuit network.
---@return TransportBeltConnectorFrame
local function get_connector_frame_sprites()
	local template = belt_frame_connector_template

	---@type TransportBeltConnectorFrame
	return {
		frame_main = util.copy(template.frame_main),
		frame_shadow = util.copy(template.frame_shadow),
		frame_back_patch = util.copy(template.back_patch),
		frame_main_scanner = util.copy(template.frame_main_scanner),
		frame_main_scanner_movement_speed = 0.032258064516129,
		frame_main_scanner_horizontal_start_shift = { -0.25, -0.125 + 1 / 32 },
		frame_main_scanner_horizontal_end_shift = { 0.25, -0.125 + 1 / 32 },
		frame_main_scanner_horizontal_y_scale = 0.70,
		frame_main_scanner_horizontal_rotation = 0,
		frame_main_scanner_vertical_start_shift = { 0, -0.3125 },
		frame_main_scanner_vertical_end_shift = { 0, 0.1875 },
		frame_main_scanner_vertical_y_scale = 0.75,
		frame_main_scanner_vertical_rotation = 0.25,
		frame_main_scanner_cross_horizontal_start_shift = { -0.3125, -0.0625 },
		frame_main_scanner_cross_horizontal_end_shift = { 0.3125, -0.0625 },
		frame_main_scanner_cross_horizontal_y_scale = 0.60,
		frame_main_scanner_cross_horizontal_rotation = 0,
		frame_main_scanner_cross_vertical_start_shift = { 0, -0.3125 },
		frame_main_scanner_cross_vertical_end_shift = { 0, 0.1875 },
		frame_main_scanner_cross_vertical_y_scale = 0.75,
		frame_main_scanner_cross_vertical_rotation = 0.25,
		frame_main_scanner_nw_ne = {
			filename = "__base__/graphics/entity/transport-belt/connector/transport-belt-connector-frame-main-scanner-nw-ne.png",
			priority = "low",
			blend_mode = "additive",
			draw_as_glow = true,
			line_length = 8,
			width = 28,
			height = 24,
			frame_count = 32,
			shift = { -0.03125, -0.0625 },
		},
		frame_main_scanner_sw_se = {
			filename = "__base__/graphics/entity/transport-belt/connector/transport-belt-connector-frame-main-scanner-sw-se.png",
			priority = "low",
			blend_mode = "additive",
			draw_as_glow = true,
			line_length = 8,
			width = 29,
			height = 28,
			frame_count = 32,
			shift = { 0.015625, -0.09375 },
		},
	}
end

---Defines the options for the vanilla transport belt sprite set.
---@class TransportBeltSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color
---The belt artwork to use.
---@field belt_sprite BeltSprites

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("TransportBeltSpriteSetParams", {
			tint = Common.color:optional(),
			belt_sprite = V.one_of(_defines.belt_sprites),
		}):strict(),
	},
})

---Gets the sprite set for the vanilla transport belt.
---@param params TransportBeltSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<TransportBeltSpriteSet> # The sprite set definition for the vanilla transport belt.
---
---#### Examples
---```lua
---local transport_belt = require("__reskins-assets-api__.assets.base.entities.transport-belt")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = transport_belt.get_sprite_set({ tint = tint, belt_sprite = belt_sprite })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@throws When `params` defines an unrecognized field.
---@throws When `params.tint` is not a `Color`.
---@throws When `params.belt_sprite` is not a `BeltSprites`.
---@nodiscard
function M.get_sprite_set(params)
	check_get_sprite_set(params)

	---@type SpriteSetDefinition<TransportBeltSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.transport_belt_sprite_set,
		set = {
			belt_animation_set = M.get_belt_animation_set(params.tint, params.belt_sprite),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = TransportBeltExplosion.get_explosion({
				tints = params.tint and {
					["transport-belt-metal-particle-medium"] = params.tint,
					["transport-belt-metal-particle-small"] = params.tint,
				},
			}),
			corpse = Remnants.get_corpse("transport-belt-remnants", { animation = get_corpse_animation(params.tint) }),
			water_reflection = nil,
			circuit_connector = get_circuit_connector(),
			connector_frame_sprites = get_connector_frame_sprites(),
			nominal_width = 1,
			nominal_height = 1,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-base__/graphics/icons" })

local icon_builder = icons:tinted("transport-belt")

---Gets the icon for the vanilla transport belt, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the icon for the vanilla transport belt as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
