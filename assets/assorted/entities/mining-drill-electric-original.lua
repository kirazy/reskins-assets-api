---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Assorted.Entities

local _defines = require("api.defines")

local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local IconCatalog = require("api.icon-catalog")

local M = {}

local FOLDER = "__reskins-assets-assorted__/graphics/entity/mining-drill-electric-original/"
	.. "mining-drill-electric-original-"

---The belt the drill unloads onto.
---@alias MiningDrillElectricOriginalBeltOutput
---| "blue" # The blue belt Bob's area drills unload onto.

local DIRECTIONS = { "north", "east", "south", "west" }

-- Every part is cut per direction, and every direction is cut to its own size.
local PARTS = {
	["north"] = {
		drill = { width = 196, height = 226, shift = util.by_pixel(0, -8) },
		drill_shadow = { width = 201, height = 223, shift = util.by_pixel(1.25, -7.25) },
		received_shadow = { width = 204, height = 206, shift = util.by_pixel(-0.5, -2) },
		patch = { width = 200, height = 222, shift = util.by_pixel(-0.5, -6.5) },
		patch_shadow = { width = 220, height = 197, shift = util.by_pixel(5, -0.25) },
		window = { width = 142, height = 107, shift = util.by_pixel(-1, 0.75) },
		fluid_background = { width = 138, height = 94, shift = util.by_pixel(-2, 0) },
		fluid_flow = { width = 136, height = 99, shift = util.by_pixel(-2.5, -0.75) },
	},
	["east"] = {
		drill = { width = 211, height = 197, shift = util.by_pixel(3.75, -1.25) },
		drill_shadow = { width = 221, height = 195, shift = util.by_pixel(6.25, -0.25) },
		received_shadow = { width = 204, height = 209, shift = util.by_pixel(-0.5, -1.25) },
		patch = { width = 200, height = 219, shift = util.by_pixel(0, -5.75) },
		patch_shadow = { width = 224, height = 198, shift = util.by_pixel(6, 0) },
		window = { width = 104, height = 147, shift = util.by_pixel(-11, -11.25) },
		fluid_background = { width = 84, height = 138, shift = util.by_pixel(-12, -11) },
		fluid_flow = { width = 82, height = 139, shift = util.by_pixel(-11.5, -11.25) },
	},
	["south"] = {
		drill = { width = 196, height = 219, shift = util.by_pixel(0, -1.25) },
		drill_shadow = { width = 200, height = 206, shift = util.by_pixel(1, 2.5) },
		received_shadow = { width = 204, height = 204, shift = util.by_pixel(-0.5, -2.5) },
		patch = { width = 200, height = 226, shift = util.by_pixel(-0.5, -7.5) },
		patch_shadow = { width = 220, height = 197, shift = util.by_pixel(5, -0.25) },
		window = { width = 141, height = 86, shift = util.by_pixel(-1.75, -29) },
		fluid_background = { width = 138, height = 80, shift = util.by_pixel(-2, -29) },
		fluid_flow = { width = 136, height = 80, shift = util.by_pixel(-2.5, -29.5) },
	},
	["west"] = {
		drill = { width = 211, height = 197, shift = util.by_pixel(-3.75, -0.75) },
		drill_shadow = { width = 229, height = 195, shift = util.by_pixel(1.25, -0.25) },
		received_shadow = { width = 198, height = 206, shift = util.by_pixel(1, -2) },
		patch = { width = 200, height = 220, shift = util.by_pixel(-0.5, -6) },
		patch_shadow = { width = 220, height = 197, shift = util.by_pixel(5, -0.25) },
		window = { width = 80, height = 137, shift = util.by_pixel(11.5, -11.25) },
		fluid_background = { width = 83, height = 137, shift = util.by_pixel(11.75, -10.75) },
		fluid_flow = { width = 83, height = 140, shift = util.by_pixel(10.75, -11) },
	},
}

---@param direction string
---@param name string The file the layer is drawn from, less the direction and the extension.
---@param part table The size and shift the direction cuts this part at.
---@param speed double
---@return Animation
---@nodiscard
local function get_drill_layer(direction, name, part, speed)
	---@type Animation
	return {
		priority = "high",
		filename = FOLDER .. direction .. name .. ".png",
		line_length = 8,
		width = part.width,
		height = part.height,
		frame_count = 64,
		animation_speed = speed,
		shift = part.shift,
		run_mode = "forward-then-backward",
		scale = 0.5,
	}
end

---@param direction string
---@param params MiningDrillElectricOriginalSpriteSetParams
---@param speed double
---@return Animation
---@nodiscard
local function get_direction_animation(direction, params, speed)
	local part = PARTS[direction]

	---@type Animation
	local animation = { layers = { get_drill_layer(direction, "-base", part.drill, speed) } }

	if params.belt_output then
		local belt = get_drill_layer(direction, "-base", part.drill, speed)

		belt.filename = FOLDER .. "belt-output-" .. params.belt_output .. "-" .. direction .. ".png"

		table.insert(animation.layers--[[@cast -?]], belt)
	end

	if params.tint then
		local mask = get_drill_layer(direction, "-mask", part.drill, speed)
		local highlights = get_drill_layer(direction, "-highlights", part.drill, speed)

		mask.tint = params.tint
		highlights.blend_mode = "additive-soft"

		table.insert(animation.layers--[[@cast -?]], mask)
		table.insert(animation.layers--[[@cast -?]], highlights)
	end

	-- Shadows are always appended last.
	local shadow = get_drill_layer(direction, "-drill-shadow", part.drill_shadow, speed)

	shadow.flags = { "shadow" }
	shadow.draw_as_shadow = true

	table.insert(animation.layers--[[@cast -?]], shadow)

	return animation
end

---@param params MiningDrillElectricOriginalSpriteSetParams
---@param speed double
---@return Animation4Way
---@nodiscard
local function get_animation(params, speed)
	---@type Animation4Way
	local animation = {}

	for _, direction in pairs(DIRECTIONS) do
		animation[direction] = get_direction_animation(direction, params, speed)
	end

	return animation
end

---@param name string The file the sprite is drawn from, less the direction and the extension.
---@param part_name string The key naming the size and shift in `PARTS`.
---@param speed double?
---@return Animation4Way
---@nodiscard
local function get_sprites(name, part_name, speed)
	---@type Animation4Way
	local sprites = {}

	for _, direction in pairs(DIRECTIONS) do
		local part = PARTS[direction][part_name]

		sprites[direction] = {
			priority = speed and "high" or "extra-high",
			filename = FOLDER .. direction .. name .. ".png",
			width = part.width,
			height = part.height,
			line_length = speed and 1 or nil,
			frame_count = 1,
			animation_speed = speed,
			shift = part.shift,
			scale = 0.5,
		}
	end

	return sprites
end

---@param speed double
---@return WorkingVisualisation[]
---@nodiscard
local function get_wet_working_visualisations(speed)
	local window = get_sprites("-window-background", "window")
	local fluid_background = get_sprites("-fluid-background", "fluid_background", speed)
	local fluid_flow = get_sprites("-fluid-flow", "fluid_flow", speed)
	local patch = get_sprites("-patch", "patch")
	local patch_shadow = get_sprites("-patch-shadow", "patch_shadow")

	---@type WorkingVisualisation
	local patch_frame = { always_draw = true }
	---@type WorkingVisualisation
	local received_shadow = { always_draw = true }

	for _, direction in pairs(DIRECTIONS) do
		patch_shadow[direction].flags = { "shadow" }
		patch_shadow[direction].draw_as_shadow = true

		local shadow = get_drill_layer(direction, "-drill-received-shadow", PARTS[direction].received_shadow, speed)

		shadow.tint = { r = 0.5, g = 0.5, b = 0.5, a = 0.5 }

		patch_frame[direction .. "_animation"] = { layers = { patch[direction], patch_shadow[direction] } }
		received_shadow[direction .. "_animation"] = shadow
	end

	---@type WorkingVisualisation[]
	return {
		{
			always_draw = true,
			north_animation = window.north,
			east_animation = window.east,
			south_animation = window.south,
			west_animation = window.west,
		},
		{
			always_draw = true,
			apply_tint = "input-fluid-base-color",
			north_animation = fluid_background.north,
			east_animation = fluid_background.east,
			south_animation = fluid_background.south,
			west_animation = fluid_background.west,
		},
		{
			always_draw = true,
			apply_tint = "input-fluid-flow-color",
			north_animation = fluid_flow.north,
			east_animation = fluid_flow.east,
			south_animation = fluid_flow.south,
			west_animation = fluid_flow.west,
		},
		patch_frame,
		received_shadow,
	}
end

---@class MiningDrillElectricOriginalSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?
---The belt the drill unloads onto. When `nil`, the drill unloads onto no belt of its own.
---@field belt_output MiningDrillElectricOriginalBeltOutput?
---The speed the drill's head strokes at. Defaults to `0.5`.
---@field animation_speed double?

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.shape({
			tint = Common.color:optional(),
			belt_output = V.one_of({ "blue" }):optional(),
			animation_speed = Common.positive_number:optional(),
		}),
	},
})

---Gets the sprite set for the classic electric mining drill.
---@param params MiningDrillElectricOriginalSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<MiningDrillSpriteSet>
---
---#### Examples
---```lua
---local drill = require("__reskins-assets-api__.assets.assorted.entities.mining-drill-electric-original")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = drill.get_sprite_set({ tint = tint, belt_output = "blue" })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set(params)
	check_get_sprite_set(params)

	local speed = params.animation_speed or 0.5

	---@type SpriteSetDefinition<MiningDrillSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.mining_drill_sprite_set,
		set = {
			graphics_set = {
				animation = get_animation(params, speed),
				circuit_connector_layer = "object",
			},
			graphics_set_flipped = nil,
			wet_mining_graphics_set = {
				animation = get_animation(params, speed),
				circuit_connector_layer = "object",
				working_visualisations = get_wet_working_visualisations(speed),
			},
			wet_mining_graphics_set_flipped = nil,
			radius_visualisation_picture = {
				filename = "__base__/graphics/entity/electric-mining-drill/electric-mining-drill-radius-visualization.png",
				width = 10,
				height = 10,
			},
			-- The drill draws the frame the fluid runs through itself, so the engine draws none.
			integration_patch = util.empty_sprite(),
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = nil,
			water_reflection = nil,
			nominal_width = 3,
			nominal_height = 3,
		},
	}

	return definition
end

local icons = IconCatalog:create({ folder = "__reskins-assets-assorted__/graphics/icons" })

---Gets the icon for the classic electric mining drill, in the tints given by `params`.
M.get_icon = icons:tinted("mining-drill-electric-original"):build("get_icon")

---Gets the icon for the classic area mining drill, in the tints given by `params`.
M.get_area_icon = icons
	:layers("mining-drill-electric-original")
	:base({ part = "area" })
	:mask()
	:highlights({ requires = "tint" })
	:build("get_area_icon")

return M
