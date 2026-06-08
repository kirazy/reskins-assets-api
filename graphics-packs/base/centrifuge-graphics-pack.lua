local _sprites = require("__reskins-sprite-utils__.sprites")
local _defines = require("api.defines")

local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")

---@class Reskins.Base.CentrifugeGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local CentrifugeGraphicsPack = {}
CentrifugeGraphicsPack.__index = CentrifugeGraphicsPack

-- Set up inheritance
setmetatable(CentrifugeGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class Reskins.Base.CentrifugeGraphicsParams:Reskins.Abstractions.BaseGraphicsParams

---@param params Reskins.Base.CentrifugeGraphicsParams
---@return Reskins.Base.CentrifugeGraphicsPack
---@nodiscard
function CentrifugeGraphicsPack:configure(params)
	local graphics_set = CentrifugeGraphicsPack.get_graphics_set(params.tint)
	local remnants = CentrifugeGraphicsPack.get_corpse_animation(params.tint)

	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		scale = params.scale,
		scale_factor = params.scale_factor,
		remnants = remnants,
		nominal_width = 3,
		nominal_height = 3,
		required_assets = { [_defines.assets.base_assets] = true },
		graphics_set = graphics_set,
	}) --[[@as Reskins.Base.CentrifugeGraphicsPack]]

	setmetatable(instance, CentrifugeGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
function CentrifugeGraphicsPack.get_graphics_set(tint)
	local assets_path = "__reskins-assets-base__/graphics/entity/centrifuge/"

	---@type data.Animation
	local idle_animation = {
		layers = {
			-- Centrifuge C — no tint layers; C sub-assembly is always unmodified base-game appearance
			{
				filename = "__base__/graphics/entity/centrifuge/centrifuge-C.png",
				priority = "high",
				scale = 0.5,
				line_length = 8,
				width = 237,
				height = 214,
				frame_count = 64,
				shift = util.by_pixel(-0.25, -26.5),
			},
			{
				filename = "__base__/graphics/entity/centrifuge/centrifuge-C-shadow.png",
				priority = "high",
				draw_as_shadow = true,
				scale = 0.5,
				line_length = 8,
				width = 279,
				height = 152,
				frame_count = 64,
				shift = util.by_pixel(16.75, -10),
			},
			-- Centrifuge B — base
			{
				filename = "__base__/graphics/entity/centrifuge/centrifuge-B.png",
				priority = "high",
				scale = 0.5,
				line_length = 8,
				width = 156,
				height = 234,
				frame_count = 64,
				shift = util.by_pixel(23, 6.5),
			},
		},
	}

	if tint then
		-- Centrifuge B — mask and highlights
		table.insert(idle_animation.layers, {
			filename = assets_path .. "centrifuge-b-mask.png",
			priority = "high",
			tint = tint,
			scale = 0.5,
			line_length = 8,
			width = 156,
			height = 234,
			frame_count = 64,
			shift = util.by_pixel(23, 6.5),
		})
		table.insert(idle_animation.layers, {
			filename = assets_path .. "centrifuge-b-highlights.png",
			priority = "high",
			blend_mode = "additive-soft",
			scale = 0.5,
			line_length = 8,
			width = 156,
			height = 234,
			frame_count = 64,
			shift = util.by_pixel(23, 6.5),
		})
	end

	-- Centrifuge B — shadow
	table.insert(idle_animation.layers, {
		filename = "__base__/graphics/entity/centrifuge/centrifuge-B-shadow.png",
		priority = "high",
		draw_as_shadow = true,
		scale = 0.5,
		line_length = 8,
		width = 251,
		height = 149,
		frame_count = 64,
		shift = util.by_pixel(63.25, 15.25),
	})

	-- Centrifuge A — base
	table.insert(idle_animation.layers, {
		filename = "__base__/graphics/entity/centrifuge/centrifuge-A.png",
		priority = "high",
		scale = 0.5,
		line_length = 8,
		width = 139,
		height = 246,
		frame_count = 64,
		shift = util.by_pixel(-26.25, 3.5),
	})

	if tint then
		-- Centrifuge A — mask and highlights
		table.insert(idle_animation.layers, {
			filename = assets_path .. "centrifuge-a-mask.png",
			priority = "high",
			tint = tint,
			scale = 0.5,
			line_length = 8,
			width = 139,
			height = 246,
			frame_count = 64,
			shift = util.by_pixel(-26.25, 3.5),
		})
		table.insert(idle_animation.layers, {
			filename = assets_path .. "centrifuge-a-highlights.png",
			priority = "high",
			blend_mode = "additive-soft",
			scale = 0.5,
			line_length = 8,
			width = 139,
			height = 246,
			frame_count = 64,
			shift = util.by_pixel(-26.25, 3.5),
		})
	end

	-- Centrifuge A — shadow
	table.insert(idle_animation.layers, {
		filename = "__base__/graphics/entity/centrifuge/centrifuge-A-shadow.png",
		priority = "high",
		draw_as_shadow = true,
		scale = 0.5,
		line_length = 8,
		width = 230,
		height = 124,
		frame_count = 64,
		shift = util.by_pixel(8.5, 23.5),
	})

	---@type data.WorkingVisualisation[]
	local working_visualisations = {
		-- Area light
		{
			effect = "uranium-glow",
			apply_recipe_tint = "primary",
			fadeout = true,
			light = { intensity = 0.1, size = 9.9, shift = { 0.0, 0.0 }, color = { r = 0.0, g = 1.0, b = 0.0 } },
		},
		-- Working lights — three sub-assembly glow layers
		{
			effect = "uranium-glow",
			fadeout = true,
			apply_recipe_tint = "primary",
			animation = {
				layers = {
					-- Centrifuge C
					{
						filename = assets_path .. "lights/centrifuge-c-light.png",
						priority = "high",
						scale = 0.5,
						blend_mode = "additive",
						line_length = 8,
						width = 190,
						height = 207,
						frame_count = 64,
						shift = util.by_pixel(0, -27.25),
						draw_as_glow = true,
					},
					-- Centrifuge B
					{
						filename = assets_path .. "lights/centrifuge-b-light.png",
						priority = "high",
						scale = 0.5,
						blend_mode = "additive",
						line_length = 8,
						width = 131,
						height = 206,
						frame_count = 64,
						shift = util.by_pixel(16.75, 0.5),
						draw_as_glow = true,
					},
					-- Centrifuge A
					{
						filename = assets_path .. "lights/centrifuge-a-light.png",
						priority = "high",
						scale = 0.5,
						blend_mode = "additive",
						line_length = 8,
						width = 108,
						height = 197,
						frame_count = 64,
						shift = util.by_pixel(-23.5, -1.75),
						draw_as_glow = true,
					},
				},
			},
		},
	}

	return {
		always_draw_idle_animation = true,
		idle_animation = idle_animation,
		working_visualisations = working_visualisations,
	}
end

---@param tint data.Color?
---@return data.RotatedAnimationVariations
function CentrifugeGraphicsPack.get_corpse_animation(tint)
	local assets_path = "__reskins-assets-base__/graphics/entity/centrifuge/"

	local layers = {
		-- Base
		{
			filename = "__base__/graphics/entity/centrifuge/remnants/centrifuge-remnants.png",
			width = 286,
			height = 284,
			direction_count = 1,
			shift = util.by_pixel(7, 4),
			scale = 0.5,
		},
	}

	if tint then
		-- Mask
		table.insert(layers, {
			filename = assets_path .. "remnants/centrifuge-remnants-mask.png",
			width = 286,
			height = 284,
			direction_count = 1,
			shift = util.by_pixel(7, 4),
			tint = tint,
			scale = 0.5,
		})
		-- Highlights
		table.insert(layers, {
			filename = assets_path .. "remnants/centrifuge-remnants-highlights.png",
			width = 286,
			height = 284,
			direction_count = 1,
			shift = util.by_pixel(7, 4),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return _sprites.make_rotated_animation_variations_from_spritesheet(1, { layers = layers })
end

return CentrifugeGraphicsPack
