local _defines = require("api.defines")
local _pipes = require("assets.base.entities.pipe-pictures")
local CraftingMachineGraphicsPack = require("graphics-packs.abstractions.crafting-machine-graphics-pack")
local StringValidator = require("prototypes.string-validator")

---@class Reskins.Angels.InductionFurnaceGraphicsPack:Reskins.Abstractions.CraftingMachineGraphicsPack
local InductionFurnaceGraphicsPack = {}
InductionFurnaceGraphicsPack.__index = InductionFurnaceGraphicsPack

local assets_induction_furnace = "__reskins-assets-angels__/graphics/entity/induction-furnace/"
local smelting_induction_furnace = "__angelssmeltinggraphics__/graphics/entity/induction-furnace/"

-- Set up inheritance
setmetatable(InductionFurnaceGraphicsPack, {
	__index = CraftingMachineGraphicsPack,
})

-- Cardinal directions in CW order, used for rotation math
local all_dirs = {
	defines.direction.north,
	defines.direction.east,
	defines.direction.south,
	defines.direction.west,
}

-- CCW rotation map: used to rotate a sprite direction back into base design space
local ccw = {
	[defines.direction.north] = defines.direction.west,
	[defines.direction.east] = defines.direction.north,
	[defines.direction.south] = defines.direction.east,
	[defines.direction.west] = defines.direction.south,
}

-- Number of CCW steps from base (north-facing) design for each entity-facing direction
local ccw_steps = {
	[defines.direction.north] = 0,
	[defines.direction.east] = 1,
	[defines.direction.south] = 2,
	[defines.direction.west] = 3,
}

-- Pipe sprite directions that render behind the entity body (WV1: secondary_draw_order = -1)
local behind_dirs = {
	[false] = { defines.direction.north, defines.direction.west },
	[true] = { defines.direction.north, defines.direction.east },
}

-- Pipe sprite directions that render in front of the entity body (WV2: normal draw order)
local front_dirs = {
	[false] = { defines.direction.east, defines.direction.south },
	[true] = { defines.direction.south, defines.direction.west },
}

-- Shadow patch sprites, indexed by [is_flipped][sprite_dir].
-- When a behind-WV sprite direction is connected in a given rotation, the corresponding shadow
-- patch is appended to that rotation's WV1 layers. Positions are fixed screen-space offsets tuned
-- to the geometry of the induction furnace pipe connection at {2, -2} in north-facing design space.
local vertical_shadow = _pipes.vertical_pipe_shadow({ 2, -2 })
local horizontal_shadow_n = _pipes.horizontal_pipe_shadow({ -2, -2 })
local horizontal_shadow_f = _pipes.horizontal_pipe_shadow({ -2, 2 })
local shadow_lookup = {
	[false] = {
		[defines.direction.north] = vertical_shadow,
		[defines.direction.west] = horizontal_shadow_n,
	},
	[true] = {
		[defines.direction.west] = horizontal_shadow_f,
	},
}

-- Horizontal mirror map: east<->west swap for the flipped (horizontally-mirrored) design space
local h_mirror = {
	[defines.direction.north] = defines.direction.north,
	[defines.direction.east] = defines.direction.west,
	[defines.direction.south] = defines.direction.south,
	[defines.direction.west] = defines.direction.east,
}

---@class Reskins.Angels.InductionFurnaceGraphicsParams
---@field tint data.Color?

---Creates a new `InductionFurnaceGraphicsPack` instance.
---@param params Reskins.Angels.InductionFurnaceGraphicsParams
---@return Reskins.Angels.InductionFurnaceGraphicsPack
---@nodiscard
function InductionFurnaceGraphicsPack:configure(params)
	local graphics_set = self.get_graphics_set(params.tint)
	local graphics_set_flipped = self.get_graphics_set_flipped(params.tint)

	local instance = CraftingMachineGraphicsPack.configure(self, {
		tint = params.tint,
		required_assets = {
			[_defines.assets.smelting_graphics] = true,
			[_defines.assets.angels_assets] = true,
			[_defines.assets.base_assets] = true,
		},
		nominal_width = 5,
		nominal_height = 5,
		graphics_set = graphics_set,
		graphics_set_flipped = graphics_set_flipped,
	}) --[[@as Reskins.Angels.InductionFurnaceGraphicsPack]]

	-- Set the correct metatable for this class
	setmetatable(instance, InductionFurnaceGraphicsPack)
	return instance
end

---@param state "capped" | "connected"
---@param direction defines.direction?
---@param is_flipped boolean?
---@return data.Animation
function InductionFurnaceGraphicsPack.get_pipe_picture(state, direction, is_flipped)
	assert(state == "capped" or state == "connected")
	local flipped = is_flipped == true and "-flipped" or ""

	-- Map direction to string for filename
	local direction_map = {
		[defines.direction.north] = "north",
		[defines.direction.east] = "east",
		[defines.direction.south] = "south",
		[defines.direction.west] = "west",
	}

	local direction_str = direction_map[direction] or "north"

	local base_path = smelting_induction_furnace .. "induction-furnace-pipe-" .. state .. "-" .. direction_str
	---@type data.Animation
	local animation = {
		layers = {
			util.sprite_load(base_path .. flipped, {
				priority = "high",
				scale = 0.5,
			}),
			util.sprite_load(base_path .. "-shadow" .. flipped, {
				priority = "high",
				draw_as_shadow = true,
				scale = 0.5,
			}),
		},
	}

	return animation
end

---@param is_flipped boolean?
---@return data.Animation
function InductionFurnaceGraphicsPack.get_base_animation(is_flipped)
	local flipped = is_flipped == true and "-flipped" or ""

	---@type data.Animation
	local animation = {
		layers = {
			util.sprite_load(smelting_induction_furnace .. "induction-furnace-base" .. flipped, {
				priority = "high",
				scale = 0.5,
			}),
			util.sprite_load(smelting_induction_furnace .. "induction-furnace-base-shadow" .. flipped, {
				priority = "high",
				draw_as_shadow = true,
				scale = 0.5,
			}),
		},
	}

	return animation
end

---@param is_flipped boolean?
---@return data.WorkingVisualisation
function InductionFurnaceGraphicsPack.get_integration_patch_working_vis(is_flipped)
	local flipped = is_flipped == true and "-flipped" or ""

	local working_vis = {
		always_draw = true,
		render_layer = "floor",
		animation = util.sprite_load(smelting_induction_furnace .. "induction-furnace-integration-patch" .. flipped, {
			priority = "high",
			scale = 0.5,
		}),
	}

	return working_vis
end

---@param is_flipped boolean?
---@return data.WorkingVisualisation
function InductionFurnaceGraphicsPack.get_idle_animation_working_vis(is_flipped)
	local flipped = is_flipped == true and "-flipped" or ""

	---@type data.WorkingVisualisation
	local working_vis = {
		always_draw = true,
		animation = {
			layers = {
				util.sprite_load(smelting_induction_furnace .. "induction-furnace-idle-animation" .. flipped, {
					priority = "high",
					frame_count = 36,
					animation_speed = 0.5,
					scale = 0.5,
				}),
				util.sprite_load(smelting_induction_furnace .. "induction-furnace-animation-shadow" .. flipped, {
					priority = "high",
					frame_count = 36,
					animation_speed = 0.5,
					draw_as_shadow = true,
					scale = 0.5,
				}),
			},
		},
	}

	return working_vis
end

---@param is_flipped boolean?
---@return data.WorkingVisualisation
function InductionFurnaceGraphicsPack.get_animation_working_vis(is_flipped)
	local flipped = is_flipped == true and "-flipped" or ""

	---@type data.WorkingVisualisation
	local working_vis = {
		fadeout = true,
		animation = {
			layers = {
				util.sprite_load(smelting_induction_furnace .. "induction-furnace-animation" .. flipped, {
					priority = "high",
					frame_count = 36,
					animation_speed = 0.5,
					scale = 0.5,
				}),
			},
		},
	}

	return working_vis
end

---@param is_flipped boolean?
---@return data.WorkingVisualisation
function InductionFurnaceGraphicsPack.get_recipe_mask_working_vis(is_flipped)
	local flipped = is_flipped == true and "-flipped" or ""

	---@type data.WorkingVisualisation
	local working_vis = {
		always_draw = true,
		apply_recipe_tint = "primary",
		animation = {
			layers = {
				util.sprite_load(smelting_induction_furnace .. "induction-furnace-lower-recipe-mask" .. flipped, {
					priority = "high",
					frame_count = 36,
					animation_speed = 0.5,
					scale = 0.5,
				}),
				util.sprite_load(smelting_induction_furnace .. "induction-furnace-upper-recipe-mask" .. flipped, {
					priority = "high",
					frame_count = 36,
					animation_speed = 0.5,
					scale = 0.5,
				}),
			},
		},
	}

	return working_vis
end

---@param is_flipped boolean?
---@return data.WorkingVisualisation
function InductionFurnaceGraphicsPack.get_lights_working_vis(is_flipped)
	local flipped = is_flipped == true and "-flipped" or ""

	---@type data.WorkingVisualisation
	local working_vis = {
		always_draw = true,
		animation = {
			layers = {
				util.sprite_load(smelting_induction_furnace .. "induction-furnace-lights" .. flipped, {
					priority = "high",
					frame_count = 36,
					animation_speed = 0.5,
					draw_as_light = true,
					scale = 0.5,
				}),
			},
		},
	}

	return working_vis
end

---@param is_flipped boolean?
---@return data.WorkingVisualisation
function InductionFurnaceGraphicsPack.get_working_lights_working_vis(is_flipped)
	local flipped = is_flipped == true and "-flipped" or ""

	---@type data.WorkingVisualisation
	local working_vis = {
		fadeout = true,
		animation = {
			layers = {
				util.sprite_load(smelting_induction_furnace .. "induction-furnace-working-lights" .. flipped, {
					priority = "high",
					frame_count = 36,
					animation_speed = 0.5,
					draw_as_light = true,
					scale = 0.5,
				}),
			},
		},
	}

	return working_vis
end

---@param tint data.Color?
---@param is_flipped boolean?
---@return data.WorkingVisualisation?
function InductionFurnaceGraphicsPack.get_color_mask_working_vis(tint, is_flipped)
	local flipped = is_flipped == true and "-flipped" or ""

	local working_vis = {
		always_draw = true,
		animation = {
			layers = {
				util.sprite_load(assets_induction_furnace .. "induction-furnace" .. flipped .. "-mask", {
					priority = "high",
					frame_count = 36,
					animation_speed = 0.5,
					tint = tint,
					scale = 0.5,
				}),
				util.sprite_load(assets_induction_furnace .. "induction-furnace" .. flipped .. "-highlights", {
					priority = "high",
					frame_count = 36,
					animation_speed = 0.5,
					blend_mode = "additive-soft",
					scale = 0.5,
				}),
			},
		},
	}

	return working_vis
end

---Builds a 2D connection matrix: `matrix[entity_facing_dir][sprite_dir]` = `"connected"` | `"capped"`.
---
---Constructed by rotating the canonical pipe connection set (defined in north-facing orientation)
---clockwise for each entity-facing direction. A sprite direction is connected when rotating it CCW
---back to the north-facing frame maps to a direction in the base connection set.
---
---When `is_flipped` is true, the canonical directions are first mirrored east<->west to account
---for the horizontal symmetry of the flipped variant's design space.
---@param pipe_connections defines.direction[]?
---@param is_flipped boolean
---@return table<defines.direction, table<defines.direction, "connected"|"capped">>
local function build_connection_matrix(pipe_connections, is_flipped)
	local base_set = {}
	if pipe_connections then
		for _, dir in pairs(pipe_connections) do
			base_set[is_flipped and h_mirror[dir] or dir] = true
		end
	end

	local matrix = {}
	for _, facing in pairs(all_dirs) do
		local row = {}
		local steps = ccw_steps[facing]
		for _, sprite_dir in pairs(all_dirs) do
			-- Rotate sprite_dir CCW by `steps` to recover the base design direction
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

---Builds the two pipe corner working_visualisation entries for an induction furnace.
---
---WV1 (`secondary_draw_order = -1`) covers corners that render behind the entity body.
---WV2 (normal draw order) covers corners that render in front, plus any shadow patches.
---@param pipe_connections defines.direction[]?
---@param is_flipped boolean?
---@return data.WorkingVisualisation # WV1: behind (secondary_draw_order = -1)
---@return data.WorkingVisualisation # WV2: front
local function get_pipe_working_visualisations(pipe_connections, is_flipped)
	is_flipped = is_flipped == true
	local matrix = build_connection_matrix(pipe_connections, is_flipped)
	local wv1_dirs = behind_dirs[is_flipped]
	local wv2_dirs = front_dirs[is_flipped]

	local wv1_layers_by_dir = {}
	local wv2_layers_by_dir = {}

	for _, facing in pairs(all_dirs) do
		local behind_layers = {}
		for _, sprite_dir in pairs(wv1_dirs) do
			table.insert(
				behind_layers,
				InductionFurnaceGraphicsPack.get_pipe_picture(matrix[facing][sprite_dir], sprite_dir, is_flipped)
			)
		end

		local front_layers = {}
		for _, sprite_dir in pairs(wv2_dirs) do
			table.insert(
				front_layers,
				InductionFurnaceGraphicsPack.get_pipe_picture(matrix[facing][sprite_dir], sprite_dir, is_flipped)
			)
		end

		-- Shadow patches draw on the same layer regardless of WV; append to behind_layers for simplicity.
		-- Keyed by sprite direction: fires whenever that sprite direction is connected in this rotation.
		for _, sprite_dir in pairs(all_dirs) do
			local shadow = shadow_lookup[is_flipped][sprite_dir]
			if shadow and matrix[facing][sprite_dir] == "connected" then
				table.insert(behind_layers, shadow)
			end
		end

		wv1_layers_by_dir[facing] = behind_layers
		wv2_layers_by_dir[facing] = front_layers
	end

	local wv1 = {
		always_draw = true,
		secondary_draw_order = -1,
		north_animation = { layers = wv1_layers_by_dir[defines.direction.north] },
		east_animation = { layers = wv1_layers_by_dir[defines.direction.east] },
		south_animation = { layers = wv1_layers_by_dir[defines.direction.south] },
		west_animation = { layers = wv1_layers_by_dir[defines.direction.west] },
	}

	local wv2 = {
		always_draw = true,
		north_animation = { layers = wv2_layers_by_dir[defines.direction.north] },
		east_animation = { layers = wv2_layers_by_dir[defines.direction.east] },
		south_animation = { layers = wv2_layers_by_dir[defines.direction.south] },
		west_animation = { layers = wv2_layers_by_dir[defines.direction.west] },
	}

	return wv1, wv2
end

---Collects pipe connection directions from a prototype's fluid boxes and fluid energy source.
---@param prototype data.CraftingMachinePrototype
---@return defines.direction[]
local function collect_pipe_directions(prototype)
	local dirs = {}

	if prototype.fluid_boxes then
		for _, fluid_box in pairs(prototype.fluid_boxes) do
			if fluid_box.pipe_connections then
				for _, conn in pairs(fluid_box.pipe_connections) do
					if conn.direction then
						table.insert(dirs, conn.direction)
					end
				end
			end
		end
	end

	if prototype.energy_source and prototype.energy_source.type == "fluid" then
		local fb = prototype.energy_source.fluid_box
		if fb and fb.pipe_connections then
			for _, conn in pairs(fb.pipe_connections) do
				if conn.direction then
					table.insert(dirs, conn.direction)
				end
			end
		end
	end

	return dirs
end

local function get_graphics_set(tint, is_flipped)
	local working_visualisations = {
		InductionFurnaceGraphicsPack.get_integration_patch_working_vis(is_flipped),
		InductionFurnaceGraphicsPack.get_idle_animation_working_vis(is_flipped),
		InductionFurnaceGraphicsPack.get_animation_working_vis(is_flipped),
		InductionFurnaceGraphicsPack.get_recipe_mask_working_vis(is_flipped),
		InductionFurnaceGraphicsPack.get_lights_working_vis(is_flipped),
		InductionFurnaceGraphicsPack.get_working_lights_working_vis(is_flipped),
	}

	if tint then
		table.insert(working_visualisations, InductionFurnaceGraphicsPack.get_color_mask_working_vis(tint, is_flipped))
	end

	---@type data.CraftingMachineGraphicsSet
	local graphics_set = {
		animation = InductionFurnaceGraphicsPack.get_base_animation(is_flipped),
		working_visualisations = working_visualisations,
	}

	return graphics_set
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
function InductionFurnaceGraphicsPack.get_graphics_set(tint)
	return get_graphics_set(tint, false)
end

---@param tint data.Color?
---@return data.CraftingMachineGraphicsSet
function InductionFurnaceGraphicsPack.get_graphics_set_flipped(tint)
	return get_graphics_set(tint, true)
end

---Applies the graphics pack to the specified crafting machine `prototype`.
---
---Detects pipe connection directions from the prototype's fluid boxes at apply time and appends
---the corresponding pipe corner working_visualisations to the graphics set.
---
---Validates that `prototype.forced_symmetry` is `nil` or `"horizontal"`.
---@param prototype data.CraftingMachinePrototype
function InductionFurnaceGraphicsPack:apply_to_entity(prototype)
	if prototype.forced_symmetry ~= nil then
		StringValidator.validate(prototype.forced_symmetry, "prototype.forced_symmetry"):is_one_of({ "horizontal" })
	end

	CraftingMachineGraphicsPack.apply_to_entity(self, prototype)

	local pipe_connections = collect_pipe_directions(prototype)

	local wv1, wv2 = get_pipe_working_visualisations(pipe_connections, false)
	table.insert(prototype.graphics_set.working_visualisations, wv1)
	table.insert(prototype.graphics_set.working_visualisations, wv2)

	if prototype.graphics_set_flipped then
		local wv1_f, wv2_f = get_pipe_working_visualisations(pipe_connections, true)
		table.insert(prototype.graphics_set_flipped.working_visualisations, wv1_f)
		table.insert(prototype.graphics_set_flipped.working_visualisations, wv2_f)
	end
end

return InductionFurnaceGraphicsPack
