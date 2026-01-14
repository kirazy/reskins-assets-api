local _defines = require("api.defines")
local _pipes = require("assets.base.entities.pipe-pictures")

local function throw_when_int_out_of_range(fn_name, param_name, value, min, max)
	local err_type = string.format("Invalid param in %s: '%s'", fn_name, param_name)

	if type(value) ~= "number" then
		error(string.format("%s must be a number, got %s", err_type, type(value)))
	elseif value % 1 ~= 0 then
		error(string.format("%s must be an integer, got %s", err_type, value))
	elseif value < min or value > max then
		error(string.format("%s must be between %d and %d inclusive, got %d", err_type, min, max, value))
	end
end

local CraftingMachineGraphicsPack = require("crafting-machine-graphics-pack")

---@class AssemblingMachineGraphicsPack:CraftingMachineGraphicsPack
local AssemblingMachineGraphicsPack = {}
AssemblingMachineGraphicsPack.__index = CraftingMachineGraphicsPack

-- Setup inheritance.
setmetatable(AssemblingMachineGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

---@class AssemblingMachineGraphicsParams
---@field tint data.Color?
---@field machine_tier 1|2|3|4|5|6
---@field electronics_tier (1|2|3)?
---@field use_simple_pipe_pictures boolean?

---@param params AssemblingMachineGraphicsParams
---@return AssemblingMachineGraphicsPack
---@nodiscard
function AssemblingMachineGraphicsPack:new(params)
	throw_when_int_out_of_range("new", "machine_tier", params.machine_tier, 1, 6)

	local use_electronics_set = false
	if params.electronics_tier ~= nil then
		throw_when_int_out_of_range("new", "electronics_tier", params.electronics_tier, 1, 3)
		use_electronics_set = true
	end

	local graphics_set = self.get_graphics_set(params.tint, params.machine_tier, use_electronics_set)

	-- Ensure fluid box pipe pictures draw over the mask and highlights.
	local draw_order = #graphics_set.animation
	local fluid_box = self.get_fluid_box_graphics(params.tint, draw_order, params.use_simple_pipe_pictures)

	local remnants = self.get_corpse_animation(params.tint)

	local instance = CraftingMachineGraphicsPack.new(self, {
		tint = params.tint,
		remnants = remnants,
		required_assets = { _defines.assets.base },
		graphics_set = graphics_set,
		fluid_boxes = { fluid_box },
	}) --[[@as AssemblingMachineGraphicsPack]]

	if params.electronics_tier then
		table.insert(instance.required_assets, _defines.assets.bobs_assets)
	end

	-- Set the correct metatable for this class.
	setmetatable(instance, AssemblingMachineGraphicsPack)
	return instance
end

---@param tint data.Color?
---@param assembly_set 1|2|3|4|5|6
---@param use_electronics_set boolean?
---@return data.CraftingMachineGraphicsSet
function AssemblingMachineGraphicsPack.get_graphics_set(tint, assembly_set, use_electronics_set)
	throw_when_int_out_of_range("get_graphics", "assembly_set", assembly_set, 1, 6)
	-- animations/shadows are 0-based.
	local animation_index = assembly_set - 1
	local shadow_index = math.min(4, animation_index)

	local assets_base_path = "__reskins-assets-base__/graphics/entity/assembling-machine/"

	---@type data.Animation
	local animation = {
		layers = {
			{
				filename = assets_base_path .. "assembling-machine-base.png",
				priority = "high",
				width = 214,
				height = 237,
				repeat_count = 32,
				shift = util.by_pixel(0, -0.75),
				scale = 0.5,
			},
		},
	}

	-- Increment the draw_order for use with fluid-boxes for every additional base-layer
	local draw_order = 1

	if tint then
		table.insert(animation.layers, {
			filename = assets_base_path .. "assembling-machine-base-mask.png",
			priority = "high",
			width = 214,
			height = 237,
			repeat_count = 32,
			shift = util.by_pixel(0, -0.75),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers, {
			filename = assets_base_path .. "assembling-machine-base-highlights.png",
			priority = "high",
			width = 214,
			height = 237,
			repeat_count = 32,
			shift = util.by_pixel(0, -0.75),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
		draw_order = draw_order + 2
	end

	table.insert(animation.layers, {
		filename = assets_base_path .. "animations/assembling-machine-animation-" .. animation_index .. ".png",
		priority = "high",
		width = 214,
		height = 237,
		frame_count = 32,
		line_length = 8,
		shift = util.by_pixel(0, -0.75),
		scale = 0.5,
	})

	table.insert(animation.layers, {
		filename = assets_base_path .. "shadows/assembling-machine-" .. shadow_index .. "-shadow.png",
		priority = "high",
		width = 264,
		height = 165,
		frame_count = 32,
		line_length = 8,
		draw_as_shadow = true,
		shift = util.by_pixel(27, 5),
		scale = 0.5,
	})

	if use_electronics_set then
		local assets_bobs_path = "__reskins-assets-bobs__/graphics/entity/assembling-machine-electronics/"
		table.insert(animation.layers, {
			filename = assets_bobs_path .. "assembling-machine-electronics-base.png",
			priority = "high",
			width = 214,
			height = 237,
			repeat_count = 32,
			shift = util.by_pixel(0, -0.75),
			scale = 0.5,
		})
		draw_order = draw_order + 1
		if tint then
			table.insert(animation.layers, {
				filename = assets_bobs_path .. "assembling-machine-electronics-mask.png",
				priority = "high",
				width = 214,
				height = 237,
				repeat_count = 32,
				shift = util.by_pixel(0, -0.75),
				tint = tint,
				scale = 0.5,
			})
			table.insert(animation.layers, {
				filename = assets_bobs_path .. "assembling-machine-electronics-highlights.png",
				priority = "high",
				width = 214,
				height = 237,
				repeat_count = 32,
				shift = util.by_pixel(0, -0.75),
				blend_mode = "additive-soft",
				scale = 0.5,
			})
			draw_order = draw_order + 2
		end
		table.insert(animation.layers, {
			filename = assets_bobs_path .. "assembling-machine-electronics-shadow.png",
			priority = "high",
			width = 264,
			height = 165,
			repeat_count = 32,
			draw_as_shadow = true,
			shift = util.by_pixel(27, 5),
			scale = 0.5,
		})
	end

	---@type data.CraftingMachineGraphicsSet
	local graphics_set = {
		animation = animation,
	}

	return graphics_set
end

---@param tint data.Color?
---@param draw_order int8?
---@param use_simple_pipe_pictures boolean?
---@return FluidBoxGraphics
function AssemblingMachineGraphicsPack.get_fluid_box_graphics(tint, draw_order, use_simple_pipe_pictures)
	---@type FluidBoxGraphics
	local fluid_box = {
		pipe_covers = _pipes.pipe_covers(),
		secondary_draw_orders = {
			north = -1,
			east = draw_order,
			south = draw_order,
			west = draw_order,
		},
	}

	if use_simple_pipe_pictures then
		fluid_box.pipe_picture = _pipes.simple_pipe_pictures(tint)
	else
		fluid_box.pipe_picture = _pipes.pipe_pictures(tint)
	end

	return fluid_box
end

---@param tint data.Color?
---@return data.RotatedAnimationVariations
function AssemblingMachineGraphicsPack.get_corpse_animation(tint)
	return reskins_suppress_errors and {} or error("get_corpse_animation is not implemented")
end

return AssemblingMachineGraphicsPack
