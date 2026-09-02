---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local _pipes = require("assets.base.entities.pipe-pictures")
local _sprites = require("__reskins-sprite-utils__.sprites")

local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local AssetsCommon = require("api.validation")

local M = {}

---@class PipeGraphicsParams
---Default iron.
---@field pipe_material PipeMaterial
---When true, includes the frozen sprites in the graphics pack. Default false.
---@field include_frozen_pictures boolean?

---
---Gets a `RotatedAnimationVariations` object containing pipe remnant sprites of the given
---`pipe_material`.
---@param pipe_material PipeMaterial
---@return RotatedAnimationVariations animation
local function get_corpse_animation(pipe_material)
	-- For remnants only, the iron sprites come from base.
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

---@param pipe_material PipeMaterial
---@param include_frozen_pictures boolean?
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
---@param include_frozen_pictures boolean?
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

---@class PipeSpriteSetParams
---The material the pipes are built from. Defaults to iron.
---@field pipe_material PipeMaterial
---Whether to carry the frozen artwork. Defaults to `false`.
---@field include_frozen_pictures boolean?

---Gets the sprite set for the vanilla and Bob's pipes.
---
---Window bounding boxes are the base game's.
---@param params PipeSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<PipeSpriteSet>
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

local check_get_icon = V.signature("get_icon", {
	{ "pipe_material", AssetsCommon.pipe_material },
})

---Gets the icon for a pipe built from the given `pipe_material`.
---@param pipe_material PipeMaterial # The material the pipe is built from.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(pipe_material)
	check_get_icon(pipe_material)

	if pipe_material == _defines.pipe_material.iron then
		return { { icon = "__base__/graphics/icons/pipe.png", icon_size = 64, scale = 0.5 } }
	end

	local name = _pipes.name_from_material(pipe_material)
	local folder = _pipes.asset_from_material(pipe_material) .. "/graphics/icons/pipe/"

	return { { icon = folder .. name .. "-pipe-icon.png", icon_size = 64, scale = 0.5 } }
end

return M
