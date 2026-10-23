---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local _pipes = require("assets.base.entities.pipe-pictures")
local _sprites = require("__reskins-sprite-utils__.sprites")

local V = require("__reskins-sprite-utils__.validation")
local AssetsCommon = require("api.validation")
local IconBuilderFactory = require("api.icon-builder-factory")

local M = {}

---Defines the options for the pipe sprites.
---@class PipeGraphicsParams
---The pipe material.
---@field pipe_material PipeMaterial
---When `true`, indicates that the frozen sprites are included in the graphics pack. Default `false`.
---@field include_frozen_pictures? boolean

---Gets a `RotatedAnimationVariations` object containing pipe remnant sprites of the given `pipe_material`.
---@param pipe_material PipeMaterial
---@return RotatedAnimationVariations animation
local function get_corpse_animation(pipe_material)
	-- For remnants only, the iron artwork comes from base.
	local is_iron = pipe_material == _defines.pipe_material.iron
	local material_asset = is_iron and _defines.assets_source.base or _pipes.asset_from_material(pipe_material)

	local material_name = _pipes.name_from_material(pipe_material)
	local assets_base_path = material_asset .. "/graphics/entity/pipe/" .. (is_iron and "" or material_name .. "/")

	local animation = _sprites.make_rotated_animation_variations_from_spritesheet(2, {
		filename = assets_base_path .. "remnants/pipe-remnants.png",
		width = 122,
		height = 120,
		direction_count = 2,
		shift = util.by_pixel(1.5, 2.5),
		scale = 0.5,
	})

	return animation
end

---@return PipePictures
local function get_frozen_pictures()
	local assets_base_path = "__space-age__/graphics/entity/frozen/pipe/"

	---@type PipePictures
	local frozen_pipe_pictures = {
		straight_vertical_single_frozen = {
			filename = assets_base_path .. "pipe-straight-vertical-single.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			scale = 0.5,
		},
		straight_vertical_frozen = {
			filename = assets_base_path .. "pipe-straight-vertical.png",
			priority = "extra-high",
			width = 128,
			height = 128,
			scale = 0.5,
		},
		straight_vertical_window_frozen = {
			filename = assets_base_path .. "pipe-straight-vertical-window.png",
			priority = "extra-high",
			width = 128,
			height = 128,
			scale = 0.5,
		},
		straight_horizontal_frozen = {
			filename = assets_base_path .. "pipe-straight-horizontal.png",
			priority = "extra-high",
			width = 128,
			height = 128,
			scale = 0.5,
		},
		straight_horizontal_window_frozen = {
			filename = assets_base_path .. "pipe-straight-horizontal-window.png",
			priority = "extra-high",
			width = 128,
			height = 128,
			scale = 0.5,
		},
		corner_up_right_frozen = {
			filename = assets_base_path .. "pipe-corner-up-right.png",
			priority = "extra-high",
			width = 128,
			height = 128,
			scale = 0.5,
		},
		corner_up_left_frozen = {
			filename = assets_base_path .. "pipe-corner-up-left.png",
			priority = "extra-high",
			width = 128,
			height = 128,
			scale = 0.5,
		},
		corner_down_right_frozen = {
			filename = assets_base_path .. "pipe-corner-down-right.png",
			priority = "extra-high",
			width = 128,
			height = 128,
			scale = 0.5,
		},
		corner_down_left_frozen = {
			filename = assets_base_path .. "pipe-corner-down-left.png",
			priority = "extra-high",
			width = 128,
			height = 128,
			scale = 0.5,
		},
		t_up_frozen = {
			filename = assets_base_path .. "pipe-t-up.png",
			priority = "extra-high",
			width = 128,
			height = 128,
			scale = 0.5,
		},
		t_down_frozen = {
			filename = assets_base_path .. "pipe-t-down.png",
			priority = "extra-high",
			width = 128,
			height = 128,
			scale = 0.5,
		},
		t_right_frozen = {
			filename = assets_base_path .. "pipe-t-right.png",
			priority = "extra-high",
			width = 128,
			height = 128,
			scale = 0.5,
		},
		t_left_frozen = {
			filename = assets_base_path .. "pipe-t-left.png",
			priority = "extra-high",
			width = 128,
			height = 128,
			scale = 0.5,
		},
		cross_frozen = {
			filename = assets_base_path .. "pipe-cross.png",
			priority = "extra-high",
			width = 128,
			height = 128,
			scale = 0.5,
		},
		ending_up_frozen = {
			filename = assets_base_path .. "pipe-ending-up.png",
			priority = "extra-high",
			width = 128,
			height = 128,
			scale = 0.5,
		},
		ending_down_frozen = {
			filename = assets_base_path .. "pipe-ending-down.png",
			priority = "extra-high",
			width = 128,
			height = 128,
			scale = 0.5,
		},
		ending_right_frozen = {
			filename = assets_base_path .. "pipe-ending-right.png",
			priority = "extra-high",
			width = 128,
			height = 128,
			scale = 0.5,
		},
		ending_left_frozen = {
			filename = assets_base_path .. "pipe-ending-left.png",
			priority = "extra-high",
			width = 128,
			height = 128,
			scale = 0.5,
		},
	}

	return frozen_pipe_pictures
end

--- @param i integer
local function make_visualization(i)
	return {
		filename = "__base__/graphics/entity/pipe/visualization.png",
		priority = "extra-high",
		x = i * 64,
		size = 64,
		scale = 0.5,
		flags = { "icon" },
	}
end

--- @param i integer
local function make_disabled_visualization(i)
	return {
		filename = "__base__/graphics/entity/pipe/disabled-visualization.png",
		priority = "extra-high",
		x = i * 64,
		size = 64,
		scale = 0.5,
		flags = { "icon" },
	}
end

---@param pipe_material PipeMaterial
---@param include_frozen_pictures? boolean
---@return PipePictures
local function get_pictures(pipe_material, include_frozen_pictures)
	local material_asset = _pipes.asset_from_material(pipe_material)
	local material_name = _pipes.name_from_material(pipe_material)
	local assets_base_path = material_asset .. "/graphics/entity/pipe/" .. material_name .. "/"
	local shadow_assets_base_path = "__reskins-assets-base__/graphics/entity/pipe/shadows/"

	---@type PipePictures
	local pipe_pictures = {
		straight_vertical_single = {
			layers = {
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
		straight_vertical_single_visualization = make_visualization(0),
		straight_vertical_visualization = make_visualization(5),
		straight_vertical_window_visualization = make_visualization(5),
		straight_horizontal_window_visualization = make_visualization(10),
		straight_horizontal_visualization = make_visualization(10),
		corner_up_right_visualization = make_visualization(3),
		corner_up_left_visualization = make_visualization(9),
		corner_down_right_visualization = make_visualization(6),
		corner_down_left_visualization = make_visualization(12),
		t_up_visualization = make_visualization(11),
		t_down_visualization = make_visualization(14),
		t_right_visualization = make_visualization(7),
		t_left_visualization = make_visualization(13),
		cross_visualization = make_visualization(15),
		ending_up_visualization = make_visualization(1),
		ending_down_visualization = make_visualization(4),
		ending_right_visualization = make_visualization(2),
		ending_left_visualization = make_visualization(8),
		straight_vertical_single_disabled_visualization = make_disabled_visualization(0),
		straight_vertical_disabled_visualization = make_disabled_visualization(5),
		straight_vertical_window_disabled_visualization = make_disabled_visualization(5),
		straight_horizontal_window_disabled_visualization = make_disabled_visualization(10),
		straight_horizontal_disabled_visualization = make_disabled_visualization(10),
		corner_up_right_disabled_visualization = make_disabled_visualization(3),
		corner_up_left_disabled_visualization = make_disabled_visualization(9),
		corner_down_right_disabled_visualization = make_disabled_visualization(6),
		corner_down_left_disabled_visualization = make_disabled_visualization(12),
		t_up_disabled_visualization = make_disabled_visualization(11),
		t_down_disabled_visualization = make_disabled_visualization(14),
		t_right_disabled_visualization = make_disabled_visualization(7),
		t_left_disabled_visualization = make_disabled_visualization(13),
		cross_disabled_visualization = make_disabled_visualization(15),
		ending_up_disabled_visualization = make_disabled_visualization(1),
		ending_down_disabled_visualization = make_disabled_visualization(4),
		ending_right_disabled_visualization = make_disabled_visualization(2),
		ending_left_disabled_visualization = make_disabled_visualization(8),
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

	if include_frozen_pictures then
		pipe_pictures = util.merge({ pipe_pictures, get_frozen_pictures() })
	end

	return pipe_pictures
end

---@param pipe_material PipeMaterial
---@param include_frozen_pictures? boolean
---@return FluidBoxGraphics
local function get_fluid_box_graphics(pipe_material, include_frozen_pictures)
	local pipe_covers = _pipes.pipe_covers(pipe_material)

	---@type FluidBoxGraphics
	local fluid_box_graphics = {
		pipe_covers = pipe_covers,
	}

	if include_frozen_pictures then
		fluid_box_graphics.pipe_covers_frozen = _pipes.pipe_covers_frozen()
	end

	return fluid_box_graphics
end

---Defines the options for the vanilla and Bob's pipes sprite set.
---@class PipeSpriteSetParams
---The material from which the pipes are built.
---@field pipe_material PipeMaterial
---When `true`, indicates that the frozen artwork is included. Default `false`.
---@field include_frozen_pictures? boolean

---Gets the sprite set for the vanilla and Bob's pipes.
---
---Window bounding boxes are the base game's.
---@param params PipeSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<PipeSpriteSet> # The sprite set definition for the vanilla and Bob's pipes.
---
---#### Examples
---```lua
---local pipe = require("__reskins-assets-api__.assets.base.entities.pipe")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = pipe.get_sprite_set({ pipe_material = pipe_material })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set(params)
	---@type SpriteSetDefinition<PipeSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.pipe_sprite_set,
		set = {
			horizontal_window_bounding_box = { { -0.25, -0.28125 }, { 0.25, 0.15625 } },
			vertical_window_bounding_box = { { -0.28125, -0.5 }, { 0.03125, 0.125 } },
			pictures = get_pictures(params.pipe_material, params.include_frozen_pictures),
			fluid_box = get_fluid_box_graphics(params.pipe_material),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = { animation = get_corpse_animation(params.pipe_material) },
			water_reflection = nil,
			nominal_width = 1,
			nominal_height = 1,
		},
	}

	return definition
end

---Gets the icon for a pipe built from the `material` given by `params`.
M.get_icon = IconBuilderFactory.dispatch("material", _defines.pipe_material, "get_icon", function(pipe_material)
	-- The iron pipe icon comes from the base game.
	if pipe_material == _defines.pipe_material.iron then
		return IconBuilderFactory:create({ folder = "__base__/graphics/icons" }):flat("pipe")
	end

	local folder = _pipes.asset_from_material(pipe_material) .. "/graphics/icons/pipe"
	local name = _pipes.name_from_material(pipe_material)

	return IconBuilderFactory:create({ folder = folder }):flat(name .. "-pipe")
end)

local pipe_material_tints = {
	[_defines.pipe_material.iron] = { 0.810, 0.739, 0.651, 1 },
	[_defines.pipe_material.aluminum] = util.color("#ffffff"),
	[_defines.pipe_material.copper] = util.color("#d45539"),
	[_defines.pipe_material.stone] = util.color("#cfcfcf"),
	[_defines.pipe_material.bronze] = util.color("#b09954"),
	[_defines.pipe_material.steel] = util.color("#877c76"),
	[_defines.pipe_material.plastic] = util.color("#0078ff"),
	[_defines.pipe_material.brass] = util.color("#f9c854"),
	[_defines.pipe_material.titanium] = util.color("#adadb2"),
	[_defines.pipe_material.ceramic] = util.color("#8f7967"),
	[_defines.pipe_material.tungsten] = util.color("#3b3b3b"),
	[_defines.pipe_material.nitinol] = util.color("#706f6b"),
	[_defines.pipe_material.copper_tungsten] = util.color("#99593d"),
	[_defines.pipe_material.titanium_angels] = util.color("#995f92"),
	[_defines.pipe_material.ceramic_angels] = util.color("#ffffff"),
	[_defines.pipe_material.tungsten_angels] = util.color("#7e5f45"),
	[_defines.pipe_material.nitinol_angels] = util.color("#7664a9"),
}

local check_get_material_tint = V.signature("get_material_tint", {
	{ "params", V.struct({ material = AssetsCommon.pipe_material }) },
})

---Gets the tint corresponding to the specified `pipe_material`.
---@param params { material: PipeMaterial }
---@return Color
function M.get_material_tint(params)
	check_get_material_tint(params)

	return util.copy(pipe_material_tints[params.material]) --[[@as Color]]
end

return M
