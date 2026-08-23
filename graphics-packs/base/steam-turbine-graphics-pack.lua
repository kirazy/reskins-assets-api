local _defines = require("api.defines")

local GeneratorGraphicsPack = require("graphics-packs.abstractions.generator-graphics-pack")

---@class SteamTurbineGraphicsPack:Reskins.Abstractions.GeneratorGraphicsPack
local SteamTurbineGraphicsPack = {}
SteamTurbineGraphicsPack.__index = SteamTurbineGraphicsPack

-- Set up inheritance.
setmetatable(SteamTurbineGraphicsPack, {
	__index = GeneratorGraphicsPack,
})

---@class SteamTurbineGraphicsParams:Reskins.Abstractions.BaseGraphicsParams

---@param params SteamTurbineGraphicsParams
---@return SteamTurbineGraphicsPack
---@nodiscard
function SteamTurbineGraphicsPack:configure(params)
	local instance = GeneratorGraphicsPack.configure(self, {
		tint = params.tint,
		scale = params.scale,
		scale_factor = params.scale_factor,
		remnants = self.get_corpse_animation(params.tint),
		required_assets = { [_defines.assets_source.base_assets] = true },
		nominal_width = 3,
		nominal_height = 5,
		horizontal_animation = self.get_horizontal_animation(params.tint),
		vertical_animation = self.get_vertical_animation(params.tint),
	}) --[[@as SteamTurbineGraphicsPack]]

	setmetatable(instance, SteamTurbineGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.Animation
---@nodiscard
function SteamTurbineGraphicsPack.get_horizontal_animation(tint)
	local base_path = "__base__/graphics/entity/steam-turbine/"
	local assets_path = "__reskins-assets-base__/graphics/entity/steam-turbine/"

	---@type data.Animation
	local animation = {
		layers = {
			{
				filename = base_path .. "steam-turbine-H.png",
				width = 320,
				height = 245,
				frame_count = 8,
				line_length = 4,
				shift = util.by_pixel(0, -2.75),
				run_mode = "backward",
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			filename = assets_path .. "steam-turbine-horizontal-mask.png",
			width = 320,
			height = 245,
			repeat_count = 8,
			shift = util.by_pixel(0, -2.75),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers, {
			filename = assets_path .. "steam-turbine-horizontal-highlights.png",
			width = 320,
			height = 245,
			repeat_count = 8,
			shift = util.by_pixel(0, -2.75),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	table.insert(animation.layers, {
		filename = base_path .. "steam-turbine-H-shadow.png",
		width = 435,
		height = 150,
		repeat_count = 8,
		shift = util.by_pixel(28.5, 18),
		run_mode = "backward",
		draw_as_shadow = true,
		scale = 0.5,
	})

	return animation
end

---@param tint data.Color?
---@return data.Animation
---@nodiscard
function SteamTurbineGraphicsPack.get_vertical_animation(tint)
	local base_path = "__base__/graphics/entity/steam-turbine/"
	local assets_path = "__reskins-assets-base__/graphics/entity/steam-turbine/"

	---@type data.Animation
	local animation = {
		layers = {
			{
				filename = base_path .. "steam-turbine-V.png",
				width = 217,
				height = 374,
				frame_count = 8,
				line_length = 4,
				shift = util.by_pixel(4.75, 0),
				run_mode = "backward",
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			filename = assets_path .. "steam-turbine-vertical-mask.png",
			width = 217,
			height = 347,
			repeat_count = 8,
			shift = util.by_pixel(4.75, 6.75),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers, {
			filename = assets_path .. "steam-turbine-vertical-highlights.png",
			width = 217,
			height = 347,
			repeat_count = 8,
			shift = util.by_pixel(4.75, 6.75),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	table.insert(animation.layers, {
		filename = base_path .. "steam-turbine-V-shadow.png",
		width = 302,
		height = 260,
		repeat_count = 8,
		shift = util.by_pixel(39.5, 24.5),
		run_mode = "backward",
		draw_as_shadow = true,
		scale = 0.5,
	})

	return animation
end

---@param tint data.Color?
---@return data.RotatedAnimation
---@nodiscard
function SteamTurbineGraphicsPack.get_corpse_animation(tint)
	local assets_path = "__reskins-assets-base__/graphics/entity/steam-turbine/remnants/"

	---@type data.RotatedAnimation
	local animation = {
		layers = {
			{
				filename = "__base__/graphics/entity/steam-turbine/remnants/steam-turbine-remnants.png",
				width = 460,
				height = 408,
				direction_count = 4,
				shift = util.by_pixel(6, 0),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			filename = assets_path .. "steam-turbine-remnants-mask.png",
			width = 460,
			height = 408,
			direction_count = 4,
			shift = util.by_pixel(6, 0),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers, {
			filename = assets_path .. "steam-turbine-remnants-highlights.png",
			width = 460,
			height = 408,
			direction_count = 4,
			shift = util.by_pixel(6, 0),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return animation
end

return SteamTurbineGraphicsPack
