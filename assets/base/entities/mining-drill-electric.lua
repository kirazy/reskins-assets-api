---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")

local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")

local _sprites = require("__reskins-sprite-utils__.sprites")
local IconCatalog = require("api.icon-catalog")

local M = {}

local BASE_FOLDER = "__base__/graphics/entity/electric-mining-drill/electric-mining-drill-"
local BLUE_FOLDER = "__reskins-assets-bobs__/graphics/entity/mining-drill-electric/frame-blue/mining-drill-electric-"
local DRILL_FOLDER = "__reskins-assets-base__/graphics/entity/mining-drill-electric/mining-drill-electric-"

---The housing the drill is built into.
---@alias MiningDrillElectricFrame
---| "base" # The base game's own housing.
---| "blue" # The blue housing Bob's area drills are built into.

local BLUE_PARTS = {
	["north"] = true,
	["east"] = true,
	["west"] = true,
	["east-front"] = true,
	["south-front"] = true,
	["south-output"] = true,
	["west-front"] = true,
	["north-wet"] = true,
	["east-wet"] = true,
	["west-wet"] = true,
	["east-wet-front"] = true,
	["south-wet-front"] = true,
	["west-wet-front"] = true,
}

local BASE_DIRECTION = { north = "N", east = "E", south = "S", west = "W" }

---@param frame MiningDrillElectricFrame The housing the part is drawn for.
---@param part string The part, named for its direction and role, as `"north-wet-front"`.
---@return FileName
---@nodiscard
local function get_frame_file(frame, part)
	if frame == "blue" and BLUE_PARTS[part] then
		return BLUE_FOLDER .. part .. ".png"
	end

	local direction, role = part:match("^(%a+)(.*)$")

	return BASE_FOLDER .. BASE_DIRECTION[direction] .. role .. ".png"
end

-- The frames the drill's head cycles through, extended so it idles at the bottom of its stroke.
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

-- The shadow holds its last frame for as long as the head idles.
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
				filename = "__base__/graphics/entity/electric-mining-drill/electric-mining-drill.png",
				line_length = 6,
				width = 162,
				height = 156,
				frame_count = 30,
				animation_speed = speed,
				frame_sequence = ANIMATION_SEQUENCE,
				shift = util.by_pixel(1, -11),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			priority = "high",
			filename = DRILL_FOLDER .. "mask.png",
			line_length = 6,
			width = 162,
			height = 156,
			frame_count = 30,
			animation_speed = speed,
			frame_sequence = ANIMATION_SEQUENCE,
			shift = util.by_pixel(1, -11),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			priority = "high",
			filename = DRILL_FOLDER .. "highlights.png",
			line_length = 6,
			width = 162,
			height = 156,
			frame_count = 30,
			animation_speed = speed,
			frame_sequence = ANIMATION_SEQUENCE,
			shift = util.by_pixel(1, -11),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	-- Shadows are always appended last.
	table.insert(animation.layers--[[@cast -?]], {
		priority = "high",
		filename = BASE_FOLDER .. "shadow.png",
		line_length = 7,
		width = 218,
		height = 56,
		frame_count = 21,
		animation_speed = speed,
		frame_sequence = SHADOW_SEQUENCE,
		draw_as_shadow = true,
		shift = util.by_pixel(21, 5),
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
	local width = is_front and 66 or 80
	local height = is_front and 154 or 160
	local shift = is_front and util.by_pixel(-3, 3) or util.by_pixel(2, -12)

	---@type Animation
	local animation = {
		layers = {
			{
				priority = "high",
				filename = BASE_FOLDER .. name .. ".png",
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
			filename = DRILL_FOLDER .. name .. "-mask.png",
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
			filename = DRILL_FOLDER .. name .. "-highlights.png",
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
		filename = BASE_FOLDER .. "horizontal-shadow.png",
		line_length = 7,
		width = 180,
		height = 164,
		frame_count = 21,
		animation_speed = speed,
		frame_sequence = SHADOW_SEQUENCE,
		draw_as_shadow = true,
		shift = util.by_pixel(48, 5),
		scale = 0.5,
	})

	return animation
end

---@return Animation
---@nodiscard
local function get_smoke()
	return {
		priority = "high",
		filename = BASE_FOLDER .. "smoke.png",
		line_length = 6,
		width = 48,
		height = 72,
		frame_count = 30,
		animation_speed = 0.4,
		shift = util.by_pixel(0, 3),
		scale = 0.5,
	}
end

---@return Animation
---@nodiscard
local function get_smoke_front()
	return {
		priority = "high",
		filename = BASE_FOLDER .. "smoke-front.png",
		line_length = 6,
		width = 148,
		height = 132,
		frame_count = 30,
		animation_speed = 0.4,
		shift = util.by_pixel(-3, 9),
		scale = 0.5,
	}
end

---@param direction string The direction letter naming the artwork, as `"N"`.
---@param width SpriteSizeType
---@param height SpriteSizeType
---@param shift Vector
---@param speed double
---@return Animation
---@nodiscard
local function get_directional_smoke(direction, width, height, shift, speed)
	return {
		layers = {
			{
				priority = "high",
				filename = BASE_FOLDER .. direction .. "-smoke.png",
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

---@return WorkingVisualisation
---@nodiscard
local function get_status_leds()
	---@type WorkingVisualisation
	return {
		apply_tint = "status",
		always_draw = true,
		north_animation = {
			filename = BASE_FOLDER .. "N-light.png",
			width = 32,
			height = 32,
			tint = { 1, 1, 1 },
			draw_as_glow = true,
			shift = util.by_pixel(26, -48),
			scale = 0.5,
		},
		east_animation = {
			filename = BASE_FOLDER .. "E-light.png",
			width = 32,
			height = 34,
			tint = { 1, 1, 1 },
			draw_as_glow = true,
			shift = util.by_pixel(38, -32),
			scale = 0.5,
		},
		south_animation = {
			filename = BASE_FOLDER .. "S-light.png",
			width = 38,
			height = 46,
			tint = { 1, 1, 1 },
			draw_as_glow = true,
			shift = util.by_pixel(26, 26),
			scale = 0.5,
		},
		west_animation = {
			filename = BASE_FOLDER .. "W-light.png",
			width = 32,
			height = 34,
			tint = { 1, 1, 1 },
			draw_as_glow = true,
			shift = util.by_pixel(-39, -32),
			scale = 0.5,
		},
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

---@param frame MiningDrillElectricFrame
---@param speed double
---@return Animation4Way
---@nodiscard
local function get_dry_animation(frame, speed)
	---@type Animation4Way
	return {
		north = {
			layers = {
				{
					priority = "high",
					filename = get_frame_file(frame, "north"),
					width = 190,
					height = 208,
					animation_speed = speed,
					shift = util.by_pixel(0, -4),
					repeat_count = 5,
					scale = 0.5,
				},
				{
					priority = "high",
					filename = BASE_FOLDER .. "N-output.png",
					line_length = 5,
					width = 60,
					height = 66,
					frame_count = 5,
					animation_speed = speed,
					shift = util.by_pixel(-3, -44),
					scale = 0.5,
				},
				{
					priority = "high",
					filename = BASE_FOLDER .. "N-shadow.png",
					width = 212,
					height = 204,
					animation_speed = speed,
					draw_as_shadow = true,
					shift = util.by_pixel(6, -3),
					repeat_count = 5,
					scale = 0.5,
				},
			},
		},
		east = {
			layers = {
				{
					priority = "high",
					filename = get_frame_file(frame, "east"),
					width = 192,
					height = 188,
					animation_speed = speed,
					shift = util.by_pixel(0, -4),
					repeat_count = 5,
					scale = 0.5,
				},
				{
					priority = "high",
					filename = BASE_FOLDER .. "E-output.png",
					line_length = 5,
					width = 50,
					height = 74,
					frame_count = 5,
					animation_speed = speed,
					shift = util.by_pixel(30, -8),
					scale = 0.5,
				},
				{
					priority = "high",
					filename = BASE_FOLDER .. "E-shadow.png",
					width = 222,
					height = 182,
					animation_speed = speed,
					draw_as_shadow = true,
					shift = util.by_pixel(10, 2),
					repeat_count = 5,
					scale = 0.5,
				},
			},
		},
		south = {
			layers = {
				{
					priority = "high",
					filename = get_frame_file(frame, "south"),
					width = 184,
					height = 192,
					animation_speed = speed,
					shift = util.by_pixel(0, -1),
					repeat_count = 5,
					scale = 0.5,
				},
				{
					priority = "high",
					filename = BASE_FOLDER .. "S-shadow.png",
					width = 212,
					height = 204,
					animation_speed = speed,
					draw_as_shadow = true,
					shift = util.by_pixel(6, 2),
					repeat_count = 5,
					scale = 0.5,
				},
			},
		},
		west = {
			layers = {
				{
					priority = "high",
					filename = get_frame_file(frame, "west"),
					width = 192,
					height = 188,
					animation_speed = speed,
					shift = util.by_pixel(0, -4),
					repeat_count = 5,
					scale = 0.5,
				},
				{
					priority = "high",
					filename = BASE_FOLDER .. "W-output.png",
					line_length = 5,
					width = 50,
					height = 60,
					frame_count = 5,
					animation_speed = speed,
					shift = util.by_pixel(-31, -13),
					scale = 0.5,
				},
				{
					priority = "high",
					filename = BASE_FOLDER .. "W-shadow.png",
					width = 200,
					height = 182,
					animation_speed = speed,
					draw_as_shadow = true,
					shift = util.by_pixel(-5, 2),
					repeat_count = 5,
					scale = 0.5,
				},
			},
		},
	}
end

---@param frame MiningDrillElectricFrame
---@param speed double
---@return Animation4Way
---@nodiscard
local function get_wet_animation(frame, speed)
	---@type Animation4Way
	return {
		north = {
			layers = {
				{
					priority = "high",
					filename = get_frame_file(frame, "north-wet"),
					width = 190,
					height = 198,
					animation_speed = speed,
					shift = util.by_pixel(0, -7),
					repeat_count = 5,
					scale = 0.5,
				},
				{
					priority = "high",
					filename = BASE_FOLDER .. "N-output.png",
					line_length = 5,
					width = 60,
					height = 66,
					frame_count = 5,
					animation_speed = speed,
					shift = util.by_pixel(-3, -44),
					scale = 0.5,
				},
				{
					priority = "high",
					filename = BASE_FOLDER .. "N-wet-shadow.png",
					width = 248,
					height = 222,
					animation_speed = speed,
					draw_as_shadow = true,
					shift = util.by_pixel(12, 1),
					repeat_count = 5,
					scale = 0.5,
				},
			},
		},
		east = {
			layers = {
				{
					priority = "high",
					filename = get_frame_file(frame, "east-wet"),
					width = 194,
					height = 208,
					animation_speed = speed,
					shift = util.by_pixel(-2, -9),
					repeat_count = 5,
					scale = 0.5,
				},
				{
					priority = "high",
					filename = BASE_FOLDER .. "E-output.png",
					line_length = 5,
					width = 50,
					height = 74,
					frame_count = 5,
					animation_speed = speed,
					shift = util.by_pixel(30, -8),
					scale = 0.5,
				},
				{
					priority = "high",
					filename = BASE_FOLDER .. "E-wet-shadow.png",
					width = 226,
					height = 202,
					animation_speed = speed,
					draw_as_shadow = true,
					shift = util.by_pixel(9, 5),
					repeat_count = 5,
					scale = 0.5,
				},
			},
		},
		south = {
			layers = {
				{
					priority = "high",
					filename = get_frame_file(frame, "south-wet"),
					width = 192,
					height = 208,
					animation_speed = speed,
					shift = util.by_pixel(1, -5),
					repeat_count = 5,
					scale = 0.5,
				},
				{
					priority = "high",
					filename = BASE_FOLDER .. "S-wet-shadow.png",
					width = 248,
					height = 192,
					animation_speed = speed,
					draw_as_shadow = true,
					shift = util.by_pixel(12, 5),
					repeat_count = 5,
					scale = 0.5,
				},
			},
		},
		west = {
			layers = {
				{
					priority = "high",
					filename = get_frame_file(frame, "west-wet"),
					width = 194,
					height = 208,
					animation_speed = speed,
					shift = util.by_pixel(1, -9),
					repeat_count = 5,
					scale = 0.5,
				},
				{
					priority = "high",
					filename = BASE_FOLDER .. "W-output.png",
					line_length = 5,
					width = 50,
					height = 60,
					frame_count = 5,
					animation_speed = speed,
					shift = util.by_pixel(-31, -13),
					scale = 0.5,
				},
				{
					priority = "high",
					filename = BASE_FOLDER .. "W-wet-shadow.png",
					width = 260,
					height = 202,
					animation_speed = speed,
					draw_as_shadow = true,
					shift = util.by_pixel(9, 6),
					repeat_count = 5,
					scale = 0.5,
				},
			},
		},
	}
end

---The visualisations both graphics sets open with: the dust the drill throws up, and the head itself.
---@param params MiningDrillElectricSpriteSetParams
---@param speed double
---@return WorkingVisualisation[]
---@nodiscard
local function get_shared_working_visualisations(params, speed)
	---@type WorkingVisualisation[]
	return {
		{
			constant_speed = true,
			synced_fadeout = true,
			align_to_waypoint = true,
			apply_tint = "resource-color",
			animation = get_smoke(),
			north_position = { 0, 0.25 },
			east_position = { 0, 0 },
			south_position = { 0, 0.25 },
			west_position = { 0, 0 },
		},
		{
			constant_speed = true,
			fadeout = true,
			apply_tint = "resource-color",
			north_animation = get_directional_smoke("N", 42, 58, util.by_pixel(-1, -44), speed),
		},
		{
			animated_shift = true,
			always_draw = true,
			north_animation = get_vertical_drill_animation(params.tint, speed),
			east_animation = get_horizontal_drill_animation(params.tint, speed, false),
			south_animation = get_vertical_drill_animation(params.tint, speed),
			west_animation = get_horizontal_drill_animation(params.tint, speed, false),
		},
	}
end

---The dust the drill throws up towards the viewer.
---@param speed double
---@return WorkingVisualisation
---@nodiscard
local function get_front_smoke(speed)
	---@type WorkingVisualisation
	return {
		constant_speed = true,
		fadeout = true,
		apply_tint = "resource-color",
		east_animation = get_directional_smoke("E", 46, 56, util.by_pixel(24, -12), speed),
		south_animation = get_directional_smoke("S", 48, 36, util.by_pixel(-2, 20), speed),
		west_animation = get_directional_smoke("W", 46, 54, util.by_pixel(-25, -11), speed),
	}
end

---The half of the head that stands in front of the housing.
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

---@param params MiningDrillElectricSpriteSetParams
---@param speed double
---@return WorkingVisualisation[]
---@nodiscard
local function get_dry_working_visualisations(params, speed)
	local frame = params.frame or "base"

	---@type WorkingVisualisation[]
	local visualisations = get_shared_working_visualisations(params, speed)

	table.insert(visualisations, {
		constant_speed = true,
		synced_fadeout = true,
		align_to_waypoint = true,
		apply_tint = "resource-color",
		animation = get_smoke_front(),
		north_position = { 0, 0.25 },
		east_position = { 0, 0 },
		south_position = { 0, 0.25 },
		west_position = { 0, 0 },
	})

	table.insert(visualisations, get_front_smoke(speed))
	table.insert(visualisations, get_front_drill(params.tint, speed))

	-- Front Frame
	table.insert(visualisations, {
		always_draw = true,
		east_animation = {
			priority = "high",
			filename = get_frame_file(frame, "east-front"),
			width = 136,
			height = 148,
			animation_speed = speed,
			shift = util.by_pixel(21, 10),
			scale = 0.5,
		},
		south_animation = {
			layers = {
				{
					priority = "high",
					filename = get_frame_file(frame, "south-output"),
					line_length = 5,
					width = 84,
					height = 56,
					frame_count = 5,
					animation_speed = speed,
					shift = util.by_pixel(-1, 34),
					scale = 0.5,
				},
				{
					priority = "high",
					filename = get_frame_file(frame, "south-front"),
					width = 190,
					height = 104,
					animation_speed = speed,
					repeat_count = 5,
					shift = util.by_pixel(0, 27),
					scale = 0.5,
				},
			},
		},
		west_animation = {
			priority = "high",
			filename = get_frame_file(frame, "west-front"),
			width = 134,
			height = 140,
			animation_speed = speed,
			shift = util.by_pixel(-22, 12),
			scale = 0.5,
		},
	})

	table.insert(visualisations, get_status_leds())
	table.insert(visualisations, get_secondary_light())

	return visualisations
end

---@param params MiningDrillElectricSpriteSetParams
---@param speed double
---@return WorkingVisualisation[]
---@nodiscard
local function get_wet_working_visualisations(params, speed)
	local frame = params.frame or "base"

	---@type WorkingVisualisation[]
	local visualisations = get_shared_working_visualisations(params, speed)

	table.insert(visualisations, {
		constant_speed = true,
		synced_fadeout = true,
		align_to_waypoint = true,
		apply_tint = "resource-color",
		animation = get_smoke_front(),
	})

	table.insert(visualisations, get_front_smoke(speed))

	-- Fluid Window Background (Bottom)
	table.insert(visualisations, {
		secondary_draw_order = -49,
		always_draw = true,
		east_animation = {
			layers = {
				{
					priority = "high",
					filename = BASE_FOLDER .. "E-wet-window-background.png",
					width = 22,
					height = 14,
					animation_speed = speed,
					shift = util.by_pixel(0, -52),
					scale = 0.5,
				},
			},
		},
		south_animation = {
			layers = {
				{
					priority = "high",
					filename = BASE_FOLDER .. "S-wet-window-background.png",
					width = 30,
					height = 20,
					animation_speed = speed,
					shift = util.by_pixel(-2, -43),
					scale = 0.5,
				},
			},
		},
		west_animation = {
			layers = {
				{
					priority = "high",
					filename = BASE_FOLDER .. "W-wet-window-background.png",
					width = 22,
					height = 14,
					animation_speed = speed,
					shift = util.by_pixel(0, -52),
					scale = 0.5,
				},
			},
		},
	})

	-- Fluid Base (Bottom)
	table.insert(visualisations, {
		always_draw = true,
		secondary_draw_order = -48,
		apply_tint = "input-fluid-base-color",
		east_animation = {
			layers = {
				{
					priority = "high",
					filename = BASE_FOLDER .. "E-wet-fluid-background.png",
					width = 22,
					height = 14,
					animation_speed = speed,
					shift = util.by_pixel(0, -52),
					scale = 0.5,
				},
			},
		},
		south_animation = {
			layers = {
				{
					priority = "high",
					filename = BASE_FOLDER .. "S-wet-fluid-background.png",
					width = 28,
					height = 18,
					animation_speed = speed,
					shift = util.by_pixel(-2, -43),
					scale = 0.5,
				},
			},
		},
		west_animation = {
			layers = {
				{
					priority = "high",
					filename = BASE_FOLDER .. "W-wet-fluid-background.png",
					width = 22,
					height = 14,
					animation_speed = speed,
					shift = util.by_pixel(0, -52),
					scale = 0.5,
				},
			},
		},
	})

	-- Fluid Flow (Bottom)
	table.insert(visualisations, {
		secondary_draw_order = -47,
		always_draw = true,
		apply_tint = "input-fluid-flow-color",
		east_animation = {
			layers = {
				{
					priority = "high",
					filename = BASE_FOLDER .. "E-wet-fluid-flow.png",
					width = 24,
					height = 14,
					animation_speed = speed,
					shift = util.by_pixel(0, -52),
					scale = 0.5,
				},
			},
		},
		south_animation = {
			layers = {
				{
					priority = "high",
					filename = BASE_FOLDER .. "S-wet-fluid-flow.png",
					width = 26,
					height = 16,
					animation_speed = speed,
					shift = util.by_pixel(-2, -42),
					scale = 0.5,
				},
			},
		},
		west_animation = {
			layers = {
				{
					priority = "high",
					filename = BASE_FOLDER .. "W-wet-fluid-flow.png",
					width = 24,
					height = 14,
					animation_speed = speed,
					shift = util.by_pixel(0, -52),
					scale = 0.5,
				},
			},
		},
	})

	table.insert(visualisations, get_front_drill(params.tint, speed))

	-- Fluid Window Background (Front)
	table.insert(visualisations, {
		always_draw = true,
		north_animation = {
			layers = {
				{
					priority = "high",
					filename = BASE_FOLDER .. "N-wet-window-background.png",
					width = 172,
					height = 90,
					animation_speed = speed,
					shift = util.by_pixel(0, 9),
					scale = 0.5,
				},
			},
		},
		east_animation = {
			layers = {
				{
					priority = "high",
					filename = BASE_FOLDER .. "E-wet-window-background-front.png",
					width = 82,
					height = 110,
					animation_speed = speed,
					shift = util.by_pixel(-15, 9),
					scale = 0.5,
				},
			},
		},
		south_animation = {
			layers = {
				{
					priority = "high",
					filename = BASE_FOLDER .. "S-wet-window-background-front.png",
					width = 172,
					height = 22,
					animation_speed = speed,
					shift = util.by_pixel(0, -7),
					scale = 0.5,
				},
			},
		},
		west_animation = {
			layers = {
				{
					priority = "high",
					filename = BASE_FOLDER .. "W-wet-window-background-front.png",
					width = 80,
					height = 106,
					animation_speed = speed,
					shift = util.by_pixel(14, 10),
					scale = 0.5,
				},
			},
		},
	})

	-- Fluid Base (Front)
	table.insert(visualisations, {
		always_draw = true,
		apply_tint = "input-fluid-base-color",
		north_animation = {
			layers = {
				{
					priority = "high",
					filename = BASE_FOLDER .. "N-wet-fluid-background.png",
					width = 178,
					height = 94,
					animation_speed = speed,
					shift = util.by_pixel(0, 9),
					scale = 0.5,
				},
			},
		},
		east_animation = {
			layers = {
				{
					priority = "high",
					filename = BASE_FOLDER .. "E-wet-fluid-background-front.png",
					width = 82,
					height = 106,
					animation_speed = speed,
					shift = util.by_pixel(-15, 10),
					scale = 0.5,
				},
			},
		},
		south_animation = {
			layers = {
				{
					priority = "high",
					filename = BASE_FOLDER .. "S-wet-fluid-background-front.png",
					width = 178,
					height = 28,
					animation_speed = speed,
					shift = util.by_pixel(0, -7),
					scale = 0.5,
				},
			},
		},
		west_animation = {
			layers = {
				{
					priority = "high",
					filename = BASE_FOLDER .. "W-wet-fluid-background-front.png",
					width = 80,
					height = 102,
					animation_speed = speed,
					shift = util.by_pixel(14, 11),
					scale = 0.5,
				},
			},
		},
	})

	-- Fluid Flow (Front)
	table.insert(visualisations, {
		always_draw = true,
		apply_tint = "input-fluid-flow-color",
		north_animation = {
			layers = {
				{
					priority = "high",
					filename = BASE_FOLDER .. "N-wet-fluid-flow.png",
					width = 172,
					height = 88,
					animation_speed = speed,
					shift = util.by_pixel(0, 10),
					scale = 0.5,
				},
			},
		},
		east_animation = {
			layers = {
				{
					priority = "high",
					filename = BASE_FOLDER .. "E-wet-fluid-flow-front.png",
					width = 78,
					height = 106,
					animation_speed = speed,
					shift = util.by_pixel(-14, 10),
					scale = 0.5,
				},
			},
		},
		south_animation = {
			layers = {
				{
					priority = "high",
					filename = BASE_FOLDER .. "S-wet-fluid-flow-front.png",
					width = 172,
					height = 22,
					animation_speed = speed,
					shift = util.by_pixel(0, -8),
					scale = 0.5,
				},
			},
		},
		west_animation = {
			layers = {
				{
					priority = "high",
					filename = BASE_FOLDER .. "W-wet-fluid-flow-front.png",
					width = 78,
					height = 102,
					animation_speed = speed,
					shift = util.by_pixel(14, 11),
					scale = 0.5,
				},
			},
		},
	})

	-- Front Frame (Wet)
	table.insert(visualisations, {
		always_draw = true,
		north_animation = {
			layers = {
				{
					priority = "high",
					filename = get_frame_file(frame, "north-wet-front"),
					width = 200,
					height = 130,
					animation_speed = speed,
					shift = util.by_pixel(0, 16),
					scale = 0.5,
				},
			},
		},
		east_animation = {
			layers = {
				{
					priority = "high",
					filename = get_frame_file(frame, "east-wet-front"),
					width = 208,
					height = 148,
					animation_speed = speed,
					shift = util.by_pixel(3, 11),
					scale = 0.5,
				},
			},
		},
		south_animation = {
			layers = {
				{
					priority = "high",
					filename = get_frame_file(frame, "south-output"),
					line_length = 5,
					width = 84,
					height = 56,
					frame_count = 5,
					animation_speed = speed,
					shift = util.by_pixel(-1, 34),
					scale = 0.5,
				},
				{
					priority = "high",
					filename = get_frame_file(frame, "south-wet-front"),
					width = 192,
					height = 140,
					animation_speed = speed,
					repeat_count = 5,
					shift = util.by_pixel(0, 18),
					scale = 0.5,
				},
			},
		},
		west_animation = {
			layers = {
				{
					priority = "high",
					filename = get_frame_file(frame, "west-wet-front"),
					width = 208,
					height = 144,
					animation_speed = speed,
					shift = util.by_pixel(-4, 12),
					scale = 0.5,
				},
			},
		},
	})

	table.insert(visualisations, get_status_leds())
	table.insert(visualisations, get_secondary_light())

	return visualisations
end

---@param tint Color?
---@return RotatedAnimationVariations
---@nodiscard
local function get_corpse_animation(tint)
	local remnants_folder = "__reskins-assets-base__/graphics/entity/mining-drill-electric/remnants/"

	---@type RotatedAnimation
	local animation = {
		layers = {
			{
				filename = "__base__/graphics/entity/electric-mining-drill/remnants/electric-mining-drill-remnants.png",
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
			filename = remnants_folder .. "mining-drill-electric-remnants-mask.png",
			width = 356,
			height = 328,
			direction_count = 1,
			shift = util.by_pixel(7, -0.5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = remnants_folder .. "mining-drill-electric-remnants-highlights.png",
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

---@class MiningDrillElectricSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?
---The housing the drill is built into. Defaults to `"base"`.
---@field frame MiningDrillElectricFrame?
---The speed the drill's head strokes at. Defaults to `0.4`.
---@field animation_speed double?

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.shape({
			tint = Common.color:optional(),
			frame = V.one_of({ "base", "blue" }):optional(),
			animation_speed = Common.positive_number:optional(),
		}),
	},
})

---Gets the sprite set for the vanilla electric mining drill.
---@param params MiningDrillElectricSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<MiningDrillSpriteSet>
---
---#### Examples
---```lua
---local mining_drill_electric = require("__reskins-assets-api__.assets.base.entities.mining-drill-electric")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = mining_drill_electric.get_sprite_set({ tint = tint, frame = "blue" })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set(params)
	check_get_sprite_set(params)

	local frame = params.frame or "base"
	local speed = params.animation_speed or 0.4

	---@type SpriteSetDefinition<MiningDrillSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.mining_drill_sprite_set,
		set = {
			---@diagnostic disable-next-line: assign-type-mismatch
			graphics_set = {
				animation = get_dry_animation(frame, speed),
				working_visualisations = get_dry_working_visualisations(params, speed),
				drilling_vertical_movement_duration = 10 / speed,
				shift_animation_waypoint_stop_duration = 195 / speed,
				shift_animation_transition_duration = 30 / speed,
			},
			graphics_set_flipped = nil,
			---@diagnostic disable-next-line: assign-type-mismatch
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
			integration_patch = nil,
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

local icons = IconCatalog:create({ folder = "__reskins-assets-base__/graphics/icons" })

---Gets the icon for the vanilla electric mining drill, in the tints given by `params`.
M.get_icon = icons:tinted("mining-drill-electric"):build("get_icon")

return M
