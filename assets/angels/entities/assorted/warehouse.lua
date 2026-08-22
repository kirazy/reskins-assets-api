_colors = require("__reskins-sprite-utils__.colors")

local picture = {
	layers = {
		-- Base
		{
			filename = "__reskins-assets-angels__/graphics/entity/warehouse/warehouse.png",
			priority = "extra-high",
			width = 391,
			height = 446,
			shift = util.by_pixel(-0.5, -15),
			scale = 0.5,
		},
		-- Shadow
		{
			filename = "__reskins-assets-angels__/graphics/entity/warehouse/warehouse-shadow.png",
			priority = "extra-high",
			width = 592,
			height = 276,
			shift = util.by_pixel(52.5, 30.5),
			draw_as_shadow = true,
			scale = 0.5,
		},
	},
}

-- Used for particle colors.
local logistic_map = {
	["active-provider"] = { tint = _colors.from_argb("FF760FD6") },
	["buffer"] = { tint = _colors.from_argb("FF00BF13") },
	["passive-provider"] = { tint = _colors.from_argb("FFFF0000") },
	["requester"] = { tint = _colors.from_argb("FF227DAE") },
	["storage"] = { tint = _colors.from_argb("FFBA7713") },
}

local logistic_picture = {
	layers = {
		-- Base
		{
			filename = "__reskins-assets-angels__/graphics/entity/warehouse/logistic-warehouse-" .. chest .. ".png",
			priority = "extra-high",
			width = 391,
			height = 446,
			shift = util.by_pixel(-0.5, -15),
			scale = 0.5,
		},
		-- Shadow
		{
			filename = "__reskins-assets-angels__/graphics/entity/warehouse/logistic-warehouse-shadow.png",
			priority = "extra-high",
			width = 592,
			height = 276,
			shift = util.by_pixel(52.5, 30.5),
			draw_as_shadow = true,
			scale = 0.5,
		},
		-- Light
		{
			filename = "__reskins-assets-angels__/graphics/entity/warehouse/logistic-warehouse-light.png",
			priority = "extra-high",
			width = 9,
			height = 28,
			shift = util.by_pixel(71.5, -104),
			draw_as_light = true,
			scale = 0.5,
		},
	},
}
