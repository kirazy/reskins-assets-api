---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local AssetsCommon = require("api.validation")
local EnergySources = require("api.energy-sources")
local IconBuilderFactory = require("api.icon-builder-factory")
local NuclearReactorExplosion = require("assets.base.explosions.nuclear-reactor")
local Remnants = require("assets.base.remnants")

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

---@param tint? Color
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
			blend_mode = "additive",
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

---@param tint? Color
---@param pipe_material? "base"|"aluminum-invar"|"silver-aluminum"|"silver-titanium"|"gold-copper"
---@return ReactorGraphicsSet
local function get_graphics_set(tint, pipe_material)
	check_get_graphics_set(tint, pipe_material)

	pipe_material = pipe_material or "base"

	local pipe_path = get_pipe_path(pipe_material)
	---@type ReactorGraphicsSet
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

---@param tint? Color
---@param pipe_material? "base"|"aluminum-invar"|"silver-aluminum"|"silver-titanium"|"gold-copper"
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
			blend_mode = "additive",
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

---Gets the circuit connector of the nuclear reactor.
---@return CircuitConnectorDefinition
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_single(universal_connector_template, {
		variation = 27,
		main_offset = util.by_pixel(40, 40),
		shadow_offset = util.by_pixel(45, 54.5),
		show_shadow = false,
	})
end

---Gets the water reflection of the nuclear reactor.
---@return WaterReflectionDefinition
local function get_water_reflection()
	return {
		pictures = {
			filename = "__base__/graphics/entity/nuclear-reactor/nuclear-reactor-reflection.png",
			width = 74,
			height = 74,
			scale = 5,
		},
		rotate = false,
	}
end

---Defines the options for the vanilla nuclear reactor sprite set.
---@class NuclearReactorSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color
---The material from which the pipes are built. Default `"base"`.
---@field pipe_material? "base"|"aluminum-invar"|"silver-aluminum"|"silver-titanium"|"gold-copper"
---When `true`, indicates that the fuel's own color lights the glow. Default `false`.
---@field use_fuel_glow_color? boolean

---Gets the sprite set for the vanilla nuclear reactor.
---@param params NuclearReactorSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<ReactorSpriteSet> # The sprite set definition for the vanilla nuclear reactor.
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

	---@type SpriteSetDefinition<ReactorSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.reactor_sprite_set,
		set = {
			graphics_set = get_graphics_set(params.tint, pipe_material),
			use_fuel_glow_color = params.use_fuel_glow_color == true,
			heat_buffers = {
				{
					heat_picture = apply_heat_pipe_glow({
						filename = "__base__/graphics/entity/nuclear-reactor/reactor-heated.png",
						width = 216,
						height = 256,
						scale = 0.5,
						shift = util.by_pixel(3, -6.5),
					}),
				},
			},
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = NuclearReactorExplosion.get_explosion({
				tints = params.tint and {
					["nuclear-reactor-metal-particle-big"] = params.tint,
					["nuclear-reactor-metal-particle-medium"] = params.tint,
				},
			}),
			corpse = Remnants.get_corpse(
				"nuclear-reactor-remnants",
				{ animation = get_corpse_animation(params.tint, pipe_material) }
			),
			circuit_connector = get_circuit_connector(),
			water_reflection = get_water_reflection(),
			light_flicker = EnergySources.get_zeroed_light_flicker(),
			nominal_width = 5,
			nominal_height = 5,
		},
	}

	return definition
end

---The width and height of each file for the heat pipes beneath the reactor, in pixels.
local LOWER_LAYER_WIDTH, LOWER_LAYER_HEIGHT = 320, 316

---The region for each piece of the heat pipes beneath the reactor, under the position of the tile with the heat
---connections that the piece draws. A region is given as the left, top, right, and bottom edges, in pixels from the
---centre of the reactor at 64 pixels per tile, and holds the piece in every material and in its heated form.
---@type table<string, [integer, integer, integer, integer]>
local HEAT_PIPE_REGIONS = {
	["-2,-2"] = { -164, -170, -92, -81 },
	["0,-2"] = { -20, -170, 20, -137 },
	["2,-2"] = { 89, -170, 161, -65 },
	["-2,0"] = { -164, -22, -123, 24 },
	["2,0"] = { 122, -18, 161, 18 },
	["-2,2"] = { -157, 74, -51, 151 },
	["0,2"] = { -31, 87, 44, 151 },
	["2,2"] = { 82, 51, 161, 151 },
}

---Gets the key of the given tile `position` in the regions of the heat pipes.
---@param position Vector
---@return string
local function get_tile_key(position)
	local x, y = position.x or position[1], position.y or position[2]

	return string.format("%d,%d", x, y)
end

---Gets the x and y of the given `vector`, in either form.
---@param vector Vector
---@return double x
---@return double y
local function get_coordinates(vector)
	return vector.x or vector[1], vector.y or vector[2]
end

---Gets a copy of the given `layer` that draws only the given region of its file, moved by the given `offset`.
---@param layer Sprite A layer that draws its whole file.
---@param left integer The left edge of the region, in pixels of the file.
---@param top integer The top edge of the region, in pixels of the file.
---@param right integer The right edge of the region, in pixels of the file.
---@param bottom integer The bottom edge of the region, in pixels of the file.
---@param offset Vector The offset by which the region is moved, in tiles.
---@return Sprite
local function get_layer_region(layer, left, top, right, bottom, offset)
	local pixels_per_tile = 32 / (layer.scale or 1)
	local shift_x, shift_y = get_coordinates(layer.shift or { 0, 0 })
	local offset_x, offset_y = get_coordinates(offset)

	local region = util.copy(layer)
	region.x = (layer.x or 0) + left
	region.y = (layer.y or 0) + top
	region.width = right - left
	region.height = bottom - top
	region.shift = {
		shift_x + ((left + right) / 2 - layer.width / 2) / pixels_per_tile + offset_x,
		shift_y + ((top + bottom) / 2 - layer.height / 2) / pixels_per_tile + offset_y,
	}

	return region
end

---Gets the offset from the `from` tile to the `to` tile of the given `move`, in tiles.
---@param move NuclearReactorHeatPipeMove
---@return Vector
local function get_offset(move)
	local from_x, from_y = get_coordinates(move.from)
	local to_x, to_y = get_coordinates(move.to)

	return { to_x - from_x, to_y - from_y }
end

---Gets the pieces of the given heat pipes beneath the reactor, each moved as given by `moves`, as the layers of one
---sprite.
---@param picture Sprite The heat pipes beneath the reactor.
---@param moves NuclearReactorHeatPipeMove[] The tile from which each piece is cut and the tile on which it is drawn.
---@return Sprite
local function get_moved_lower_layer(picture, moves)
	---@type Sprite[]
	local layers = {}
	for _, layer in pairs(picture.layers or { picture }) do
		if layer.width ~= LOWER_LAYER_WIDTH or layer.height ~= LOWER_LAYER_HEIGHT then
			error("The heat pipes beneath the reactor do not have the layout of the nuclear reactor.")
		end

		-- The regions are given in pixels from the centre of the reactor, at 64 pixels per tile.
		local pixels_per_tile = 32 / (layer.scale or 1)
		local factor = pixels_per_tile / 64
		local shift_x, shift_y = get_coordinates(layer.shift or { 0, 0 })
		local centre_x = layer.width / 2 - shift_x * pixels_per_tile
		local centre_y = layer.height / 2 - shift_y * pixels_per_tile

		for _, move in pairs(moves) do
			local region = HEAT_PIPE_REGIONS[get_tile_key(move.from)]
			local left = math.max(0, math.floor(centre_x + region[1] * factor))
			local top = math.max(0, math.floor(centre_y + region[2] * factor))
			local right = math.min(layer.width, math.ceil(centre_x + region[3] * factor))
			local bottom = math.min(layer.height, math.ceil(centre_y + region[4] * factor))

			layers[#layers + 1] = get_layer_region(layer, left, top, right, bottom, get_offset(move))
		end
	end

	return { layers = layers }
end

---Defines where a piece of the heat pipes beneath the nuclear reactor is drawn on a reactor of another size.
---@class NuclearReactorHeatPipeMove
---The position of the tile with the heat connections that the piece draws on the nuclear reactor, in tiles from its
---centre, such as `{ -2, 0 }`.
---@field from Vector
---The position of the tile on which the piece is drawn, in tiles from the centre of the reactor.
---@field to Vector

---Defines the heat pipes beneath the nuclear reactor, drawn in pieces.
---@class NuclearReactorHeatPipes
---The heat pipes beneath the reactor.
---@field lower_layer_picture Sprite
---The heated heat pipes beneath the reactor.
---@field heat_lower_layer_picture Sprite

local check_get_moved_heat_pipes = V.signature("get_moved_heat_pipes", {
	{ "definition", AssetsCommon.sprite_set_definition },
	{
		"moves",
		V.array(V.struct({
			from = Common.vector,
			to = Common.vector,
		}):where(function(value)
			return HEAT_PIPE_REGIONS[get_tile_key(value.from)] ~= nil
		end, "has a 'from' that is not a tile with heat connections on the nuclear reactor")),
	},
})

---Gets the heat pipes beneath the nuclear reactor of the given `definition`, cut into pieces at its heat connections
---and moved as given by `moves`, at their full size.
---
---Each piece is the length of heat pipe that leads to the heat connections on one tile at the edge of the reactor. A
---reactor of another size draws the pieces at its own heat connections, where they meet heat pipes at their full size.
---A piece that no move names is not drawn.
---@param definition SpriteSetDefinition<ReactorSpriteSet> The sprite set definition from `get_sprite_set`.
---@param moves NuclearReactorHeatPipeMove[] The tile from which each piece is cut and the tile on which it is drawn.
---@return NuclearReactorHeatPipes # The heat pipes, which are drawn in pieces.
---
---#### Examples
---```lua
----- Draw the piece at the north edge of the reactor at `{ 0, -1 }` on a 3 x 3 reactor.
---local NuclearReactor = require("__reskins-assets-api__.assets.base.entities.nuclear-reactor")
---
---local definition = NuclearReactor.get_sprite_set({ pipe_material = "gold-copper" })
---local heat_pipes = NuclearReactor.get_moved_heat_pipes(definition, { { from = { 0, -2 }, to = { 0, -1 } } })
----- heat_pipes.lower_layer_picture draws the piece one tile closer to the centre than on the nuclear reactor.
---```
---@throws When `definition` is not a `SpriteSetDefinition`.
---@throws When a move has a `from` that is not a tile with heat connections on the nuclear reactor.
---@throws When a move has a `to` that is not a `Vector`.
---@throws When the heat pipes of `definition` do not have the layout of the nuclear reactor.
---@see get_heat_pipe_shadow
---@nodiscard
function M.get_moved_heat_pipes(definition, moves)
	check_get_moved_heat_pipes(definition, moves)

	local graphics_set = definition.set.graphics_set --[[@as ReactorGraphicsSet]]

	return {
		lower_layer_picture = get_moved_lower_layer(graphics_set.lower_layer_picture, moves),
		heat_lower_layer_picture = get_moved_lower_layer(graphics_set.heat_lower_layer_picture, moves),
	}
end

---Gets the shadow of the nuclear reactor without the shadows of its heat pipes, for a reactor that draws the shadows of
---its heat pipes apart from the shadow of its body.
---@return Sprite # The shadow, at the size of the nuclear reactor.
---@see get_heat_pipe_shadow
---@nodiscard
function M.get_shadow_without_heat_pipes()
	---@type Sprite
	local shadow = {
		filename = "__reskins-assets-base__/graphics/entity/nuclear-reactor/reactor-shadow-without-pipes.png",
		width = 525,
		height = 323,
		shift = { 1.625, 0 },
		draw_as_shadow = true,
		scale = 0.5,
	}

	return shadow
end

---The width and height in pixels of the heat pipe shadow on a reactor of each size, under the size of the reactor in
---tiles.
---@type table<integer, integer>
local HEAT_PIPE_SHADOW_SIZES = {
	[1] = 69,
	[3] = 256,
}

local check_get_heat_pipe_shadow = V.signature("get_heat_pipe_shadow", {
	{ "size", V.one_of({ 1, 3 }) },
})

---Gets the shadow of the heat pipes and their ends on a reactor of the given `size`, with the pieces of the heat pipes
---that `get_moved_heat_pipes` cuts drawn at the centre of each tile at its edges.
---
---The shadow of a reactor that is 1 tile across holds the pieces at the middle tile on each edge of the nuclear
---reactor.
---@param size 1|3 The width and height of the reactor, in tiles.
---@return Sprite # The shadow, which is centred on the reactor.
---@throws When `size` is not 1 or 3.
---@nodiscard
function M.get_heat_pipe_shadow(size)
	check_get_heat_pipe_shadow(size)

	local pixels = HEAT_PIPE_SHADOW_SIZES[size]

	---@type Sprite
	local shadow = {
		filename = string.format(
			"__reskins-assets-base__/graphics/entity/nuclear-reactor/nuclear-reactor-connect-patch-shadow-%dx%d.png",
			size,
			size
		),
		width = pixels,
		height = pixels,
		draw_as_shadow = true,
		scale = 0.5,
	}

	return shadow
end

---The fuel a reactor burns, which selects the artwork of its core.
---@alias NuclearReactorFuel
---| "uranium"
---| "thorium"
---| "deuterium-blue"
---| "deuterium-pink"

---The material from which a reactor is built.
---@alias NuclearReactorMaterial
---| "base"
---| "aluminum-invar"
---| "gold-copper"
---| "silver-aluminum"
---| "silver-titanium"

---The color of a reactor's glow.
---@alias NuclearReactorGlowColor
---| "blue"
---| "cyan"

-- The materials with artwork for each fuel's reactor. Not every pairing has artwork.
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
local GLOW_COLOR = V.one_of({ "blue", "cyan" })

-- Every reactor shares one mask and one highlights layer, so only the base has a key.
local BASE_LAYER = { IconBuilderFactory.role.base }

local base_icons = IconBuilderFactory:create({ folder = "__reskins-assets-base__/graphics/icons" })
local bobs_icons = IconBuilderFactory:create({ folder = "__reskins-assets-bobs__/graphics/icons" })
local assorted_icons = IconBuilderFactory:create({ folder = "__reskins-assets-assorted__/graphics/icons" })

local icon_builder = base_icons:tinted("nuclear-reactor")

---Gets the icon for the vanilla nuclear reactor, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the icon for the vanilla nuclear reactor as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

local fuel_icon_builder =
	bobs_icons:tinted("nuclear-reactor"):keyed("fuel", FUEL, BASE_LAYER):keyed("material", MATERIAL, BASE_LAYER)

---Gets the icon for a reactor burning the `fuel`, built from the `material`, and in the tints given by `params`.
---
---Not every fuel has artwork in every material.
M.get_fuel_icon = fuel_icon_builder:build("get_fuel_icon", {
	{
		field = "material",
		fields = { "fuel", "material" },
		check = function(fuel, material)
			return FUEL_MATERIALS[fuel][material] == true
		end,
		message = "a material for which the reactor of the given fuel has artwork",
	},
})

---Gets the icon for a reactor burning the `fuel` as an `IconComposition`, built from the `material`, and in the tints
---given by `params`.
---
---Not every fuel has artwork in every material.
M.get_fuel_icon_composition = fuel_icon_builder:build_composition("get_fuel_icon_composition", {
	{
		field = "material",
		fields = { "fuel", "material" },
		check = function(fuel, material)
			return FUEL_MATERIALS[fuel][material] == true
		end,
		message = "a material for which the reactor of the given fuel has artwork",
	},
})

local realistic_icon_builder = assorted_icons
	:tinted("realistic-nuclear-reactor")
	:keyed("glow_color", GLOW_COLOR, BASE_LAYER)
	:keyed("material", MATERIAL, BASE_LAYER)

---Gets the icon for a reactor glowing in the `glow_color`, built from the `material`, and in the tints given by
---`params`.
M.get_realistic_icon = realistic_icon_builder:build("get_realistic_icon")

---Gets the icon for a reactor glowing in the `glow_color` as an `IconComposition`, built from the `material`, and in
---the tints given by `params`.
M.get_realistic_icon_composition = realistic_icon_builder:build_composition("get_realistic_icon_composition")

return M
