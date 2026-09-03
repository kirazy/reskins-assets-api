---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local _pipes = require("assets.base.entities.pipe-pictures")

local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local AssetsCommon = require("api.validation")

local M = {}

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

	return animation
end

---@return Sprite4Way
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

	return frozen_pipe_pictures
end

---@param pipe_material PipeMaterial
---@return Sprite4Way
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
	return pipe_to_ground_pictures
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

---@class PipeToGroundSpriteSetParams
---The material the pipes are built from. Defaults to iron.
---@field pipe_material PipeMaterial
---Whether to carry the frozen artwork. Defaults to `false`.
---@field include_frozen_pictures boolean?

---Gets the sprite set for the vanilla and Bob's underground pipes.
---
---Window bounding boxes are the base game's.
---@param params PipeToGroundSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<PipeToGroundSpriteSet>
---
---#### Examples
---```lua
---local pipe_to_ground = require("__reskins-assets-api__.assets.base.entities.pipe-to-ground")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = pipe_to_ground.get_sprite_set({ pipe_material = pipe_material })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set(params)
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

---Gets the icon for a pipe to ground built from the given `pipe_material`.
---@param pipe_material PipeMaterial # The material the pipe is built from.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(pipe_material)
	check_get_icon(pipe_material)

	if pipe_material == _defines.pipe_material.iron then
		return { { icon = "__base__/graphics/icons/pipe-to-ground.png", icon_size = 64, scale = 0.5 } }
	end

	local name = _pipes.name_from_material(pipe_material)
	local folder = _pipes.asset_from_material(pipe_material) .. "/graphics/icons/pipe-to-ground/"

	return { { icon = folder .. name .. "-pipe-to-ground.png", icon_size = 64, scale = 0.5 } }
end

return M
