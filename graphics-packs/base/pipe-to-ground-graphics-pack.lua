local _defines = require("api.defines")
local _pipes = require("assets.base.entities.pipe-pictures")
local _sprites = require("__reskins-sprite-utils__.sprites")

local meld = require("__core__.lualib.meld")

local GraphicsPackBase = require("graphics-packs.abstractions.graphics-pack-base")

---@class Reskins.Base.PipeToGroundGraphicsPack:Reskins.Abstractions.GraphicsPackBase
---@field horizontal_window_bounding_box data.BoundingBox
---@field vertical_window_bounding_box data.BoundingBox
---@field pictures data.Sprite4Way
---@field frozen_patch data.Sprite4Way?
---@field fluid_box FluidBoxGraphics
local PipeToGroundGraphicsPack = {}
PipeToGroundGraphicsPack.__index = PipeToGroundGraphicsPack

-- Set up inheritance
setmetatable(PipeToGroundGraphicsPack, {
	__index = GraphicsPackBase,
})

---@class Reskins.Base.PipeToGroundGraphicsParams
---Default iron.
---@field pipe_material Reskins.Defines.PipeMaterial
---When true, includes the frozen sprites in the graphics pack. Default false.
---@field include_frozen_pictures boolean?

---@param params Reskins.Base.PipeToGroundGraphicsParams
---@return Reskins.Base.PipeToGroundGraphicsPack
---@nodiscard
function PipeToGroundGraphicsPack:configure(params)
	local pictures, required_picture_assets = self.get_pictures(params.pipe_material)
	local fluid_box, required_fluid_box_assets = self.get_fluid_box_graphics(params.pipe_material)
	local remnants, required_remnants_assets = self.get_corpse_animation(params.pipe_material)

	local instance = GraphicsPackBase.configure(self, {
		tint = nil,
		remnants = remnants,
		required_assets = util.merge({ required_picture_assets, required_fluid_box_assets, required_remnants_assets }),
	}) --[[@as Reskins.Base.PipeToGroundGraphicsPack]]

	-- Bounds from base.
	instance.horizontal_window_bounding_box = { { -0.25, -0.28125 }, { 0.25, 0.15625 } }
	instance.vertical_window_bounding_box = { { -0.28125, -0.5 }, { 0.03125, 0.125 } }

	instance.pictures = pictures
	instance.fluid_box = fluid_box

	if params.include_frozen_pictures then
		local frozen_patch, required_frozen_patch_assets = self.get_frozen_pictures()
		meld(instance.required_assets, required_frozen_patch_assets)
		instance.frozen_patch = frozen_patch
	end

	-- Set the correct metatable for this class.
	setmetatable(instance, PipeToGroundGraphicsPack)
	return instance
end

---Applies a copy of the graphics pack to the specified `prototype`.
---
---#### Exceptions
---*@throws* - `string` - When `prototype` is `nil`.</br>
---*@throws* - `string` - When `prototype` is not a `table`.</br>
---*@throws* - `string` - When `prototype` is not a [PipeToGroundPrototype](lua://data.PipeToGroundPrototype).
---@param prototype data.PipeToGroundPrototype
function PipeToGroundGraphicsPack:apply_to_entity(prototype)
	assert(prototype, "'prototype' must not be nil")
	assert(type(prototype) == "table", "'prototype' must be a table, but was '" .. type(prototype) .. '".')
	assert(
		prototype.type == "pipe-to-ground",
		"'prototype' must be a pipe-to-ground prototype, but was '" .. prototype.type .. "'."
	)

	prototype.pictures = util.copy(self.pictures)
	prototype.frozen_patch = self.frozen_patch

	if prototype.fluid_box then
		meld(prototype.fluid_box, self.fluid_box or {})
	end
end

function PipeToGroundGraphicsPack:apply_to_explosion(explosion)
	self.__index:apply_to_explosion(explosion)
end

---
---Gets a `RotatedAnimationVariations` object containing pipe remnant sprites of the given
---`pipe_material`.
---
---@param pipe_material Reskins.Defines.PipeMaterial
---@return data.RotatedAnimationVariations animation
---@return RequiredAssets
---@nodiscard
function PipeToGroundGraphicsPack.get_corpse_animation(pipe_material)
	-- For remnants only, the iron sprites come from base.
	local is_iron = pipe_material == _defines.pipe_material.iron
	local material_asset = is_iron and _defines.assets.base or _pipes.asset_from_material(pipe_material)

	local material_name = _pipes.name_from_material(pipe_material)
	local assets_base_path = material_asset
		.. "/graphics/entity/pipe-to-ground/"
		.. (is_iron and "" or material_name .. "/")

	---@type data.RotatedAnimationVariations
	local animation = {
		filename = assets_base_path .. "remnants/pipe-to-ground-remnants.png",
		width = 90,
		height = 80,
		shift = util.by_pixel(0.5, -3),
		scale = 0.5,
	}

	return animation, { [material_asset] = true }
end

---@return data.Sprite4Way
---@return RequiredAssets
---@nodiscard
function PipeToGroundGraphicsPack.get_frozen_pictures()
	local assets_base_path = "__space-age__/graphics/entity/frozen/pipe-to-ground/"

	---@type data.Sprite4Way
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

	return frozen_pipe_pictures, { [_defines.assets.space_age] = true }
end

---@param pipe_material Reskins.Defines.PipeMaterial
---@return data.Sprite4Way
---@return RequiredAssets
---@nodiscard
function PipeToGroundGraphicsPack.get_pictures(pipe_material)
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
		[material_asset] = true,
	}
	return pipe_to_ground_pictures, required_assets
end

---@param pipe_material Reskins.Defines.PipeMaterial
---@param include_frozen_pictures boolean?
---@return FluidBoxGraphics
---@return RequiredAssets
---@nodiscard
function PipeToGroundGraphicsPack.get_fluid_box_graphics(pipe_material, include_frozen_pictures)
	local pipe_covers, required_assets = _pipes.pipe_covers(pipe_material)

	---@type FluidBoxGraphics
	local fluid_box_graphics = {
		pipe_covers = pipe_covers,
	}

	if include_frozen_pictures then
		fluid_box_graphics.pipe_covers_frozen = _pipes.pipe_covers_frozen()
		required_assets[_defines.assets.space_age] = true
	end

	return fluid_box_graphics, required_assets
end

return PipeToGroundGraphicsPack
