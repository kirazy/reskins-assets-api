---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local IconBuilderFactory = require("api.icon-builder-factory")
local PumpExplosion = require("assets.base.explosions.pump")
local Remnants = require("assets.base.remnants")

local BASE_PATH = _defines.assets_source.base .. "/graphics/entity/pump/"
local ASSETS_PATH = _defines.assets_source.base_assets .. "/graphics/entity/pump/"

local M = {}

---Each direction of the pump artwork has a frame size, a shift for the body and shadow, and a shift for the mask and
---highlights.
---
---North mask/highlights have a different shift from the north base layer.
---@type table<"north"|"east"|"south"|"west", { width: integer, height: integer, shift: Vector, mask_shift: Vector }>
local frames = {
	north = { width = 103, height = 164, shift = util.by_pixel(8.25, -1), mask_shift = util.by_pixel(8, 3.5) },
	east = { width = 130, height = 109, shift = util.by_pixel(-0.5, 1.75), mask_shift = util.by_pixel(-0.5, 1.75) },
	south = { width = 114, height = 160, shift = util.by_pixel(12.5, -8), mask_shift = util.by_pixel(12.5, -8) },
	west = { width = 131, height = 111, shift = util.by_pixel(-0.25, 1.25), mask_shift = util.by_pixel(-0.25, 1.25) },
}

---Gets a layer of the pump animation for the given `frame`.
---@param filename string
---@param frame { width: integer, height: integer }
---@param shift Vector
---@return Animation
local function get_animation_layer(filename, frame, shift)
	return {
		filename = filename,
		width = frame.width,
		height = frame.height,
		scale = 0.5,
		line_length = 8,
		frame_count = 32,
		animation_speed = 0.5,
		shift = shift,
	}
end

---Gets the animation of the pump for the given `direction`.
---@param direction "north"|"east"|"south"|"west"
---@param tint? Color
---@return Animation
local function get_direction_animation(direction, tint)
	local frame = frames[direction]

	local shadow = get_animation_layer(BASE_PATH .. "pump-" .. direction .. "-shadow.png", frame, frame.shift)
	shadow.draw_as_shadow = true

	local layers = {
		get_animation_layer(BASE_PATH .. "pump-" .. direction .. ".png", frame, frame.shift),
		shadow,
	}

	if tint then
		local mask = get_animation_layer(ASSETS_PATH .. "pump-" .. direction .. "-mask.png", frame, frame.mask_shift)
		mask.tint = tint

		local highlights =
			get_animation_layer(ASSETS_PATH .. "pump-" .. direction .. "-highlights.png", frame, frame.mask_shift)
		highlights.blend_mode = "additive"

		layers[#layers + 1] = mask
		layers[#layers + 1] = highlights
	end

	return { layers = layers }
end

---Gets the animations of the pump.
---@param tint? Color
---@return Animation4Way
local function get_animations(tint)
	return {
		north = get_direction_animation("north", tint),
		east = get_direction_animation("east", tint),
		south = get_direction_animation("south", tint),
		west = get_direction_animation("west", tint),
	}
end

---Gets the animation of the fluid inside the pump.
---@return Animation4Way
local function get_fluid_animation()
	return {
		north = {
			filename = BASE_PATH .. "pump-north-liquid.png",
			apply_runtime_tint = true,
			width = 38,
			height = 22,
			scale = 0.5,
			line_length = 8,
			frame_count = 32,
			shift = util.by_pixel(-0.250, -16.750),
		},
		east = {
			filename = BASE_PATH .. "pump-east-liquid.png",
			width = 35,
			height = 46,
			scale = 0.5,
			line_length = 8,
			frame_count = 32,
			shift = util.by_pixel(6.25, -8.5),
		},
		south = {
			filename = BASE_PATH .. "pump-south-liquid.png",
			width = 38,
			height = 45,
			scale = 0.5,
			line_length = 8,
			frame_count = 32,
			shift = util.by_pixel(0.5, -9.25),
		},
		west = {
			filename = BASE_PATH .. "pump-west-liquid.png",
			width = 35,
			height = 47,
			scale = 0.5,
			line_length = 8,
			frame_count = 32,
			shift = util.by_pixel(-6.5, -9.5),
		},
	}
end

---Gets the glass pictures of the pump.
---@return Sprite4Way
local function get_glass_pictures()
	return {
		north = {
			filename = BASE_PATH .. "pump-north-glass.png",
			width = 64,
			height = 128,
			scale = 0.5,
		},
		east = {
			filename = BASE_PATH .. "pump-east-glass.png",
			width = 128,
			height = 192,
			scale = 0.5,
		},
		south = {
			filename = BASE_PATH .. "pump-south-glass.png",
			width = 64,
			height = 128,
			scale = 0.5,
		},
		west = {
			filename = BASE_PATH .. "pump-west-glass.png",
			width = 192,
			height = 192,
			scale = 0.5,
			shift = util.by_pixel(-16, 0),
		},
	}
end

---Gets the frozen patch of the pump, when the freezing feature is enabled and Space Age is loaded.
---@return Sprite4Way?
local function get_frozen_patch()
	if not (feature_flags["freezing"] and mods["space-age"]) then
		return nil
	end

	local filename = _defines.assets_source.space_age .. "/graphics/entity/frozen/pump/pump.png"

	return {
		north = { filename = filename, priority = "extra-high", width = 128, height = 192, scale = 0.5 },
		east = { filename = filename, priority = "extra-high", x = 128, width = 128, height = 128, scale = 0.5 },
		south = { filename = filename, priority = "extra-high", x = 256, width = 128, height = 192, scale = 0.5 },
		west = { filename = filename, priority = "extra-high", x = 384, width = 128, height = 128, scale = 0.5 },
	}
end

---Gets the circuit connector of the pump for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 24,
			main_offset = util.by_pixel(-15, -8.5),
			shadow_offset = util.by_pixel(0, -0.5),
			show_shadow = false,
		},
		{
			variation = 26,
			main_offset = util.by_pixel(-16, 3.5),
			shadow_offset = util.by_pixel(-14, 13.5),
			show_shadow = true,
		},
		{
			variation = 24,
			main_offset = util.by_pixel(-14.5, -8.5),
			shadow_offset = util.by_pixel(-12.5, 6),
			show_shadow = false,
		},
		{
			variation = 26,
			main_offset = util.by_pixel(13.5, 4.5),
			shadow_offset = util.by_pixel(-7, -12.5),
			show_shadow = true,
		},
	})
end

---Gets the graphics of the arm that connects the pump to a fluid wagon.
---@return PumpWagonConnectionGraphics
local function get_wagon_connection_graphics()
	return util.copy(require("__base__.prototypes.entity.pump-wagon-connector-graphics"))
end

---Gets the animation of the pump remnants.
---@param tint? Color
---@return RotatedAnimationVariations
local function get_corpse_animation(tint)
	local base_path = BASE_PATH .. "remnants/"
	local assets_path = ASSETS_PATH .. "remnants/"

	---@type RotatedAnimation
	local animation = {
		layers = {
			{
				filename = base_path .. "pump-remnants.png",
				line_length = 1,
				width = 188,
				height = 186,
				direction_count = 4,
				shift = util.by_pixel(2, 2),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "pump-remnants-mask.png",
			line_length = 1,
			width = 188,
			height = 186,
			direction_count = 4,
			shift = util.by_pixel(2, 2),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "pump-remnants-highlights.png",
			line_length = 1,
			width = 188,
			height = 186,
			direction_count = 4,
			shift = util.by_pixel(2, 2),
			blend_mode = "additive",
			scale = 0.5,
		})
	end

	return { animation }
end

---Defines the options for the pump sprite set.
---@class PumpSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("PumpSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for the pump.
---@param params PumpSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<PumpSpriteSet> # The sprite set definition for the pump.
---
---#### Examples
---```lua
---local pump = require("__reskins-assets-api__.assets.base.entities.pump")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = pump.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@throws When `params` defines an unrecognized field.
---@throws When `params.tint` is not a `Color`.
---@nodiscard
function M.get_sprite_set(params)
	check_get_sprite_set(params)

	---@type SpriteSetDefinition<PumpSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.pump_sprite_set,
		set = {
			animations = get_animations(params.tint),
			fluid_animation = get_fluid_animation(),
			glass_pictures = get_glass_pictures(),
			frozen_patch = get_frozen_patch(),
			circuit_connector = get_circuit_connector(),
			wagon_connection_graphics = get_wagon_connection_graphics(),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = PumpExplosion.get_explosion({
				tints = params.tint and { ["pump-metal-particle-medium"] = params.tint },
			}),
			corpse = Remnants.get_corpse("pump-remnants", { animation = get_corpse_animation(params.tint) }),
			water_reflection = nil,
			nominal_width = 1,
			nominal_height = 2,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-base__/graphics/icons" })

---Gets the icon for the pump, in the tints given by `params`.
M.get_icon = icons:tinted("pump"):build("get_icon")

return M
