---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local _sprites = require("__reskins-sprite-utils__.sprites")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local IconBuilderFactory = require("api.icon-builder-factory")
local HeatPipeExplosion = require("assets.base.explosions.heat-pipe")

local VANILLA_PATH = "__base__/graphics/entity/heat-pipe/"
local ASSETS_BASE_PATH = "__reskins-assets-base__/graphics/entity/heat-pipe/"
local ASSETS_BOBS_PATH = "__reskins-assets-bobs__/graphics/entity/heat-pipe/"

local M = {}

---The material from which a heat pipe drawn in fixed colors is built, which selects its artwork.
---@alias HeatPipeMaterial
---| "base"
---| "aluminum-invar"
---| "silver-aluminum"
---| "silver-titanium"
---| "gold-copper"

local HEAT_PIPE_MATERIALS = { "base", "aluminum-invar", "silver-aluminum", "silver-titanium", "gold-copper" }

local HeatPipeMaterial = V.one_of(HEAT_PIPE_MATERIALS)

---The tints of the metal particles in the dying explosion of a heat pipe, by the material of the heat pipe and the name
---of the particle.
---@type table<HeatPipeMaterial, table<ParticleID, Color>>
local particle_tints = {
	["aluminum-invar"] = {
		["heat-pipe-metal-particle-small"] = util.color("dff5ff"),
		["heat-pipe-metal-particle-medium"] = util.color("a99b84"),
	},
	["silver-titanium"] = {
		["heat-pipe-metal-particle-small"] = util.color("d4d4d4"),
		["heat-pipe-metal-particle-medium"] = util.color("cfd2d4"),
	},
	["gold-copper"] = {
		["heat-pipe-metal-particle-small"] = util.color("d6b968"),
		["heat-pipe-metal-particle-medium"] = util.color("ff7f3f"),
	},
}

---Defines the file name and the number of variations of the artwork of a field of `ConnectableEntityGraphics`.
---@class (exact) HeatPipeTile
---The segment of the file names that selects the artwork. When `nil`, the name of the field is used, with each
---underscore replaced by a hyphen.
---@field name? string
---When `true`, indicates that the file name has no variation number. Default `false`.
---@field omit_number? boolean
---The number of variations of the artwork. Default `1`.
---@field variations? integer

-- The artwork of each field of `ConnectableEntityGraphics`.
---@type table<string, HeatPipeTile>
local TILES = {
	single = { name = "straight-vertical-single", omit_number = true },
	straight_vertical = { variations = 6 },
	straight_horizontal = { variations = 6 },
	corner_right_up = { name = "corner-up-right", variations = 6 },
	corner_left_up = { name = "corner-up-left", variations = 6 },
	corner_right_down = { name = "corner-down-right", variations = 6 },
	corner_left_down = { name = "corner-down-left", variations = 6 },
	t_up = {},
	t_down = {},
	t_right = {},
	t_left = {},
	cross = { name = "t" },
	ending_up = {},
	ending_down = {},
	ending_right = {},
	ending_left = {},
}

---Gets the segment of the file names of the given `variation` of the artwork of the given `field`.
---@param field string
---@param tile HeatPipeTile
---@param variation integer
---@return string
local function get_tile_name(field, tile, variation)
	local name = tile.name or string.gsub(field, "_", "-")

	return tile.omit_number and name or (name .. "-" .. variation)
end

---Gets one layer of a tile, from the file with the given `filename`.
---@param filename string
---@return Sprite
local function get_tile_layer(filename)
	return {
		filename = filename,
		priority = "extra-high",
		width = 64,
		height = 64,
		scale = 0.5,
	}
end

---Gets a `ConnectableEntityGraphics` with each variation of each field created by the given `get_sprite`.
---@param get_sprite fun(tile_name: string): Sprite
---@return ConnectableEntityGraphics
local function make_connectable_entity_graphics(get_sprite)
	local graphics = {}

	for field, tile in pairs(TILES) do
		---@type Sprite[]
		local variations = {}
		for i = 1, tile.variations or 1 do
			variations[i] = get_sprite(get_tile_name(field, tile, i))
		end

		graphics[field] = variations
	end

	---@cast graphics ConnectableEntityGraphics
	return graphics
end

---Gets the folder of the artwork of the heat pipe for the given `pipe_material`.
---@param pipe_material HeatPipeMaterial
---@return string
local function get_material_path(pipe_material)
	if pipe_material == "base" then
		return VANILLA_PATH
	end

	return ASSETS_BOBS_PATH .. pipe_material .. "/"
end

---Gets the connection sprites of the heat pipe for the given `pipe_material`.
---@param pipe_material HeatPipeMaterial
---@return ConnectableEntityGraphics
local function get_material_connection_sprites(pipe_material)
	local path = get_material_path(pipe_material)

	return make_connectable_entity_graphics(function(tile_name)
		return get_tile_layer(path .. "heat-pipe-" .. tile_name .. ".png")
	end)
end

---Gets the connection sprites of the tintable heat pipe.
---@param tint? Color
---@param plate_tint? Color
---@return ConnectableEntityGraphics
local function get_tinted_connection_sprites(tint, plate_tint)
	return make_connectable_entity_graphics(function(tile_name)
		local layers = { get_tile_layer(ASSETS_BASE_PATH .. "heat-pipe-" .. tile_name .. ".png") }

		if tint then
			local mask = get_tile_layer(ASSETS_BASE_PATH .. "heat-pipe-mask-" .. tile_name .. ".png")
			mask.tint = tint
			layers[#layers + 1] = mask
		end

		if plate_tint then
			local plate_mask = get_tile_layer(ASSETS_BASE_PATH .. "heat-pipe-plate-mask-" .. tile_name .. ".png")
			plate_mask.tint = plate_tint
			layers[#layers + 1] = plate_mask
		end

		if tint then
			local highlights = get_tile_layer(ASSETS_BASE_PATH .. "heat-pipe-highlights-" .. tile_name .. ".png")
			highlights.blend_mode = "additive"
			layers[#layers + 1] = highlights
		end

		return { layers = layers }
	end)
end

---Gets the heat glow sprites of the heat pipe.
---@return ConnectableEntityGraphics
local function get_heat_glow_sprites()
	local heat_glow_sprites = make_connectable_entity_graphics(function(tile_name)
		return apply_heat_pipe_glow(get_tile_layer(VANILLA_PATH .. "heated-" .. tile_name .. ".png"))
	end)

	-- The heat pipe with no connections does not glow.
	heat_glow_sprites.single = {
		filename = "__core__/graphics/empty.png",
		priority = "extra-high",
		width = 1,
		height = 1,
	}

	return heat_glow_sprites
end

---Gets the circuit connector of the heat pipe for each field of `ConnectableEntityGraphics`.
---@return CircuitConnectorDefinition[]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch, undefined-global
	return circuit_connector_definitions.create_vector(heat_pipe_connector_template, {
		{ variation = 0, show_shadow = true },
		{ variation = 1, show_shadow = true },
		{ variation = 2, show_shadow = true },
		{ variation = 3, show_shadow = true },
		{ variation = 4, show_shadow = true },
		{ variation = 5, show_shadow = true },
		{ variation = 6, show_shadow = true },
		{ variation = 7, show_shadow = false },
		{ variation = 8, show_shadow = true },
		{ variation = 9, show_shadow = true },
		{ variation = 10, show_shadow = true },
		{ variation = 11, show_shadow = true },
		{ variation = 12, show_shadow = true },
		{ variation = 13, show_shadow = true },
		{ variation = 14, show_shadow = true },
		{ variation = 15, show_shadow = false },
	})
end

---Gets one layer of the animation of the heat pipe remnants, from the file with the given `filename`.
---@param filename string
---@return RotatedAnimation
local function get_corpse_animation_layer(filename)
	return {
		filename = filename,
		line_length = 1,
		width = 122,
		height = 100,
		direction_count = 2,
		shift = util.by_pixel(0.5, -1.5),
		scale = 0.5,
	}
end

---Gets the animation of the heat pipe remnants for the given `pipe_material`.
---@param pipe_material HeatPipeMaterial
---@return RotatedAnimationVariations
local function get_material_corpse_animation(pipe_material)
	local filename = get_material_path(pipe_material) .. "remnants/heat-pipe-remnants.png"

	return _sprites.make_rotated_animation_variations_from_spritesheet(6, get_corpse_animation_layer(filename))
end

---Gets the animation of the tintable heat pipe remnants.
---@param tint? Color
---@param plate_tint? Color
---@return RotatedAnimationVariations
local function get_tinted_corpse_animation(tint, plate_tint)
	local path = ASSETS_BASE_PATH .. "remnants/"
	local layers = { get_corpse_animation_layer(path .. "heat-pipe-remnants.png") }

	if tint then
		local mask = get_corpse_animation_layer(path .. "heat-pipe-remnants-mask.png")
		mask.tint = tint
		layers[#layers + 1] = mask
	end

	if plate_tint then
		local plate_mask = get_corpse_animation_layer(path .. "heat-pipe-remnants-plate-mask.png")
		plate_mask.tint = plate_tint
		layers[#layers + 1] = plate_mask
	end

	if tint then
		local highlights = get_corpse_animation_layer(path .. "heat-pipe-remnants-highlights.png")
		highlights.blend_mode = "additive"
		layers[#layers + 1] = highlights
	end

	return _sprites.make_rotated_animation_variations_from_spritesheet(6, { layers = layers })
end

---Defines the options for the heat pipe sprite set.
---
---The heat pipe is drawn in the fixed colors of `pipe_material` when it is given. Otherwise, the tintable heat pipe is
---drawn in `tint` and `plate_tint`.
---@class HeatPipeSpriteSetParams
---The material from which the heat pipe is built, which selects artwork drawn in fixed colors. When `nil`, the
---tintable artwork is used.
---@field pipe_material? HeatPipeMaterial
---The color to tint the pipes of the tintable artwork. When `nil`, the mask and highlights layers are omitted from the
---set.
---@field tint? Color
---The color to tint the plates of the tintable artwork. When `nil`, the plate mask layer is omitted from the set.
---@field plate_tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("HeatPipeSpriteSetParams", {
			pipe_material = HeatPipeMaterial:optional(),
			tint = Common.color:optional(),
			plate_tint = Common.color:optional(),
		})
			:strict()
			:where(function(value)
				return value.pipe_material == nil or (value.tint == nil and value.plate_tint == nil)
			end, "sets 'pipe_material' with 'tint' or 'plate_tint'"),
	},
})

---Gets the sprite set for the heat pipe.
---@param params HeatPipeSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<HeatPipeSpriteSet> # The sprite set definition for the heat pipe.
---
---#### Examples
---```lua
----- Apply the heat pipe drawn in fixed colors to one entity, and the tintable heat pipe to another.
---local heat_pipe = require("__reskins-assets-api__.assets.base.entities.heat-pipe")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---applicators.apply_sprite_set(entity, heat_pipe.get_sprite_set({ pipe_material = "gold-copper" }))
---applicators.apply_sprite_set(other_entity, heat_pipe.get_sprite_set({ tint = tint, plate_tint = plate_tint }))
---```
---@throws When `params.pipe_material` is not a `HeatPipeMaterial`.
---@throws When `params.tint` or `params.plate_tint` is not a `Color`.
---@throws When `params` sets `pipe_material` with `tint` or `plate_tint`.
---@throws When `params` defines an unrecognized field.
---@nodiscard
function M.get_sprite_set(params)
	check_get_sprite_set(params)

	local connection_sprites, corpse_animation
	if params.pipe_material then
		connection_sprites = get_material_connection_sprites(params.pipe_material)
		corpse_animation = get_material_corpse_animation(params.pipe_material)
	else
		connection_sprites = get_tinted_connection_sprites(params.tint, params.plate_tint)
		corpse_animation = get_tinted_corpse_animation(params.tint, params.plate_tint)
	end

	---@type SpriteSetDefinition<HeatPipeSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.heat_pipe_sprite_set,
		set = {
			connection_sprites = connection_sprites,
			heat_glow_sprites = get_heat_glow_sprites(),
			circuit_connector = get_circuit_connector(),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = HeatPipeExplosion.get_explosion({
				tints = params.pipe_material and util.copy(particle_tints[params.pipe_material]),
			}),
			corpse = { animation = corpse_animation },
			water_reflection = nil,
			nominal_width = 1,
			nominal_height = 1,
		},
	}

	return definition
end

local vanilla_icons = IconBuilderFactory:create({ folder = "__base__/graphics/icons" })
local base_icons = IconBuilderFactory:create({ folder = "__reskins-assets-base__/graphics/icons" })
local bobs_icons = IconBuilderFactory:create({ folder = "__reskins-assets-bobs__/graphics/icons" })

---Gets the icon for a heat pipe built from the `pipe_material` given by `params`.
M.get_icon = IconBuilderFactory.dispatch("pipe_material", HEAT_PIPE_MATERIALS, "get_icon", function(pipe_material)
	-- The icon of the heat pipe of the base material comes from the base game.
	if pipe_material == "base" then
		return vanilla_icons:flat("heat-pipe")
	end

	return bobs_icons:layers("heat-pipe"):stem("heat-pipe-" .. pipe_material):base()
end)

---Gets the icon for the tintable heat pipe, in the tints given by `params`.
M.get_tinted_icon = base_icons
	:layers("heat-pipe")
	:base()
	:mask()
	:tinted_layer("plate-mask", "plate_tint")
	:highlights({ requires = "tint" })
	:build("get_tinted_icon")

return M
