-- THIS MODULE IS EXTREMELY WIP AND SUBJECT TO CHANGE.
-- The require path, function names and signatures are not stable.

local StringValidator = require("prototypes.string-validator")
local _defines = require("api.defines")
local _pipes = {}

---Gets the asset that provides the sprites for the given `pipe_material`.
---@param pipe_material Reskins.Defines.PipeMaterial
---@return Reskins.Defines.Assets material_asset
function _pipes.asset_from_material(pipe_material)
	StringValidator.validate(pipe_material, "pipe_material"):is_one_of(_defines.pipe_material)
	---@cast pipe_material string

	local assets_base_path
	if pipe_material == _defines.pipe_material.iron then
		assets_base_path = _defines.assets.base_assets
	elseif pipe_material:find("angels") then
		assets_base_path = _defines.assets.angels_assets
	else
		assets_base_path = _defines.assets.bobs_assets
	end

	return assets_base_path
end

---Gets the bare material name absent any discriminators for the given `pipe_material`.
---@param pipe_material Reskins.Defines.PipeMaterial
---@return PipeMaterialName material_name
function _pipes.name_from_material(pipe_material)
	StringValidator.validate(pipe_material, "pipe_material"):is_one_of(_defines.pipe_material)
	---@cast pipe_material string

	local material, _ = pipe_material:gsub("%-angels", "")
	return material
end

---Gets an `Animation` object configured to draw a vertical pipe shadow at the given `shift`, for a single tile.
---
---Conventional use is by non-pipe entities that have pipe connections, and need to dynamically draw a shadow at the
---connection point for a given rotation state, rather than bake the shadow into the entity's sprite.
---
---### Parameters
---@param shift data.Vector The shift to apply to the shadow. Typically whole-tile or half-tile increments.
---
---### Returns
---@return data.Animation # A vertical pipe shadow for a single tile.
---@return RequiredAssets # The required asset mods.
---
---### Examples
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
function _pipes.vertical_pipe_shadow(shift)
	---@type data.Animation
	local shadow_animation = {
		filename = "__reskins-assets-base__/graphics/entity/pipe/vertical-pipe-shadow-patch.png",
		priority = "high",
		width = 128,
		height = 128,
		draw_as_shadow = true,
		shift = shift,
		scale = 0.5,
	}

	return shadow_animation, { [_defines.assets.base_assets] = true }
end

---Gets an `Animation` object configured to draw a horizontal pipe shadow at the given `shift`, for a single tile.
---
---Conventional use is by non-pipe entities that have pipe connections, and need to dynamically draw a shadow at the
---connection point for a given rotation state, rather than bake the shadow into the entity's sprite.
---
---### Parameters
---@param shift data.Vector The shift to apply to the shadow. Typically whole-tile or half-tile increments.
---
---### Returns
---@return data.Animation # A horizontal pipe shadow for a single tile.
---@return RequiredAssets # The required asset mods.
---
---### Examples
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
function _pipes.horizontal_pipe_shadow(shift)
	---@type data.Animation
	local shadow_animation = {
		filename = "__reskins-assets-base__/graphics/entity/pipe/horizontal-pipe-shadow-patch.png",
		priority = "high",
		width = 128,
		height = 128,
		draw_as_shadow = true,
		shift = shift,
		scale = 0.5,
	}

	return shadow_animation, { [_defines.assets.base_assets] = true }
end

---Gets a `Sprite4Way` object containing pipe cover sprites in the given `pipe_material`.
---
---### Parameters
---@param pipe_material Reskins.Defines.PipeMaterial # The material type to get sprites for.
---
---### Returns
---@return data.Sprite4Way pictures # The complete set of pipe cover sprites in the given `pipe_material`.
---@return RequiredAssets required_assets # The required asset mods.
---
---### Examples
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
function _pipes.pipe_covers(pipe_material)
	local material_asset = _pipes.asset_from_material(pipe_material)
	local material_name = _pipes.name_from_material(pipe_material)
	local assets_base_path = material_asset .. "/graphics/entity/pipe-covers/" .. material_name .. "/"
	local shadow_assets_base_path = "__reskins-assets-base__/graphics/entity/pipe-covers/shadows/"

	---@type data.Sprite4Way
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
		[_defines.assets.base_assets] = true,
	}

	if material_asset ~= _defines.assets.base_assets then
		required_assets[material_asset] = true
	end

	return pipe_cover_pictures, required_assets
end

---Gets a `Sprite4Way` object containing frozen pipe cover sprites.
---
---### Returns
---@return data.Sprite4Way pictures # The complete set of frozen pipe cover sprites.
---@return RequiredAssets required_assets # The required asset mods.
---
---### Examples
---```lua
---local _pipes = require("__reskins-assets-api__.assets.base.entities.pipe_pictures")
---
----- Add the frozen pipe cover sprites to the iron pipe.
---local pipe_entity = data.raw["pipe"]["pipe"]
---
---pipe_entity.fluid_box.pipe_covers_frozen = _pipes.pipe_covers_frozen()
---```
---@nodiscard
function _pipes.pipe_covers_frozen()
	---@type data.Sprite4Way
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

	return pipe_covers_frozen, { [_defines.assets.space_age] = true }
end

--- Gets a `Sprite4Way` object containing pipe-to-ground sprites in the given `pipe_material`.
---
---### Parameters
---@param pipe_material Reskins.Defines.PipeMaterial # The material type to get sprites for.
---
---### Returns
---@return data.Sprite4Way pictures # The complete set of pipe-to-ground sprites in the given `pipe_material`.
---@return RequiredAssets required_assets # The required asset mods.
---
---### Examples
---```lua
---local _defines = require("__reskins-assets-api__.api.defines")
---local _pipes = require("__reskins-assets-api__.assets.base.entities.pipe_pictures")
---
----- Update the pipe-to-ground sprites for the bronze pipes.
---local pipe_to_ground_entity = data.raw["pipe-to-ground"]["bronze-pipe"]
---
---pipe_to_ground_entity.pictures = _pipes.pipe_to_ground_pictures(_defines.pipe_material.bronze)
---```
---@nodiscard
function _pipes.pipe_to_ground_pictures(pipe_material)
	local material_asset = _pipes.asset_from_material(pipe_material)
	local material_name = _pipes.name_from_material(pipe_material)
	local assets_base_path = material_asset .. "/graphics/entity/pipe-to-ground/" .. material_name .. "/"
	local shadow_assets_base_path = "__reskins-assets-base__/graphics/entity/pipe-to-ground/shadows/"

	---@type data.Sprite4Way
	local pipe_to_ground_pictures = {
		north = {
			layers = {
				{
					filename = assets_base_path .. "pipe-to-ground-up.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					scale = 0.5,
				},
				{
					filename = shadow_assets_base_path .. "pipe-to-ground-up-shadow.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					draw_as_shadow = true,
					scale = 0.5,
				},
			},
		},
		east = {
			layers = {
				{
					filename = assets_base_path .. "pipe-to-ground-right.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					scale = 0.5,
				},
				{
					filename = shadow_assets_base_path .. "pipe-to-ground-right-shadow.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					draw_as_shadow = true,
					scale = 0.5,
				},
			},
		},
		south = {
			layers = {
				{
					filename = assets_base_path .. "pipe-to-ground-down.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					scale = 0.5,
				},
				{
					filename = shadow_assets_base_path .. "pipe-to-ground-down-shadow.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					draw_as_shadow = true,
					scale = 0.5,
				},
			},
		},
		west = {
			layers = {
				{
					filename = assets_base_path .. "pipe-to-ground-left.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					scale = 0.5,
				},
				{
					filename = shadow_assets_base_path .. "pipe-to-ground-left-shadow.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					draw_as_shadow = true,
					scale = 0.5,
				},
			},
		},
	}

	---@type RequiredAssets
	local required_assets = {
		[_defines.assets.base_assets] = true,
	}

	if material_asset ~= _defines.assets.base_assets then
		required_assets[material_asset] = true
	end

	return pipe_to_ground_pictures, required_assets
end

---Gets a `PipePictures` object containing pipe sprites in the given `pipe_material`.
---
---### Parameters
---@param pipe_material Reskins.Defines.PipeMaterial # The material type to get sprites for.
---
---### Returns
---@return data.PipePictures pictures The complete set of pipe sprites in the given `pipe_material`.
---@return RequiredAssets required_assets The required asset mods.
---
---### Examples
---```lua
---local _defines = require("__reskins-assets-api__.api.defines")
---local _pipes = require("__reskins-assets-api__.assets.base.entities.pipe_pictures")
---
----- Update the pipe sprites for the bronze pipes.
---local pipe_entity = data.raw["pipe"]["bronze-pipe"]
---
---pipe_entity.pictures = _pipes.pipe_pictures(_defines.pipe_material.bronze)
---```
---@nodiscard
function _pipes.pipe_pictures(pipe_material)
	local material_asset = _pipes.asset_from_material(pipe_material)
	local material_name = _pipes.name_from_material(pipe_material)
	local assets_base_path = material_asset .. "/graphics/entity/pipe/" .. material_name .. "/"
	local shadow_assets_base_path = "__reskins-assets-base__/graphics/entity/pipe/shadows/"

	---@type data.PipePictures
	local pipe_pictures = {
		straight_vertical_single = {
			layers = {
				-- Base
				{
					filename = assets_base_path .. "pipe-straight-vertical-single.png",
					priority = "extra-high",
					width = 160,
					height = 160,
					scale = 0.5,
				},
				{
					filename = shadow_assets_base_path .. "pipe-straight-vertical-single-shadow.png",
					priority = "extra-high",
					width = 160,
					height = 160,
					draw_as_shadow = true,
					scale = 0.5,
				},
			},
		},
		straight_vertical = {
			layers = {
				-- Base
				{
					filename = assets_base_path .. "pipe-straight-vertical.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					scale = 0.5,
				},
				{
					filename = shadow_assets_base_path .. "pipe-straight-vertical-shadow.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					draw_as_shadow = true,
					scale = 0.5,
				},
			},
		},
		straight_vertical_window = {
			layers = {
				-- Base
				{
					filename = assets_base_path .. "pipe-straight-vertical-window.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					scale = 0.5,
				},
				{
					filename = shadow_assets_base_path .. "pipe-straight-vertical-shadow.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					draw_as_shadow = true,
					scale = 0.5,
				},
			},
		},
		straight_horizontal_window = {
			layers = {
				-- Base
				{
					filename = assets_base_path .. "pipe-straight-horizontal-window.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					scale = 0.5,
				},
				{
					filename = shadow_assets_base_path .. "pipe-straight-horizontal-shadow.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					draw_as_shadow = true,
					scale = 0.5,
				},
			},
		},
		straight_horizontal = {
			layers = {
				-- Base
				{
					filename = assets_base_path .. "pipe-straight-horizontal.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					scale = 0.5,
				},
				{
					filename = shadow_assets_base_path .. "pipe-straight-horizontal-shadow.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					draw_as_shadow = true,
					scale = 0.5,
				},
			},
		},
		corner_up_right = {
			layers = {
				-- Base
				{
					filename = assets_base_path .. "pipe-corner-up-right.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					scale = 0.5,
				},
				{
					filename = shadow_assets_base_path .. "pipe-corner-up-right-shadow.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					draw_as_shadow = true,
					scale = 0.5,
				},
			},
		},
		corner_up_left = {
			layers = {
				-- Base
				{
					filename = assets_base_path .. "pipe-corner-up-left.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					scale = 0.5,
				},
				{
					filename = shadow_assets_base_path .. "pipe-corner-up-left-shadow.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					draw_as_shadow = true,
					scale = 0.5,
				},
			},
		},
		corner_down_right = {
			layers = {
				-- Base
				{
					filename = assets_base_path .. "pipe-corner-down-right.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					scale = 0.5,
				},
				{
					filename = shadow_assets_base_path .. "pipe-corner-down-right-shadow.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					draw_as_shadow = true,
					scale = 0.5,
				},
			},
		},
		corner_down_left = {
			layers = {
				-- Base
				{
					filename = assets_base_path .. "pipe-corner-down-left.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					scale = 0.5,
				},
				{
					filename = shadow_assets_base_path .. "pipe-corner-down-left-shadow.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					draw_as_shadow = true,
					scale = 0.5,
				},
			},
		},
		t_up = {
			layers = {
				-- Base
				{
					filename = assets_base_path .. "pipe-t-up.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					scale = 0.5,
				},
				{
					filename = shadow_assets_base_path .. "pipe-t-up-shadow.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					draw_as_shadow = true,
					scale = 0.5,
				},
			},
		},
		t_down = {
			layers = {
				-- Base
				{
					filename = assets_base_path .. "pipe-t-down.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					scale = 0.5,
				},
				{
					filename = shadow_assets_base_path .. "pipe-t-down-shadow.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					draw_as_shadow = true,
					scale = 0.5,
				},
			},
		},
		t_right = {
			layers = {
				-- Base
				{
					filename = assets_base_path .. "pipe-t-right.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					scale = 0.5,
				},
				{
					filename = shadow_assets_base_path .. "pipe-t-right-shadow.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					draw_as_shadow = true,
					scale = 0.5,
				},
			},
		},
		t_left = {
			layers = {
				-- Base
				{
					filename = assets_base_path .. "pipe-t-left.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					scale = 0.5,
				},
				{
					filename = shadow_assets_base_path .. "pipe-t-left-shadow.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					draw_as_shadow = true,
					scale = 0.5,
				},
			},
		},
		cross = {
			layers = {
				-- Base
				{
					filename = assets_base_path .. "pipe-cross.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					scale = 0.5,
				},
				{
					filename = shadow_assets_base_path .. "pipe-cross-shadow.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					draw_as_shadow = true,
					scale = 0.5,
				},
			},
		},
		ending_up = {
			layers = {
				-- Base
				{
					filename = assets_base_path .. "pipe-ending-up.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					scale = 0.5,
				},
				{
					filename = shadow_assets_base_path .. "pipe-ending-up-shadow.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					draw_as_shadow = true,
					scale = 0.5,
				},
			},
		},
		ending_down = {
			layers = {
				-- Base
				{
					filename = assets_base_path .. "pipe-ending-down.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					scale = 0.5,
				},
				{
					filename = shadow_assets_base_path .. "pipe-ending-down-shadow.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					draw_as_shadow = true,
					scale = 0.5,
				},
			},
		},
		ending_right = {
			layers = {
				-- Base
				{
					filename = assets_base_path .. "pipe-ending-right.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					scale = 0.5,
				},
				{
					filename = shadow_assets_base_path .. "pipe-ending-right-shadow.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					draw_as_shadow = true,
					scale = 0.5,
				},
			},
		},
		ending_left = {
			layers = {
				-- Base
				{
					filename = assets_base_path .. "pipe-ending-left.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					scale = 0.5,
				},
				{
					filename = shadow_assets_base_path .. "pipe-ending-left-shadow.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					draw_as_shadow = true,
					scale = 0.5,
				},
			},
		},
		horizontal_window_background = {
			filename = assets_base_path .. "pipe-horizontal-window-background.png",
			priority = "extra-high",
			width = 128,
			height = 128,
			scale = 0.5,
		},
		vertical_window_background = {
			filename = assets_base_path .. "pipe-vertical-window-background.png",
			priority = "extra-high",
			width = 128,
			height = 128,
			scale = 0.5,
		},
		fluid_background = {
			filename = "__base__/graphics/entity/pipe/fluid-background.png",
			priority = "extra-high",
			width = 64,
			height = 40,
			scale = 0.5,
		},
		low_temperature_flow = {
			filename = "__base__/graphics/entity/pipe/fluid-flow-low-temperature.png",
			priority = "extra-high",
			width = 160,
			height = 18,
		},
		middle_temperature_flow = {
			filename = "__base__/graphics/entity/pipe/fluid-flow-medium-temperature.png",
			priority = "extra-high",
			width = 160,
			height = 18,
		},
		high_temperature_flow = {
			filename = "__base__/graphics/entity/pipe/fluid-flow-high-temperature.png",
			priority = "extra-high",
			width = 160,
			height = 18,
		},
		gas_flow = {
			filename = "__base__/graphics/entity/pipe/steam.png",
			priority = "extra-high",
			line_length = 10,
			width = 48,
			height = 30,
			frame_count = 60,
		},
	}

	---@type RequiredAssets
	local required_assets = {
		[_defines.assets.base] = true,
		[_defines.assets.base_assets] = true,
	}

	if material_asset ~= _defines.assets.base_assets then
		required_assets[material_asset] = true
	end

	return pipe_pictures, required_assets
end

---Gets the tinted pipe pictures for the assembling machine (and functionally identical entities such as the oil boiler).
---The `north` direction has no tinted variant when `use_simple_pipe_pictures` is true; the east direction always uses the
---simple sprite when that flag is set.
---
---### Parameters
---@param tint data.Color? Tint color for the mask and highlights layers. When `nil`, only the base layer is returned.
---@param use_simple_pipe_pictures boolean? When true, omits the `north` mask/highlights and uses the `-simple` east variant.
---
---### Returns
---@return data.Sprite4Way
---@return RequiredAssets
---@nodiscard
function _pipes.assembling_machine_pipe_pictures(tint, use_simple_pipe_pictures)
	local simple = use_simple_pipe_pictures and "-simple" or ""
	local assets_base_path = "__reskins-assets-base__/graphics/entity/assembling-machine/pipes/"

	---@type data.Sprite4Way
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
		[_defines.assets.base_assets] = true,
	}

	return pictures, required_assets
end

return _pipes
