---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")

local M = {}

local ReactorPipeMaterial = V.one_of({
	"base",
	"aluminum-invar",
	"silver-aluminum",
	"silver-titanium",
	"gold-copper",
})

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

local check_get_graphics_set = V.signature("get_graphics_set", {
	{ "tint", Common.color:optional() },
	{ "pipe_material", ReactorPipeMaterial:optional() },
})

---@param tint Color?
---@param pipe_material ("base"|"aluminum-invar"|"silver-aluminum"|"silver-titanium"|"gold-copper")?
---@return NuclearReactorGraphicsSet
local function get_graphics_set(tint, pipe_material)
	check_get_graphics_set(tint, pipe_material)

	pipe_material = pipe_material or "base"

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

local check_get_corpse_animation = V.signature("get_corpse_animation", {
	{ "tint", Common.color:optional() },
	{ "pipe_material", ReactorPipeMaterial:optional() },
})

---@param tint Color?
---@param pipe_material ("base"|"aluminum-invar"|"silver-aluminum"|"silver-titanium"|"gold-copper")?
---@return RotatedAnimation
local function get_corpse_animation(tint, pipe_material)
	check_get_corpse_animation(tint, pipe_material)

	pipe_material = pipe_material or "base"

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

---@class NuclearReactorSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?
---The material the pipes are built from. Defaults to iron.
---@field pipe_material ("base"|"aluminum-invar"|"silver-aluminum"|"silver-titanium"|"gold-copper")?
---Whether the fuel's own color lights the glow. Defaults to `false`.
---@field use_fuel_glow_color boolean?

---Gets the sprite set for the vanilla nuclear reactor.
---@param params NuclearReactorSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<NuclearReactorSpriteSet>
---
---#### Examples
---```lua
---local nuclear_reactor = require("__reskins-assets-api__.assets.base.entities.nuclear-reactor")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = nuclear_reactor.get_sprite_set({ tint = tint, pipe_material = pipe_material })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set(params)
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
			corpse = { animation = get_corpse_animation(params.tint, pipe_material) },
			water_reflection = nil,
			nominal_width = 5,
			nominal_height = 5,
		},
	}

	return definition
end

---The fuel a reactor burns, selecting the artwork its core is drawn with.
---@alias NuclearReactorFuel
---| "uranium"
---| "thorium"
---| "deuterium-blue"
---| "deuterium-pink"

---The material a reactor is built from.
---@alias NuclearReactorMaterial
---| "base"
---| "aluminum-invar"
---| "gold-copper"
---| "silver-aluminum"
---| "silver-titanium"

---The color a reactor's glow is drawn in.
---@alias NuclearReactorGlowColor
---| "blue"
---| "cyan"

-- The materials each fuel's reactor is drawn in. Not every pairing is drawn.
local FUEL_MATERIALS = {
	["uranium"] = {
		["base"] = true,
		["aluminum-invar"] = true,
		["gold-copper"] = true,
		["silver-aluminum"] = true,
		["silver-titanium"] = true,
	},
	["thorium"] = { ["silver-aluminum"] = true, ["silver-titanium"] = true },
	["deuterium-blue"] = { ["gold-copper"] = true },
	["deuterium-pink"] = { ["gold-copper"] = true },
}

local FUEL = V.one_of({ "uranium", "thorium", "deuterium-blue", "deuterium-pink" })
local MATERIAL = V.one_of({ "base", "aluminum-invar", "gold-copper", "silver-aluminum", "silver-titanium" })

---Builds a reactor icon around `base_layer`. Every reactor shares one mask and one highlights layer.
---@param base_layer FileName # The file the base layer is drawn from.
---@param tint Color? # The color to tint the mask.
---@return SafeIconData[]
---@nodiscard
local function get_layers(base_layer, tint)
	local shared = "__reskins-assets-base__/graphics/icons/nuclear-reactor/nuclear-reactor-"
	local layers = { { icon = base_layer, icon_size = 64, scale = 0.5 } }

	if tint then
		table.insert(layers, { icon = shared .. "mask.png", icon_size = 64, scale = 0.5, tint = tint })
		table.insert(layers, { icon = shared .. "highlights.png", icon_size = 64, scale = 0.5, tint = { 1, 1, 1, 0 } })
	end

	return layers
end

local check_get_icon = V.signature("get_icon", {
	{ "tint", Common.color:optional() },
})

---Gets the icon for the vanilla nuclear reactor, in the given `tint`.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(tint)
	check_get_icon(tint)

	return get_layers("__reskins-assets-base__/graphics/icons/nuclear-reactor/nuclear-reactor-base.png", tint)
end

local check_get_fuel_icon = V.signature("get_fuel_icon", {
	{ "fuel", FUEL },
	{ "material", MATERIAL },
	{ "tint", Common.color:optional() },
}, {
	{
		parameter = "material",
		arguments = { "fuel", "material" },
		check = function(fuel, material)
			return FUEL_MATERIALS[fuel][material] == true
		end,
		message = "must be a material the given fuel's reactor is drawn in",
	},
})

---Gets the icon for a reactor burning the given `fuel`, built from the given `material`, in the given
---`tint`.
---@param fuel NuclearReactorFuel # The fuel the reactor burns.
---@param material NuclearReactorMaterial # The material the reactor is built from.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_fuel_icon(fuel, material, tint)
	check_get_fuel_icon(fuel, material, tint)

	local folder = "__reskins-assets-bobs__/graphics/icons/nuclear-reactor/"

	return get_layers(folder .. "nuclear-reactor-" .. fuel .. "-" .. material .. "-base.png", tint)
end

local check_get_realistic_icon = V.signature("get_realistic_icon", {
	{ "material", MATERIAL },
	{ "glow_color", V.one_of({ "blue", "cyan" }) },
	{ "tint", Common.color:optional() },
})

---Gets the icon for a reactor built from the given `material`, glowing in the given `glow_color`, in
---the given `tint`.
---@param material NuclearReactorMaterial # The material the reactor is built from.
---@param glow_color NuclearReactorGlowColor # The color the glow is drawn in.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_realistic_icon(material, glow_color, tint)
	check_get_realistic_icon(material, glow_color, tint)

	local folder = "__reskins-assets-assorted__/graphics/icons/realistic-nuclear-reactor/" .. glow_color .. "/"
	local suffix = glow_color == "cyan" and "-color_cyan.png" or "-color.png"

	return get_layers(folder .. "nuclear-reactor-" .. material .. suffix, tint)
end

return M
