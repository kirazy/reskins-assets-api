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
local AssemblingMachineGraphicsPack = require("graphics-packs.base.assembling-machine-graphics-pack")

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
local InductionFurnaceGraphicsPack = require("graphics-packs.angels.smelting.induction-furnace-graphics-pack")

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
add_fluid_box(induction_furnace_2, defines.direction.south, { -2, 2 })
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
local AccumulatorGraphicsPack = require("graphics-packs.base.accumulator-graphics-pack")
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
local CentrifugeGraphicsPack = require("graphics-packs.base.centrifuge-graphics-pack")

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
local ChemicalPlantGraphicsPack = require("graphics-packs.base.chemical-plant-graphics-pack")

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
local OilRefineryGraphicsPack = require("graphics-packs.base.oil-refinery-graphics-pack")

OilRefineryGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-oil-refinery-1", "assembling-machine", "oil-refinery"))

OilRefineryGraphicsPack:configure({
	tint = tints.red,
}):apply_to_entity(create_dummy_entity("ar-oil-refinery-2", "assembling-machine", "oil-refinery"))

-- TRANSPORT BELT TESTS
local _defines = require("api.defines")
local TransportBeltGraphicsPack = require("graphics-packs.base.transport-belt-graphics-pack")

TransportBeltGraphicsPack:configure({
	tint = tints.green,
	belt_sprite = _defines.belt_sprites.standard,
}):apply_to_entity(create_dummy_entity("ar-transport-belt-1", "transport-belt", "transport-belt"))

TransportBeltGraphicsPack:configure({
	tint = tints.tahiti_blue,
	belt_sprite = _defines.belt_sprites.fast,
}):apply_to_entity(create_dummy_entity("ar-transport-belt-2", "transport-belt", "fast-transport-belt"))

-- SPLITTER TESTS
local SplitterGraphicsPack = require("graphics-packs.base.splitter-graphics-pack")

SplitterGraphicsPack:configure({
	tint = tints.green,
	belt_sprite = _defines.belt_sprites.standard,
}):apply_to_entity(create_dummy_entity("ar-splitter-1", "splitter", "splitter"))

SplitterGraphicsPack:configure({
	tint = tints.tahiti_blue,
	belt_sprite = _defines.belt_sprites.fast,
}):apply_to_entity(create_dummy_entity("ar-splitter-2", "splitter", "fast-splitter"))

-- UNDERGROUND BELT TESTS
local UndergroundBeltGraphicsPack = require("graphics-packs.base.underground-belt-graphics-pack")

UndergroundBeltGraphicsPack:configure({
	tint = tints.green,
	belt_sprite = _defines.belt_sprites.standard,
}):apply_to_entity(create_dummy_entity("ar-underground-belt-1", "underground-belt", "underground-belt"))

UndergroundBeltGraphicsPack:configure({
	tint = tints.tahiti_blue,
	belt_sprite = _defines.belt_sprites.fast,
}):apply_to_entity(create_dummy_entity("ar-underground-belt-2", "underground-belt", "fast-underground-belt"))

-- STONE FURNACE TESTS
local FurnaceStoneGraphicsPack = require("graphics-packs.base.furnace-stone-graphics-pack")

FurnaceStoneGraphicsPack:configure({
	tint = tints.yellow,
	variant = "standard",
}):apply_to_entity(create_dummy_entity("ar-furnace-stone-1", "furnace", "stone-furnace"))

FurnaceStoneGraphicsPack:configure({
	tint = tints.red,
	variant = "chemical",
}):apply_to_entity(create_dummy_entity("ar-furnace-stone-2", "assembling-machine", "assembling-machine-1"))

-- STEEL FURNACE TESTS
local FurnaceSteelGraphicsPack = require("graphics-packs.base.furnace-steel-graphics-pack")

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
local FurnaceElectricGraphicsPack = require("graphics-packs.base.furnace-electric-graphics-pack")

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
local BoilerGraphicsPack = require("graphics-packs.base.boiler-graphics-pack")

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

-- HEAT EXCHANGER TESTS
local HeatExchangerGraphicsPack = require("graphics-packs.base.heat-exchanger-graphics-pack")

HeatExchangerGraphicsPack:configure({
	tint = tints.yellow,
	pipe_material = "base",
}):apply_to_entity(create_dummy_entity("ar-heat-exchanger-1", "boiler", "heat-exchanger"))

HeatExchangerGraphicsPack:configure({
	tint = tints.red,
	pipe_material = "aluminum-invar",
}):apply_to_entity(create_dummy_entity("ar-heat-exchanger-2", "boiler", "heat-exchanger"))

HeatExchangerGraphicsPack:configure({
	tint = tints.blue,
	pipe_material = "silver-aluminum",
}):apply_to_entity(create_dummy_entity("ar-heat-exchanger-3", "boiler", "heat-exchanger"))

HeatExchangerGraphicsPack:configure({
	tint = tints.purple,
	pipe_material = "silver-titanium",
}):apply_to_entity(create_dummy_entity("ar-heat-exchanger-4", "boiler", "heat-exchanger"))

HeatExchangerGraphicsPack:configure({
	tint = tints.green,
	pipe_material = "gold-copper",
}):apply_to_entity(create_dummy_entity("ar-heat-exchanger-5", "boiler", "heat-exchanger"))

-- STEAM ENGINE TESTS
local SteamEngineGraphicsPack = require("graphics-packs.base.steam-engine-graphics-pack")

SteamEngineGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-steam-engine-1", "generator", "steam-engine"))

-- STEAM TURBINE TESTS
local SteamTurbineGraphicsPack = require("graphics-packs.base.steam-turbine-graphics-pack")

SteamTurbineGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-steam-turbine-1", "generator", "steam-turbine"))

-- NUCLEAR REACTOR TESTS
local NuclearReactorGraphicsPack = require("graphics-packs.base.nuclear-reactor-graphics-pack")

NuclearReactorGraphicsPack:configure({
	tint = tints.yellow,
	pipe_material = "base",
}):apply_to_entity(create_dummy_entity("ar-nuclear-reactor-1", "reactor", "nuclear-reactor"))

NuclearReactorGraphicsPack:configure({
	tint = tints.red,
	pipe_material = "aluminum-invar",
}):apply_to_entity(create_dummy_entity("ar-nuclear-reactor-2", "reactor", "nuclear-reactor"))

NuclearReactorGraphicsPack:configure({
	tint = tints.blue,
	pipe_material = "silver-aluminum",
}):apply_to_entity(create_dummy_entity("ar-nuclear-reactor-3", "reactor", "nuclear-reactor"))

NuclearReactorGraphicsPack:configure({
	tint = tints.purple,
	pipe_material = "silver-titanium",
}):apply_to_entity(create_dummy_entity("ar-nuclear-reactor-4", "reactor", "nuclear-reactor"))

NuclearReactorGraphicsPack:configure({
	tint = tints.orange,
	pipe_material = "gold-copper",
}):apply_to_entity(create_dummy_entity("ar-nuclear-reactor-5", "reactor", "nuclear-reactor"))

-- SOLAR PANEL TESTS
local SolarPanelGraphicsPack = require("graphics-packs.base.solar-panel-graphics-pack")

SolarPanelGraphicsPack:configure({
	tint = tints.yellow,
	variant = "small",
}):apply_to_entity(create_dummy_entity("ar-solar-panel-small-1", "solar-panel", "solar-panel"))

SolarPanelGraphicsPack:configure({
	tint = tints.red,
	variant = "standard",
}):apply_to_entity(create_dummy_entity("ar-solar-panel-1", "solar-panel", "solar-panel"))

SolarPanelGraphicsPack:configure({
	tint = tints.blue,
	variant = "large",
}):apply_to_entity(create_dummy_entity("ar-solar-panel-large-1", "solar-panel", "solar-panel"))

-- SUBSTATION TESTS
local SubstationGraphicsPack = require("graphics-packs.base.substation-graphics-pack")

SubstationGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-substation-1", "electric-pole", "substation"))

SubstationGraphicsPack:configure({
	tint = tints.red,
}):apply_to_entity(create_dummy_entity("ar-substation-2", "electric-pole", "substation"))

SubstationGraphicsPack:configure({
	tint = tints.blue,
}):apply_to_entity(create_dummy_entity("ar-substation-3", "electric-pole", "substation"))

SubstationGraphicsPack:configure({
	tint = tints.purple,
}):apply_to_entity(create_dummy_entity("ar-substation-4", "electric-pole", "substation"))

-- ELECTRIC POLE BIG TESTS
local ElectricPoleBigGraphicsPack = require("graphics-packs.base.electric-pole-big-graphics-pack")

ElectricPoleBigGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-big-electric-pole-1", "electric-pole", "big-electric-pole"))

ElectricPoleBigGraphicsPack:configure({
	tint = tints.red,
}):apply_to_entity(create_dummy_entity("ar-big-electric-pole-2", "electric-pole", "big-electric-pole"))

ElectricPoleBigGraphicsPack:configure({
	tint = tints.blue,
}):apply_to_entity(create_dummy_entity("ar-big-electric-pole-3", "electric-pole", "big-electric-pole"))

ElectricPoleBigGraphicsPack:configure({
	tint = tints.purple,
}):apply_to_entity(create_dummy_entity("ar-big-electric-pole-4", "electric-pole", "big-electric-pole"))

-- ELECTRIC POLE MEDIUM TESTS
local ElectricPoleMediumGraphicsPack = require("graphics-packs.base.electric-pole-medium-graphics-pack")

ElectricPoleMediumGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-medium-electric-pole-1", "electric-pole", "medium-electric-pole"))

ElectricPoleMediumGraphicsPack:configure({
	tint = tints.red,
}):apply_to_entity(create_dummy_entity("ar-medium-electric-pole-2", "electric-pole", "medium-electric-pole"))

ElectricPoleMediumGraphicsPack:configure({
	tint = tints.blue,
}):apply_to_entity(create_dummy_entity("ar-medium-electric-pole-3", "electric-pole", "medium-electric-pole"))

ElectricPoleMediumGraphicsPack:configure({
	tint = tints.purple,
}):apply_to_entity(create_dummy_entity("ar-medium-electric-pole-4", "electric-pole", "medium-electric-pole"))

-- RADAR TESTS
local RadarGraphicsPack = require("graphics-packs.base.radar-graphics-pack")

RadarGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-radar-1", "radar", "radar"))

RadarGraphicsPack:configure({
	tint = tints.red,
}):apply_to_entity(create_dummy_entity("ar-radar-2", "radar", "radar"))

RadarGraphicsPack:configure({
	tint = tints.blue,
}):apply_to_entity(create_dummy_entity("ar-radar-3", "radar", "radar"))

RadarGraphicsPack:configure({
	tint = tints.purple,
}):apply_to_entity(create_dummy_entity("ar-radar-4", "radar", "radar"))

RadarGraphicsPack:configure({
	tint = tints.green,
}):apply_to_entity(create_dummy_entity("ar-radar-5", "radar", "radar"))

-- STORAGE TANK TESTS
local StorageTankGraphicsPack = require("graphics-packs.base.storage-tank-graphics-pack")

StorageTankGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-storage-tank-1", "storage-tank", "storage-tank"))

StorageTankGraphicsPack:configure({
	tint = tints.red,
}):apply_to_entity(create_dummy_entity("ar-storage-tank-2", "storage-tank", "storage-tank"))

StorageTankGraphicsPack:configure({
	tint = tints.blue,
}):apply_to_entity(create_dummy_entity("ar-storage-tank-3", "storage-tank", "storage-tank"))

StorageTankGraphicsPack:configure({
	tint = tints.purple,
}):apply_to_entity(create_dummy_entity("ar-storage-tank-4", "storage-tank", "storage-tank"))

-- PUMP TESTS
local PumpGraphicsPack = require("graphics-packs.base.pump-graphics-pack")

PumpGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-pump-1", "pump", "pump"))

PumpGraphicsPack:configure({
	tint = tints.red,
}):apply_to_entity(create_dummy_entity("ar-pump-2", "pump", "pump"))

PumpGraphicsPack:configure({
	tint = tints.blue,
}):apply_to_entity(create_dummy_entity("ar-pump-3", "pump", "pump"))

PumpGraphicsPack:configure({
	tint = tints.purple,
}):apply_to_entity(create_dummy_entity("ar-pump-4", "pump", "pump"))

-- BEACON TESTS
local BeaconGraphicsPack = require("graphics-packs.base.beacon-graphics-pack")

BeaconGraphicsPack:configure({
	tint = tints.yellow,
	variant = "2-slots",
}):apply_to_entity(create_dummy_entity("ar-beacon-1", "beacon", "beacon"))

BeaconGraphicsPack:configure({
	tint = tints.red,
	variant = "4-slots",
}):apply_to_entity(create_dummy_entity("ar-beacon-2", "beacon", "beacon"))

BeaconGraphicsPack:configure({
	tint = tints.blue,
	variant = "6-slots",
}):apply_to_entity(create_dummy_entity("ar-beacon-3", "beacon", "beacon"))

-- CONSTRUCTION ROBOT TESTS
local RobotConstructionGraphicsPack = require("graphics-packs.base.robot-construction-graphics-pack")

RobotConstructionGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-construction-robot-1", "construction-robot", "construction-robot"))

RobotConstructionGraphicsPack:configure({
	tint = tints.red,
}):apply_to_entity(create_dummy_entity("ar-construction-robot-2", "construction-robot", "construction-robot"))

RobotConstructionGraphicsPack:configure({
	tint = tints.blue,
}):apply_to_entity(create_dummy_entity("ar-construction-robot-3", "construction-robot", "construction-robot"))

RobotConstructionGraphicsPack:configure({
	tint = tints.purple,
}):apply_to_entity(create_dummy_entity("ar-construction-robot-4", "construction-robot", "construction-robot"))

RobotConstructionGraphicsPack:configure({
	tint = tints.green,
}):apply_to_entity(create_dummy_entity("ar-construction-robot-5", "construction-robot", "construction-robot"))

-- LOGISTIC ROBOT TESTS
local RobotLogisticGraphicsPack = require("graphics-packs.base.robot-logistic-graphics-pack")

RobotLogisticGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-logistic-robot-1", "logistic-robot", "logistic-robot"))

RobotLogisticGraphicsPack:configure({
	tint = tints.red,
}):apply_to_entity(create_dummy_entity("ar-logistic-robot-2", "logistic-robot", "logistic-robot"))

RobotLogisticGraphicsPack:configure({
	tint = tints.blue,
}):apply_to_entity(create_dummy_entity("ar-logistic-robot-3", "logistic-robot", "logistic-robot"))

RobotLogisticGraphicsPack:configure({
	tint = tints.purple,
}):apply_to_entity(create_dummy_entity("ar-logistic-robot-4", "logistic-robot", "logistic-robot"))

RobotLogisticGraphicsPack:configure({
	tint = tints.green,
}):apply_to_entity(create_dummy_entity("ar-logistic-robot-5", "logistic-robot", "logistic-robot"))

-- ROBOPORT TESTS
local RoboportGraphicsPack = require("graphics-packs.base.roboport-graphics-pack")

RoboportGraphicsPack:configure({
	tint = tints.gray,
	antenna_variant = 0,
	door_variant = 0,
}):apply_to_entity(create_dummy_entity("ar-roboport-0", "roboport", "roboport"))

RoboportGraphicsPack:configure({
	tint = tints.yellow,
	antenna_variant = 1,
	door_variant = 1,
}):apply_to_entity(create_dummy_entity("ar-roboport-1", "roboport", "roboport"))

RoboportGraphicsPack:configure({
	tint = tints.red,
	antenna_variant = 2,
	door_variant = 2,
}):apply_to_entity(create_dummy_entity("ar-roboport-2", "roboport", "roboport"))

RoboportGraphicsPack:configure({
	tint = tints.blue,
	antenna_variant = 3,
	door_variant = 3,
}):apply_to_entity(create_dummy_entity("ar-roboport-3", "roboport", "roboport"))

RoboportGraphicsPack:configure({
	tint = tints.purple,
	antenna_variant = 4,
	door_variant = 4,
}):apply_to_entity(create_dummy_entity("ar-roboport-4", "roboport", "roboport"))

-- INSERTER TESTS (Group 1 — tintable, three-layer)
local InserterGraphicsPack = require("graphics-packs.base.inserter-graphics-pack")

InserterGraphicsPack:configure({
	tint = tints.yellow,
	variant = "inserter",
}):apply_to_entity(create_dummy_entity("ar-inserter", "inserter", "inserter"))

InserterGraphicsPack:configure({
	tint = tints.red,
	variant = "inserter-long",
}):apply_to_entity(create_dummy_entity("ar-inserter-long", "inserter", "long-handed-inserter"))

InserterGraphicsPack:configure({
	tint = tints.blue,
	variant = "inserter-filter",
}):apply_to_entity(create_dummy_entity("ar-inserter-filter", "inserter", "fast-inserter"))

InserterGraphicsPack:configure({
	tint = tints.purple,
	variant = "inserter-filter-long",
}):apply_to_entity(create_dummy_entity("ar-inserter-filter-long", "inserter", "fast-inserter"))

InserterGraphicsPack:configure({
	tint = tints.green,
	variant = "inserter-bulk",
}):apply_to_entity(create_dummy_entity("ar-inserter-bulk", "inserter", "bulk-inserter"))

InserterGraphicsPack:configure({
	tint = tints.orange,
	variant = "inserter-bulk-filter",
}):apply_to_entity(create_dummy_entity("ar-inserter-bulk-filter", "inserter", "bulk-inserter"))

-- INSERTER TESTS (Group 2 — fixed-color presets)
local InserterPresetGraphicsPack = require("graphics-packs.base.inserter-preset-graphics-pack")

InserterPresetGraphicsPack:configure({
	preset = "inserter",
}):apply_to_entity(create_dummy_entity("ar-inserter-preset-standard", "inserter", "inserter"))

InserterPresetGraphicsPack:configure({
	preset = "inserter",
	is_long = true,
}):apply_to_entity(create_dummy_entity("ar-inserter-preset-standard-long", "inserter", "inserter"))

InserterPresetGraphicsPack:configure({
	preset = "inserter-burner",
}):apply_to_entity(create_dummy_entity("ar-inserter-preset-burner", "inserter", "burner-inserter"))

InserterPresetGraphicsPack:configure({
	preset = "inserter-fast",
}):apply_to_entity(create_dummy_entity("ar-inserter-preset-fast", "inserter", "fast-inserter"))

InserterPresetGraphicsPack:configure({
	preset = "inserter-express",
}):apply_to_entity(create_dummy_entity("ar-inserter-preset-express", "inserter", "fast-inserter"))

InserterPresetGraphicsPack:configure({
	preset = "inserter-filter",
}):apply_to_entity(create_dummy_entity("ar-inserter-preset-filter", "inserter", "fast-inserter"))

InserterPresetGraphicsPack:configure({
	preset = "inserter-express-filter",
}):apply_to_entity(create_dummy_entity("ar-inserter-preset-express-filter", "inserter", "fast-inserter"))

InserterPresetGraphicsPack:configure({
	preset = "inserter-long-handed",
}):apply_to_entity(create_dummy_entity("ar-inserter-preset-long-handed", "inserter", "long-handed-inserter"))

InserterPresetGraphicsPack:configure({
	preset = "inserter-bulk",
}):apply_to_entity(create_dummy_entity("ar-inserter-preset-bulk", "inserter", "bulk-inserter"))

InserterPresetGraphicsPack:configure({
	preset = "inserter-express-bulk",
}):apply_to_entity(create_dummy_entity("ar-inserter-preset-express-bulk", "inserter", "bulk-inserter"))

InserterPresetGraphicsPack:configure({
	preset = "inserter-bulk-filter",
}):apply_to_entity(create_dummy_entity("ar-inserter-preset-bulk-filter", "inserter", "bulk-inserter"))

InserterPresetGraphicsPack:configure({
	preset = "inserter-express-bulk-filter",
}):apply_to_entity(create_dummy_entity("ar-inserter-preset-express-bulk-filter", "inserter", "bulk-inserter"))

-- ============================================================
-- ANGELS SMELTING TESTS
-- ============================================================

-- CHEMICAL FURNACE TESTS
local ChemicalFurnaceGraphicsPack = require("graphics-packs.angels.smelting.chemical-furnace-graphics-pack")

ChemicalFurnaceGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-smelting-chemical-furnace-1", "assembling-machine", "assembling-machine-1"))

ChemicalFurnaceGraphicsPack:configure({
	tint = tints.blue,
}):apply_to_entity(create_dummy_entity("ar-smelting-chemical-furnace-2", "assembling-machine", "assembling-machine-1"))

-- ORE PROCESSING MACHINE TESTS
local OreProcessingMachineGraphicsPack = require("graphics-packs.angels.smelting.ore-processing-machine-graphics-pack")

OreProcessingMachineGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(
	create_dummy_entity("ar-smelting-ore-processing-machine-1", "assembling-machine", "assembling-machine-1")
)

OreProcessingMachineGraphicsPack:configure({
	tint = tints.red,
}):apply_to_entity(
	create_dummy_entity("ar-smelting-ore-processing-machine-2", "assembling-machine", "assembling-machine-1")
)

-- POWDER MIXER TESTS
local PowderMixerGraphicsPack = require("graphics-packs.angels.smelting.powder-mixer-graphics-pack")

PowderMixerGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-smelting-powder-mixer-1", "assembling-machine", "assembling-machine-1"))

PowderMixerGraphicsPack:configure({
	tint = tints.purple,
}):apply_to_entity(create_dummy_entity("ar-smelting-powder-mixer-2", "assembling-machine", "assembling-machine-1"))

-- SINTERING OVEN TESTS
local SinteringOvenGraphicsPack = require("graphics-packs.angels.smelting.sintering-over-graphics-pack")

SinteringOvenGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-smelting-sintering-oven-1", "assembling-machine", "assembling-machine-1"))

SinteringOvenGraphicsPack:configure({
	tint = tints.green,
}):apply_to_entity(create_dummy_entity("ar-smelting-sintering-oven-2", "assembling-machine", "assembling-machine-1"))

-- PELLET PRESS TESTS
local PelletPressGraphicsPack = require("graphics-packs.angels.smelting.pellet-press-graphics-pack")

PelletPressGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-smelting-pellet-press-1", "assembling-machine", "assembling-machine-1"))

PelletPressGraphicsPack:configure({
	tint = tints.orange,
}):apply_to_entity(create_dummy_entity("ar-smelting-pellet-press-2", "assembling-machine", "assembling-machine-1"))

-- BLAST FURNACE TESTS
local BlastFurnaceGraphicsPack = require("graphics-packs.angels.smelting.blast-furnace-graphics-pack")

BlastFurnaceGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-smelting-blast-furnace-1", "assembling-machine", "assembling-machine-1"))

BlastFurnaceGraphicsPack:configure({
	tint = tints.red,
}):apply_to_entity(create_dummy_entity("ar-smelting-blast-furnace-2", "assembling-machine", "assembling-machine-1"))

-- CASTING MACHINE TESTS
local CastingMachineGraphicsPack = require("graphics-packs.angels.smelting.casting-machine-graphics-pack")

local casting_machine_1 =
	create_dummy_entity("ar-smelting-casting-machine-1", "assembling-machine", "assembling-machine-1")
CastingMachineGraphicsPack:configure({ tint = tints.yellow }):apply_to_entity(casting_machine_1)

local casting_machine_2 =
	create_dummy_entity("ar-smelting-casting-machine-2", "assembling-machine", "assembling-machine-1")
casting_machine_2.forced_symmetry = "horizontal"
CastingMachineGraphicsPack:configure({ tint = tints.red }):apply_to_entity(casting_machine_2)

-- STRAND CASTING MACHINE TESTS
local StrandCastingMachineGraphicsPack = require("graphics-packs.angels.smelting.strand-casting-machine-graphics-pack")

StrandCastingMachineGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(
	create_dummy_entity("ar-smelting-strand-casting-machine-1", "assembling-machine", "assembling-machine-1")
)

StrandCastingMachineGraphicsPack:configure({
	tint = tints.blue,
}):apply_to_entity(
	create_dummy_entity("ar-smelting-strand-casting-machine-2", "assembling-machine", "assembling-machine-1")
)

-- ============================================================
-- ANGELS REFINING TESTS
-- ============================================================

-- WASHING PLANT TESTS
local WashingPlantGraphicsPack = require("graphics-packs.angels.refining.washing-plant-graphics-pack")

WashingPlantGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-refining-washing-plant-1", "assembling-machine", "assembling-machine-1"))

WashingPlantGraphicsPack:configure({
	tint = tints.blue,
}):apply_to_entity(create_dummy_entity("ar-refining-washing-plant-2", "assembling-machine", "assembling-machine-1"))

-- SALINATION PLANT TESTS
local SalinationPlantGraphicsPack = require("graphics-packs.angels.refining.salination-plant-graphics-pack")

SalinationPlantGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-refining-salination-plant-1", "assembling-machine", "assembling-machine-1"))

SalinationPlantGraphicsPack:configure({
	tint = tints.red,
}):apply_to_entity(create_dummy_entity("ar-refining-salination-plant-2", "assembling-machine", "assembling-machine-1"))

-- ORE SORTING FACILITY TESTS
local OreSortingFacilityGraphicsPack = require("graphics-packs.angels.refining.ore-sorting-facility-graphics-pack")

OreSortingFacilityGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(
	create_dummy_entity("ar-refining-ore-sorting-facility-1", "assembling-machine", "assembling-machine-1")
)

OreSortingFacilityGraphicsPack:configure({
	tint = tints.green,
}):apply_to_entity(
	create_dummy_entity("ar-refining-ore-sorting-facility-2", "assembling-machine", "assembling-machine-1")
)

-- ORE POWDERIZER TESTS
local PowderizerGraphicsPack = require("graphics-packs.angels.refining.powderizer-graphics-pack")

PowderizerGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-refining-powderizer-1", "assembling-machine", "assembling-machine-1"))

PowderizerGraphicsPack:configure({
	tint = tints.purple,
}):apply_to_entity(create_dummy_entity("ar-refining-powderizer-2", "assembling-machine", "assembling-machine-1"))

-- ORE LEACHING PLANT TESTS
local OreLeachingPlantGraphicsPack = require("graphics-packs.angels.refining.ore-leaching-plant-graphics-pack")

OreLeachingPlantGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(
	create_dummy_entity("ar-refining-ore-leaching-plant-1", "assembling-machine", "assembling-machine-1")
)

OreLeachingPlantGraphicsPack:configure({
	tint = tints.blue,
}):apply_to_entity(
	create_dummy_entity("ar-refining-ore-leaching-plant-2", "assembling-machine", "assembling-machine-1")
)

-- ORE FLOTATION CELL TESTS
local OreFlotationCellGraphicsPack = require("graphics-packs.angels.refining.ore-flotation-cell-graphics-pack")

OreFlotationCellGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(
	create_dummy_entity("ar-refining-ore-flotation-cell-1", "assembling-machine", "assembling-machine-1")
)

OreFlotationCellGraphicsPack:configure({
	tint = tints.red,
}):apply_to_entity(
	create_dummy_entity("ar-refining-ore-flotation-cell-2", "assembling-machine", "assembling-machine-1")
)

-- ORE CRUSHER TESTS
local OreCrusherGraphicsPack = require("graphics-packs.angels.refining.ore-crusher-graphics-pack")

OreCrusherGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-refining-ore-crusher-1", "assembling-machine", "assembling-machine-1"))

OreCrusherGraphicsPack:configure({
	tint = tints.orange,
}):apply_to_entity(create_dummy_entity("ar-refining-ore-crusher-2", "assembling-machine", "assembling-machine-1"))

-- LIQUEFIER TESTS
local LiquefierGraphicsPack = require("graphics-packs.angels.refining.liquefier-graphics-pack")

LiquefierGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-refining-liquefier-1", "assembling-machine", "assembling-machine-1"))

LiquefierGraphicsPack:configure({
	tint = tints.tahiti_blue,
}):apply_to_entity(create_dummy_entity("ar-refining-liquefier-2", "assembling-machine", "assembling-machine-1"))

-- HYDRO PLANT TESTS
local HydroPlantGraphicsPack = require("graphics-packs.angels.refining.hydro-plant-graphics-pack")

HydroPlantGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-refining-hydro-plant-1", "assembling-machine", "assembling-machine-1"))

HydroPlantGraphicsPack:configure({
	tint = tints.blue,
}):apply_to_entity(create_dummy_entity("ar-refining-hydro-plant-2", "assembling-machine", "assembling-machine-1"))

-- ELECTRO-WINNING CELL TESTS
local ElectroWinningCellGraphicsPack = require("graphics-packs.angels.refining.electro-winning-cell-graphics-pack")

ElectroWinningCellGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(
	create_dummy_entity("ar-refining-electro-winning-cell-1", "assembling-machine", "assembling-machine-1")
)

ElectroWinningCellGraphicsPack:configure({
	tint = tints.red,
}):apply_to_entity(
	create_dummy_entity("ar-refining-electro-winning-cell-2", "assembling-machine", "assembling-machine-1")
)

-- CRYSTALLIZER TESTS
local CrystallizerGraphicsPack = require("graphics-packs.angels.refining.crystallizer-graphics-pack")

CrystallizerGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-refining-crystallizer-1", "assembling-machine", "assembling-machine-1"))

CrystallizerGraphicsPack:configure({
	tint = tints.purple,
}):apply_to_entity(create_dummy_entity("ar-refining-crystallizer-2", "assembling-machine", "assembling-machine-1"))

-- FILTRATION UNIT TESTS
local FiltrationUnitGraphicsPack = require("graphics-packs.angels.refining.filtration-unit-graphics-pack")

FiltrationUnitGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-refining-filtration-unit-1", "assembling-machine", "assembling-machine-1"))

FiltrationUnitGraphicsPack:configure({
	tint = tints.green,
}):apply_to_entity(create_dummy_entity("ar-refining-filtration-unit-2", "assembling-machine", "assembling-machine-1"))

-- ORE REFINERY TESTS
local OreRefineryGraphicsPack = require("graphics-packs.angels.refining.ore-refinery-graphics-pack")

OreRefineryGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-refining-ore-refinery-1", "assembling-machine", "assembling-machine-1"))

OreRefineryGraphicsPack:configure({
	tint = tints.red,
}):apply_to_entity(create_dummy_entity("ar-refining-ore-refinery-2", "assembling-machine", "assembling-machine-1"))

-- ============================================================
-- ANGELS PETROCHEM TESTS
-- ============================================================

-- STEAM CRACKER TESTS
local SteamCrackerGraphicsPack = require("graphics-packs.angels.petrochem.steam-cracker-graphics-pack")

SteamCrackerGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-petrochem-steam-cracker-1", "assembling-machine", "assembling-machine-1"))

SteamCrackerGraphicsPack:configure({
	tint = tints.blue,
}):apply_to_entity(create_dummy_entity("ar-petrochem-steam-cracker-2", "assembling-machine", "assembling-machine-1"))

-- SEPARATOR TESTS
local SeparatorGraphicsPack = require("graphics-packs.angels.petrochem.separator-graphics-pack")

SeparatorGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-petrochem-separator-1", "assembling-machine", "assembling-machine-1"))

SeparatorGraphicsPack:configure({
	tint = tints.red,
}):apply_to_entity(create_dummy_entity("ar-petrochem-separator-2", "assembling-machine", "assembling-machine-1"))

-- GAS REFINERY TESTS
local GasRefineryGraphicsPack = require("graphics-packs.angels.petrochem.gas-refinery-graphics-pack")

GasRefineryGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-petrochem-gas-refinery-1", "assembling-machine", "assembling-machine-1"))

GasRefineryGraphicsPack:configure({
	tint = tints.purple,
}):apply_to_entity(create_dummy_entity("ar-petrochem-gas-refinery-2", "assembling-machine", "assembling-machine-1"))

-- ELECTROLYSER TESTS
local ElectrolyserGraphicsPack = require("graphics-packs.angels.petrochem.electrolyser-graphics-pack")

ElectrolyserGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-petrochem-electrolyser-1", "assembling-machine", "assembling-machine-1"))

ElectrolyserGraphicsPack:configure({
	tint = tints.green,
}):apply_to_entity(create_dummy_entity("ar-petrochem-electrolyser-2", "assembling-machine", "assembling-machine-1"))

-- ELECTRIC BOILER TESTS
local ElectricBoilerGraphicsPack = require("graphics-packs.angels.petrochem.electric-boiler-graphics-pack")

ElectricBoilerGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-petrochem-electric-boiler-1", "assembling-machine", "assembling-machine-1"))

ElectricBoilerGraphicsPack:configure({
	tint = tints.orange,
}):apply_to_entity(create_dummy_entity("ar-petrochem-electric-boiler-2", "assembling-machine", "assembling-machine-1"))

-- PETROCHEM CHEMICAL PLANT TESTS
local PetrochemChemicalPlantGraphicsPack = require("graphics-packs.angels.petrochem.chemical-plant-graphics-pack")

PetrochemChemicalPlantGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-petrochem-chemical-plant-1", "assembling-machine", "assembling-machine-1"))

PetrochemChemicalPlantGraphicsPack:configure({
	tint = tints.red,
}):apply_to_entity(create_dummy_entity("ar-petrochem-chemical-plant-2", "assembling-machine", "assembling-machine-1"))

-- AIR FILTER TESTS
local AirFilterGraphicsPack = require("graphics-packs.angels.petrochem.air-filter-graphics-pack")

AirFilterGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-petrochem-air-filter-1", "assembling-machine", "assembling-machine-1"))

AirFilterGraphicsPack:configure({
	tint = tints.blue,
}):apply_to_entity(create_dummy_entity("ar-petrochem-air-filter-2", "assembling-machine", "assembling-machine-1"))

-- ADVANCED GAS REFINERY TESTS
local AdvancedGasRefineryGraphicsPack = require("graphics-packs.angels.petrochem.advanced-gas-refinery-graphics-pack")

AdvancedGasRefineryGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(
	create_dummy_entity("ar-petrochem-advanced-gas-refinery-1", "assembling-machine", "assembling-machine-1")
)

AdvancedGasRefineryGraphicsPack:configure({
	tint = tints.purple,
}):apply_to_entity(
	create_dummy_entity("ar-petrochem-advanced-gas-refinery-2", "assembling-machine", "assembling-machine-1")
)

-- ADVANCED CHEMICAL PLANT TESTS
local AdvancedChemicalPlantGraphicsPack =
	require("graphics-packs.angels.petrochem.advanced-chemical-plant-graphics-pack")

AdvancedChemicalPlantGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(
	create_dummy_entity("ar-petrochem-advanced-chemical-plant-1", "assembling-machine", "assembling-machine-1")
)

AdvancedChemicalPlantGraphicsPack:configure({
	tint = tints.green,
}):apply_to_entity(
	create_dummy_entity("ar-petrochem-advanced-chemical-plant-2", "assembling-machine", "assembling-machine-1")
)

-- ============================================================
-- ANGELS BIOPROCESSING TESTS
-- ============================================================

-- SEED EXTRACTOR TESTS
local SeedExtractorGraphicsPack = require("graphics-packs.angels.bioprocessing.seed-extractor-graphics-pack")

SeedExtractorGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-bio-seed-extractor-1", "assembling-machine", "assembling-machine-1"))

SeedExtractorGraphicsPack:configure({
	tint = tints.green,
}):apply_to_entity(create_dummy_entity("ar-bio-seed-extractor-2", "assembling-machine", "assembling-machine-1"))

-- ALGAE FARM TESTS
local AlgaeFarmGraphicsPack = require("graphics-packs.angels.bioprocessing.algae-farm-graphics-pack")

AlgaeFarmGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-bio-algae-farm-1", "assembling-machine", "assembling-machine-1"))

AlgaeFarmGraphicsPack:configure({
	tint = tints.blue,
}):apply_to_entity(create_dummy_entity("ar-bio-algae-farm-2", "assembling-machine", "assembling-machine-1"))

-- PRESS TESTS
local OilPressGraphicsPack = require("graphics-packs.angels.bioprocessing.oil-press-graphics-pack")

OilPressGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-bio-press-1", "assembling-machine", "assembling-machine-1"))

OilPressGraphicsPack:configure({
	tint = tints.red,
}):apply_to_entity(create_dummy_entity("ar-bio-press-2", "assembling-machine", "assembling-machine-1"))

-- NUTRIENT EXTRACTOR TESTS
local NutrientExtractorGraphicsPack = require("graphics-packs.angels.bioprocessing.nutrient-extractor-graphics-pack")

NutrientExtractorGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-bio-nutrient-extractor-1", "assembling-machine", "assembling-machine-1"))

NutrientExtractorGraphicsPack:configure({
	tint = tints.purple,
}):apply_to_entity(create_dummy_entity("ar-bio-nutrient-extractor-2", "assembling-machine", "assembling-machine-1"))

-- COMPOSTER TESTS
local ComposterGraphicsPack = require("graphics-packs.angels.bioprocessing.composter-graphics-pack")

ComposterGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-bio-composter-1", "assembling-machine", "assembling-machine-1"))

ComposterGraphicsPack:configure({
	tint = tints.green,
}):apply_to_entity(create_dummy_entity("ar-bio-composter-2", "assembling-machine", "assembling-machine-1"))

-- BUTCHERY TESTS
local ButcheryGraphicsPack = require("graphics-packs.angels.bioprocessing.butchery-graphics-pack")

ButcheryGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-bio-butchery-1", "assembling-machine", "assembling-machine-1"))

ButcheryGraphicsPack:configure({
	tint = tints.red,
}):apply_to_entity(create_dummy_entity("ar-bio-butchery-2", "assembling-machine", "assembling-machine-1"))

-- PROCESSOR TESTS
local BioProcessorGraphicsPack = require("graphics-packs.angels.bioprocessing.bio-processor-graphics-pack")

BioProcessorGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-bio-processor-1", "assembling-machine", "assembling-machine-1"))

BioProcessorGraphicsPack:configure({
	tint = tints.blue,
}):apply_to_entity(create_dummy_entity("ar-bio-processor-2", "assembling-machine", "assembling-machine-1"))

-- HATCHERY TESTS
local HatcheryGraphicsPack = require("graphics-packs.angels.bioprocessing.hatchery-graphics-pack")

HatcheryGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-bio-hatchery-1", "assembling-machine", "assembling-machine-1"))

HatcheryGraphicsPack:configure({
	tint = tints.purple,
}):apply_to_entity(create_dummy_entity("ar-bio-hatchery-2", "assembling-machine", "assembling-machine-1"))

-- ARBORETUM TESTS
local ArboretumGraphicsPack = require("graphics-packs.angels.bioprocessing.arboretum-graphics-pack")

ArboretumGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(create_dummy_entity("ar-bio-arboretum-1", "assembling-machine", "assembling-machine-1"))

ArboretumGraphicsPack:configure({
	tint = tints.green,
}):apply_to_entity(create_dummy_entity("ar-bio-arboretum-2", "assembling-machine", "assembling-machine-1"))

-- TREE GENERATOR TESTS
local TreeGeneratorGraphicsPack = require("graphics-packs.angels.bioprocessing.tree-generator-graphics-pack")

TreeGeneratorGraphicsPack:configure({
	tint = tints.yellow,
	variant = "temperate",
}):apply_to_entity(create_dummy_entity("ar-bio-tree-generator-temperate", "assembling-machine", "assembling-machine-1"))

TreeGeneratorGraphicsPack:configure({
	tint = tints.orange,
	variant = "desert",
}):apply_to_entity(create_dummy_entity("ar-bio-tree-generator-desert", "assembling-machine", "assembling-machine-1"))

TreeGeneratorGraphicsPack:configure({
	tint = tints.blue,
	variant = "swamp",
}):apply_to_entity(create_dummy_entity("ar-bio-tree-generator-swamp", "assembling-machine", "assembling-machine-1"))

-- REFUGIUM TESTS
local RefugiumFishGraphicsPack = require("graphics-packs.angels.bioprocessing.refugium-fish-graphics-pack")
RefugiumFishGraphicsPack:configure({
	tint = tints.blue,
}):apply_to_entity(create_dummy_entity("ar-bio-refugium-fish", "assembling-machine", "assembling-machine-1"))

local RefugiumPufferGraphicsPack = require("graphics-packs.angels.bioprocessing.refugium-puffer-graphics-pack")
RefugiumPufferGraphicsPack:configure({
	tint = tints.purple,
}):apply_to_entity(create_dummy_entity("ar-bio-refugium-puffer", "assembling-machine", "assembling-machine-1"))

local RefugiumBiterGraphicsPack = require("graphics-packs.angels.bioprocessing.refugium-biter-graphics-pack")
RefugiumBiterGraphicsPack:configure({
	tint = tints.red,
}):apply_to_entity(create_dummy_entity("ar-bio-refugium-biter", "assembling-machine", "assembling-machine-1"))

-- CROP FARM TESTS
local CropFarmGraphicsPack = require("graphics-packs.angels.bioprocessing.crop-farm-graphics-pack")

CropFarmGraphicsPack:configure({
	tint = tints.yellow,
	variant = "basic",
}):apply_to_entity(create_dummy_entity("ar-bio-crop-farm-basic", "assembling-machine", "assembling-machine-1"))

CropFarmGraphicsPack:configure({
	tint = tints.green,
	variant = "temperate",
}):apply_to_entity(create_dummy_entity("ar-bio-crop-farm-temperate", "assembling-machine", "assembling-machine-1"))

CropFarmGraphicsPack:configure({
	tint = tints.orange,
	variant = "desert",
}):apply_to_entity(create_dummy_entity("ar-bio-crop-farm-desert", "assembling-machine", "assembling-machine-1"))

CropFarmGraphicsPack:configure({
	tint = tints.blue,
	variant = "swamp",
}):apply_to_entity(create_dummy_entity("ar-bio-crop-farm-swamp", "assembling-machine", "assembling-machine-1"))
