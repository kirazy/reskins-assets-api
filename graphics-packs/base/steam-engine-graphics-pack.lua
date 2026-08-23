local _defines = require("api.defines")

local GeneratorGraphicsPack = require("graphics-packs.abstractions.generator-graphics-pack")

---@class SteamEngineGraphicsPack:Reskins.Abstractions.GeneratorGraphicsPack
local SteamEngineGraphicsPack = {}
SteamEngineGraphicsPack.__index = SteamEngineGraphicsPack

-- Set up inheritance.
setmetatable(SteamEngineGraphicsPack, {
	__index = GeneratorGraphicsPack,
})

---@class SteamEngineGraphicsParams:Reskins.Abstractions.BaseGraphicsParams

---@param params SteamEngineGraphicsParams
---@return SteamEngineGraphicsPack
---@nodiscard
function SteamEngineGraphicsPack:configure(params)
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
	}) --[[@as SteamEngineGraphicsPack]]

	setmetatable(instance, SteamEngineGraphicsPack)
	return instance
end

---@param tint data.Color?
---@return data.Animation
---@nodiscard
function SteamEngineGraphicsPack.get_horizontal_animation(tint)
	local base_path = "__base__/graphics/entity/steam-engine/"
	local assets_path = "__reskins-assets-base__/graphics/entity/steam-engine/"

	---@type data.Animation
	local animation = {
		layers = {
			{
				filename = base_path .. "steam-engine-H.png",
				width = 352,
				height = 257,
				frame_count = 32,
				line_length = 8,
				shift = util.by_pixel(1, -4.75),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			filename = assets_path .. "steam-engine-horizontal-mask.png",
			width = 352,
			height = 257,
			frame_count = 32,
			line_length = 8,
			shift = util.by_pixel(1, -4.75),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers, {
			filename = assets_path .. "steam-engine-horizontal-highlights.png",
			width = 352,
			height = 257,
			frame_count = 32,
			line_length = 8,
			shift = util.by_pixel(1, -4.75),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	table.insert(animation.layers, {
		filename = base_path .. "steam-engine-H-shadow.png",
		width = 508,
		height = 160,
		frame_count = 32,
		line_length = 8,
		shift = util.by_pixel(48, 24),
		draw_as_shadow = true,
		scale = 0.5,
	})

	return animation
end

---@param tint data.Color?
---@return data.Animation
---@nodiscard
function SteamEngineGraphicsPack.get_vertical_animation(tint)
	local base_path = "__base__/graphics/entity/steam-engine/"
	local assets_path = "__reskins-assets-base__/graphics/entity/steam-engine/"

	---@type data.Animation
	local animation = {
		layers = {
			{
				filename = base_path .. "steam-engine-V.png",
				width = 225,
				height = 391,
				frame_count = 32,
				line_length = 8,
				shift = util.by_pixel(4.75, -6.25),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			filename = assets_path .. "steam-engine-vertical-mask.png",
			width = 225,
			height = 391,
			frame_count = 32,
			line_length = 8,
			shift = util.by_pixel(4.75, -6.25),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers, {
			filename = assets_path .. "steam-engine-vertical-highlights.png",
			width = 225,
			height = 391,
			frame_count = 32,
			line_length = 8,
			shift = util.by_pixel(4.75, -6.25),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	table.insert(animation.layers, {
		filename = base_path .. "steam-engine-V-shadow.png",
		width = 330,
		height = 307,
		frame_count = 32,
		line_length = 8,
		shift = util.by_pixel(40.5, 9.25),
		draw_as_shadow = true,
		scale = 0.5,
	})

	return animation
end

---@param tint data.Color?
---@return data.RotatedAnimation
---@nodiscard
function SteamEngineGraphicsPack.get_corpse_animation(tint)
	local assets_path = "__reskins-assets-base__/graphics/entity/steam-engine/remnants/"

	---@type data.RotatedAnimation
	local animation = {
		layers = {
			{
				filename = "__base__/graphics/entity/steam-engine/remnants/steam-engine-remnants.png",
				width = 462,
				height = 386,
				direction_count = 4,
				shift = util.by_pixel(17, 6.5),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			filename = assets_path .. "steam-engine-remnants-mask.png",
			width = 462,
			height = 386,
			direction_count = 4,
			shift = util.by_pixel(17, 6.5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers, {
			filename = assets_path .. "steam-engine-remnants-highlights.png",
			width = 462,
			height = 386,
			direction_count = 4,
			shift = util.by_pixel(17, 6.5),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return animation
end

return SteamEngineGraphicsPack
