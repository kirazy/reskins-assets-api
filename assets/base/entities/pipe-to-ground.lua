---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local _pipes = require("assets.base.entities.pipe-pictures")

local M = {}

---
---Gets a `RotatedAnimationVariations` object containing pipe remnant sprites of the given
---`pipe_material`.
---
---@param pipe_material PipeMaterial
---@return RotatedAnimationVariations animation
---@return RequiredAssets
local function get_corpse_animation(pipe_material)
	-- For remnants only, the iron sprites come from base.
	local is_iron = pipe_material == _defines.pipe_material.iron
	local material_asset = is_iron and _defines.assets_source.base or _pipes.asset_from_material(pipe_material)

	local material_name = _pipes.name_from_material(pipe_material)
	local assets_base_path = material_asset
		.. "/graphics/entity/pipe-to-ground/"
		.. (is_iron and "" or material_name .. "/")

	---@type RotatedAnimationVariations
	local animation = {
		filename = assets_base_path .. "remnants/pipe-to-ground-remnants.png",
		width = 90,
		height = 80,
		shift = util.by_pixel(0.5, -3),
		scale = 0.5,
	}

	return animation, { [material_asset] = true }
end

---@return Sprite4Way
---@return RequiredAssets
local function get_frozen_pictures()
	local assets_base_path = "__space-age__/graphics/entity/frozen/pipe-to-ground/"

	---@type Sprite4Way
	local frozen_pipe_pictures = {
		north = {
			filename = assets_base_path .. "pipe-to-ground-up.png",
			priority = "extra-high",
			width = 128,
			height = 128,
			scale = 0.5,
		},
		east = {
			filename = assets_base_path .. "pipe-to-ground-right.png",
			priority = "extra-high",
			width = 128,
			height = 128,
			scale = 0.5,
		},
		south = {
			filename = assets_base_path .. "pipe-to-ground-down.png",
			priority = "extra-high",
			width = 128,
			height = 128,
			scale = 0.5,
		},
		west = {
			filename = assets_base_path .. "pipe-to-ground-left.png",
			priority = "extra-high",
			width = 128,
			height = 128,
			scale = 0.5,
		},
	}

	return frozen_pipe_pictures, { [_defines.assets_source.space_age] = true }
end

---@param pipe_material PipeMaterial
---@return Sprite4Way
---@return RequiredAssets
local function get_pictures(pipe_material)
	local material_asset = _pipes.asset_from_material(pipe_material)
	local material_name = _pipes.name_from_material(pipe_material)
	local assets_base_path = material_asset .. "/graphics/entity/pipe-to-ground/" .. material_name .. "/"
	local shadow_assets_base_path = "__reskins-assets-base__/graphics/entity/pipe-to-ground/shadows/"

	---@type Sprite4Way
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
		[_defines.assets_source.base_assets] = true,
		[material_asset] = true,
	}
	return pipe_to_ground_pictures, required_assets
end

---@param pipe_material PipeMaterial
---@param include_frozen_pictures boolean?
---@return FluidBoxGraphics
---@return RequiredAssets
local function get_fluid_box_graphics(pipe_material, include_frozen_pictures)
	local pipe_covers, required_assets = _pipes.pipe_covers(pipe_material)

	---@type FluidBoxGraphics
	local fluid_box_graphics = {
		pipe_covers = pipe_covers,
	}

	if include_frozen_pictures then
		fluid_box_graphics.pipe_covers_frozen = _pipes.pipe_covers_frozen()
		required_assets[_defines.assets_source.space_age] = true
	end

	return fluid_box_graphics, required_assets
end

---The sprite data a `pipe_to_ground_sprite_set`-tagged `SpriteSetDefinition` carries.
---
---Provisional: no applicator consumes this shape yet. When one is written, this
---declaration moves to it, the way `BoilerSpriteSet` lives in `api/applicators/boiler.lua`.
---@class (exact) PipeToGroundSpriteSet : EntityWithHealthSpriteSet
---The prototype's `horizontal_window_bounding_box`.
---@field horizontal_window_bounding_box BoundingBox
---The prototype's `vertical_window_bounding_box`.
---@field vertical_window_bounding_box BoundingBox
---The prototype's `pictures`.
---@field pictures Sprite4Way
---The prototype's `frozen_patch`.
---@field frozen_patch Sprite4Way?
---Pipe graphics for the prototype's `fluid_box`.
---@field fluid_box FluidBoxGraphics

---@class PipeToGroundSpriteSetParams
---@field pipe_material PipeMaterial # Default iron.
---@field include_frozen_pictures boolean? # When true, includes the frozen sprites. Default false.

---Produces the sprite set for the vanilla and Bob's underground pipes.
---
---Window bounding boxes are the base game's, unchanged.
---@param params PipeToGroundSpriteSetParams
---@return SpriteSetDefinition<PipeToGroundSpriteSet>
---@nodiscard
function M.get(params)
	local frozen_patch = params.include_frozen_pictures and get_frozen_pictures() or nil

	---@type SpriteSetDefinition<PipeToGroundSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.pipe_to_ground_sprite_set,
		set = {
			horizontal_window_bounding_box = { { -0.25, -0.28125 }, { 0.25, 0.15625 } },
			vertical_window_bounding_box = { { -0.28125, -0.5 }, { 0.03125, 0.125 } },
			pictures = get_pictures(params.pipe_material),
			frozen_patch = frozen_patch,
			fluid_box = get_fluid_box_graphics(params.pipe_material),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = get_corpse_animation(params.pipe_material),
			water_reflection = nil,
			nominal_width = 1,
			nominal_height = 1,
		},
	}

	return definition
end

return M
