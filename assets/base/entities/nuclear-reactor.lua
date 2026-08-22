---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local StringValidator = require("prototypes.string-validator")

---@class NuclearReactorGraphicsSet
---@field connection_patches_connected SpriteVariations
---@field connection_patches_disconnected SpriteVariations
---@field heat_connection_patches_connected SpriteVariations
---@field heat_connection_patches_disconnected SpriteVariations
---@field heat_lower_layer_picture Sprite
---@field lower_layer_picture Sprite
---@field picture Sprite
---@field fuel_glow_working_light_picture Animation
---@field working_light_picture Animation

local M = {}

---@param pipe_material "base"|"aluminum-invar"|"silver-aluminum"|"silver-titanium"|"gold-copper"
---@return string
local function get_pipe_path(pipe_material)
	if pipe_material == "base" then
		return "__reskins-assets-base__/graphics/entity/nuclear-reactor/heat-pipes/base/"
	else
		return "__reskins-assets-bobs__/graphics/entity/nuclear-reactor/heat-pipes/" .. pipe_material .. "/"
	end
end

---@param tint Color?
---@param pipe_path string
---@return Sprite
local function get_picture(tint, pipe_path)
	local base_path = "__base__/graphics/entity/nuclear-reactor/"
	local assets_path = "__reskins-assets-base__/graphics/entity/nuclear-reactor/"

	---@type Sprite
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
		table.insert(picture.layers--[[@cast -?]], {
			filename = assets_path .. "nuclear-reactor-mask.png",
			width = 302,
			height = 318,
			shift = util.by_pixel(-5, -7),
			tint = tint,
			scale = 0.5,
		})
		table.insert(picture.layers--[[@cast -?]], {
			filename = assets_path .. "nuclear-reactor-highlights.png",
			width = 302,
			height = 318,
			shift = util.by_pixel(-5, -7),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	table.insert(picture.layers--[[@cast -?]], {
		filename = pipe_path .. "nuclear-reactor-piping.png",
		width = 302,
		height = 318,
		shift = util.by_pixel(-5, -7),
		scale = 0.5,
	})

	return picture
end

---@param tint Color?
---@param pipe_material ("base"|"aluminum-invar"|"silver-aluminum"|"silver-titanium"|"gold-copper")?
---@return NuclearReactorGraphicsSet
local function get_graphics_set(tint, pipe_material)
	pipe_material = pipe_material or "base"
	StringValidator.validate(pipe_material, "pipe_material"):is_one_of({
		"base",
		"aluminum-invar",
		"silver-aluminum",
		"silver-titanium",
		"gold-copper",
	})

	local pipe_path = get_pipe_path(pipe_material)
	---@type NuclearReactorGraphicsSet
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

---@param tint Color?
---@param pipe_material ("base"|"aluminum-invar"|"silver-aluminum"|"silver-titanium"|"gold-copper")?
---@return RotatedAnimation
local function get_corpse_animation(tint, pipe_material)
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

	---@type RotatedAnimation
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
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "nuclear-reactor-remnants-mask.png",
			width = 410,
			height = 396,
			direction_count = 1,
			shift = util.by_pixel(7, 4),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "nuclear-reactor-remnants-highlights.png",
			width = 410,
			height = 396,
			direction_count = 1,
			shift = util.by_pixel(7, 4),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	table.insert(animation.layers--[[@cast -?]], {
		filename = pipe_path .. "nuclear-reactor-remnants.png",
		width = 410,
		height = 396,
		direction_count = 1,
		shift = util.by_pixel(7, 4),
		scale = 0.5,
	})

	return animation
end

---The sprite data a `reactor_sprite_set`-tagged `SpriteSetDefinition` carries.
---
---Provisional: no applicator consumes this shape yet. When one is written, this
---declaration moves to it, the way `BoilerSpriteSet` lives in `api/applicators/boiler.lua`.
---@class (exact) NuclearReactorSpriteSet : EntityWithHealthSpriteSet
---The sprites making up the reactor, spread across the prototype's own fields.
---@field graphics_set NuclearReactorGraphicsSet
---Sets the prototype's `use_fuel_glow_color`, selecting which working light the
---applicator takes from `graphics_set`.
---@field use_fuel_glow_color boolean

---@class NuclearReactorSpriteSetParams
---@field tint Color?
---@field pipe_material ("base"|"aluminum-invar"|"silver-aluminum"|"silver-titanium"|"gold-copper")?
---@field use_fuel_glow_color boolean?

---Produces the sprite set for the vanilla nuclear reactor.
---@param params NuclearReactorSpriteSetParams
---@return SpriteSetDefinition<NuclearReactorSpriteSet>
---@nodiscard
function M.get(params)
	local pipe_material = params.pipe_material or "base"

	---@type SpriteSetDefinition<NuclearReactorSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.reactor_sprite_set,
		set = {
			graphics_set = get_graphics_set(params.tint, pipe_material),
			use_fuel_glow_color = params.use_fuel_glow_color == true,
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = get_corpse_animation(params.tint, pipe_material),
			water_reflection = nil,
			nominal_width = 5,
			nominal_height = 5,
		},
	}

	return definition
end

return M
