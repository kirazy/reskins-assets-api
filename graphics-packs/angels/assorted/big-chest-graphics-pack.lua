_colors = require("__reskins-sprite-utils__.colors")

local picture = {
	layers = {
		-- Base
		{
			filename = "__reskins-assets-angels__/graphics/entity/big-chest/big-chest.png",
			priority = "extra-high",
			width = 135,
			height = 169,
			shift = util.by_pixel(-0.5, -10),
			scale = 0.5,
		},
		-- Shadow
		{
			filename = "__reskins-assets-angels__/graphics/entity/big-chest/big-chest-shadow.png",
			priority = "extra-high",
			width = 209,
			height = 97,
			shift = util.by_pixel(18.5, 8.5),
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
			filename = "__reskins-assets-angels__/graphics/entity/big-chest/logistic-big-chest-" .. chest .. ".png",
			priority = "extra-high",
			width = 135,
			height = 169,
			shift = util.by_pixel(-0.5, -10.5),
			scale = 0.5,
		},
		-- Shadow
		{
			filename = "__reskins-assets-angels__/graphics/entity/big-chest/logistic-big-chest-shadow.png",
			priority = "extra-high",
			width = 209,
			height = 97,
			shift = util.by_pixel(18.5, 8.5),
			draw_as_shadow = true,
			scale = 0.5,
		},
		-- Light
		{
			filename = "__reskins-assets-angels__/graphics/entity/big-chest/logistic-big-chest-light.png",
			priority = "extra-high",
			width = 5,
			height = 15,
			shift = util.by_pixel(20.5, -41.5),
			draw_as_light = true,
			scale = 0.5,
		},
	},
}
