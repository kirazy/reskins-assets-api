local _defines = require("api.defines")
local StringValidator = require("prototypes.string-validator")

local GraphicsPackBase = require("graphics-packs.abstractions.graphics-pack-base")

---@class Reskins.Base.NuclearReactorGraphicsSet
---@field connection_patches_connected data.SpriteVariations
---@field connection_patches_disconnected data.SpriteVariations
---@field heat_connection_patches_connected data.SpriteVariations
---@field heat_connection_patches_disconnected data.SpriteVariations
---@field heat_lower_layer_picture data.Sprite
---@field lower_layer_picture data.Sprite
---@field picture data.Sprite
---@field fuel_glow_working_light_picture data.Animation
---@field working_light_picture data.Animation

---@class Reskins.Base.NuclearReactorGraphicsPack:Reskins.Abstractions.GraphicsPackBase
---@field graphics_set Reskins.Base.NuclearReactorGraphicsSet
---@field use_fuel_glow_color boolean
local NuclearReactorGraphicsPack = {}
NuclearReactorGraphicsPack.__index = NuclearReactorGraphicsPack

-- Set up inheritance.
setmetatable(NuclearReactorGraphicsPack, {
	__index = GraphicsPackBase,
})

---@param pipe_material "base"|"aluminum-invar"|"silver-aluminum"|"silver-titanium"|"gold-copper"
---@return string
---@nodiscard
local function get_pipe_path(pipe_material)
	if pipe_material == "base" then
		return "__reskins-assets-base__/graphics/entity/nuclear-reactor/heat-pipes/base/"
	else
		return "__reskins-assets-bobs__/graphics/entity/nuclear-reactor/heat-pipes/" .. pipe_material .. "/"
	end
end

---@param tint data.Color?
---@param pipe_path string
---@return data.Sprite
---@nodiscard
local function get_picture(tint, pipe_path)
	local base_path = "__base__/graphics/entity/nuclear-reactor/"
	local assets_path = "__reskins-assets-base__/graphics/entity/nuclear-reactor/"

	---@type data.Sprite
	local picture = {
		layers = {
			{
				filename = base_path .. "reactor.png",
				width = 302,
				height = 318,
				shift = util.by_pixel(-5, -7),
				scale = 0.5,
			},
			{
				filename = base_path .. "reactor-shadow.png",
				width = 525,
				height = 323,
				shift = { 1.625, 0 },
				draw_as_shadow = true,
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(picture.layers, {
			filename = assets_path .. "nuclear-reactor-mask.png",
			width = 302,
			height = 318,
			shift = util.by_pixel(-5, -7),
			tint = tint,
			scale = 0.5,
		})
		table.insert(picture.layers, {
			filename = assets_path .. "nuclear-reactor-highlights.png",
			width = 302,
			height = 318,
			shift = util.by_pixel(-5, -7),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	table.insert(picture.layers, {
		filename = pipe_path .. "nuclear-reactor-piping.png",
		width = 302,
		height = 318,
		shift = util.by_pixel(-5, -7),
		scale = 0.5,
	})

	return picture
end

---@class NuclearReactorGraphicsParams
---@field tint data.Color?
---@field pipe_material ("base"|"aluminum-invar"|"silver-aluminum"|"silver-titanium"|"gold-copper")?
---@field use_fuel_glow_color boolean?

---@param params NuclearReactorGraphicsParams
---@return Reskins.Base.NuclearReactorGraphicsPack
---@nodiscard
function NuclearReactorGraphicsPack:configure(params)
	local required_assets = { [_defines.assets.base_assets] = true }

	local pipe_material = params.pipe_material or "base"
	if pipe_material ~= "base" then
		required_assets[_defines.assets.bobs_assets] = true
	end

	local graphics_set = self.get_graphics_set(params.tint, pipe_material)
	local instance = GraphicsPackBase.configure(self, {
		tint = params.tint,
		remnants = self.get_corpse_animation(params.tint, pipe_material),
		required_assets = required_assets,
	}) --[[@as Reskins.Base.NuclearReactorGraphicsPack]]

	instance.graphics_set = graphics_set
	instance.use_fuel_glow_color = params.use_fuel_glow_color == true

	setmetatable(instance, NuclearReactorGraphicsPack)
	return instance
end

---@param prototype data.ReactorPrototype
function NuclearReactorGraphicsPack:apply_to_entity(prototype)
	local graphics_set = util.copy(self.graphics_set)

	prototype.connection_patches_connected = graphics_set.connection_patches_connected
	prototype.connection_patches_disconnected = graphics_set.connection_patches_disconnected
	prototype.heat_connection_patches_connected = graphics_set.heat_connection_patches_connected
	prototype.heat_connection_patches_disconnected = graphics_set.heat_connection_patches_disconnected
	prototype.heat_lower_layer_picture = graphics_set.heat_lower_layer_picture
	prototype.lower_layer_picture = graphics_set.lower_layer_picture

	prototype.picture = graphics_set.picture
	if self.use_fuel_glow_color then
		prototype.working_light_picture = graphics_set.fuel_glow_working_light_picture
		prototype.use_fuel_glow_color = true
	else
		prototype.working_light_picture = graphics_set.working_light_picture
		prototype.use_fuel_glow_color = nil
	end
end

---@param tint data.Color?
---@param pipe_material ("base"|"aluminum-invar"|"silver-aluminum"|"silver-titanium"|"gold-copper")?
---@return Reskins.Base.NuclearReactorGraphicsSet
---@nodiscard
function NuclearReactorGraphicsPack.get_graphics_set(tint, pipe_material)
	pipe_material = pipe_material or "base"
	StringValidator.validate(pipe_material, "pipe_material"):is_one_of({
		"base",
		"aluminum-invar",
		"silver-aluminum",
		"silver-titanium",
		"gold-copper",
	})

	local pipe_path = get_pipe_path(pipe_material)
	---@type Reskins.Base.NuclearReactorGraphicsSet
	local graphics_set = {
		connection_patches_connected = {
			sheet = {
				filename = pipe_path .. "nuclear-reactor-connect-patches.png",
				width = 64,
				height = 64,
				variation_count = 12,
				scale = 0.5,
			},
		},
		connection_patches_disconnected = {
			sheet = {
				filename = pipe_path .. "nuclear-reactor-connect-patches.png",
				width = 64,
				height = 64,
				variation_count = 12,
				y = 64,
				scale = 0.5,
			},
		},
		heat_connection_patches_connected = {
			sheet = apply_heat_pipe_glow({
				filename = "__base__/graphics/entity/nuclear-reactor/reactor-connect-patches-heated.png",
				width = 64,
				height = 64,
				variation_count = 12,
				scale = 0.5,
			}),
		},

		heat_connection_patches_disconnected = {
			sheet = apply_heat_pipe_glow({
				filename = "__base__/graphics/entity/nuclear-reactor/reactor-connect-patches-heated.png",
				width = 64,
				height = 64,
				variation_count = 12,
				y = 64,
				scale = 0.5,
			}),
		},
		heat_lower_layer_picture = apply_heat_pipe_glow({
			filename = "__base__/graphics/entity/nuclear-reactor/reactor-pipes-heated.png",
			width = 320,
			height = 316,
			scale = 0.5,
			shift = util.by_pixel(-0.5, -4.5),
		}),
		lower_layer_picture = {
			filename = pipe_path .. "nuclear-reactor-base-pipes.png",
			width = 320,
			height = 316,
			shift = util.by_pixel(-1, -5),
			scale = 0.5,
		},
		picture = get_picture(tint, pipe_path),
		fuel_glow_working_light_picture = {
			filename = "__reskins-assets-base__/graphics/entity/nuclear-reactor/nuclear-reactor-lights.png",
			width = 320,
			height = 320,
			shift = { -0.03125, -0.1875 },
			blend_mode = "additive",
			draw_as_glow = true,
			scale = 0.5,
		},
		working_light_picture = {
			filename = "__base__/graphics/entity/nuclear-reactor/reactor-lights-color.png",
			blend_mode = "additive",
			draw_as_glow = true,
			width = 320,
			height = 320,
			scale = 0.5,
			shift = { -0.03125, -0.1875 },
		},
	}

	return graphics_set
end

---@param tint data.Color?
---@param pipe_material ("base"|"aluminum-invar"|"silver-aluminum"|"silver-titanium"|"gold-copper")?
---@return data.RotatedAnimation
---@nodiscard
function NuclearReactorGraphicsPack.get_corpse_animation(tint, pipe_material)
	pipe_material = pipe_material or "base"
	StringValidator.validate(pipe_material, "pipe_material"):is_one_of({
		"base",
		"aluminum-invar",
		"silver-aluminum",
		"silver-titanium",
		"gold-copper",
	})

	local pipe_path = get_pipe_path(pipe_material)
	local assets_path = "__reskins-assets-base__/graphics/entity/nuclear-reactor/remnants/"

	---@type data.RotatedAnimation
	local animation = {
		layers = {
			{
				filename = "__base__/graphics/entity/nuclear-reactor/remnants/nuclear-reactor-remnants.png",
				width = 410,
				height = 396,
				direction_count = 1,
				shift = util.by_pixel(7, 4),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers, {
			filename = assets_path .. "nuclear-reactor-remnants-mask.png",
			width = 410,
			height = 396,
			direction_count = 1,
			shift = util.by_pixel(7, 4),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers, {
			filename = assets_path .. "nuclear-reactor-remnants-highlights.png",
			width = 410,
			height = 396,
			direction_count = 1,
			shift = util.by_pixel(7, 4),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	table.insert(animation.layers, {
		filename = pipe_path .. "nuclear-reactor-remnants.png",
		width = 410,
		height = 396,
		direction_count = 1,
		shift = util.by_pixel(7, 4),
		scale = 0.5,
	})

	return animation
end

return NuclearReactorGraphicsPack
