---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local IconBuilderFactory = require("api.icon-builder-factory")
local OffshorePumpExplosion = require("assets.base.explosions.offshore-pump")
local Remnants = require("assets.base.remnants")

local BASE_PATH = _defines.assets_source.base .. "/graphics/entity/offshore-pump/"
local ASSETS_PATH = _defines.assets_source.base_assets .. "/graphics/entity/offshore-pump/"

local M = {}

---The name of each direction in the base game file names.
---@type table<"north"|"east"|"south"|"west", string>
local base_direction_names = {
	north = "North",
	east = "East",
	south = "South",
	west = "West",
}

---The frame size and shift of the body and the shadow in each direction of the offshore pump animation. The mask and
---highlights use the frame size and shift of the body.
---@type table<"north"|"east"|"south"|"west", { body: { width: integer, height: integer, shift: Vector }, shadow: { width: integer, height: integer, shift: Vector } }>
local frames = {
	north = {
		body = { width = 90, height = 162, shift = util.by_pixel(-1, -15) },
		shadow = { width = 150, height = 134, shift = util.by_pixel(13, -7) },
	},
	east = {
		body = { width = 124, height = 102, shift = util.by_pixel(15, -2) },
		shadow = { width = 180, height = 66, shift = util.by_pixel(27, 8) },
	},
	south = {
		body = { width = 92, height = 192, shift = util.by_pixel(-1, 0) },
		shadow = { width = 164, height = 128, shift = util.by_pixel(15, 23) },
	},
	west = {
		body = { width = 124, height = 102, shift = util.by_pixel(-15, -2) },
		shadow = { width = 172, height = 66, shift = util.by_pixel(-3, 8) },
	},
}

---Gets a layer of the offshore pump animation for the given `frame`.
---@param filename string
---@param frame { width: integer, height: integer, shift: Vector }
---@return Animation
local function get_animation_layer(filename, frame)
	return {
		filename = filename,
		priority = "high",
		line_length = 8,
		frame_count = 32,
		animation_speed = 0.25,
		width = frame.width,
		height = frame.height,
		shift = util.copy(frame.shift),
		scale = 0.5,
	}
end

---Gets the animation of the offshore pump for the given `direction`.
---@param direction "north"|"east"|"south"|"west"
---@param tint? Color
---@return Animation
local function get_direction_animation(direction, tint)
	local frame = frames[direction]
	local base_name = BASE_PATH .. "offshore-pump_" .. base_direction_names[direction]

	local shadow = get_animation_layer(base_name .. "-shadow.png", frame.shadow)
	shadow.draw_as_shadow = true

	local layers = {
		get_animation_layer(base_name .. ".png", frame.body),
		shadow,
	}

	if tint then
		local mask = get_animation_layer(ASSETS_PATH .. "offshore-pump-" .. direction .. "-mask.png", frame.body)
		mask.tint = tint

		local highlights =
			get_animation_layer(ASSETS_PATH .. "offshore-pump-" .. direction .. "-highlights.png", frame.body)
		highlights.blend_mode = "additive"

		layers[#layers + 1] = mask
		layers[#layers + 1] = highlights
	end

	return { layers = layers }
end

---Gets the animation of the offshore pump.
---@param tint? Color
---@return Animation4Way
local function get_animation(tint)
	return {
		north = get_direction_animation("north", tint),
		east = get_direction_animation("east", tint),
		south = get_direction_animation("south", tint),
		west = get_direction_animation("west", tint),
	}
end

---Gets the animation of the fluid inside the offshore pump.
---@return Animation4Way
local function get_fluid_animation()
	return {
		north = {
			filename = BASE_PATH .. "offshore-pump_North-fluid.png",
			apply_runtime_tint = true,
			line_length = 8,
			frame_count = 32,
			animation_speed = 0.25,
			width = 40,
			height = 40,
			shift = util.by_pixel(-1, -22),
			scale = 0.5,
		},
		east = {
			filename = BASE_PATH .. "offshore-pump_East-fluid.png",
			apply_runtime_tint = true,
			line_length = 8,
			frame_count = 32,
			animation_speed = 0.25,
			width = 38,
			height = 50,
			shift = util.by_pixel(6, -11),
			scale = 0.5,
		},
		south = {
			filename = BASE_PATH .. "offshore-pump_South-fluid.png",
			apply_runtime_tint = true,
			line_length = 8,
			frame_count = 32,
			animation_speed = 0.25,
			width = 36,
			height = 14,
			shift = util.by_pixel(-1, -4),
			scale = 0.5,
		},
		west = {
			filename = BASE_PATH .. "offshore-pump_West-fluid.png",
			apply_runtime_tint = true,
			line_length = 8,
			frame_count = 32,
			animation_speed = 0.25,
			width = 36,
			height = 50,
			shift = util.by_pixel(-7, -11),
			scale = 0.5,
		},
	}
end

---Gets the glass pictures of the offshore pump.
---@return Sprite4Way
local function get_glass_pictures()
	return {
		north = {
			filename = BASE_PATH .. "offshore-pump_North-glass.png",
			width = 36,
			height = 40,
			shift = util.by_pixel(-2, -22),
			scale = 0.5,
		},
		east = {
			filename = BASE_PATH .. "offshore-pump_East-glass.png",
			width = 30,
			height = 32,
			shift = util.by_pixel(5, -13),
			scale = 0.5,
		},
		south = {
			filename = BASE_PATH .. "offshore-pump_South-glass.png",
			width = 40,
			height = 24,
			shift = util.by_pixel(-1, -6),
			scale = 0.5,
		},
		west = {
			filename = BASE_PATH .. "offshore-pump_West-glass.png",
			width = 30,
			height = 32,
			shift = util.by_pixel(-6, -14),
			scale = 0.5,
		},
	}
end

---Gets the legs of the offshore pump.
---@return Sprite4Way
local function get_base_pictures()
	return {
		north = {
			filename = BASE_PATH .. "offshore-pump_North-legs.png",
			width = 114,
			height = 106,
			shift = util.by_pixel(-1, -5),
			scale = 0.5,
		},
		east = {
			filename = BASE_PATH .. "offshore-pump_East-legs.png",
			width = 106,
			height = 60,
			shift = util.by_pixel(4, 13),
			scale = 0.5,
		},
		south = {
			filename = BASE_PATH .. "offshore-pump_South-legs.png",
			width = 110,
			height = 108,
			shift = util.by_pixel(-2, 6),
			scale = 0.5,
		},
		west = {
			filename = BASE_PATH .. "offshore-pump_West-legs.png",
			width = 108,
			height = 64,
			shift = util.by_pixel(-6, 12),
			scale = 0.5,
		},
	}
end

---The frame size and shift of the underwater pictures in each direction.
---@type table<"north"|"east"|"south"|"west", { width: integer, height: integer, shift: Vector }>
local underwater_frames = {
	north = { width = 98, height = 36, shift = util.by_pixel(-1, -32) },
	east = { width = 40, height = 72, shift = util.by_pixel(39, 17) },
	south = { width = 98, height = 48, shift = util.by_pixel(-1, 49) },
	west = { width = 40, height = 72, shift = util.by_pixel(-40, 17) },
}

---Gets the underwater pictures of the offshore pump, with the file name for each direction from the given
---`get_filename`.
---@param get_filename fun(direction: "north"|"east"|"south"|"west"): string
---@return Sprite4Way
local function get_underwater_pictures(get_filename)
	local pictures = {}

	for direction, frame in pairs(underwater_frames) do
		pictures[direction] = {
			filename = get_filename(direction),
			width = frame.width,
			height = frame.height,
			shift = util.copy(frame.shift),
			scale = 0.5,
		}
	end

	return pictures
end

---Gets the file name of the underwater picture from the base game for the given `direction`.
---@param direction "north"|"east"|"south"|"west"
---@return string
local function get_base_underwater_filename(direction)
	return BASE_PATH .. "offshore-pump_" .. base_direction_names[direction] .. "-underwater.png"
end

---Gets the file name of the faded underwater picture for the given `direction`.
---@param direction "north"|"east"|"south"|"west"
---@return string
local function get_faded_underwater_filename(direction)
	return ASSETS_PATH .. "underwater/offshore-pump-" .. direction .. "-underwater.png"
end

---Gets the graphics set of the offshore pump.
---@param tint? Color
---@return OffshorePumpGraphicsSet
local function get_graphics_set(tint)
	return {
		underwater_layer_offset = 15,
		base_render_layer = "ground-patch",
		animation = get_animation(tint),
		fluid_animation = get_fluid_animation(),
		glass_pictures = get_glass_pictures(),
		base_pictures = get_base_pictures(),
		underwater_pictures = get_underwater_pictures(get_base_underwater_filename),
	}
end

---Gets the circuit connector of the offshore pump for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 24,
			main_offset = util.by_pixel(-16, -8.5),
			shadow_offset = util.by_pixel(-2, -0.5),
			show_shadow = false,
		},
		{
			variation = 26,
			main_offset = util.by_pixel(-7, 4.5),
			shadow_offset = util.by_pixel(-5, 14.5),
			show_shadow = true,
		},
		{
			variation = 16,
			main_offset = util.by_pixel(-13.5, -5.5),
			shadow_offset = util.by_pixel(-11.5, 9),
			show_shadow = false,
		},
		{
			variation = 26,
			main_offset = util.by_pixel(5.5, 4.5),
			shadow_offset = util.by_pixel(-15, -12.5),
			show_shadow = true,
		},
	})
end

---Gets the water reflection of the offshore pump.
---@return WaterReflectionDefinition
local function get_water_reflection()
	return {
		pictures = {
			filename = BASE_PATH .. "offshore-pump-reflection.png",
			priority = "extra-high",
			width = 132,
			height = 156,
			shift = util.by_pixel(0, 19),
			variation_count = 4,
			scale = 1,
		},
		rotate = false,
		orientation_to_variation = true,
	}
end

---The frame size and shift of each variation in the offshore pump remnants.
---@type { width: integer, height: integer, shift: Vector }[]
local corpse_frames = {
	{ width = 146, height = 140, shift = util.by_pixel(2, -2.5) },
	{ width = 136, height = 134, shift = util.by_pixel(1.5, 0.5) },
}

---Gets a layer of the offshore pump remnants for the given `frame`.
---@param filename string
---@param frame { width: integer, height: integer, shift: Vector }
---@return RotatedAnimation
local function get_corpse_layer(filename, frame)
	return {
		filename = filename,
		line_length = 1,
		width = frame.width,
		height = frame.height,
		direction_count = 4,
		shift = util.copy(frame.shift),
		scale = 0.5,
	}
end

---Gets the animation of the offshore pump remnants.
---@param tint? Color
---@return RotatedAnimationVariations
local function get_corpse_animation(tint)
	---@type RotatedAnimation[]
	local variations = {}

	for index, frame in pairs(corpse_frames) do
		local name = "offshore-pump-remnants-variation-" .. index

		local layers = {
			get_corpse_layer(BASE_PATH .. "remnants/" .. name .. ".png", frame),
		}

		if tint then
			local mask = get_corpse_layer(ASSETS_PATH .. "remnants/" .. name .. "-mask.png", frame)
			mask.tint = tint

			local highlights = get_corpse_layer(ASSETS_PATH .. "remnants/" .. name .. "-highlights.png", frame)
			highlights.blend_mode = "additive"

			layers[#layers + 1] = mask
			layers[#layers + 1] = highlights
		end

		variations[index] = { layers = layers }
	end

	return variations
end

---Defines the options for the offshore pump sprite set.
---@class OffshorePumpSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("OffshorePumpSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for the offshore pump.
---@param params OffshorePumpSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<OffshorePumpSpriteSet> # The sprite set definition for the offshore pump.
---
---#### Examples
---```lua
----- Apply the tinted offshore pump sprite set to an offshore pump.
---local OffshorePump = require("__reskins-assets-api__.assets.base.entities.offshore-pump")
---local Applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = OffshorePump.get_sprite_set({ tint = tint })
---Applicators.apply_sprite_set(entity, sprite_set)
---```
---@throws When `params` defines an unrecognized field.
---@throws When `params.tint` is not a `Color`.
---@nodiscard
function M.get_sprite_set(params)
	check_get_sprite_set(params)

	---@type SpriteSetDefinition<OffshorePumpSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.offshore_pump_sprite_set,
		set = {
			graphics_set = get_graphics_set(params.tint),
			circuit_connector = get_circuit_connector(),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = OffshorePumpExplosion.get_explosion({
				tints = params.tint and { ["offshore-pump-metal-particle-small"] = params.tint },
			}),
			corpse = Remnants.get_corpse("offshore-pump-remnants", { animation = get_corpse_animation(params.tint) }),
			water_reflection = get_water_reflection(),
			nominal_width = 1.2,
			nominal_height = 1.98,
		},
	}

	return definition
end

---Gets the underwater pictures of the offshore pump in a version that fades to transparent with depth.
---
---An entity that has no `underwater_pictures`, such as an assembling machine, draws these pictures above the water.
---The pictures use the frame size and shift of the `underwater_pictures` in the sprite set.
---@return Sprite4Way # The faded underwater pictures.
---
---#### Examples
---```lua
----- Draw the faded underwater pictures above the water in an assembling machine.
---local OffshorePump = require("__reskins-assets-api__.assets.base.entities.offshore-pump")
---
---local pictures = OffshorePump.get_faded_underwater_pictures()
---table.insert(entity.graphics_set.working_visualisations, {
---    always_draw = true,
---    render_layer = "decorative",
---    north_animation = pictures.north,
---    east_animation = pictures.east,
---    south_animation = pictures.south,
---    west_animation = pictures.west,
---})
---```
---@nodiscard
function M.get_faded_underwater_pictures()
	return get_underwater_pictures(get_faded_underwater_filename)
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-base__/graphics/icons" })

local icon_builder = icons:tinted("offshore-pump")

---Gets the icon for the offshore pump, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the icon for the offshore pump as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
