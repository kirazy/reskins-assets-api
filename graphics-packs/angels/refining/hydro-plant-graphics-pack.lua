local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Angels.HydroPlantGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local HydroPlantGraphicsPack = {}
HydroPlantGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(HydroPlantGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

local pipe_pictures = {
	north = {
		filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/pipe-north1.png",
		priority = "extra-high",
		width = 48,
		height = 48,
		shift = { -0.08, 0.45 },
	},
	east = {
		filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/blank.png",
		priority = "extra-high",
		width = 1,
		height = 1,
		shift = { 0, 0 },
	},
	south = {
		filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/pipe-south1.png",
		priority = "extra-high",
		width = 48,
		height = 48,
		shift = { 0.06, -0.6 },
	},
	west = {
		filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/pipe-west1.png",
		priority = "extra-high",
		width = 48,
		height = 48,
		shift = { 0.62, 0.05 },
	},
}

local mirrored_pipe_pictures = {
	north = {
		filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/pipe-north2.png",
		priority = "extra-high",
		width = 48,
		height = 48,
		shift = { -0.08, 0.45 },
	},
	east = {
		filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/blank.png",
		priority = "extra-high",
		width = 1,
		height = 1,
		shift = { 0, 0 },
	},
	south = {
		filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/pipe-south1.png",
		priority = "extra-high",
		width = 48,
		height = 48,
		shift = { 0.06, -0.6 },
	},
	west = {
		filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/pipe-west2.png",
		priority = "extra-high",
		width = 48,
		height = 48,
		shift = { 0.62, 0.05 },
	},
}

---@class Reskins.Angels.HydroPlantGraphicsParams:Reskins.Abstractions.BaseGraphicsParams

---@param params Reskins.Angels.HydroPlantGraphicsParams
---@return Reskins.Angels.HydroPlantGraphicsPack
---@nodiscard
function HydroPlantGraphicsPack:configure(params)
	---@type FluidBoxGraphics
	local fluid_box = {
		pipe_picture = pipe_pictures,
		mirrored_pipe_picture = mirrored_pipe_pictures,
	}

	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		scale = params.scale,
		scale_factor = params.scale_factor,
		required_assets = {
			[_defines.assets.refining_graphics] = true,
		},
		nominal_width = 7,
		nominal_height = 7,
		graphics_set = self.get_graphics_set(params.tint),
		graphics_set_flipped = self.get_graphics_set_flipped(params.tint),
		fluid_boxes = { fluid_box },
		fluid_boxes_off_when_no_fluid_recipe = false,
	}) --[[@as Reskins.Angels.HydroPlantGraphicsPack]]

	-- Set the correct metatable for this class.
	setmetatable(instance, HydroPlantGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.Animation
local function make_animation(tint)
	local layers = {
		-- Base
		{
			filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/hydro-plant-base.png",
			priority = "extra-high",
			width = 459,
			height = 491,
			shift = util.by_pixel(0, 0),
			scale = 0.5,
		},
	}

	if tint then
		table.insert(layers, {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/hydro-plant/hydro-plant-mask.png",
			priority = "extra-high",
			width = 459,
			height = 491,
			shift = util.by_pixel(0, 0),
			tint = tint,
			scale = 0.5,
		})
		table.insert(layers, {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/hydro-plant/hydro-plant-highlights.png",
			priority = "extra-high",
			width = 459,
			height = 491,
			shift = util.by_pixel(0, 0),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return { layers = layers }
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function HydroPlantGraphicsPack.get_graphics_set(tint)
	---@type data.CraftingMachineGraphicsSet
	local graphics_set = {
		animation = make_animation(tint),
		working_visualisations = {
			{
				always_draw = true,
				north_position = util.by_pixel(-52.5, -43),
				east_position = util.by_pixel(-52.5, -43),
				south_position = util.by_pixel(-52.5, -43),
				west_position = util.by_pixel(-52.5, -43),
				animation = {
					layers = {
						{
							filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/hydro-plant-fan.png",
							priority = "extra-high",
							width = 107,
							height = 77,
							frame_count = 24,
							line_length = 6,
							animation_speed = 0.5,
							shift = util.by_pixel(0, -47.75),
							scale = 0.5,
						},
						{
							filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/hydro-plant-fan.png",
							priority = "extra-high",
							width = 107,
							height = 77,
							frame_count = 24,
							line_length = 6,
							animation_speed = 0.5,
							shift = util.by_pixel(0, 0.125),
							scale = 0.5,
						},
						{
							filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/hydro-plant-fan.png",
							priority = "extra-high",
							width = 107,
							height = 77,
							frame_count = 24,
							line_length = 6,
							animation_speed = 0.5,
							shift = util.by_pixel(0, 48),
							scale = 0.5,
						},
					},
				},
			},
			{
				always_draw = true,
				north_position = util.by_pixel(14.5, -21.5),
				east_position = util.by_pixel(14.5, -21.5),
				south_position = util.by_pixel(14.5, -21.5),
				west_position = util.by_pixel(14.5, -21.5),
				animation = {
					layers = {
						{
							filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/hydro-plant-dynamo.png",
							priority = "extra-high",
							width = 40,
							height = 36,
							frame_count = 24,
							line_length = 6,
							animation_speed = 0.5,
							shift = util.by_pixel(0, -47.75),
							scale = 0.5,
						},
						{
							filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/hydro-plant-dynamo.png",
							priority = "extra-high",
							width = 40,
							height = 36,
							frame_count = 24,
							line_length = 6,
							animation_speed = 0.5,
							shift = util.by_pixel(0, 0.125),
							scale = 0.5,
						},
						{
							filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/hydro-plant-dynamo.png",
							priority = "extra-high",
							width = 40,
							height = 36,
							frame_count = 24,
							line_length = 6,
							animation_speed = 0.5,
							shift = util.by_pixel(0, 48),
							scale = 0.5,
						},
					},
				},
			},
			{
				always_draw = true,
				north_animation = {
					draw_as_shadow = true,
					filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/hydro-plant-shadow.png",
					priority = "extra-high",
					width = 538,
					height = 454,
					shift = util.by_pixel(20, 10.5),
					x = 0,
					y = 0,
					frame_count = 1,
					scale = 0.5,
				},
				east_animation = {
					draw_as_shadow = true,
					filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/hydro-plant-shadow.png",
					priority = "extra-high",
					width = 538,
					height = 454,
					x = 538,
					y = 0,
					frame_count = 1,
					shift = util.by_pixel(20, 10.5),
					scale = 0.5,
				},
				south_animation = {
					draw_as_shadow = true,
					filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/hydro-plant-shadow.png",
					priority = "extra-high",
					width = 538,
					x = 1076,
					y = 0,
					height = 454,
					frame_count = 1,
					shift = util.by_pixel(20, 10.5),
					scale = 0.5,
				},
				west_animation = {
					draw_as_shadow = true,
					filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/hydro-plant-shadow.png",
					priority = "extra-high",
					width = 538,
					height = 454,
					x = 1614,
					y = 0,
					frame_count = 1,
					shift = util.by_pixel(20, 10.5),
					scale = 0.5,
				},
			},
			{
				always_draw = true,
				north_animation = {
					filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/hydro-plant-pipe-connections.png",
					priority = "extra-high",
					width = 459,
					height = 491,
					x = 0,
					y = 0,
					frame_count = 1,
					scale = 0.5,
				},
				east_animation = {
					filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/hydro-plant-pipe-connections.png",
					priority = "extra-high",
					frame_count = 1,
					width = 459,
					height = 491,
					x = 459,
					y = 0,
					scale = 0.5,
				},
				south_animation = {
					filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/hydro-plant-pipe-connections.png",
					priority = "extra-high",
					width = 459,
					height = 491,
					x = 918,
					y = 0,
					frame_count = 1,
					scale = 0.5,
				},
				west_animation = {
					filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/hydro-plant-pipe-connections.png",
					priority = "extra-high",
					width = 459,
					height = 491,
					x = 1377,
					y = 0,
					frame_count = 1,
					scale = 0.5,
				},
			},
			{
				always_draw = true,
				north_animation = {
					draw_as_shadow = true,
					filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/vertical-pipe-shadow-patch.png",
					priority = "high",
					width = 128,
					height = 128,
					repeat_count = 36,
					scale = 0.5,
					shift = { -2, -3 },
				},
				south_animation = {
					layers = {
						{
							draw_as_shadow = true,
							filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/vertical-pipe-shadow-patch.png",
							priority = "high",
							width = 128,
							height = 128,
							repeat_count = 36,
							scale = 0.5,
							shift = { -2, -3 },
						},
						{
							draw_as_shadow = true,
							filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/vertical-pipe-shadow-patch.png",
							priority = "high",
							width = 128,
							height = 128,
							repeat_count = 36,
							scale = 0.5,
							shift = { 2, -3 },
						},
					},
				},
			},
		},
	}

	return graphics_set
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
---@nodiscard
function HydroPlantGraphicsPack.get_graphics_set_flipped(tint)
	---@type data.CraftingMachineGraphicsSet
	local graphics_set = {
		animation = make_animation(tint),
		working_visualisations = {
			{
				always_draw = true,
				north_position = util.by_pixel(-52.5, -43),
				east_position = util.by_pixel(-52.5, -43),
				south_position = util.by_pixel(-52.5, -43),
				west_position = util.by_pixel(-52.5, -43),
				animation = {
					layers = {
						{
							filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/hydro-plant-fan.png",
							priority = "extra-high",
							width = 107,
							height = 77,
							frame_count = 24,
							line_length = 6,
							animation_speed = 0.5,
							shift = util.by_pixel(0, -47.75),
							scale = 0.5,
						},
						{
							filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/hydro-plant-fan.png",
							priority = "extra-high",
							width = 107,
							height = 77,
							frame_count = 24,
							line_length = 6,
							animation_speed = 0.5,
							shift = util.by_pixel(0, 0.125),
							scale = 0.5,
						},
						{
							filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/hydro-plant-fan.png",
							priority = "extra-high",
							width = 107,
							height = 77,
							frame_count = 24,
							line_length = 6,
							animation_speed = 0.5,
							shift = util.by_pixel(0, 48),
							scale = 0.5,
						},
					},
				},
			},
			{
				always_draw = true,
				north_position = util.by_pixel(14.5, -21.5),
				east_position = util.by_pixel(14.5, -21.5),
				south_position = util.by_pixel(14.5, -21.5),
				west_position = util.by_pixel(14.5, -21.5),
				animation = {
					layers = {
						{
							filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/hydro-plant-dynamo.png",
							priority = "extra-high",
							width = 40,
							height = 36,
							frame_count = 24,
							line_length = 6,
							animation_speed = 0.5,
							shift = util.by_pixel(0, -47.75),
							scale = 0.5,
						},
						{
							filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/hydro-plant-dynamo.png",
							priority = "extra-high",
							width = 40,
							height = 36,
							frame_count = 24,
							line_length = 6,
							animation_speed = 0.5,
							shift = util.by_pixel(0, 0.125),
							scale = 0.5,
						},
						{
							filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/hydro-plant-dynamo.png",
							priority = "extra-high",
							width = 40,
							height = 36,
							frame_count = 24,
							line_length = 6,
							animation_speed = 0.5,
							shift = util.by_pixel(0, 48),
							scale = 0.5,
						},
					},
				},
			},
			{
				always_draw = true,
				north_animation = {
					draw_as_shadow = true,
					filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/hydro-plant-shadow-flipped.png",
					priority = "extra-high",
					width = 538,
					height = 454,
					shift = util.by_pixel(20, 10.5),
					x = 0,
					y = 0,
					frame_count = 1,
					scale = 0.5,
				},
				east_animation = {
					draw_as_shadow = true,
					filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/hydro-plant-shadow-flipped.png",
					priority = "extra-high",
					width = 538,
					height = 454,
					x = 538,
					y = 0,
					frame_count = 1,
					shift = util.by_pixel(20, 10.5),
					scale = 0.5,
				},
				south_animation = {
					draw_as_shadow = true,
					filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/hydro-plant-shadow-flipped.png",
					priority = "extra-high",
					width = 538,
					x = 1076,
					y = 0,
					height = 454,
					frame_count = 1,
					shift = util.by_pixel(20, 10.5),
					scale = 0.5,
				},
				west_animation = {
					draw_as_shadow = true,
					filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/hydro-plant-shadow-flipped.png",
					priority = "extra-high",
					width = 538,
					height = 454,
					x = 1614,
					y = 0,
					frame_count = 1,
					shift = util.by_pixel(20, 10.5),
					scale = 0.5,
				},
			},
			{
				always_draw = true,
				north_animation = {
					filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/hydro-plant-pipe-connections-flipped.png",
					priority = "extra-high",
					width = 459,
					height = 491,
					x = 0,
					y = 0,
					frame_count = 1,
					scale = 0.5,
				},
				east_animation = {
					filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/hydro-plant-pipe-connections-flipped.png",
					priority = "extra-high",
					frame_count = 1,
					width = 459,
					height = 491,
					x = 459,
					y = 0,
					scale = 0.5,
				},
				south_animation = {
					filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/hydro-plant-pipe-connections-flipped.png",
					priority = "extra-high",
					width = 459,
					height = 491,
					x = 918,
					y = 0,
					frame_count = 1,
					scale = 0.5,
				},
				west_animation = {
					filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/hydro-plant-pipe-connections-flipped.png",
					priority = "extra-high",
					width = 459,
					height = 491,
					x = 1377,
					y = 0,
					frame_count = 1,
					scale = 0.5,
				},
			},
			{
				always_draw = true,
				north_animation = {
					draw_as_shadow = true,
					filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/vertical-pipe-shadow-patch.png",
					priority = "high",
					width = 128,
					height = 128,
					repeat_count = 36,
					scale = 0.5,
					shift = { 2, -3 },
				},
				south_animation = {
					layers = {
						{
							draw_as_shadow = true,
							filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/vertical-pipe-shadow-patch.png",
							priority = "high",
							width = 128,
							height = 128,
							repeat_count = 36,
							scale = 0.5,
							shift = { 2, -3 },
						},
						{
							draw_as_shadow = true,
							filename = "__angelsrefininggraphics__/graphics/entity/hydro-plant/vertical-pipe-shadow-patch.png",
							priority = "high",
							width = 128,
							height = 128,
							repeat_count = 36,
							scale = 0.5,
							shift = { -2, -3 },
						},
					},
				},
			},
		},
	}

	return graphics_set
end

return HydroPlantGraphicsPack
