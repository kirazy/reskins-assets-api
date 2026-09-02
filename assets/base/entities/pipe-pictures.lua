-- THIS MODULE IS EXTREMELY WIP AND SUBJECT TO CHANGE.
-- The require path, function names and signatures are not stable.

---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Base.Entities

local V = require("__reskins-sprite-utils__.validation")
local _defines = require("api.defines")

local M = {}

local PipeMaterial = V.one_of(_defines.pipe_material)

local check_asset_from_material = V.signature("asset_from_material", {
	{ "pipe_material", PipeMaterial },
})

---Gets the asset that provides the sprites for the given `pipe_material`.
---@param pipe_material PipeMaterial
---@return AssetsSource material_asset
function M.asset_from_material(pipe_material)
	check_asset_from_material(pipe_material)
	---@cast pipe_material string

	local assets_base_path
	if pipe_material == _defines.pipe_material.iron then
		assets_base_path = _defines.assets_source.base_assets
	elseif pipe_material:find("angels") then
		assets_base_path = _defines.assets_source.angels_assets
	else
		assets_base_path = _defines.assets_source.bobs_assets
	end

	return assets_base_path
end

local check_name_from_material = V.signature("name_from_material", {
	{ "pipe_material", PipeMaterial },
})

---Gets the bare material name absent any discriminators for the given `pipe_material`.
---@param pipe_material PipeMaterial
---@return PipeMaterialName material_name
function M.name_from_material(pipe_material)
	check_name_from_material(pipe_material)
	---@cast pipe_material string

	local material, _ = pipe_material:gsub("^angels%-", "")
	return material--[[@as PipeMaterialName]]
end

---Gets an `Animation` object configured to draw a vertical pipe shadow at the given `shift`, for a single tile.
---
---Conventional use is by non-pipe entities that have pipe connections, and need to dynamically draw a shadow at the
---connection point for a given rotation state, rather than bake the shadow into the entity's sprite.
---@param shift Vector The shift to apply to the shadow. Typically whole-tile or half-tile increments.
---@return Animation # A vertical pipe shadow for a single tile.
---@return RequiredAssets # The required asset mods.
---
---#### Examples
---Add a vertical pipe shadow in the north and south directions to the working_visualisations field of an assembly
---machine prototype. The shadow will offset up 1 tile for north, and down 1 tile for south, along the centerline of a 3
---x 3 entity.
---```lua
---local _pipes = require("__reskins-assets-api__.assets.base.entities.pipe-pictures")
---
---local greenhouse = data.raw["assembling-machine"]["bob-greenhouse"]
---table.insert(greenhouse.working_visualisations, {
---    always_draw = true,
---    north_animation = _pipes.get_vertical_pipe_shadow({0, -1}),
---    south_animation = _pipes.get_vertical_pipe_shadow({0, 1}),
---)}
---```
---@nodiscard
function M.vertical_pipe_shadow(shift)
	---@type Animation
	local shadow_animation = {
		filename = "__reskins-assets-base__/graphics/entity/pipe/vertical-pipe-shadow-patch.png",
		priority = "high",
		width = 128,
		height = 128,
		draw_as_shadow = true,
		shift = shift,
		scale = 0.5,
	}

	return shadow_animation, { [_defines.assets_source.base_assets] = true }
end

---Gets an `Animation` object configured to draw a horizontal pipe shadow at the given `shift`, for a single tile.
---
---Conventional use is by non-pipe entities that have pipe connections, and need to dynamically draw a shadow at the
---connection point for a given rotation state, rather than bake the shadow into the entity's sprite.
---@param shift Vector The shift to apply to the shadow. Typically whole-tile or half-tile increments.
---@return Animation # A horizontal pipe shadow for a single tile.
---@return RequiredAssets # The required asset mods.
---
---#### Examples
---Add a horizontal pipe shadow in the north and south directions to the `working_visualisations` field of an assembly
---machine prototype. The shadow will offset right 1 tile for east, and left 1 tile for west, along the centerline of a
---3 x 3 entity.
---```lua
---local _pipes = require("__reskins-assets-api__.assets.base.entities.pipe-pictures")
---
---local greenhouse = data.raw["assembling-machine"]["bob-greenhouse"]
---table.insert(greenhouse.working_visualisations, {
---    always_draw = true,
---    east_animation = _pipes.get_horizontal_pipe_shadow({1, 0}),
---    west_animation = _pipes.get_horizontal_pipe_shadow({-1, 0}),
---)}
---```
---@nodiscard
function M.horizontal_pipe_shadow(shift)
	---@type Animation
	local shadow_animation = {
		filename = "__reskins-assets-base__/graphics/entity/pipe/horizontal-pipe-shadow-patch.png",
		priority = "high",
		width = 128,
		height = 128,
		draw_as_shadow = true,
		shift = shift,
		scale = 0.5,
	}

	return shadow_animation, { [_defines.assets_source.base_assets] = true }
end

---Gets a `Sprite4Way` object containing pipe cover sprites in the given `pipe_material`.
---
---#### Parameters
---@param pipe_material PipeMaterial The material type to get sprites for.
---
---#### Returns
---@return Sprite4Way pictures The complete set of pipe cover sprites in the given `pipe_material`.
---@return RequiredAssets required_assets # The required asset mods.
---
---#### Examples
---```lua
---local _defines = require("__reskins-assets-api__.api.defines")
---local _pipes = require("__reskins-assets-api__.assets.base.entities.pipe_pictures")
---
----- Update the pipe cover sprites on the bronze pipe fluid box.
---local pipe_entity = data.raw["pipe"]["bronze-pipe"]
---
---pipe_entity.fluid_box.pipe_covers = _pipes.pipe_covers(_defines.pipe_material.bronze)
---```
---@nodiscard
function M.pipe_covers(pipe_material)
	local material_asset = M.asset_from_material(pipe_material)
	local material_name = M.name_from_material(pipe_material)
	local assets_base_path = material_asset .. "/graphics/entity/pipe-covers/" .. material_name .. "/"
	local shadow_assets_base_path = "__reskins-assets-base__/graphics/entity/pipe-covers/shadows/"

	---@type Sprite4Way
	local pipe_cover_pictures = {
		north = {
			layers = {
				{
					filename = assets_base_path .. "pipe-cover-north.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					scale = 0.5,
				},
				{
					filename = shadow_assets_base_path .. "pipe-cover-north-shadow.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					scale = 0.5,
					draw_as_shadow = true,
				},
			},
		},
		east = {
			layers = {
				{
					filename = assets_base_path .. "pipe-cover-east.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					scale = 0.5,
				},
				{
					filename = shadow_assets_base_path .. "pipe-cover-east-shadow.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					scale = 0.5,
					draw_as_shadow = true,
				},
			},
		},
		south = {
			layers = {
				{
					filename = assets_base_path .. "pipe-cover-south.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					scale = 0.5,
				},
				{
					filename = shadow_assets_base_path .. "pipe-cover-south-shadow.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					scale = 0.5,
					draw_as_shadow = true,
				},
			},
		},
		west = {
			layers = {
				{
					filename = assets_base_path .. "pipe-cover-west.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					scale = 0.5,
				},
				{
					filename = shadow_assets_base_path .. "pipe-cover-west-shadow.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					scale = 0.5,
					draw_as_shadow = true,
				},
			},
		},
	}

	---@type RequiredAssets
	local required_assets = {
		[_defines.assets_source.base_assets] = true,
	}

	if material_asset ~= _defines.assets_source.base_assets then
		required_assets[material_asset] = true
	end

	return pipe_cover_pictures, required_assets
end

---Gets a `Sprite4Way` object containing frozen pipe cover sprites.
---@return Sprite4Way pictures The complete set of frozen pipe cover sprites.
---@return RequiredAssets required_assets # The required asset mods.
---
---#### Examples
---```lua
---local _pipes = require("__reskins-assets-api__.assets.base.entities.pipe_pictures")
---
----- Add the frozen pipe cover sprites to the iron pipe.
---local pipe_entity = data.raw["pipe"]["pipe"]
---
---pipe_entity.fluid_box.pipe_covers_frozen = _pipes.pipe_covers_frozen()
---```
---@nodiscard
function M.pipe_covers_frozen()
	---@type Sprite4Way
	local pipe_covers_frozen = {
		north = {
			filename = "__space-age__/graphics/entity/frozen/pipe-covers/pipe-cover-north.png",
			priority = "extra-high",
			width = 128,
			height = 128,
			scale = 0.5,
		},
		east = {
			filename = "__space-age__/graphics/entity/frozen/pipe-covers/pipe-cover-east.png",
			priority = "extra-high",
			width = 128,
			height = 128,
			scale = 0.5,
		},
		south = {
			filename = "__space-age__/graphics/entity/frozen/pipe-covers/pipe-cover-south.png",
			priority = "extra-high",
			width = 128,
			height = 128,
			scale = 0.5,
		},
		west = {
			filename = "__space-age__/graphics/entity/frozen/pipe-covers/pipe-cover-west.png",
			priority = "extra-high",
			width = 128,
			height = 128,
			scale = 0.5,
		},
	}

	return pipe_covers_frozen, { [_defines.assets_source.space_age] = true }
end

---Gets the tinted pipe pictures for the assembling machine (and functionally identical entities such as the oil boiler).
---The `north` direction has no tinted variant when `use_simple_pipe_pictures` is true; the east direction always uses the
---simple sprite when that flag is set.
---@param tint Color? Tint color for the mask and highlights layers. When `nil`, only the base layer is returned.
---@param use_simple_pipe_pictures boolean? When true, omits the `north` mask/highlights and uses the `-simple` east variant.
---@return Sprite4Way
---@return RequiredAssets
---@nodiscard
function M.assembling_machine_pipe_pictures(tint, use_simple_pipe_pictures)
	local simple = use_simple_pipe_pictures and "-simple" or ""
	local assets_base_path = "__reskins-assets-base__/graphics/entity/assembling-machine/pipes/"

	---@type Sprite4Way
	local pictures = {
		north = {
			filename = assets_base_path .. "assembling-machine-pipe-north-base.png",
			priority = "extra-high",
			width = 71,
			height = 38,
			shift = util.by_pixel(2.25, 13.5),
			scale = 0.5,
		},
		east = {
			filename = assets_base_path .. "assembling-machine-pipe-east" .. simple .. "-base.png",
			priority = "extra-high",
			width = 42,
			height = 76,
			shift = util.by_pixel(-24.5, 1),
			scale = 0.5,
		},
		south = {
			filename = assets_base_path .. "assembling-machine-pipe-south-base.png",
			priority = "extra-high",
			width = 88,
			height = 61,
			shift = util.by_pixel(0, -31.25),
			scale = 0.5,
		},
		west = {
			filename = assets_base_path .. "assembling-machine-pipe-west-base.png",
			priority = "extra-high",
			width = 39,
			height = 73,
			shift = util.by_pixel(25.75, 1.25),
			scale = 0.5,
		},
	}

	if tint then
		if not use_simple_pipe_pictures then
			pictures.north = {
				layers = {
					pictures.north,
					{
						filename = assets_base_path .. "assembling-machine-pipe-north-mask.png",
						priority = "extra-high",
						width = 71,
						height = 38,
						shift = util.by_pixel(2.25, 13.5),
						tint = tint,
						scale = 0.5,
					},
					{
						filename = assets_base_path .. "assembling-machine-pipe-north-highlights.png",
						priority = "extra-high",
						width = 71,
						height = 38,
						shift = util.by_pixel(2.25, 13.5),
						blend_mode = "additive-soft",
						scale = 0.5,
					},
				},
			}
		end

		pictures.east = {
			layers = {
				pictures.east,
				{
					filename = assets_base_path .. "assembling-machine-pipe-east" .. simple .. "-mask.png",
					priority = "extra-high",
					width = 42,
					height = 76,
					shift = util.by_pixel(-24.5, 1),
					tint = tint,
					scale = 0.5,
				},
				{
					filename = assets_base_path .. "assembling-machine-pipe-east" .. simple .. "-highlights.png",
					priority = "extra-high",
					width = 42,
					height = 76,
					shift = util.by_pixel(-24.5, 1),
					blend_mode = "additive-soft",
					scale = 0.5,
				},
			},
		}

		pictures.south = {
			layers = {
				pictures.south,
				{
					filename = assets_base_path .. "assembling-machine-pipe-south-mask.png",
					priority = "extra-high",
					width = 88,
					height = 61,
					shift = util.by_pixel(0, -31.25),
					tint = tint,
					scale = 0.5,
				},
				{
					filename = assets_base_path .. "assembling-machine-pipe-south-highlights.png",
					priority = "extra-high",
					width = 88,
					height = 61,
					shift = util.by_pixel(0, -31.25),
					blend_mode = "additive-soft",
					scale = 0.5,
				},
			},
		}

		pictures.west = {
			layers = {
				pictures.west,
				{
					filename = assets_base_path .. "assembling-machine-pipe-west-mask.png",
					priority = "extra-high",
					width = 39,
					height = 73,
					shift = util.by_pixel(25.75, 1.25),
					tint = tint,
					scale = 0.5,
				},
				{
					filename = assets_base_path .. "assembling-machine-pipe-west-highlights.png",
					priority = "extra-high",
					width = 39,
					height = 73,
					shift = util.by_pixel(25.75, 1.25),
					blend_mode = "additive-soft",
					scale = 0.5,
				},
			},
		}
	end

	---@type RequiredAssets
	local required_assets = {
		[_defines.assets_source.base_assets] = true,
	}

	return pictures, required_assets
end

return M
