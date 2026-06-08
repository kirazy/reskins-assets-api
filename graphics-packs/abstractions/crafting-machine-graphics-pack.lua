local _pipes = require("assets.base.entities.pipe-pictures")

local GraphicsPackBase = require("graphics-packs.abstractions.graphics-pack-base")

---@class Reskins.Abstractions.CraftingMachineGraphicsPack:Reskins.Abstractions.GraphicsPackBase
---@field graphics_set data.CraftingMachineGraphicsSet
---@field graphics_set_flipped data.CraftingMachineGraphicsSet?
---@field fluid_boxes FluidBoxGraphics[]?
---@field fluid_boxes_off_when_no_fluid_recipe boolean?
local CraftingMachineGraphicsPack = {}
CraftingMachineGraphicsPack.__index = CraftingMachineGraphicsPack

-- Set up inheritance
setmetatable(CraftingMachineGraphicsPack, {
	__index = GraphicsPackBase,
})

---@class Reskins.Abstractions.CraftingMachineGraphicsParams:Reskins.Abstractions.GraphicsParams
---@field graphics_set data.CraftingMachineGraphicsSet
---@field graphics_set_flipped data.CraftingMachineGraphicsSet?
---@field fluid_boxes FluidBoxGraphics[]?
---@field fluid_boxes_off_when_no_fluid_recipe boolean?

---Creates a new `CraftingMachineGraphicsPack` instance.
---
---The parameters are not copied for performance reasons; if they are not properly isolated changes made elsewhere will
---apply to the graphics pack. The recommended pattern is to create the parameters alongside the graphics pack instance.
---@param params Reskins.Abstractions.CraftingMachineGraphicsParams
---@return Reskins.Abstractions.CraftingMachineGraphicsPack
---@nodiscard
function CraftingMachineGraphicsPack:configure(params)
	local instance = GraphicsPackBase.configure(self, {
		tint = params.tint,
		scale = params.scale,
		scale_factor = params.scale_factor,
		remnants = params.remnants,
		required_assets = params.required_assets,
		nominal_width = params.nominal_width,
		nominal_height = params.nominal_height,
	}) --[[@as Reskins.Abstractions.CraftingMachineGraphicsPack]]

	-- Add specialized fields
	instance.graphics_set = params.graphics_set
	instance.graphics_set_flipped = params.graphics_set_flipped or params.graphics_set
	instance.fluid_boxes = params.fluid_boxes
	instance.fluid_boxes_off_when_no_fluid_recipe = params.fluid_boxes_off_when_no_fluid_recipe

	-- Set the correct metatable for this class
	setmetatable(instance, CraftingMachineGraphicsPack)
	return instance
end

---@alias FluidBoxDirections {[defines.direction]: boolean}

---Collects the set of directions declared by a fluid box's pipe connections.
---@param fluid_box data.FluidBox
---@return FluidBoxDirections
local function collect_directions_from_fluid_box(fluid_box)
	---@type FluidBoxDirections
	local directions = {
		[defines.direction.north] = false,
		[defines.direction.east] = false,
		[defines.direction.south] = false,
		[defines.direction.west] = false,
	}

	if fluid_box and fluid_box.pipe_connections then
		for _, pipe_connection in pairs(fluid_box.pipe_connections) do
			directions[pipe_connection.direction] = true
		end
	end

	return directions
end

---Finds the first `FluidBoxGraphics` in `fb_graphics_list` that matches the given set of
---prototype fluid box directions.
---
---A match is found when any direction in a `FluidBoxGraphics.pipe_connections` entry is
---present in `proto_directions`. If no direction-specific match is found, the first entry
---with no `pipe_connections` is returned as a universal fallback.
---@param proto_directions FluidBoxDirections
---@param fb_graphics_list FluidBoxGraphics[]
---@return FluidBoxGraphics?
local function find_matching_fluid_box_graphics(proto_directions, fb_graphics_list)
	---@type FluidBoxGraphics?
	local fallback = nil

	for _, fb_graphics in pairs(fb_graphics_list) do
		if fb_graphics.pipe_connections then
			for _, pipe_connection_graphics in pairs(fb_graphics.pipe_connections) do
				if proto_directions[pipe_connection_graphics.direction] then
					return util.copy(fb_graphics)
				end
			end
		elseif not fallback then
			fallback = fb_graphics
		end
	end

	return util.copy(fallback)
end

---Applies the graphics pack to the specified crafting machine `prototype`.
---
---The prototype is mutated in place.
---@param prototype data.CraftingMachinePrototype
function CraftingMachineGraphicsPack:apply_to_entity(prototype)
	-- Apply graphics set, clear any conflicting properties.
	local graphics_set = util.copy(self.graphics_set)
	local graphics_set_flipped = self.graphics_set_flipped and util.copy(self.graphics_set_flipped) or nil

	-- Scale the graphics to the prototype's footprint, if it differs from the nominal dimensions.
	local scaler = self:create_scaler(prototype)
	scaler:rescale(graphics_set)
	scaler:rescale(graphics_set_flipped)

	prototype.graphics_set = graphics_set
	prototype.graphics_set_flipped = graphics_set_flipped
	prototype.water_reflection = nil

	-- Apply fluid box configurations if present.
	if self.fluid_boxes then
		self:apply_fluid_box_graphics(prototype)
	end

	-- Apply fluid_boxes_off_when_no_fluid_recipe if explicitly set.
	if self.fluid_boxes_off_when_no_fluid_recipe ~= nil and prototype.type == "assembling-machine" then
		---@cast prototype data.AssemblingMachinePrototype
		prototype.fluid_boxes_off_when_no_fluid_recipe = self.fluid_boxes_off_when_no_fluid_recipe
	end
end

---Applies fluid box graphics to the specified `prototype`.
---
---Each prototype fluid box is matched to a `FluidBoxGraphics` entry by direction. A
---`FluidBoxGraphics` with no `pipe_connections` acts as a universal fallback and is applied
---to any fluid box that has no more-specific match.
---
---The prototype is mutated in place.
---@param prototype data.CraftingMachinePrototype
---@private
function CraftingMachineGraphicsPack:apply_fluid_box_graphics(prototype)
	local fluid_boxes = {}
	if prototype.energy_source and prototype.energy_source.fluid_box then
		table.insert(fluid_boxes, prototype.energy_source.fluid_box)
	end

	if prototype.fluid_boxes then
		for _, fluid_box in pairs(prototype.fluid_boxes) do
			if fluid_box then
				table.insert(fluid_boxes, fluid_box)
			end
		end
	end

	for _, fluid_box in pairs(fluid_boxes) do
		local proto_directions = collect_directions_from_fluid_box(fluid_box)
		local match = find_matching_fluid_box_graphics(proto_directions, self.fluid_boxes)

		if not match then
			-- No graphics defined for this fluid box; leave it unmodified.
			goto continue
		end

		fluid_box.pipe_covers = match.pipe_covers or _pipes.pipe_covers("iron")
		fluid_box.pipe_covers_frozen = match.pipe_covers_frozen
			or (mods["space-age"] and _pipes.pipe_covers_frozen() or nil)
		fluid_box.pipe_picture = match.pipe_picture
		fluid_box.pipe_picture_frozen = match.pipe_picture_frozen
		fluid_box.mirrored_pipe_picture = match.mirrored_pipe_picture
		fluid_box.mirrored_pipe_picture_frozen = match.mirrored_pipe_picture_frozen
		fluid_box.secondary_draw_orders = match.secondary_draw_orders
		fluid_box.render_layer = match.render_layer

		-- Collect working visualisation names from all matched pipe connection graphics.
		local working_vis = {}
		if match.pipe_connections then
			for _, pipe_connection_graphics in pairs(match.pipe_connections) do
				if proto_directions[pipe_connection_graphics.direction] then
					for _, name in pairs(pipe_connection_graphics.enable_working_visualisations) do
						working_vis[#working_vis + 1] = name
					end
				end
			end
		end
		fluid_box.enable_working_visualisations = working_vis

		::continue::
	end
end

return CraftingMachineGraphicsPack
