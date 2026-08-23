---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")
local _pipes = require("assets.base.entities.pipe-pictures")

-- Cardinal directions in CW order, used for the pipe-connector rotation math below.
local all_dirs = {
	defines.direction.north,
	defines.direction.east,
	defines.direction.south,
	defines.direction.west,
}

-- CCW rotation map: rotates a sprite direction back into base (north-facing) design space.
local ccw = {
	[defines.direction.north] = defines.direction.west,
	[defines.direction.east] = defines.direction.north,
	[defines.direction.south] = defines.direction.east,
	[defines.direction.west] = defines.direction.south,
}

-- Number of CCW steps from the base (north-facing) design for each entity-facing direction.
local ccw_steps = {
	[defines.direction.north] = 0,
	[defines.direction.east] = 1,
	[defines.direction.south] = 2,
	[defines.direction.west] = 3,
}

-- Horizontal mirror map: east<->west swap for a flipped (horizontally-mirrored) design space.
local h_mirror = {
	[defines.direction.north] = defines.direction.north,
	[defines.direction.east] = defines.direction.west,
	[defines.direction.south] = defines.direction.south,
	[defines.direction.west] = defines.direction.east,
}

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

---Collects pipe connection directions from a prototype's fluid boxes and fluid energy source.
---@param prototype CraftingMachinePrototype
---@return defines.direction[]
local function collect_pipe_connection_directions(prototype)
	local directions = {}

	if prototype.fluid_boxes then
		for _, fluid_box in pairs(prototype.fluid_boxes) do
			if fluid_box.pipe_connections then
				for _, connection in pairs(fluid_box.pipe_connections) do
					if connection.direction then
						table.insert(directions, connection.direction)
					end
				end
			end
		end
	end

	if prototype.energy_source and prototype.energy_source.type == "fluid" then
		local fluid_box = prototype.energy_source.fluid_box
		if fluid_box and fluid_box.pipe_connections then
			for _, connection in pairs(fluid_box.pipe_connections) do
				if connection.direction then
					table.insert(directions, connection.direction)
				end
			end
		end
	end

	return directions
end

---Builds a 2D connection matrix: `matrix[entity_facing_dir][sprite_dir]` = `"connected"` | `"capped"`.
---
---Constructed by rotating the canonical pipe connection set (defined in north-facing orientation)
---clockwise for each entity-facing direction. A sprite direction is connected when rotating it CCW
---back to the north-facing frame maps to a direction in the base connection set.
---
---When `is_flipped` is true, the canonical directions are first mirrored east<->west to account
---for the horizontal symmetry of the flipped variant's design space.
---@param directions defines.direction[]
---@param is_flipped boolean
---@return table<defines.direction, table<defines.direction, "connected"|"capped">>
local function build_connection_matrix(directions, is_flipped)
	local base_set = {}
	for _, dir in pairs(directions) do
		base_set[is_flipped and h_mirror[dir] or dir] = true
	end

	local matrix = {}
	for _, facing in pairs(all_dirs) do
		local row = {}
		local steps = ccw_steps[facing]
		for _, sprite_dir in pairs(all_dirs) do
			local base_dir = sprite_dir
			for _ = 1, steps do
				base_dir = ccw[base_dir]
			end
			row[sprite_dir] = base_set[base_dir] and "connected" or "capped"
		end
		matrix[facing] = row
	end

	return matrix
end

---Mirrors a list of sprite directions east<->west.
---@param directions defines.direction[]
---@return defines.direction[]
local function mirror_directions(directions)
	local mirrored = {}
	for i, dir in pairs(directions) do
		mirrored[i] = h_mirror[dir]
	end
	return mirrored
end

---Resolves `connectors`' behind/front direction sets for the flipped orientation: the explicit
---`flipped_behind_directions`/`flipped_front_directions` overrides if given, otherwise a
---horizontal mirror of `behind_directions`/`front_directions`. Most entities don't need the
---overrides — the flipped variant's geometry is usually just the unflipped one mirrored — but nothing
---guarantees that in general, so producers can supply it explicitly when it isn't.
---@param connectors WorkingVisualisationPipeConnectors
---@return defines.direction[] behind_directions, defines.direction[] front_directions
local function resolve_flipped_directions(connectors)
	return connectors.flipped_behind_directions or mirror_directions(connectors.behind_directions),
		connectors.flipped_front_directions or mirror_directions(connectors.front_directions)
end

---Builds the two pipe corner working_visualisation entries for one orientation.
---
---WV1 (`secondary_draw_order = -1`) covers corners that render behind the entity body.
---WV2 (normal draw order) covers corners that render in front, plus any shadow patches.
---@param connectors WorkingVisualisationPipeConnectors
---@param directions defines.direction[]
---@param is_flipped boolean
---@return WorkingVisualisation # WV1: behind (secondary_draw_order = -1)
---@return WorkingVisualisation # WV2: front
local function build_pipe_connector_visualisations(connectors, directions, is_flipped)
	local matrix = build_connection_matrix(directions, is_flipped)
	local behind_dirs, front_dirs = connectors.behind_directions, connectors.front_directions
	if is_flipped then
		behind_dirs, front_dirs = resolve_flipped_directions(connectors)
	end

	local wv1_layers_by_dir = {}
	local wv2_layers_by_dir = {}

	for _, facing in pairs(all_dirs) do
		local behind_layers = {}
		for _, sprite_dir in pairs(behind_dirs) do
			table.insert(behind_layers, connectors.get_picture(matrix[facing][sprite_dir], sprite_dir, is_flipped))
		end

		local front_layers = {}
		for _, sprite_dir in pairs(front_dirs) do
			table.insert(front_layers, connectors.get_picture(matrix[facing][sprite_dir], sprite_dir, is_flipped))
		end

		-- Shadow patches draw on the same layer regardless of WV; appended to behind_layers for
		-- simplicity. Keyed by sprite direction: fires whenever that sprite direction is connected
		-- in this rotation.
		if connectors.get_shadow then
			for _, sprite_dir in pairs(all_dirs) do
				if matrix[facing][sprite_dir] == "connected" then
					local shadow = connectors.get_shadow(sprite_dir, is_flipped)
					if shadow then
						table.insert(behind_layers, shadow)
					end
				end
			end
		end

		wv1_layers_by_dir[facing] = behind_layers
		wv2_layers_by_dir[facing] = front_layers
	end

	---@type WorkingVisualisation
	local wv1 = {
		always_draw = true,
		secondary_draw_order = -1,
		north_animation = { layers = wv1_layers_by_dir[defines.direction.north] },
		east_animation = { layers = wv1_layers_by_dir[defines.direction.east] },
		south_animation = { layers = wv1_layers_by_dir[defines.direction.south] },
		west_animation = { layers = wv1_layers_by_dir[defines.direction.west] },
	}

	---@type WorkingVisualisation
	local wv2 = {
		always_draw = true,
		north_animation = { layers = wv2_layers_by_dir[defines.direction.north] },
		east_animation = { layers = wv2_layers_by_dir[defines.direction.east] },
		south_animation = { layers = wv2_layers_by_dir[defines.direction.south] },
		west_animation = { layers = wv2_layers_by_dir[defines.direction.west] },
	}

	return wv1, wv2
end

---Builds and appends pipe corner working_visualisations to `prototype.graphics_set` (and
---`prototype.graphics_set_flipped`, if present), from `connectors` and the prototype's own fluid
---box connection directions.
---
---The prototype is mutated in place.
---@param prototype CraftingMachinePrototype
---@param connectors WorkingVisualisationPipeConnectors
local function apply_working_visualisation_pipe_connectors(prototype, connectors)
	assert(prototype.graphics_set, "prototype.graphics_set must be set before applying pipe connectors")

	local directions = collect_pipe_connection_directions(prototype)

	prototype.graphics_set.working_visualisations = prototype.graphics_set.working_visualisations or {}
	local wv1, wv2 = build_pipe_connector_visualisations(connectors, directions, false)
	table.insert(prototype.graphics_set.working_visualisations, wv1)
	table.insert(prototype.graphics_set.working_visualisations, wv2)

	if prototype.graphics_set_flipped then
		prototype.graphics_set_flipped.working_visualisations = prototype.graphics_set_flipped.working_visualisations or {}
		local wv1_f, wv2_f = build_pipe_connector_visualisations(connectors, directions, true)
		table.insert(prototype.graphics_set_flipped.working_visualisations, wv1_f)
		table.insert(prototype.graphics_set_flipped.working_visualisations, wv2_f)
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

	if sprite_set.working_visualisation_pipe_connectors then
		apply_working_visualisation_pipe_connectors(prototype, sprite_set.working_visualisation_pipe_connectors)
	end

	if sprite_set.fluid_boxes_off_when_no_fluid_recipe ~= nil and prototype.type == "assembling-machine" then
		---@cast prototype AssemblingMachinePrototype
		prototype.fluid_boxes_off_when_no_fluid_recipe = sprite_set.fluid_boxes_off_when_no_fluid_recipe
	end
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
	apply_to_explosion = apply_sprite_set_to_explosion,
}

---A pipe corner's art for one connection state, sprite direction, and flip orientation.
---@alias PipeConnectorPicture fun(state: "connected"|"capped", direction: defines.direction, is_flipped: boolean): Animation

---An optional shadow patch drawn when `direction` is connected. Returns `nil` for no shadow there.
---@alias PipeConnectorShadow fun(direction: defines.direction, is_flipped: boolean): Animation?

---Dynamic, connection-state-driven pipe corner art, built at apply time from the prototype's own
---fluid box connection directions — the alternative to `fluid_boxes` for a crafting machine whose
---pipe art is expressed as rotated working_visualisations rather than direct FluidBox pictures.
---@class (exact) WorkingVisualisationPipeConnectors
---The connected/capped pipe corner art for a sprite direction and flip orientation.
---@field get_picture PipeConnectorPicture
---The shadow patch for a connected direction and flip orientation, if this entity has one.
---@field get_shadow PipeConnectorShadow?
---Sprite directions, unflipped, drawn behind the entity body (`secondary_draw_order = -1`).
---@field behind_directions defines.direction[]
---Sprite directions, unflipped, drawn in front of the entity body.
---@field front_directions defines.direction[]
---Overrides `behind_directions` for the flipped orientation. Defaults to a horizontal mirror of
---`behind_directions` when omitted; set explicitly if the flipped geometry doesn't mirror cleanly.
---@field flipped_behind_directions defines.direction[]?
---Overrides `front_directions` for the flipped orientation. Defaults to a horizontal mirror of
---`front_directions` when omitted; set explicitly if the flipped geometry doesn't mirror cleanly.
---@field flipped_front_directions defines.direction[]?

---The sprite data a `crafting_machine_sprite_set`-tagged `SpriteSetDefinition` carries.
---@class (exact) CraftingMachineSpriteSet : EntityWithHealthSpriteSet
---The prototype's `graphics_set`.
---@field graphics_set CraftingMachineGraphicsSet
---The prototype's `graphics_set_flipped`, for a crafting machine that supports flipping.
---@field graphics_set_flipped CraftingMachineGraphicsSet?
---Fluid box pipe graphics, matched to the prototype's fluid boxes by direction.
---@field fluid_boxes FluidBoxGraphics[]?
---Dynamic pipe corner art built from the prototype's own fluid box connection directions. Used
---instead of (or alongside) `fluid_boxes` by crafting machines whose pipe art is expressed as
---working_visualisations rather than direct FluidBox pictures.
---@field working_visualisation_pipe_connectors WorkingVisualisationPipeConnectors?
---Sets the prototype's `fluid_boxes_off_when_no_fluid_recipe` (`AssemblingMachinePrototype` only;
---ignored for furnaces).
---@field fluid_boxes_off_when_no_fluid_recipe boolean?

---The applicator for crafting machines (`AssemblingMachinePrototype`, `FurnacePrototype`).
---@class (exact) CraftingMachineSpriteSetApplicator : SpriteSetApplicator<CraftingMachinePrototype, CraftingMachineSpriteSet>
