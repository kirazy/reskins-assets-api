local _defines = require("api.defines")
local _sprites = require("__reskins-sprite-utils__.sprites")

local GraphicsPackBase = require("graphics-pack-base")

---@class Reskins.Base.HeatExchangerGraphicsPack:Reskins.Abstractions.GraphicsPackBase
---@field pictures data.BoilerPictureSet
---@field pipe_covers data.Animation4Way
local HeatExchangerGraphicsPack = {}
HeatExchangerGraphicsPack.__index = HeatExchangerGraphicsPack

-- Set up inheritance.
setmetatable(HeatExchangerGraphicsPack, {
	__index = GraphicsPackBase,
})

---@class Reskins.Base.HeatExchangerGraphicsParams
---@field tint data.Color?
---@field pipe_material "base"|"aluminum-invar"|"silver-aluminum"|"silver-titanium"|"gold-copper"

---@param params Reskins.Base.HeatExchangerGraphicsParams
---@return Reskins.Base.HeatExchangerGraphicsPack
---@nodiscard
function HeatExchangerGraphicsPack:configure(params)
	local required_assets = { [_defines.assets.base_assets] = true }
	if params.pipe_material ~= "base" then
		required_assets[_defines.assets.bobs_assets] = true
	end

	local instance = GraphicsPackBase.configure(self, {
		tint = params.tint,
		remnants = self.get_corpse_animation(params.tint, params.pipe_material),
		required_assets = required_assets,
	}) --[[@as Reskins.Base.HeatExchangerGraphicsPack]]

	instance.pictures = self.get_picture_set(params.tint, params.pipe_material)
	instance.pipe_covers = self.get_pipe_covers(params.pipe_material)

	setmetatable(instance, HeatExchangerGraphicsPack)
	return instance
end

---@param prototype data.BoilerPrototype
function HeatExchangerGraphicsPack:apply_to_entity(prototype)
	prototype.pictures = util.copy(self.pictures)
	prototype.energy_source.pipe_covers = util.copy(self.pipe_covers)
end

---@param pipe_material "base"|"aluminum-invar"|"silver-aluminum"|"silver-titanium"|"gold-copper"
---@return string
---@nodiscard
---@private
function HeatExchangerGraphicsPack.get_pipe_path(pipe_material)
	if pipe_material == "base" then
		return "__reskins-assets-base__/graphics/entity/heat-exchanger/heat-pipes/base/"
	else
		return "__reskins-assets-bobs__/graphics/entity/heat-exchanger/heat-pipes/" .. pipe_material .. "/"
	end
end

---@param tint data.Color?
---@param pipe_material "base"|"aluminum-invar"|"silver-aluminum"|"silver-titanium"|"gold-copper"
---@return data.BoilerPictureSet
---@nodiscard
function HeatExchangerGraphicsPack.get_picture_set(tint, pipe_material)
	local base_path = "__base__/graphics/entity/heat-exchanger/"
	local shadow_path = "__base__/graphics/entity/boiler/"
	local assets_path = "__reskins-assets-base__/graphics/entity/heat-exchanger/"
	local pipe_path = HeatExchangerGraphicsPack.get_pipe_path(pipe_material)

	---@type data.Animation
	local north = {
		layers = {
			{
				filename = base_path .. "heatex-N-idle.png",
				priority = "extra-high",
				width = 269,
				height = 221,
				shift = util.by_pixel(-1.25, 5.25),
				scale = 0.5,
			},
		},
	}

	---@type data.Animation
	local east = {
		layers = {
			{
				filename = base_path .. "heatex-E-idle.png",
				priority = "extra-high",
				width = 211,
				height = 301,
				shift = util.by_pixel(-1.75, 1.25),
				scale = 0.5,
			},
		},
	}

	---@type data.Animation
	local south = {
		layers = {
			{
				filename = base_path .. "heatex-S-idle.png",
				priority = "extra-high",
				width = 260,
				height = 201,
				shift = util.by_pixel(4, 10.75),
				scale = 0.5,
			},
		},
	}

	---@type data.Animation
	local west = {
		layers = {
			{
				filename = base_path .. "heatex-W-idle.png",
				priority = "extra-high",
				width = 196,
				height = 273,
				shift = util.by_pixel(1.5, 7.75),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(north.layers, {
			filename = assets_path .. "heat-exchanger-north-idle-mask.png",
			priority = "extra-high",
			width = 269,
			height = 221,
			shift = util.by_pixel(-1.25, 5.25),
			tint = tint,
			scale = 0.5,
		})
		table.insert(north.layers, {
			filename = assets_path .. "heat-exchanger-north-idle-highlights.png",
			priority = "extra-high",
			width = 269,
			height = 221,
			shift = util.by_pixel(-1.25, 5.25),
			blend_mode = "additive-soft",
			scale = 0.5,
		})

		table.insert(east.layers, {
			filename = assets_path .. "heat-exchanger-east-idle-mask.png",
			priority = "extra-high",
			width = 211,
			height = 301,
			shift = util.by_pixel(-1.75, 1.25),
			tint = tint,
			scale = 0.5,
		})
		table.insert(east.layers, {
			filename = assets_path .. "heat-exchanger-east-idle-highlights.png",
			priority = "extra-high",
			width = 211,
			height = 301,
			shift = util.by_pixel(-1.75, 1.25),
			blend_mode = "additive-soft",
			scale = 0.5,
		})

		table.insert(south.layers, {
			filename = assets_path .. "heat-exchanger-south-idle-mask.png",
			priority = "extra-high",
			width = 260,
			height = 201,
			shift = util.by_pixel(4, 10.75),
			tint = tint,
			scale = 0.5,
		})
		table.insert(south.layers, {
			filename = assets_path .. "heat-exchanger-south-idle-highlights.png",
			priority = "extra-high",
			width = 260,
			height = 201,
			shift = util.by_pixel(4, 10.75),
			blend_mode = "additive-soft",
			scale = 0.5,
		})

		table.insert(west.layers, {
			filename = assets_path .. "heat-exchanger-west-idle-mask.png",
			priority = "extra-high",
			width = 196,
			height = 273,
			shift = util.by_pixel(1.5, 7.75),
			tint = tint,
			scale = 0.5,
		})
		table.insert(west.layers, {
			filename = assets_path .. "heat-exchanger-west-idle-highlights.png",
			priority = "extra-high",
			width = 196,
			height = 273,
			shift = util.by_pixel(1.5, 7.75),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	-- Pipe overlay is always appended regardless of tint.
	table.insert(north.layers, {
		filename = pipe_path .. "heat-pipe-north-idle.png",
		priority = "extra-high",
		width = 269,
		height = 221,
		shift = util.by_pixel(-1.25, 5.25),
		scale = 0.5,
	})
	table.insert(east.layers, {
		filename = pipe_path .. "heat-pipe-east-idle.png",
		priority = "extra-high",
		width = 211,
		height = 301,
		shift = util.by_pixel(-1.75, 1.25),
		scale = 0.5,
	})
	table.insert(south.layers, {
		filename = pipe_path .. "heat-pipe-south-idle.png",
		priority = "extra-high",
		width = 260,
		height = 201,
		shift = util.by_pixel(4, 10.75),
		scale = 0.5,
	})
	table.insert(west.layers, {
		filename = pipe_path .. "heat-pipe-west-idle.png",
		priority = "extra-high",
		width = 196,
		height = 273,
		shift = util.by_pixel(1.5, 7.75),
		scale = 0.5,
	})

	-- Shadows are always appended last.
	table.insert(north.layers, {
		filename = shadow_path .. "boiler-N-shadow.png",
		priority = "extra-high",
		width = 274,
		height = 164,
		shift = util.by_pixel(20.5, 9),
		draw_as_shadow = true,
		scale = 0.5,
	})
	table.insert(east.layers, {
		filename = shadow_path .. "boiler-E-shadow.png",
		priority = "extra-high",
		width = 184,
		height = 194,
		shift = util.by_pixel(30, 9.5),
		draw_as_shadow = true,
		scale = 0.5,
	})
	table.insert(south.layers, {
		filename = shadow_path .. "boiler-S-shadow.png",
		priority = "extra-high",
		width = 311,
		height = 131,
		shift = util.by_pixel(29.75, 15.75),
		draw_as_shadow = true,
		scale = 0.5,
	})
	table.insert(west.layers, {
		filename = shadow_path .. "boiler-W-shadow.png",
		priority = "extra-high",
		width = 206,
		height = 218,
		shift = util.by_pixel(19.5, 6.5),
		draw_as_shadow = true,
		scale = 0.5,
	})

	---@type data.BoilerPictureSet
	local picture_set = {
		north = { structure = north },
		east = { structure = east },
		south = { structure = south },
		west = { structure = west },
	}

	return picture_set
end

---@param pipe_material "base"|"aluminum-invar"|"silver-aluminum"|"silver-titanium"|"gold-copper"
---@return data.Animation4Way
---@nodiscard
function HeatExchangerGraphicsPack.get_pipe_covers(pipe_material)
	local pipe_path = HeatExchangerGraphicsPack.get_pipe_path(pipe_material)

	return _sprites.make_4way_animation_from_spritesheet({
		filename = pipe_path .. "heat-pipe-endings.png",
		width = 64,
		height = 64,
		direction_count = 4,
		scale = 0.5,
	})
end

---@param tint data.Color?
---@param pipe_material "base"|"aluminum-invar"|"silver-aluminum"|"silver-titanium"|"gold-copper"
---@return data.RotatedAnimation
---@nodiscard
function HeatExchangerGraphicsPack.get_corpse_animation(tint, pipe_material)
	local assets_path = "__reskins-assets-base__/graphics/entity/heat-exchanger/remnants/"
	local pipe_path = HeatExchangerGraphicsPack.get_pipe_path(pipe_material)
	local pipe_remnant_filename = pipe_material == "base" and "heat-pipe-remnants.png" or "heat-pipe-remnants-base.png"

	---@type data.RotatedAnimation
	local animation = {
		layers = {
			{
				filename = "__base__/graphics/entity/heat-exchanger/remnants/heat-exchanger-remnants.png",
				width = 272,
				height = 262,
				direction_count = 4,
				shift = util.by_pixel(0.5, 8),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			filename = assets_path .. "heat-exchanger-remnants-mask.png",
			width = 272,
			height = 262,
			direction_count = 4,
			shift = util.by_pixel(0.5, 8),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers, {
			filename = assets_path .. "heat-exchanger-remnants-highlights.png",
			width = 272,
			height = 262,
			direction_count = 4,
			shift = util.by_pixel(0.5, 8),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	-- Pipe remnant is always appended regardless of tint.
	table.insert(animation.layers, {
		filename = pipe_path .. pipe_remnant_filename,
		width = 272,
		height = 262,
		direction_count = 4,
		shift = util.by_pixel(0.5, 8),
		scale = 0.5,
	})

	return animation
end

return HeatExchangerGraphicsPack
