---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")
local _pipes = require("assets.base.entities.pipe-pictures")

---Collects the set of directions declared by a fluid box's pipe connections.
---@param fluid_box FluidBox
---@return FluidBoxDirections
local function collect_directions_from_fluid_box(fluid_box)
	---@type FluidBoxDirections
	local directions = {
		[defines.direction.north] = false,
		[defines.direction.east] = false,
		[defines.direction.south] = false,
		[defines.direction.west] = false,
	}

	if fluid_box ~= nil and fluid_box.pipe_connections ~= nil then
		for _, pipe_connection in pairs(fluid_box.pipe_connections) do
			directions[
				pipe_connection.direction--[[@cast -?]]
			] = true
		end
	end

	return directions
end

---Finds the first `FluidBoxGraphics` in `fluid_box_graphics` that matches the given set of
---prototype fluid box directions.
---
---A match is found when any direction in a `FluidBoxGraphics.pipe_connections` entry is
---present in `directions`. If no direction-specific match is found, the first entry
---with no `pipe_connections` is returned as a universal fallback.
---@param directions FluidBoxDirections
---@param fluid_box_graphics FluidBoxGraphics[]
---@return FluidBoxGraphics?
local function find_matching_fluid_box_graphics(directions, fluid_box_graphics)
	---@type FluidBoxGraphics?
	local fallback_graphics = nil

	for _, graphics in pairs(fluid_box_graphics) do
		if graphics.pipe_connections then
			for _, pipe_connection_graphics in pairs(graphics.pipe_connections) do
				if directions[pipe_connection_graphics.direction] then
					return util.copy(graphics)
				end
			end
		elseif not fallback_graphics then
			fallback_graphics = graphics
		end
	end

	return util.copy(fallback_graphics)
end

---Applies fluid box graphics to the specified `prototype`.
---
---Each prototype fluid box is matched to a `FluidBoxGraphics` entry by direction. A
---`FluidBoxGraphics` with no `pipe_connections` acts as a universal fallback and is applied
---to any fluid box that has no more-specific match.
---
---The prototype is mutated in place.
---@param prototype CraftingMachinePrototype
---@param fluid_box_graphics FluidBoxGraphics[]
local function apply_fluid_box_graphics(prototype, fluid_box_graphics)
	local fluid_boxes = {}
	if prototype.energy_source and prototype.energy_source.fluid_box then
		-- Ensure that the prototype's energy source fluid box is decoupled from any other fluid box.
		prototype.energy_source.fluid_box = util.copy(prototype.energy_source.fluid_box)
		table.insert(fluid_boxes, prototype.energy_source.fluid_box)
	end

	if prototype.fluid_boxes then
		-- Ensure that the prototype's fluid boxes are decoupled from any other fluid boxes.
		prototype.fluid_boxes = util.copy(prototype.fluid_boxes)
		for _, fluid_box in pairs(prototype.fluid_boxes) do
			if fluid_box ~= nil then
				table.insert(fluid_boxes, fluid_box)
			end
		end
	end

	for _, fluid_box in pairs(fluid_boxes) do
		local directions = collect_directions_from_fluid_box(fluid_box)
		local match = find_matching_fluid_box_graphics(directions, fluid_box_graphics)

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
				if directions[pipe_connection_graphics.direction] then
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

---Applies a `crafting_machine_graphics_set`-shaped `value` to `prototype`. `value` is always
---already in this applicator's native shape by the time it arrives here — getting an arbitrary
---source shape to this one is `graphics-packs.apply`'s and `graphics-packs.converters`' job, not
---this applicator's; it only needs to know how to consume its own shape.
---@param prototype CraftingMachinePrototype
---@param sprite_set CraftingMachineSpriteSet
local function apply_sprite_set_to_crafting_machine(prototype, sprite_set)
	local graphics_set = util.copy(sprite_set.graphics_set)
	local graphics_set_flipped = sprite_set.graphics_set_flipped and util.copy(sprite_set.graphics_set_flipped) or nil

	prototype.graphics_set = graphics_set
	prototype.graphics_set_flipped = graphics_set_flipped

	if sprite_set.fluid_boxes then
		apply_fluid_box_graphics(prototype, sprite_set.fluid_boxes)
	end

	if sprite_set.fluid_boxes_off_when_no_fluid_recipe ~= nil and prototype.type == "assembling-machine" then
		---@cast prototype AssemblingMachinePrototype
		prototype.fluid_boxes_off_when_no_fluid_recipe = sprite_set.fluid_boxes_off_when_no_fluid_recipe
	end
end

---@param corpse CorpsePrototype
---@param sprite_set CraftingMachineSpriteSet
local function apply_sprite_set_to_corpse(corpse, sprite_set)
	error("Not implemented")
end

---@param explosion ExplosionPrototype
---@param sprite_set CraftingMachineSpriteSet
local function apply_sprite_set_to_explosion(explosion, sprite_set)
	error("Not implemented")
end

---@type CraftingMachineSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.crafting_machine_sprite_set,
	apply_to = apply_sprite_set_to_crafting_machine,
	apply_to_corpse = apply_sprite_set_to_corpse,
	apply_to_explosion = apply_sprite_set_to_explosion,
}

---The sprite data a `crafting_machine_sprite_set`-tagged `SpriteSetDefinition` carries.
---@class (exact) CraftingMachineSpriteSet : EntityWithHealthSpriteSet
---The prototype's `graphics_set`.
---@field graphics_set CraftingMachineGraphicsSet
---The prototype's `graphics_set_flipped`, for a crafting machine that supports flipping.
---@field graphics_set_flipped CraftingMachineGraphicsSet?
---Fluid box pipe graphics, matched to the prototype's fluid boxes by direction.
---@field fluid_boxes FluidBoxGraphics[]?
---Sets the prototype's `fluid_boxes_off_when_no_fluid_recipe` (`AssemblingMachinePrototype` only;
---ignored for furnaces).
---@field fluid_boxes_off_when_no_fluid_recipe boolean?

---The applicator for crafting machines (`AssemblingMachinePrototype`, `FurnacePrototype`).
---@class (exact) CraftingMachineSpriteSetApplicator : SpriteSetApplicator<CraftingMachinePrototype, CraftingMachineSpriteSet>
