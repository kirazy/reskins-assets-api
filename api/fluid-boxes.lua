---@using data

---@namespace Reskins.Assets

local V = require("__reskins-sprite-utils__.validation")
local AssetsCommon = require("api.validation")
local ConnectionMatching = require("api.connection-matching")
local _defines = require("api.defines")
local _pipes = require("assets.base.entities.pipe-pictures")

---Provides methods for applying `FluidBoxGraphics` to the fluid boxes of a prototype.
---
---#### Examples
---```lua
---local FluidBoxes = require("__reskins-assets-api__.api.fluid-boxes")
---```
---@class FluidBoxes
local _fluid_boxes = {}

-- The fields of a prototype that are a single `FluidBox`.
local fluid_box_fields = {
	"fluid_box",
	"input_fluid_box",
	"output_fluid_box",
	"fuel_fluid_box",
	"oxidizer_fluid_box",
}

-- The fields of a prototype that are copied before graphics are applied to their fluid boxes.
local copied_fields = {
	"fluid_box",
	"input_fluid_box",
	"output_fluid_box",
	"fuel_fluid_box",
	"oxidizer_fluid_box",
	"fluid_boxes",
	"energy_source",
}

-- The fields of a fluid box that draw artwork specific to the entity. They are removed from a fluid box that matches no
-- `FluidBoxGraphics`.
local pipe_picture_fields = {
	"pipe_picture",
	"pipe_picture_frozen",
	"mirrored_pipe_picture",
	"mirrored_pipe_picture_frozen",
}

---Gets the fluid boxes of the given `prototype`, including the fluid box of a fluid energy source.
---@param prototype EntityWithHealthPrototype
---@return FluidBox[]
local function collect_fluid_boxes(prototype)
	local fields = prototype --[[@as table<string, any>]]

	---@type FluidBox[]
	local fluid_boxes = {}

	for _, field in pairs(fluid_box_fields) do
		if fields[field] then
			fluid_boxes[#fluid_boxes + 1] = fields[field]
		end
	end

	for _, fluid_box in pairs(fields.fluid_boxes or {}) do
		fluid_boxes[#fluid_boxes + 1] = fluid_box
	end

	local energy_source = fields.energy_source
	if energy_source and energy_source.type == "fluid" and energy_source.fluid_box then
		fluid_boxes[#fluid_boxes + 1] = energy_source.fluid_box
	end

	return fluid_boxes
end

---Gets the frozen pipe covers when the freezing feature is enabled and Space Age is active.
---@return Sprite4Way?
local function get_default_pipe_covers_frozen()
	if feature_flags["freezing"] and mods["space-age"] then
		return _pipes.pipe_covers_frozen()
	end

	return nil
end

---Sets the `pipe_covers` and `pipe_covers_frozen` of the given `fluid_box`, in place.
---
---The given `pipe_covers` are used when defined. Otherwise, the pipe covers of the given `pipe_material` are used.
---@param fluid_box FluidBox
---@param pipe_material PipeMaterial
---@param pipe_covers? Sprite4Way
---@param pipe_covers_frozen? Sprite4Way
local function apply_pipe_covers(fluid_box, pipe_material, pipe_covers, pipe_covers_frozen)
	fluid_box.pipe_covers = pipe_covers or _pipes.pipe_covers(pipe_material)
	fluid_box.pipe_covers_frozen = pipe_covers_frozen or get_default_pipe_covers_frozen()
end

---Sets the graphics fields of the given `fluid_box` from the given `graphics`, in place.
---@param fluid_box FluidBox
---@param graphics FluidBoxGraphics
---@param pipe_material PipeMaterial
local function apply_graphics(fluid_box, graphics, pipe_material)
	apply_pipe_covers(fluid_box, pipe_material, graphics.pipe_covers, graphics.pipe_covers_frozen)

	fluid_box.render_layer = graphics.render_layer
	fluid_box.draw_only_when_connected = graphics.draw_only_when_connected
	fluid_box.always_draw_covers = graphics.always_draw_covers
	fluid_box.pipe_picture = graphics.pipe_picture
	fluid_box.pipe_picture_frozen = graphics.pipe_picture_frozen
	fluid_box.mirrored_pipe_picture = graphics.mirrored_pipe_picture
	fluid_box.mirrored_pipe_picture_frozen = graphics.mirrored_pipe_picture_frozen
	fluid_box.secondary_draw_order = graphics.secondary_draw_order
	fluid_box.secondary_draw_orders = graphics.secondary_draw_orders
	fluid_box.enable_working_visualisations = graphics.enable_working_visualisations

	for _, pipe_connection in pairs(fluid_box.pipe_connections or {}) do
		if pipe_connection.direction ~= nil then
			local pipe_connection_graphics =
				ConnectionMatching.find_connection_graphics(graphics.pipe_connections or {}, pipe_connection)
			pipe_connection.enable_working_visualisations = pipe_connection_graphics
				and pipe_connection_graphics.enable_working_visualisations
		end
	end
end

---Replaces the pipe covers of the given `fluid_box` and removes its pipe pictures, in place.
---@param fluid_box FluidBox
---@param pipe_material PipeMaterial
local function apply_defaults(fluid_box, pipe_material)
	apply_pipe_covers(fluid_box, pipe_material)

	local fields = fluid_box --[[@as table<string, any>]]
	for _, field in pairs(pipe_picture_fields) do
		fields[field] = nil
	end
end

---Defines the options of `FluidBoxes.apply`.
---@class (exact) ApplyFluidBoxGraphicsParams
---The material of the pipe covers of a fluid box when its `FluidBoxGraphics` does not define `pipe_covers`. Default
---`"iron"`.
---@field pipe_material? PipeMaterial

local check_apply = V.signature("apply", {
	{ "prototype", AssetsCommon.prototype },
	{ "fluid_box_graphics", V.array(AssetsCommon.fluid_box_graphics) },
	{
		"params",
		V.class("ApplyFluidBoxGraphicsParams", { pipe_material = AssetsCommon.pipe_material:optional() })
			:strict()
			:describe_as("an ApplyFluidBoxGraphicsParams")
			:optional(),
	},
})

---Applies the given `fluid_box_graphics` to the fluid boxes of the given `prototype`, in place.
---
---Each fluid box, including the fluid box of a fluid energy source, is matched to an entry of `fluid_box_graphics` by
---the directions and positions of its pipe connections, and takes its graphics fields. A fluid box that matches no
---entry has its pipe pictures removed. Every fluid box takes the pipe covers of the matching entry, or the pipe covers
---of `params.pipe_material` when the entry defines none or no entry matches. Every fluid box takes the frozen pipe
---covers when the freezing feature is enabled and the matching entry defines none.
---
---The fluid boxes and the energy source of `prototype` are replaced with copies before they are modified.
---
---#### Parameters
---@param prototype EntityWithHealthPrototype The prototype to which the graphics are applied.
---@param fluid_box_graphics FluidBoxGraphics[] The graphics to apply. An empty array applies only the pipe covers.
---@param params? ApplyFluidBoxGraphicsParams The options for the pipe covers.
---
---#### Examples
---```lua
----- Apply bronze pipe covers to every fluid box of a storage tank.
---local FluidBoxes = require("__reskins-assets-api__.api.fluid-boxes")
---
---FluidBoxes.apply(data.raw["storage-tank"]["storage-tank"], {}, { pipe_material = "bronze" })
----- The `pipe_covers` of the fluid box of the storage tank are the bronze pipe covers.
---```
---@throws When `prototype` is not a prototype.
---@throws When `fluid_box_graphics` is not an array of `FluidBoxGraphics`.
---@throws When `params` is not an `ApplyFluidBoxGraphicsParams`.
function _fluid_boxes.apply(prototype, fluid_box_graphics, params)
	check_apply(prototype, fluid_box_graphics, params)

	local pipe_material = params and params.pipe_material or _defines.pipe_material.iron

	local fields = prototype --[[@as table<string, any>]]
	for _, field in pairs(copied_fields) do
		if fields[field] then
			fields[field] = util.copy(fields[field])
		end
	end

	for _, fluid_box in pairs(collect_fluid_boxes(prototype)) do
		local graphics =
			ConnectionMatching.find_graphics(fluid_box_graphics, "pipe_connections", fluid_box.pipe_connections or {})

		if graphics then
			apply_graphics(fluid_box, graphics, pipe_material)
		else
			apply_defaults(fluid_box, pipe_material)
		end
	end
end

local check_get_pipe_connection_directions = V.signature("get_pipe_connection_directions", {
	{ "prototype", AssetsCommon.prototype },
})

---Gets the direction of each pipe connection of the fluid boxes of the given `prototype`, including the fluid box of a
---fluid energy source.
---
---A direction appears once for each pipe connection in that direction.
---@param prototype EntityWithHealthPrototype The prototype from which the directions are read.
---@return defines.direction[] # The directions, with the prototype facing north.
---@throws When `prototype` is not a prototype.
---@nodiscard
function _fluid_boxes.get_pipe_connection_directions(prototype)
	check_get_pipe_connection_directions(prototype)

	---@type defines.direction[]
	local directions = {}

	for _, fluid_box in pairs(collect_fluid_boxes(prototype)) do
		for _, pipe_connection in pairs(fluid_box.pipe_connections or {}) do
			if pipe_connection.direction ~= nil then
				directions[#directions + 1] = pipe_connection.direction
			end
		end
	end

	return directions
end

return _fluid_boxes
