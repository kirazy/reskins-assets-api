loader.structure.front_patch = {
	sheet = {
		filename = "__reskins-assets-angels__/graphics/entity/loader-1x2/loader-1x2-front-patch.png",
		priority = "extra-high",
		width = 186,
		height = 155,
		shift = util.by_pixel(9.5, 1.5),
		scale = 0.5,
	},
}
loader.structure.direction_in = {
	sheets = {
		-- Base
		{
			filename = "__reskins-assets-angels__/graphics/entity/loader-1x2/loader-1x2-base.png",
			priority = "extra-high",
			width = 186,
			height = 155,
			shift = util.by_pixel(9.5, 1.5),
			scale = 0.5,
		},
		-- Mask
		{
			filename = "__reskins-assets-angels__/graphics/entity/loader-1x2/loader-1x2-mask.png",
			priority = "extra-high",
			width = 186,
			height = 155,
			shift = util.by_pixel(9.5, 1.5),
			tint = tint,
			scale = 0.5,
		},
		-- Shadow
		{
			filename = "__reskins-assets-angels__/graphics/entity/loader-1x2/loader-1x2-shadow.png",
			priority = "extra-high",
			width = 186,
			height = 155,
			shift = util.by_pixel(9.5, 1.5),
			draw_as_shadow = true,
			scale = 0.5,
		},
		-- Lights
		{
			filename = "__reskins-assets-angels__/graphics/entity/loader-1x2/loader-1x2-lights.png",
			priority = "extra-high",
			width = 186,
			height = 155,
			shift = util.by_pixel(9.5, 1.5),
			draw_as_light = true,
			scale = 0.5,
		},
	},
}
loader.structure.direction_out = {
	sheets = {
		-- Base
		{
			filename = "__reskins-assets-angels__/graphics/entity/loader-1x2/loader-1x2-base.png",
			priority = "extra-high",
			y = 155,
			width = 186,
			height = 155,
			shift = util.by_pixel(9.5, 1.5),
			scale = 0.5,
		},
		-- Mask
		{
			filename = "__reskins-assets-angels__/graphics/entity/loader-1x2/loader-1x2-mask.png",
			priority = "extra-high",
			width = 186,
			height = 155,
			shift = util.by_pixel(9.5, 1.5),
			tint = tint,
			scale = 0.5,
		},
		-- Shadow
		{
			filename = "__reskins-assets-angels__/graphics/entity/loader-1x2/loader-1x2-shadow.png",
			priority = "extra-high",
			width = 186,
			height = 155,
			shift = util.by_pixel(9.5, 1.5),
			draw_as_shadow = true,
			scale = 0.5,
		},
		-- Lights
		{
			filename = "__reskins-assets-angels__/graphics/entity/loader-1x2/loader-1x2-lights.png",
			priority = "extra-high",
			y = 155,
			width = 186,
			height = 155,
			shift = util.by_pixel(9.5, 1.5),
			draw_as_light = true,
			scale = 0.5,
		},
	},
}

loader.structure_render_layer = "object"
