---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Assorted.Entities

local _defines = require("api.defines")

local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")

local _sprites = require("__reskins-sprite-utils__.sprites")

local ENTITY_FOLDER = "__reskins-assets-assorted__/graphics/entity/mining-drill-electric-tall/"
local FOLDER = ENTITY_FOLDER .. "mining-drill-electric-tall-"
local ICON_FOLDER = "__reskins-assets-assorted__/graphics/icons/mining-drill-electric-tall/"
	.. "mining-drill-electric-tall-"

local M = {}

---The housing the drill is built into.
---@alias MiningDrillElectricTallFrame
---| "yellow" # The yellow housing the semi-classic drill is built into.
---| "blue" # The blue housing the semi-classic area drills are built into.

---@param frame MiningDrillElectricTallFrame
---@param part string The part, named for its direction and role, as `"north-wet"`.
---@return FileName
---@nodiscard
local function get_frame_file(frame, part)
	return ENTITY_FOLDER .. "frame-" .. frame .. "/mining-drill-electric-tall-" .. part .. ".png"
end

-- stylua: ignore
local ANIMATION_SEQUENCE = {
	1, 1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
	21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
	21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
	21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
	21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
	21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
	21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
	21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
	21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
	21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
	21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
	21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
	21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
	21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
	21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
	21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
	21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 1, 1,
}

-- stylua: ignore
local SHADOW_SEQUENCE = {
	1, 1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
	21, 21, 21, 21, 21, 21, 21, 21, 21, 21,
	21, 21, 21, 21, 21, 21, 21, 21, 21, 21,
	21, 21, 21, 21, 21, 21, 21, 21, 21, 21,
	21, 21, 21, 21, 21, 21, 21, 21, 21, 21,
	21, 21, 21, 21, 21, 21, 21, 21, 21, 21,
	21, 21, 21, 21, 21, 21, 21, 21, 21, 21,
	21, 21, 21, 21, 21, 21, 21, 21, 21, 21,
	21, 21, 21, 21, 21, 21, 21, 21, 21, 21,
	21, 21, 21, 21, 21, 21, 21, 21, 21, 21,
	21, 21, 21, 21, 21, 21, 21, 21, 21, 21,
	21, 21, 21, 21, 21, 21, 21, 21, 21, 21,
	21, 21, 21, 21, 21, 21, 21, 21, 21, 21,
	21, 21, 21, 21, 21, 21, 21, 21, 21, 21,
	21, 21, 21, 21, 21, 21, 21, 21, 21, 21,
	21, 21, 21, 21, 21, 21, 21, 21, 21, 21,
	21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 1, 1,
}

---@param tint Color?
---@param speed double
---@return Animation
---@nodiscard
local function get_vertical_drill_animation(tint, speed)
	---@type Animation
	local animation = {
		layers = {
			{
				priority = "high",
				filename = ENTITY_FOLDER .. "mining-drill-electric-tall.png",
				line_length = 6,
				width = 194,
				height = 154,
				frame_count = 30,
				animation_speed = speed,
				frame_sequence = ANIMATION_SEQUENCE,
				shift = util.by_pixel(0, -21),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			priority = "high",
			filename = FOLDER .. "mask.png",
			line_length = 6,
			width = 194,
			height = 154,
			frame_count = 30,
			animation_speed = speed,
			frame_sequence = ANIMATION_SEQUENCE,
			shift = util.by_pixel(0, -21),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			priority = "high",
			filename = FOLDER .. "highlights.png",
			line_length = 6,
			width = 194,
			height = 154,
			frame_count = 30,
			animation_speed = speed,
			frame_sequence = ANIMATION_SEQUENCE,
			shift = util.by_pixel(0, -21),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	-- Shadows are always appended last.
	table.insert(animation.layers--[[@cast -?]], {
		priority = "high",
		filename = FOLDER .. "shadow.png",
		line_length = 7,
		width = 232,
		height = 50,
		frame_count = 21,
		animation_speed = speed,
		frame_sequence = SHADOW_SEQUENCE,
		draw_as_shadow = true,
		shift = util.by_pixel(49, 7),
		scale = 0.5,
	})

	return animation
end

---@param tint Color?
---@param speed double
---@param is_front boolean When `true`, draws the half of the head that stands in front of the housing.
---@return Animation
---@nodiscard
local function get_horizontal_drill_animation(tint, speed, is_front)
	local name = is_front and "horizontal-front" or "horizontal"
	local width = is_front and 54 or 104
	local height = is_front and 136 or 178
	local shift = is_front and util.by_pixel(14, -23) or util.by_pixel(-3, -27)

	---@type Animation
	local animation = {
		layers = {
			{
				priority = "high",
				filename = FOLDER .. name .. ".png",
				line_length = 6,
				width = width,
				height = height,
				frame_count = 30,
				animation_speed = speed,
				frame_sequence = ANIMATION_SEQUENCE,
				shift = shift,
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			priority = "high",
			filename = FOLDER .. name .. "-mask.png",
			line_length = 6,
			width = width,
			height = height,
			frame_count = 30,
			animation_speed = speed,
			frame_sequence = ANIMATION_SEQUENCE,
			shift = shift,
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			priority = "high",
			filename = FOLDER .. name .. "-highlights.png",
			line_length = 6,
			width = width,
			height = height,
			frame_count = 30,
			animation_speed = speed,
			frame_sequence = ANIMATION_SEQUENCE,
			shift = shift,
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	-- Shadows are always appended last. Both halves of the head cast the one shadow.
	table.insert(animation.layers--[[@cast -?]], {
		priority = "high",
		filename = FOLDER .. "horizontal-shadow.png",
		line_length = 7,
		width = 236,
		height = 138,
		frame_count = 21,
		animation_speed = speed,
		frame_sequence = SHADOW_SEQUENCE,
		draw_as_shadow = true,
		shift = util.by_pixel(48, 5),
		scale = 0.5,
	})

	return animation
end

---@param name string The file the smoke is drawn from, less the folder and the extension.
---@param width SpriteSizeType
---@param height SpriteSizeType
---@param shift Vector
---@param speed double
---@return Animation
---@nodiscard
local function get_directional_smoke(name, width, height, shift, speed)
	return {
		layers = {
			{
				priority = "high",
				filename = FOLDER .. name .. "-smoke.png",
				line_length = 5,
				width = width,
				height = height,
				frame_count = 10,
				animation_speed = speed,
				shift = shift,
				scale = 0.5,
			},
		},
	}
end

---@param name string The file the light is drawn from, less the folder and the extension.
---@param width SpriteSizeType
---@param height SpriteSizeType
---@param shift Vector
---@return Animation
---@nodiscard
local function get_light(name, width, height, shift)
	return {
		filename = FOLDER .. name .. "-light.png",
		width = width,
		height = height,
		tint = { 1, 1, 1 },
		draw_as_glow = true,
		shift = shift,
		scale = 0.5,
	}
end

---@return WorkingVisualisation
---@nodiscard
local function get_status_leds()
	---@type WorkingVisualisation
	return {
		apply_tint = "status",
		always_draw = true,
		north_animation = get_light("north", 30, 32, util.by_pixel(26, -69)),
		east_animation = get_light("east", 32, 34, util.by_pixel(41, -45)),
		south_animation = get_light("south", 32, 30, util.by_pixel(26, 10)),
		west_animation = get_light("west", 32, 34, util.by_pixel(-42, -45)),
	}
end

---@return WorkingVisualisation
---@nodiscard
local function get_secondary_light()
	---@type WorkingVisualisation
	return {
		always_draw = true,
		apply_tint = "status",
		light = { intensity = 0.2, size = 2, color = { r = 1, g = 1, b = 1 }, minimum_darkness = 0.1 },
		north_position = { 0.8, -1.5 },
		east_position = { 1.2, -1 },
		south_position = { 0.8, 0.8 },
		west_position = { -1.2, -1 },
	}
end

---@param name string The file the fluid layer is drawn from, less the folder and the extension.
---@param width SpriteSizeType
---@param height SpriteSizeType
---@param shift Vector
---@param speed double
---@return Animation
---@nodiscard
local function get_fluid_layer(name, width, height, shift, speed)
	return {
		layers = {
			{
				priority = "high",
				filename = FOLDER .. name .. ".png",
				width = width,
				height = height,
				animation_speed = speed,
				shift = shift,
				scale = 0.5,
			},
		},
	}
end

---@param frame MiningDrillElectricTallFrame
---@param part string The part, named for its direction and role.
---@param width SpriteSizeType
---@param height SpriteSizeType
---@param shift Vector
---@param speed double
---@return Animation
---@nodiscard
local function get_frame_layer(frame, part, width, height, shift, speed)
	return {
		priority = "high",
		filename = get_frame_file(frame, part),
		width = width,
		height = height,
		animation_speed = speed,
		repeat_count = 5,
		shift = shift,
		scale = 0.5,
	}
end

---The halves of the housing that stand in front of the head, which do not repeat with its stroke.
---@param frame MiningDrillElectricTallFrame
---@param part string The part, named for its direction and role.
---@param width SpriteSizeType
---@param height SpriteSizeType
---@param shift Vector
---@param speed double
---@return Animation
---@nodiscard
local function get_frame_front_layer(frame, part, width, height, shift, speed)
	return {
		priority = "high",
		filename = get_frame_file(frame, part),
		width = width,
		height = height,
		animation_speed = speed,
		shift = shift,
		scale = 0.5,
	}
end

---@param name string The file the output is drawn from, less the folder and the extension.
---@param width SpriteSizeType
---@param height SpriteSizeType
---@param shift Vector
---@param speed double
---@return Animation
---@nodiscard
local function get_output_layer(name, width, height, shift, speed)
	return {
		priority = "high",
		filename = FOLDER .. name .. "-output.png",
		line_length = 5,
		width = width,
		height = height,
		frame_count = 5,
		animation_speed = speed,
		shift = shift,
		scale = 0.5,
	}
end

---@param frame MiningDrillElectricTallFrame
---@param part string The part, named for its direction and role.
---@param width SpriteSizeType
---@param height SpriteSizeType
---@param shift Vector
---@param speed double
---@return Animation
---@nodiscard
local function get_frame_output_layer(frame, part, width, height, shift, speed)
	return {
		priority = "high",
		filename = get_frame_file(frame, part),
		line_length = 5,
		width = width,
		height = height,
		frame_count = 5,
		animation_speed = speed,
		shift = shift,
		scale = 0.5,
	}
end

---@param name string The file the shadow is drawn from, less the folder and the extension.
---@param width SpriteSizeType
---@param height SpriteSizeType
---@param shift Vector
---@param speed double
---@return Animation
---@nodiscard
local function get_housing_shadow(name, width, height, shift, speed)
	return {
		priority = "high",
		filename = FOLDER .. name .. "-shadow.png",
		width = width,
		height = height,
		animation_speed = speed,
		draw_as_shadow = true,
		repeat_count = 5,
		shift = shift,
		scale = 0.5,
	}
end

---@param frame MiningDrillElectricTallFrame
---@param speed double
---@return Animation4Way
---@nodiscard
local function get_dry_animation(frame, speed)
	---@type Animation4Way
	return {
		north = {
			layers = {
				get_frame_layer(frame, "north", 194, 242, util.by_pixel(0, -12), speed),
				get_frame_output_layer(frame, "north-output", 72, 66, util.by_pixel(-1, -44), speed),
				get_housing_shadow("north", 274, 206, util.by_pixel(19, -3), speed),
			},
		},
		east = {
			layers = {
				get_frame_layer(frame, "east", 194, 94, util.by_pixel(0, -33), speed),
				get_output_layer("east", 50, 56, util.by_pixel(30, -11), speed),
				get_housing_shadow("east", 276, 170, util.by_pixel(20, 6), speed),
			},
		},
		south = {
			layers = {
				get_frame_layer(frame, "south", 194, 240, util.by_pixel(0, -7), speed),
				get_housing_shadow("south", 274, 204, util.by_pixel(19, 2), speed),
			},
		},
		west = {
			layers = {
				get_frame_layer(frame, "west", 194, 94, util.by_pixel(0, -33), speed),
				get_output_layer("west", 50, 56, util.by_pixel(-31, -12), speed),
				get_housing_shadow("west", 282, 170, util.by_pixel(15, 6), speed),
			},
		},
	}
end

---@param frame MiningDrillElectricTallFrame
---@param speed double
---@return Animation4Way
---@nodiscard
local function get_wet_animation(frame, speed)
	---@type Animation4Way
	return {
		north = {
			layers = {
				get_frame_layer(frame, "north-wet", 194, 242, util.by_pixel(0, -12), speed),
				get_frame_output_layer(frame, "north-output", 72, 66, util.by_pixel(-1, -44), speed),
				get_housing_shadow("north-wet", 276, 222, util.by_pixel(19, 1), speed),
			},
		},
		east = {
			layers = {
				get_frame_layer(frame, "east-wet", 194, 94, util.by_pixel(0, -33), speed),
				get_output_layer("east", 50, 56, util.by_pixel(30, -11), speed),
				get_housing_shadow("east-wet", 276, 194, util.by_pixel(20, 8), speed),
			},
		},
		south = {
			layers = {
				get_frame_layer(frame, "south-wet", 194, 240, util.by_pixel(0, -7), speed),
				get_housing_shadow("south-wet", 276, 204, util.by_pixel(19, 2), speed),
			},
		},
		west = {
			layers = {
				get_frame_layer(frame, "west-wet", 194, 94, util.by_pixel(0, -33), speed),
				get_output_layer("west", 50, 56, util.by_pixel(-31, -12), speed),
				get_housing_shadow("west-wet", 284, 194, util.by_pixel(15, 8), speed),
			},
		},
	}
end

---The visualisations both graphics sets open with: the dust the drill throws up, and the head itself.
---@param tint Color?
---@param speed double
---@return WorkingVisualisation[]
---@nodiscard
local function get_shared_working_visualisations(tint, speed)
	---@type WorkingVisualisation[]
	return {
		{
			constant_speed = true,
			synced_fadeout = true,
			align_to_waypoint = true,
			apply_tint = "resource-color",
			animation = {
				priority = "high",
				filename = FOLDER .. "smoke.png",
				line_length = 6,
				width = 48,
				height = 72,
				frame_count = 30,
				animation_speed = 0.4,
				shift = util.by_pixel(0, 3),
				scale = 0.5,
			},
			north_position = { 0, 0.25 },
			east_position = { 0, 0 },
			south_position = { 0, 0.25 },
			west_position = { 0, 0 },
		},
		{
			constant_speed = true,
			fadeout = true,
			apply_tint = "resource-color",
			north_animation = get_directional_smoke("north", 46, 58, util.by_pixel(1, -44), speed),
		},
		{
			animated_shift = true,
			always_draw = true,
			north_animation = get_vertical_drill_animation(tint, speed),
			east_animation = get_horizontal_drill_animation(tint, speed, false),
			south_animation = get_vertical_drill_animation(tint, speed),
			west_animation = get_horizontal_drill_animation(tint, speed, false),
		},
		{
			constant_speed = true,
			synced_fadeout = true,
			align_to_waypoint = true,
			apply_tint = "resource-color",
			animation = {
				priority = "high",
				filename = FOLDER .. "smoke-front.png",
				line_length = 6,
				width = 148,
				height = 132,
				frame_count = 30,
				animation_speed = 0.4,
				shift = util.by_pixel(-3, 9),
				scale = 0.5,
			},
			north_position = { 0, 0.25 },
			east_position = { 0, 0 },
			south_position = { 0, 0.25 },
			west_position = { 0, 0 },
		},
		{
			constant_speed = true,
			fadeout = true,
			apply_tint = "resource-color",
			east_animation = get_directional_smoke("east", 52, 56, util.by_pixel(25, -12), speed),
			south_animation = get_directional_smoke("south", 48, 36, util.by_pixel(-2, 20), speed),
			west_animation = get_directional_smoke("west", 46, 54, util.by_pixel(-25, -11), speed),
		},
	}
end

---@param tint Color?
---@param speed double
---@return WorkingVisualisation
---@nodiscard
local function get_front_drill(tint, speed)
	---@type WorkingVisualisation
	return {
		animated_shift = true,
		always_draw = true,
		east_animation = get_horizontal_drill_animation(tint, speed, true),
		west_animation = get_horizontal_drill_animation(tint, speed, true),
	}
end

---@param params MiningDrillElectricTallSpriteSetParams
---@param speed double
---@return WorkingVisualisation[]
---@nodiscard
local function get_dry_working_visualisations(params, speed)
	local frame = params.frame or "yellow"

	---@type WorkingVisualisation[]
	local visualisations = get_shared_working_visualisations(params.tint, speed)

	-- Front Frame
	table.insert(visualisations, {
		always_draw = true,
		east_animation = get_frame_front_layer(frame, "east-front", 208, 186, util.by_pixel(3, 2), speed),
		south_animation = {
			layers = {
				get_frame_output_layer(frame, "south-output", 82, 56, util.by_pixel(-1, 34), speed),
				get_frame_layer(frame, "south-front", 172, 42, util.by_pixel(0, 13), speed),
			},
		},
		west_animation = get_frame_front_layer(frame, "west-front", 210, 190, util.by_pixel(-4, 1), speed),
	})

	table.insert(visualisations, get_front_drill(params.tint, speed))
	table.insert(visualisations, get_status_leds())
	table.insert(visualisations, get_secondary_light())

	return visualisations
end

---@param params MiningDrillElectricTallSpriteSetParams
---@param speed double
---@return WorkingVisualisation[]
---@nodiscard
local function get_wet_working_visualisations(params, speed)
	local frame = params.frame or "yellow"

	---@type WorkingVisualisation[]
	local visualisations = get_shared_working_visualisations(params.tint, speed)

	-- Fluid Window Background (Bottom)
	table.insert(visualisations, {
		secondary_draw_order = -49,
		always_draw = true,
		north_animation = get_fluid_layer("north-wet-window-background", 30, 20, util.by_pixel(1, 21), speed),
		south_animation = get_fluid_layer("south-wet-window-background", 132, 88, util.by_pixel(-1, -33), speed),
	})

	-- Fluid Window Background (Front)
	table.insert(visualisations, {
		always_draw = true,
		north_animation = get_fluid_layer("north-wet-window-background-front", 132, 28, util.by_pixel(-1, -18), speed),
		east_animation = get_fluid_layer("east-wet-window-background-front", 86, 86, util.by_pixel(-12, 0), speed),
		west_animation = get_fluid_layer("west-wet-window-background-front", 88, 86, util.by_pixel(11, 0), speed),
	})

	-- Fluid Base (Bottom)
	table.insert(visualisations, {
		always_draw = true,
		secondary_draw_order = -48,
		apply_tint = "input-fluid-base-color",
		north_animation = get_fluid_layer("north-wet-fluid-background", 28, 22, util.by_pixel(2, 21), speed),
		south_animation = get_fluid_layer("south-wet-fluid-background", 130, 96, util.by_pixel(0, -32), speed),
	})

	-- Fluid Base (Front)
	table.insert(visualisations, {
		always_draw = true,
		apply_tint = "input-fluid-base-color",
		north_animation = get_fluid_layer("north-wet-fluid-background-front", 130, 36, util.by_pixel(0, -17), speed),
		east_animation = get_fluid_layer("east-wet-fluid-background-front", 82, 88, util.by_pixel(-12, -1), speed),
		west_animation = get_fluid_layer("west-wet-fluid-background-front", 82, 88, util.by_pixel(12, -1), speed),
	})

	-- Fluid Flow (Bottom)
	table.insert(visualisations, {
		secondary_draw_order = -47,
		always_draw = true,
		apply_tint = "input-fluid-flow-color",
		north_animation = get_fluid_layer("north-wet-fluid-flow", 26, 20, util.by_pixel(2, 22), speed),
		south_animation = get_fluid_layer("south-wet-fluid-flow", 130, 88, util.by_pixel(-2, -32), speed),
	})

	-- Fluid Flow (Front)
	table.insert(visualisations, {
		always_draw = true,
		apply_tint = "input-fluid-flow-color",
		north_animation = get_fluid_layer("north-wet-fluid-flow-front", 130, 28, util.by_pixel(-2, -17), speed),
		east_animation = get_fluid_layer("east-wet-fluid-flow-front", 82, 86, util.by_pixel(-12, 0), speed),
		west_animation = get_fluid_layer("west-wet-fluid-flow-front", 84, 86, util.by_pixel(11, 0), speed),
	})

	-- Front Frame (Wet)
	table.insert(visualisations, {
		always_draw = true,
		north_animation = {
			layers = {
				{
					priority = "high",
					filename = FOLDER .. "north-wet-front.png",
					width = 162,
					height = 124,
					animation_speed = speed,
					shift = util.by_pixel(-2, 20),
					scale = 0.5,
				},
			},
		},
		east_animation = get_frame_front_layer(frame, "east-wet-front", 208, 186, util.by_pixel(3, 2), speed),
		south_animation = {
			layers = {
				get_frame_output_layer(frame, "south-output", 82, 56, util.by_pixel(-1, 34), speed),
				get_frame_layer(frame, "south-wet-front", 192, 70, util.by_pixel(0, 19), speed),
			},
		},
		west_animation = get_frame_front_layer(frame, "west-wet-front", 210, 190, util.by_pixel(-4, 1), speed),
	})

	table.insert(visualisations, get_front_drill(params.tint, speed))
	table.insert(visualisations, get_status_leds())
	table.insert(visualisations, get_secondary_light())

	return visualisations
end

---@param name string The file the patch is drawn from, less the folder and the extension.
---@param width SpriteSizeType
---@param height SpriteSizeType
---@param shift Vector
---@return Sprite
---@nodiscard
local function get_integration_sprite(name, width, height, shift)
	return {
		priority = "high",
		filename = FOLDER .. name .. "-integration.png",
		line_length = 1,
		width = width,
		height = height,
		shift = shift,
		scale = 0.5,
	}
end

---@return Sprite4Way
---@nodiscard
local function get_integration_patch()
	---@type Sprite4Way
	return {
		north = get_integration_sprite("north", 230, 236, util.by_pixel(0, -2)),
		east = get_integration_sprite("east", 238, 204, util.by_pixel(2, 5)),
		south = get_integration_sprite("south", 224, 228, util.by_pixel(0, -2)),
		west = get_integration_sprite("west", 234, 202, util.by_pixel(-3, 5)),
	}
end

---@param tint Color?
---@return RotatedAnimationVariations
---@nodiscard
local function get_corpse_animation(tint)
	local remnants_folder = ENTITY_FOLDER .. "remnants/mining-drill-electric-tall-remnants"

	---@type RotatedAnimation
	local animation = {
		layers = {
			{
				filename = remnants_folder .. ".png",
				width = 356,
				height = 328,
				direction_count = 1,
				shift = util.by_pixel(7, -0.5),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = remnants_folder .. "-mask.png",
			width = 356,
			height = 328,
			direction_count = 1,
			shift = util.by_pixel(7, -0.5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = remnants_folder .. "-highlights.png",
			width = 356,
			height = 328,
			direction_count = 1,
			shift = util.by_pixel(7, -0.5),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return _sprites.make_rotated_animation_variations_from_spritesheet(4, animation)
end

---@class MiningDrillElectricTallSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?
---The housing the drill is built into. Defaults to `"yellow"`.
---@field frame MiningDrillElectricTallFrame?
---The speed the drill's head strokes at. Defaults to `0.4`.
---@field animation_speed double?

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.shape({
			tint = Common.color:optional(),
			frame = V.one_of({ "yellow", "blue" }):optional(),
			animation_speed = Common.positive_number:optional(),
		}),
	},
})

---Gets the sprite set for the semi-classic electric mining drill.
---@param params MiningDrillElectricTallSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<MiningDrillSpriteSet>
---
---#### Examples
---```lua
---local drill = require("__reskins-assets-api__.assets.assorted.entities.mining-drill-electric-tall")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = drill.get_sprite_set({ tint = tint, frame = "blue" })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set(params)
	check_get_sprite_set(params)

	local frame = params.frame or "yellow"
	local speed = params.animation_speed or 0.4

	---@type SpriteSetDefinition<MiningDrillSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.mining_drill_sprite_set,
		set = {
			graphics_set = {
				animation = get_dry_animation(frame, speed),
				working_visualisations = get_dry_working_visualisations(params, speed),
				drilling_vertical_movement_duration = 10 / speed,
				shift_animation_waypoint_stop_duration = 195 / speed,
				shift_animation_transition_duration = 30 / speed,
			},
			graphics_set_flipped = nil,
			wet_mining_graphics_set = {
				animation = get_wet_animation(frame, speed),
				working_visualisations = get_wet_working_visualisations(params, speed),
				drilling_vertical_movement_duration = 10 / speed,
				shift_animation_waypoint_stop_duration = 195 / speed,
				shift_animation_transition_duration = 30 / speed,
			},
			wet_mining_graphics_set_flipped = nil,
			radius_visualisation_picture = {
				filename = "__base__/graphics/entity/electric-mining-drill/electric-mining-drill-radius-visualization.png",
				width = 10,
				height = 10,
			},
			integration_patch = get_integration_patch(),
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = { animation = get_corpse_animation(params.tint) },
			water_reflection = nil,
			nominal_width = 3,
			nominal_height = 3,
		},
	}

	return definition
end

---@param base_layer FileName
---@param tint Color?
---@return SafeIconData[]
---@nodiscard
local function get_layers(base_layer, tint)
	---@type SafeIconData[]
	local layers = { { icon = base_layer, icon_size = 64, scale = 0.5 } }

	if tint then
		table.insert(layers, { icon = ICON_FOLDER .. "icon-mask.png", icon_size = 64, scale = 0.5, tint = tint })
		table.insert(layers, {
			icon = ICON_FOLDER .. "icon-highlights.png",
			icon_size = 64,
			scale = 0.5,
			tint = { 1, 1, 1, 0 },
		})
	end

	return layers
end

local check_get_icon = V.signature("get_icon", {
	{ "tint", Common.color:optional() },
})

---Gets the icon for the semi-classic electric mining drill, in the given `tint`.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(tint)
	check_get_icon(tint)

	return get_layers(ICON_FOLDER .. "icon-base.png", tint)
end

local check_get_area_icon = V.signature("get_area_icon", {
	{ "tint", Common.color:optional() },
})

---Gets the icon for the semi-classic area mining drill, in the given `tint`.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_area_icon(tint)
	check_get_area_icon(tint)

	return get_layers(ICON_FOLDER .. "area-icon-base.png", tint)
end

return M
