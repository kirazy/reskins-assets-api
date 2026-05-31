local _defines = require("api.defines")
local _pipes = require("assets.base.entities.pipe-pictures")
local _sprites = require("__reskins-sprite-utils__.sprites")

local meld = require("__core__.lualib.meld")

local GraphicsPackBase = require("graphics-pack-base")

---@class Reskins.Base.PipeGraphicsPack:Reskins.Abstractions.GraphicsPackBase
---@field horizontal_window_bounding_box data.BoundingBox
---@field vertical_window_bounding_box data.BoundingBox
---@field pictures data.PipePictures
---@field fluid_box FluidBoxGraphics
local PipeGraphicsPack = {}
PipeGraphicsPack.__index = GraphicsPackBase

-- Set up inheritance
setmetatable(PipeGraphicsPack, {
	__index = GraphicsPackBase,
})

---@class Reskins.Base.PipeGraphicsPackParams
---Default iron.
---@field pipe_material Reskins.Defines.PipeMaterial
---When true, includes the frozen sprites in the graphics pack. Default false.
---@field include_frozen_pictures boolean?

---@param params Reskins.Base.PipeGraphicsPackParams
---@return Reskins.Base.PipeGraphicsPack
---@nodiscard
function PipeGraphicsPack:configure(params)
	local pictures, required_picture_assets = self.get_pictures(params.pipe_material, params.include_frozen_pictures)
	local fluid_box, required_fluid_box_assets = self.get_fluid_box_graphics(params.pipe_material)
	local remnants, required_remnants_assets = self.get_corpse_animation(params.pipe_material)

	local instance = GraphicsPackBase.configure(self, {
		tint = nil,
		remnants = remnants,
		required_assets = util.merge({ required_picture_assets, required_fluid_box_assets, required_remnants_assets }),
	}) --[[@as Reskins.Base.PipeGraphicsPack]]

	-- Bounds from base.
	instance.horizontal_window_bounding_box = { { -0.25, -0.28125 }, { 0.25, 0.15625 } }
	instance.vertical_window_bounding_box = { { -0.28125, -0.5 }, { 0.03125, 0.125 } }

	instance.pictures = pictures
	instance.fluid_box = fluid_box

	-- Set the correct metatable for this class.
	setmetatable(instance, PipeGraphicsPack)
	return instance
end

---Applies a copy of the graphics pack to the specified `prototype`.
---
---#### Exceptions
---*@throws* - `string` - When `prototype` is `nil`.</br>
---*@throws* - `string` - When `prototype` is not a `table`.</br>
---*@throws* - `string` - When `prototype` is not a [PipePrototype](lua://data.PipePrototype).
---@param prototype data.PipePrototype
function PipeGraphicsPack:apply_to_entity(prototype)
	assert(prototype, "'prototype' must not be nil")
	assert(type(prototype) == "table", "'prototype' must be a table")
	assert(prototype.type == "pipe", "'prototype' must be a pipe prototype.")

	prototype.pictures = util.copy(self.pictures)

	if prototype.fluid_box then
		meld(prototype.fluid_box, self.fluid_box or {})
	end
end

function PipeGraphicsPack:apply_to_explosion(explosion)
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
function PipeGraphicsPack.get_corpse_animation(pipe_material)
	-- For remnants only, the iron sprites come from base.
	local is_iron = pipe_material == _defines.pipe_material.iron
	local material_asset = is_iron and _defines.assets.base or _pipes.asset_from_material(pipe_material)

	local material_name = _pipes.name_from_material(pipe_material)
	local assets_base_path = material_asset .. "/graphics/entity/pipe/" .. material_name .. "/"

	local animation = _sprites.make_rotated_animation_variations_from_spritesheet(2, {
		filename = assets_base_path .. "remnants/pipe-remnants.png",
		width = 122,
		height = 120,
		direction_count = 2,
		shift = util.by_pixel(1.5, 2.5),
		scale = 0.5,
	})

	return animation, { [material_asset] = true }
end

---@return data.PipePictures
---@nodiscard
local function get_frozen_pictures()
	local assets_base_path = "__space-age__/graphics/entity/frozen/pipe/"

	---@type data.PipePictures
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

---@param pipe_material Reskins.Defines.PipeMaterial
---@param include_frozen_pictures boolean?
---@return data.PipePictures
---@return RequiredAssets
---@nodiscard
function PipeGraphicsPack.get_pictures(pipe_material, include_frozen_pictures)
	local material_asset = _pipes.asset_from_material(pipe_material)
	local material_name = _pipes.name_from_material(pipe_material)
	local assets_base_path = material_asset .. "/graphics/entity/pipe/" .. material_name .. "/"
	local shadow_assets_base_path = "__reskins-assets-base__/graphics/entity/pipe/shadows/"

	---@type data.PipePictures
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

	---@type RequiredAssets
	local required_assets = {
		[_defines.assets.base] = true,
		[_defines.assets.base_assets] = true,
	}

	required_assets[material_asset] = true

	if include_frozen_pictures then
		pipe_pictures = util.merge({ pipe_pictures, get_frozen_pictures() })
		required_assets[_defines.assets.space_age] = true
	end

	return pipe_pictures, required_assets
end

---@param pipe_material Reskins.Defines.PipeMaterial
---@param include_frozen_pictures boolean?
---@return FluidBoxGraphics
---@return RequiredAssets
---@nodiscard
function PipeGraphicsPack.get_fluid_box_graphics(pipe_material, include_frozen_pictures)
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

return PipeGraphicsPack
