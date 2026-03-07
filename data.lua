local _icons = require("api.icons")
local _sprites = require("api.sprites")
local colors = require("__reskins-sprite-utils__.colors")

---@param name data.EntityID
---@param source_type string
---@param source_name data.EntityID
---@param icons data.IconData[]?
local function create_dummy_entity(name, source_type, source_name, icons)
	local source_entity = data.raw[source_type][source_name]

	---@type data.ItemPrototype
	local item = {
		type = "item",
		name = name,
		localised_name = name,
		icons = icons or _icons.get_icon_from_prototype(source_entity),
		stack_size = 10,
		place_result = name,
	}

	local entity = util.merge({
		util.copy(source_entity),
		{
			name = name,
			minable = { result = name },
		},
	})

	entity.next_upgrade = nil

	---@type data.RecipePrototype
	local recipe = {
		type = "recipe",
		name = name,
		ingredients = {},
		results = { { type = "item", name = name, amount = 1 } },
	}

	data:extend({ item, entity, recipe })

	return entity
end

---Adds a simple always-on fluid box to an entity in the given cardinal direction.
---
---Intended for use in the test harness to simulate entities with fluid connections,
---so that graphics packs that assign pipe pictures to `fluid_boxes` entries can be tested.
---
---@param entity data.CraftingMachinePrototype
---@param direction defines.direction
---@param position data.MapPosition
local function add_fluid_box(entity, direction, position)
	local production_type = "output"
	local flow_direction = "output"

	entity.fluid_boxes = entity.fluid_boxes or {}
	table.insert(entity.fluid_boxes, {
		production_type = production_type,
		volume = 1000,
		pipe_connections = {
			{
				flow_direction = flow_direction,
				direction = direction,
				position = position,
			},
		},
		pipe_covers = pipecoverspictures(),
	})
end

reskins_suppress_errors = true

local tints = {
	gray = colors.from_argb("FF808080"),
	yellow = colors.from_argb("FFFFB726"),
	red = colors.from_argb("FFF22318"),
	blue = colors.from_argb("FF33B4FF"),
	purple = colors.from_argb("FFB459FF"),
	green = colors.from_argb("FF2EE55C"),
	orange = colors.from_argb("FFFF8533"),
	tahiti_blue = colors.from_argb("FF00C1DF"),
}

-- STANDARD ASSEMBLY MACHINE TESTS
local AssemblingMachineGraphicsPack = require("graphics-packs.assembling-machine-graphics-pack")

AssemblingMachineGraphicsPack:configure({
	tint = tints.yellow,
	machine_tier = 1,
}):apply_to_entity(create_dummy_entity("ar-assembly-0", "assembling-machine", "assembling-machine-1"))
AssemblingMachineGraphicsPack:configure({
	tint = tints.red,
	machine_tier = 2,
}):apply_to_entity(create_dummy_entity("ar-assembly-1", "assembling-machine", "assembling-machine-1"))
AssemblingMachineGraphicsPack:configure({
	tint = tints.blue,
	machine_tier = 3,
}):apply_to_entity(create_dummy_entity("ar-assembly-2", "assembling-machine", "assembling-machine-2"))
AssemblingMachineGraphicsPack:configure({
	tint = tints.purple,
	machine_tier = 4,
}):apply_to_entity(create_dummy_entity("ar-assembly-3", "assembling-machine", "assembling-machine-2"))
AssemblingMachineGraphicsPack:configure({
	tint = tints.green,
	machine_tier = 5,
}):apply_to_entity(create_dummy_entity("ar-assembly-4", "assembling-machine", "assembling-machine-3"))
AssemblingMachineGraphicsPack:configure({
	tint = tints.orange,
	machine_tier = 6,
}):apply_to_entity(create_dummy_entity("ar-assembly-5", "assembling-machine", "assembling-machine-3"))

-- ELECTRIC ASSEMBLY MACHINE TESTS
-- NOTE: rescaling fluid boxes needs manual correction.
local assembly_electric_1 = create_dummy_entity("ar-assembly-electric-1", "assembling-machine", "assembling-machine-1")
AssemblingMachineGraphicsPack:configure({
	tint = tints.yellow,
	machine_tier = 2,
	use_electronics_set = true,
}):apply_to_entity(assembly_electric_1)
_sprites.rescale_prototype(assembly_electric_1, 2 / 3)

local assembly_electric_2 = create_dummy_entity("ar-assembly-electric-2", "assembling-machine", "assembling-machine-1")
AssemblingMachineGraphicsPack:configure({
	tint = tints.red,
	machine_tier = 4,
	use_electronics_set = true,
}):apply_to_entity(assembly_electric_2)
_sprites.rescale_prototype(assembly_electric_2, 2 / 3)

local assembly_electric_3 = create_dummy_entity("ar-assembly-electric-3", "assembling-machine", "assembling-machine-1")
AssemblingMachineGraphicsPack:configure({
	tint = tints.blue,
	machine_tier = 6,
	use_electronics_set = true,
}):apply_to_entity(assembly_electric_3)
_sprites.rescale_prototype(assembly_electric_3, 2 / 3)

-- INDUCTION FURNACE TESTS
local InductionFurnaceGraphicsPack = require("graphics-packs.induction-furnace-graphics-pack")

-- 0 pipe connections (all capped — degenerate case)
local induction_furnace_0 = create_dummy_entity("ar-induction-furnace-0", "assembling-machine", "assembling-machine-1")
_sprites.rescale_prototype(induction_furnace_0, 5 / 3)
induction_furnace_0.collision_box = { { -2.5, -2.5 }, { 2.5, 2.5 } }
InductionFurnaceGraphicsPack:configure({ tint = tints.gray }):apply_to_entity(induction_furnace_0)

-- 1 pipe connection (north)
local induction_furnace_1 = create_dummy_entity("ar-induction-furnace-1", "assembling-machine", "assembling-machine-1")
_sprites.rescale_prototype(induction_furnace_1, 5 / 3)
induction_furnace_1.collision_box = { { -2.5, -2.5 }, { 2.5, 2.5 } }
induction_furnace_1.forced_symmetry = "horizontal"
add_fluid_box(induction_furnace_1, defines.direction.north, { 2, -2 })
InductionFurnaceGraphicsPack:configure({ tint = tints.yellow }):apply_to_entity(induction_furnace_1)

-- 2 pipe connections (north + east)
local induction_furnace_2 = create_dummy_entity("ar-induction-furnace-2", "assembling-machine", "assembling-machine-1")
_sprites.rescale_prototype(induction_furnace_2, 5 / 3)
induction_furnace_2.collision_box = { { -2.5, -2.5 }, { 2.5, 2.5 } }
induction_furnace_2.forced_symmetry = "horizontal"
add_fluid_box(induction_furnace_2, defines.direction.north, { 2, -2 })
add_fluid_box(induction_furnace_2, defines.direction.east, { 2, 2 })
InductionFurnaceGraphicsPack:configure({ tint = tints.red }):apply_to_entity(induction_furnace_2)

-- 3 pipe connections (north + east + south)
local induction_furnace_3 = create_dummy_entity("ar-induction-furnace-3", "assembling-machine", "assembling-machine-1")
_sprites.rescale_prototype(induction_furnace_3, 5 / 3)
induction_furnace_3.collision_box = { { -2.5, -2.5 }, { 2.5, 2.5 } }
induction_furnace_3.forced_symmetry = "horizontal"
add_fluid_box(induction_furnace_3, defines.direction.north, { 2, -2 })
add_fluid_box(induction_furnace_3, defines.direction.east, { 2, 2 })
add_fluid_box(induction_furnace_3, defines.direction.south, { -2, 2 })
InductionFurnaceGraphicsPack:configure({ tint = tints.blue }):apply_to_entity(induction_furnace_3)

-- 4 pipe connections (all)
local induction_furnace_4 = create_dummy_entity("ar-induction-furnace-4", "assembling-machine", "assembling-machine-1")
_sprites.rescale_prototype(induction_furnace_4, 5 / 3)
induction_furnace_4.collision_box = { { -2.5, -2.5 }, { 2.5, 2.5 } }
induction_furnace_4.forced_symmetry = "horizontal"
add_fluid_box(induction_furnace_4, defines.direction.north, { 2, -2 })
add_fluid_box(induction_furnace_4, defines.direction.east, { 2, 2 })
add_fluid_box(induction_furnace_4, defines.direction.south, { -2, 2 })
add_fluid_box(induction_furnace_4, defines.direction.west, { -2, -2 })
InductionFurnaceGraphicsPack:configure({ tint = tints.purple }):apply_to_entity(induction_furnace_4)

-- ACCUMULATOR TESTS
local AccumulatorGraphicsPack = require("graphics-packs.accumulator-graphics-pack")
AccumulatorGraphicsPack:configure({
	tint = tints.yellow,
	sprite_set = "base",
}):apply_to_entity(create_dummy_entity("ar-accumulator", "accumulator", "accumulator"))
AccumulatorGraphicsPack:configure({
	tint = tints.red,
	sprite_set = "fast",
}):apply_to_entity(create_dummy_entity("ar-accumulator-fast", "accumulator", "accumulator"))
AccumulatorGraphicsPack:configure({
	tint = tints.blue,
	sprite_set = "high-capacity",
}):apply_to_entity(create_dummy_entity("ar-accumulator-high-capacity", "accumulator", "accumulator"))
AccumulatorGraphicsPack:configure({
	tint = tints.purple,
	sprite_set = "slow",
}):apply_to_entity(create_dummy_entity("ar-accumulator-slow", "accumulator", "accumulator"))

-- CENTRIFUGE TESTS
local CentrifugeGraphicsPack = require("graphics-packs.centrifuge-graphics-pack")

CentrifugeGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-centrifuge-1", "assembling-machine", "centrifuge"))

CentrifugeGraphicsPack:configure({
	tint = tints.red,
}):apply_to_entity(create_dummy_entity("ar-centrifuge-2", "assembling-machine", "centrifuge"))

CentrifugeGraphicsPack:configure({
	tint = tints.blue,
}):apply_to_entity(create_dummy_entity("ar-centrifuge-3", "assembling-machine", "centrifuge"))

-- CHEMICAL PLANT TESTS
local ChemicalPlantGraphicsPack = require("graphics-packs.chemical-plant-graphics-pack")

ChemicalPlantGraphicsPack:configure({
	tint = tints.green,
}):apply_to_entity(create_dummy_entity("ar-chemical-plant-1", "assembling-machine", "chemical-plant"))

ChemicalPlantGraphicsPack:configure({
	tint = tints.orange,
}):apply_to_entity(create_dummy_entity("ar-chemical-plant-2", "assembling-machine", "chemical-plant"))

ChemicalPlantGraphicsPack:configure({
	tint = tints.tahiti_blue,
}):apply_to_entity(create_dummy_entity("ar-chemical-plant-3", "assembling-machine", "chemical-plant"))

-- OIL REFINERY TESTS
local OilRefineryGraphicsPack = require("graphics-packs.oil-refinery-graphics-pack")

OilRefineryGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-oil-refinery-1", "assembling-machine", "oil-refinery"))

OilRefineryGraphicsPack:configure({
	tint = tints.red,
}):apply_to_entity(create_dummy_entity("ar-oil-refinery-2", "assembling-machine", "oil-refinery"))

-- TRANSPORT BELT TESTS
local _defines = require("api.defines")
local TransportBeltGraphicsPack = require("graphics-packs.transport-belt-graphics-pack")

TransportBeltGraphicsPack:configure({
	tint = tints.green,
	belt_sprite = _defines.belt_sprites.standard,
}):apply_to_entity(create_dummy_entity("ar-transport-belt-1", "transport-belt", "transport-belt"))

TransportBeltGraphicsPack:configure({
	tint = tints.tahiti_blue,
	belt_sprite = _defines.belt_sprites.fast,
}):apply_to_entity(create_dummy_entity("ar-transport-belt-2", "transport-belt", "fast-transport-belt"))

-- SPLITTER TESTS
local SplitterGraphicsPack = require("graphics-packs.splitter-graphics-pack")

SplitterGraphicsPack:configure({
	tint = tints.green,
	belt_sprite = _defines.belt_sprites.standard,
}):apply_to_entity(create_dummy_entity("ar-splitter-1", "splitter", "splitter"))

SplitterGraphicsPack:configure({
	tint = tints.tahiti_blue,
	belt_sprite = _defines.belt_sprites.fast,
}):apply_to_entity(create_dummy_entity("ar-splitter-2", "splitter", "fast-splitter"))

-- UNDERGROUND BELT TESTS
local UndergroundBeltGraphicsPack = require("graphics-packs.underground-belt-graphics-pack")

UndergroundBeltGraphicsPack:configure({
	tint = tints.green,
	belt_sprite = _defines.belt_sprites.standard,
}):apply_to_entity(create_dummy_entity("ar-underground-belt-1", "underground-belt", "underground-belt"))

UndergroundBeltGraphicsPack:configure({
	tint = tints.tahiti_blue,
	belt_sprite = _defines.belt_sprites.fast,
}):apply_to_entity(create_dummy_entity("ar-underground-belt-2", "underground-belt", "fast-underground-belt"))

-- STONE FURNACE TESTS
local FurnaceStoneGraphicsPack = require("graphics-packs.furnace-stone-graphics-pack")

FurnaceStoneGraphicsPack:configure({
	tint = tints.yellow,
	variant = "standard",
}):apply_to_entity(create_dummy_entity("ar-furnace-stone-1", "furnace", "stone-furnace"))

FurnaceStoneGraphicsPack:configure({
	tint = tints.red,
	variant = "chemical",
}):apply_to_entity(create_dummy_entity("ar-furnace-stone-2", "assembling-machine", "assembling-machine-1"))

-- STEEL FURNACE TESTS
local FurnaceSteelGraphicsPack = require("graphics-packs.furnace-steel-graphics-pack")

FurnaceSteelGraphicsPack:configure({
	tint = tints.yellow,
	variant = "standard",
}):apply_to_entity(create_dummy_entity("ar-furnace-steel-1", "furnace", "steel-furnace"))

FurnaceSteelGraphicsPack:configure({
	tint = tints.red,
	variant = "fluid",
}):apply_to_entity(create_dummy_entity("ar-furnace-steel-2", "furnace", "steel-furnace"))

FurnaceSteelGraphicsPack:configure({
	tint = tints.blue,
	variant = "chemical",
}):apply_to_entity(create_dummy_entity("ar-furnace-steel-3", "assembling-machine", "assembling-machine-1"))

FurnaceSteelGraphicsPack:configure({
	tint = tints.purple,
	variant = "chemical-fluid",
}):apply_to_entity(create_dummy_entity("ar-furnace-steel-4", "assembling-machine", "assembling-machine-1"))

-- ELECTRIC FURNACE TESTS
local FurnaceElectricGraphicsPack = require("graphics-packs.furnace-electric-graphics-pack")

FurnaceElectricGraphicsPack:configure({
	tint = tints.yellow,
	variant = "standard",
}):apply_to_entity(create_dummy_entity("ar-furnace-electric-1", "furnace", "electric-furnace"))

FurnaceElectricGraphicsPack:configure({
	tint = tints.green,
	variant = "mixing",
}):apply_to_entity(create_dummy_entity("ar-furnace-electric-2", "assembling-machine", "assembling-machine-1"))

FurnaceElectricGraphicsPack:configure({
	tint = tints.blue,
	variant = "chemical",
}):apply_to_entity(create_dummy_entity("ar-furnace-electric-3", "assembling-machine", "assembling-machine-1"))

FurnaceElectricGraphicsPack:configure({
	tint = tints.purple,
	variant = "chemical-mixing",
}):apply_to_entity(create_dummy_entity("ar-furnace-electric-4", "assembling-machine", "assembling-machine-1"))

-- BOILER TESTS
local BoilerGraphicsPack = require("graphics-packs.boiler-graphics-pack")

BoilerGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-boiler-1", "boiler", "boiler"))

BoilerGraphicsPack:configure({
	tint = tints.red,
}):apply_to_entity(create_dummy_entity("ar-boiler-2", "boiler", "boiler"))

BoilerGraphicsPack:configure({
	tint = tints.blue,
}):apply_to_entity(create_dummy_entity("ar-boiler-3", "boiler", "boiler"))

BoilerGraphicsPack:configure({
	tint = tints.purple,
}):apply_to_entity(create_dummy_entity("ar-boiler-4", "boiler", "boiler"))

BoilerGraphicsPack:configure({
	tint = tints.green,
}):apply_to_entity(create_dummy_entity("ar-boiler-5", "boiler", "boiler"))
