---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local _pipes = require("assets.base.entities.pipe-pictures")

local IconBuilderFactory = require("api.icon-builder-factory")
local Pipe = require("assets.base.entities.pipe")
local PipeToGroundExplosion = require("assets.base.explosions.pipe-to-ground")
local Remnants = require("assets.base.remnants")

local M = {}

---Gets a `RotatedAnimationVariations` object containing pipe remnant sprites of the given `pipe_material`.
---@param pipe_material PipeMaterial
---@return RotatedAnimationVariations animation
local function get_corpse_animation(pipe_material)
	-- For remnants only, the iron artwork comes from base.
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

---Gets the circuit connector of the underground pipe for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 2,
			main_offset = util.by_pixel(0, -17.375),
			shadow_offset = util.by_pixel(0, -17.375),
			show_shadow = false,
		},
		{
			variation = 8,
			main_offset = util.by_pixel(7, -6),
			shadow_offset = util.by_pixel(7, -6),
			show_shadow = false,
		},
		{
			variation = 6,
			main_offset = util.by_pixel(0, 3.75),
			shadow_offset = util.by_pixel(0, 3.75),
			show_shadow = false,
		},
		{
			variation = 12,
			main_offset = util.by_pixel(-7, -6),
			shadow_offset = util.by_pixel(-7, -6),
			show_shadow = false,
		},
	})
end

---Defines the options for the underground pipes sprite set.
---@class PipeToGroundSpriteSetParams
---The material from which the pipes are built.
---@field pipe_material PipeMaterial

---Gets the sprite set for the underground pipes.
---
---Window bounding boxes are the base game's.
---@param params PipeToGroundSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<PipeToGroundSpriteSet> # The sprite set definition for the underground pipes.
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
	local particle_tint = Pipe.get_material_tint({ material = params.pipe_material })

	---@type SpriteSetDefinition<PipeToGroundSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.pipe_to_ground_sprite_set,
		set = {
			pictures = get_pictures(params.pipe_material),
			pipe_material = params.pipe_material,
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = PipeToGroundExplosion.get_explosion({
				tints = particle_tint and {
					["pipe-to-ground-metal-particle-medium"] = particle_tint,
					["pipe-to-ground-metal-particle-small"] = particle_tint,
				},
			}),
			corpse = Remnants.get_corpse(
				"pipe-to-ground-remnants",
				{ animation = get_corpse_animation(params.pipe_material) }
			),
			water_reflection = nil,
			circuit_connector = get_circuit_connector(),
			nominal_width = 1,
			nominal_height = 1,
		},
	}

	if feature_flags["freezing"] and mods["space-age"] then
		definition.set.frozen_patch = get_frozen_pictures()
	end

	return definition
end

---Gets the builder of the icon of the pipe to ground built from the given `pipe_material`.
---@param pipe_material PipeMaterial
---@return FlatIconBuilder<{}>
local function get_icon_builder(pipe_material)
	-- The iron pipe-to-ground icon comes from the base game.
	if pipe_material == _defines.pipe_material.iron then
		return IconBuilderFactory:create({ folder = "__base__/graphics/icons" }):flat("pipe-to-ground")
	end

	local folder = _pipes.asset_from_material(pipe_material) .. "/graphics/icons/pipe-to-ground"
	local name = _pipes.name_from_material(pipe_material)

	return IconBuilderFactory:create({ folder = folder }):flat(name .. "-pipe-to-ground")
end

---Gets the icon for a pipe to ground built from the `material` given by `params`.
M.get_icon = IconBuilderFactory.dispatch("material", _defines.pipe_material, "get_icon", get_icon_builder)

---Gets the icon for a pipe to ground built from the `material` given by `params`, as an `IconComposition`.
M.get_icon_composition =
	IconBuilderFactory.dispatch_composition("material", _defines.pipe_material, "get_icon_composition", get_icon_builder)

return M
