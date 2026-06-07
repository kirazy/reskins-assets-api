if not mods["boblibrary"] then
	return
end

local tints = require("reference_tints")

-- stylua: ignore end
local AssemblingMachineGraphicsPack = require("graphics-packs.base.assembling-machine-graphics-pack")
local assembling_machines = {
	["assembling-machine-1"] = { tint = tints.cobalt_blue, machine_tier = 1 },
	["assembling-machine-2"] = { tint = tints.cerulean, machine_tier = 2 },
	["assembling-machine-3"] = { tint = tints.lime_green, machine_tier = 3 },
	["bob-assembling-machine-4"] = { tint = tints.golden_yellow, machine_tier = 4 },
	["bob-assembling-machine-5"] = { tint = tints.vermilion, machine_tier = 5 },
	["bob-assembling-machine-6"] = { tint = tints.orange, machine_tier = 6 },
	["bob-electronics-machine-1"] = { tint = tints.cobalt_blue, machine_tier = 2, use_electronics_set = true },
	["bob-electronics-machine-2"] = { tint = tints.lime_green, machine_tier = 4, use_electronics_set = true },
	["bob-electronics-machine-3"] = { tint = tints.vermilion, machine_tier = 6, use_electronics_set = true },
	["bob-steam-assembling-machine"] = { tint = tints.white, machine_tier = 1 },
	["bob-burner-assembling-machine"] = { tint = tints.black, machine_tier = 1 },
}
-- stylua: ignore end

for name, params in pairs(assembling_machines) do
	AssemblingMachineGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local AccumulatorGraphicsPack = require("graphics-packs.base.accumulator-graphics-pack")
local accumulators = {
	["accumulator"] = { tint = tints.cobalt_blue, sprite_set = "high-capacity" },
	["bob-large-accumulator-2"] = { tint = tints.cerulean, sprite_set = "high-capacity" },
	["bob-large-accumulator-3"] = { tint = tints.lime_green, sprite_set = "high-capacity" },
	["bob-slow-accumulator"] = { tint = tints.cobalt_blue, sprite_set = "slow" },
	["bob-slow-accumulator-2"] = { tint = tints.cerulean, sprite_set = "slow" },
	["bob-slow-accumulator-3"] = { tint = tints.lime_green, sprite_set = "slow" },
	["bob-fast-accumulator"] = { tint = tints.cobalt_blue, sprite_set = "fast" },
	["bob-fast-accumulator-2"] = { tint = tints.cerulean, sprite_set = "fast" },
	["bob-fast-accumulator-3"] = { tint = tints.lime_green, sprite_set = "fast" },
}

for name, params in pairs(accumulators) do
	AccumulatorGraphicsPack:configure(params):try_apply_to_entity(data.raw["accumulator"][name])
end

local CentrifugeGraphicsPack = require("graphics-packs.base.centrifuge-graphics-pack")
local centrifuges = {
	["centrifuge"] = { tint = tints.cobalt_blue },
	["bob-centrifuge-2"] = { tint = tints.cerulean },
	["bob-centrifuge-3"] = { tint = tints.lime_green },
}

for name, params in pairs(centrifuges) do
	CentrifugeGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local ChemicalPlantGraphicsPack = require("graphics-packs.base.chemical-plant-graphics-pack")
local chemical_plants = {
	["chemical-plant"] = { tint = tints.cobalt_blue },
	["bob-chemical-plant-2"] = { tint = tints.cerulean },
	["bob-chemical-plant-3"] = { tint = tints.lime_green },
	["bob-chemical-plant-4"] = { tint = tints.golden_yellow },
}

for name, params in pairs(chemical_plants) do
	ChemicalPlantGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local OilRefineryGraphicsPack = require("graphics-packs.base.oil-refinery-graphics-pack")
local oil_refineries = {
	["oil-refinery"] = { tint = tints.cobalt_blue },
	["bob-oil-refinery-2"] = { tint = tints.cerulean },
	["bob-oil-refinery-3"] = { tint = tints.lime_green },
	["bob-oil-refinery-4"] = { tint = tints.golden_yellow },
	["angels-oil-refinery-2"] = { tint = tints.cerulean },
	["angels-oil-refinery-3"] = { tint = tints.lime_green },
	["angels-oil-refinery-4"] = { tint = tints.golden_yellow },
}

for name, params in pairs(oil_refineries) do
	OilRefineryGraphicsPack:configure(params):try_apply_to_entity(data.raw["assembling-machine"][name])
end

local TransportBeltGraphicsPack = require("graphics-packs.base.transport-belt-graphics-pack")
local transport_belts = {
	["bob-basic-transport-belt"] = { tint = tints.gray, belt_sprite = 1 },
	["transport-belt"] = { tint = tints.cobalt_blue, belt_sprite = 1 },
	["fast-transport-belt"] = { tint = tints.cerulean, belt_sprite = 2 },
	["express-transport-belt"] = { tint = tints.lime_green, belt_sprite = 2 },
	["turbo-transport-belt"] = { tint = tints.golden_yellow, belt_sprite = 2 },
	["bob-ultimate-transport-belt"] = { tint = tints.vermilion, belt_sprite = 2 },
}

for name, params in pairs(transport_belts) do
	TransportBeltGraphicsPack:configure(params):try_apply_to_entity(data.raw["transport-belt"][name])
end

local SplitterGraphicsPack = require("graphics-packs.base.splitter-graphics-pack")
local splitters = {
	["bob-basic-splitter"] = { tint = tints.gray, belt_sprite = 1 },
	["splitter"] = { tint = tints.cobalt_blue, belt_sprite = 1 },
	["fast-splitter"] = { tint = tints.cerulean, belt_sprite = 2 },
	["express-splitter"] = { tint = tints.lime_green, belt_sprite = 2 },
	["turbo-splitter"] = { tint = tints.golden_yellow, belt_sprite = 2 },
	["bob-ultimate-splitter"] = { tint = tints.vermilion, belt_sprite = 2 },
}

for name, params in pairs(splitters) do
	SplitterGraphicsPack:configure(params):try_apply_to_entity(data.raw["splitter"][name])
end

local UndergroundBeltGraphicsPack = require("graphics-packs.base.underground-belt-graphics-pack")
local underground_belts = {
	["bob-basic-underground-belt"] = { tint = tints.gray, belt_sprite = 1 },
	["underground-belt"] = { tint = tints.cobalt_blue, belt_sprite = 1 },
	["fast-underground-belt"] = { tint = tints.cerulean, belt_sprite = 2 },
	["express-underground-belt"] = { tint = tints.lime_green, belt_sprite = 2 },
	["turbo-underground-belt"] = { tint = tints.golden_yellow, belt_sprite = 2 },
	["bob-ultimate-underground-belt"] = { tint = tints.vermilion, belt_sprite = 2 },
}

for name, params in pairs(underground_belts) do
	UndergroundBeltGraphicsPack:configure(params):try_apply_to_entity(data.raw["underground-belt"][name])
end

-- stylua: ignore start
local FurnaceStoneGraphicsPack = require("graphics-packs.base.furnace-stone-graphics-pack")
local stone_furnaces = {
	["stone-furnace"] = { type = "furnace", params = { tint = tints.cobalt_blue, variant = "standard" } },
	["bob-stone-mixing-furnace"] = { type = "assembling-machine", params = { tint = tints.lime_green, variant = "standard" } },
	["bob-stone-chemical-furnace"] = { type = "assembling-machine", params = { tint = tints.cerulean, variant = "chemical" } },
}
-- stylua: ignore end

for name, options in pairs(stone_furnaces) do
	FurnaceStoneGraphicsPack:configure(options.params):try_apply_to_entity(data.raw[options.type][name])
end

-- stylua: ignore start
local FurnaceSteelGraphicsPack = require("graphics-packs.base.furnace-steel-graphics-pack")
local steel_furnaces = {
  ["steel-furnace"] = { type = "furnace", params = { tint = tints.cobalt_blue, variant = "standard" } },
	["bob-fluid-furnace"] = { type = "furnace", params = { tint = tints.cobalt_blue, variant = "fluid" } },
	["bob-steel-mixing-furnace"] = { type = "assembling-machine", params = { tint = tints.lime_green, variant = "standard" } },
	["bob-fluid-mixing-furnace"] = { type = "assembling-machine", params = { tint = tints.lime_green, variant = "fluid" } },
	["bob-steel-chemical-furnace"] = { type = "assembling-machine", params = { tint = tints.cerulean, variant = "chemical" } },
	["bob-fluid-chemical-furnace"] = { type = "assembling-machine", params = { tint = tints.cerulean, variant = "chemical-fluid" } },
}
-- stylua: ignore end

for name, options in pairs(steel_furnaces) do
	FurnaceSteelGraphicsPack:configure(options.params):try_apply_to_entity(data.raw[options.type][name])
end

-- stylua: ignore start
local FurnaceElectricGraphicsPack = require("graphics-packs.base.furnace-electric-graphics-pack")
local electric_furnaces = {
	["electric-furnace"] = { type = "furnace", params = { tint = tints.cobalt_blue, variant = "standard" } },
	["bob-electric-furnace-2"] = { type = "furnace", params = { tint = tints.golden_yellow, variant = "standard" } },
	["bob-electric-furnace-3"] = { type = "furnace", params = { tint = tints.vermilion, variant = "standard" } },
	["bob-electric-mixing-furnace"] = { type = "assembling-machine", params = { tint = tints.lime_green, variant = "mixing" } },
	["bob-electric-chemical-furnace"] = { type = "assembling-machine", params = { tint = tints.cerulean, variant = "chemical" } },
	["bob-electric-chemical-mixing-furnace"] = { type = "assembling-machine", params = { tint = tints.golden_yellow, variant = "chemical-mixing" } },
	["bob-electric-chemical-mixing-furnace-2"] = { type = "assembling-machine", params = { tint = tints.vermilion, variant = "chemical-mixing" } },
}
-- stylua: ignore end

for name, options in pairs(electric_furnaces) do
	FurnaceElectricGraphicsPack:configure(options.params):try_apply_to_entity(data.raw[options.type][name])
end

local BoilerGraphicsPack = require("graphics-packs.base.boiler-graphics-pack")
local boilers = {
	["boiler"] = { tint = tints.cobalt_blue },
	["bob-boiler-2"] = { tint = tints.cerulean },
	["bob-boiler-3"] = { tint = tints.lime_green },
	["bob-boiler-4"] = { tint = tints.golden_yellow },
	["bob-boiler-5"] = { tint = tints.vermilion },
	["bob-oil-boiler"] = { tint = tints.cerulean },
	["bob-oil-boiler-2"] = { tint = tints.lime_green },
	["bob-oil-boiler-3"] = { tint = tints.golden_yellow },
	["bob-oil-boiler-4"] = { tint = tints.vermilion },
}

for name, params in pairs(boilers) do
	BoilerGraphicsPack:configure(params):try_apply_to_entity(data.raw["boiler"][name])
end

local HeatExchangerGraphicsPack = require("graphics-packs.base.heat-exchanger-graphics-pack")
local heat_exchangers = {
	["heat-exchanger"] = { tint = tints.cobalt_blue, pipe_material = "base" },
	["bob-heat-exchanger-2"] = { tint = tints.cerulean, pipe_material = "aluminum-invar" },
	["bob-heat-exchanger-3"] = { tint = tints.lime_green, pipe_material = "silver-titanium" },
	["bob-heat-exchanger-4"] = { tint = tints.golden_yellow, pipe_material = "gold-copper" },
}

for name, params in pairs(heat_exchangers) do
	HeatExchangerGraphicsPack:configure(params):try_apply_to_entity(data.raw["boiler"][name])
end

local SteamEngineGraphicsPack = require("graphics-packs.base.steam-engine-graphics-pack")
local steam_engines = {
	["steam-engine"] = { tint = tints.cobalt_blue },
	["bob-steam-engine-2"] = { tint = tints.cerulean },
	["bob-steam-engine-3"] = { tint = tints.lime_green },
	["bob-steam-engine-4"] = { tint = tints.golden_yellow },
	["bob-steam-engine-5"] = { tint = tints.vermilion },
}

for name, params in pairs(steam_engines) do
	SteamEngineGraphicsPack:configure(params):try_apply_to_entity(data.raw["generator"][name])
end

local SteamTurbineGraphicsPack = require("graphics-packs.base.steam-turbine-graphics-pack")
local steam_turbines = {
	["steam-turbine"] = { tint = tints.cobalt_blue },
	["bob-steam-turbine-2"] = { tint = tints.cerulean },
	["bob-steam-turbine-3"] = { tint = tints.lime_green },
}

for name, params in pairs(steam_turbines) do
	SteamTurbineGraphicsPack:configure(params):try_apply_to_entity(data.raw["generator"][name])
end

local NuclearReactorGraphicsPack = require("graphics-packs.base.nuclear-reactor-graphics-pack")
local nuclear_reactors = {
	["nuclear-reactor"] = { tint = tints.cobalt_blue, pipe_material = "aluminum-invar" },
	["bob-nuclear-reactor-2"] = { tint = tints.cerulean, pipe_material = "silver-titanium" },
	["bob-nuclear-reactor-3"] = { tint = tints.lime_green, pipe_material = "gold-copper" },
}

for name, params in pairs(nuclear_reactors) do
	NuclearReactorGraphicsPack:configure(params):try_apply_to_entity(data.raw["reactor"][name])
end

local SolarPanelGraphicsPack = require("graphics-packs.base.solar-panel-graphics-pack")
local solar_panels = {
	["bob-solar-panel-small"] = { tint = tints.cobalt_blue, variant = "small" },
	["bob-solar-panel-small-2"] = { tint = tints.cerulean, variant = "small" },
	["bob-solar-panel-small-3"] = { tint = tints.lime_green, variant = "small" },
	["solar-panel"] = { tint = tints.cobalt_blue, variant = "standard" },
	["bob-solar-panel-2"] = { tint = tints.cerulean, variant = "standard" },
	["bob-solar-panel-3"] = { tint = tints.lime_green, variant = "standard" },
	["bob-solar-panel-large"] = { tint = tints.cobalt_blue, variant = "large" },
	["bob-solar-panel-large-2"] = { tint = tints.cerulean, variant = "large" },
	["bob-solar-panel-large-3"] = { tint = tints.lime_green, variant = "large" },
}

for name, params in pairs(solar_panels) do
	SolarPanelGraphicsPack:configure(params):try_apply_to_entity(data.raw["solar-panel"][name])
end

local SubstationGraphicsPack = require("graphics-packs.base.substation-graphics-pack")
local substations = {
	["substation"] = { tint = tints.cobalt_blue },
	["bob-substation-2"] = { tint = tints.cerulean },
	["bob-substation-3"] = { tint = tints.lime_green },
	["bob-substation-4"] = { tint = tints.golden_yellow },
}

for name, params in pairs(substations) do
	SubstationGraphicsPack:configure(params):try_apply_to_entity(data.raw["electric-pole"][name])
end

local ElectricPoleBigGraphicsPack = require("graphics-packs.base.electric-pole-big-graphics-pack")
local big_electric_poles = {
	["big-electric-pole"] = { tint = tints.cobalt_blue },
	["bob-big-electric-pole-2"] = { tint = tints.cerulean },
	["bob-big-electric-pole-3"] = { tint = tints.lime_green },
	["bob-big-electric-pole-4"] = { tint = tints.golden_yellow },
}

for name, params in pairs(big_electric_poles) do
	ElectricPoleBigGraphicsPack:configure(params):try_apply_to_entity(data.raw["electric-pole"][name])
end

local ElectricPoleMediumGraphicsPack = require("graphics-packs.base.electric-pole-medium-graphics-pack")
local medium_electric_poles = {
	["medium-electric-pole"] = { tint = tints.cobalt_blue },
	["bob-medium-electric-pole-2"] = { tint = tints.cerulean },
	["bob-medium-electric-pole-3"] = { tint = tints.lime_green },
	["bob-medium-electric-pole-4"] = { tint = tints.golden_yellow },
}

for name, params in pairs(medium_electric_poles) do
	ElectricPoleMediumGraphicsPack:configure(params):try_apply_to_entity(data.raw["electric-pole"][name])
end

local RadarGraphicsPack = require("graphics-packs.base.radar-graphics-pack")
local radars = {
	["radar"] = { tint = tints.cobalt_blue },
	["bob-radar-2"] = { tint = tints.cerulean },
	["bob-radar-3"] = { tint = tints.lime_green },
	["bob-radar-4"] = { tint = tints.golden_yellow },
	["bob-radar-5"] = { tint = tints.vermilion },
}

for name, params in pairs(radars) do
	RadarGraphicsPack:configure(params):try_apply_to_entity(data.raw["radar"][name])
end

local StorageTankGraphicsPack = require("graphics-packs.base.storage-tank-graphics-pack")
local storage_tanks = {
	["storage-tank"] = { tint = tints.cobalt_blue },
	["bob-storage-tank-2"] = { tint = tints.cerulean },
	["bob-storage-tank-3"] = { tint = tints.lime_green },
	["bob-storage-tank-4"] = { tint = tints.golden_yellow },
}

for name, params in pairs(storage_tanks) do
	StorageTankGraphicsPack:configure(params):try_apply_to_entity(data.raw["storage-tank"][name])
end

local PumpGraphicsPack = require("graphics-packs.base.pump-graphics-pack")
local pumps = {
	["pump"] = { tint = tints.cobalt_blue },
	["bob-pump-2"] = { tint = tints.cerulean },
	["bob-pump-3"] = { tint = tints.lime_green },
	["bob-pump-4"] = { tint = tints.golden_yellow },
}

for name, params in pairs(pumps) do
	PumpGraphicsPack:configure(params):try_apply_to_entity(data.raw["pump"][name])
end

local BeaconGraphicsPack = require("graphics-packs.base.beacon-graphics-pack")
local beacons = {
	-- FIXME: This should just take a slot_count parameter rather than couple to file names.
	["beacon"] = { tint = tints.cobalt_blue, variant = "2-slots" },
	["bob-beacon-2"] = { tint = tints.cerulean, variant = "4-slots" },
	["bob-beacon-3"] = { tint = tints.lime_green, variant = "6-slots" },
}

for name, params in pairs(beacons) do
	BeaconGraphicsPack:configure(params):try_apply_to_entity(data.raw["beacon"][name])
end

local RobotConstructionGraphicsPack = require("graphics-packs.base.robot-construction-graphics-pack")
local construction_robots = {
	["construction-robot"] = { tint = tints.cobalt_blue },
	["bob-construction-robot-2"] = { tint = tints.cerulean },
	["bob-construction-robot-3"] = { tint = tints.lime_green },
	["bob-construction-robot-4"] = { tint = tints.golden_yellow },
	["bob-construction-robot-5"] = { tint = tints.vermilion },
}

for name, params in pairs(construction_robots) do
	RobotConstructionGraphicsPack:configure(params):try_apply_to_entity(data.raw["construction-robot"][name])
end

local RobotLogisticGraphicsPack = require("graphics-packs.base.robot-logistic-graphics-pack")
local logistic_robots = {
	["logistic-robot"] = { tint = tints.cobalt_blue },
	["bob-logistic-robot-2"] = { tint = tints.cerulean },
	["bob-logistic-robot-3"] = { tint = tints.lime_green },
	["bob-logistic-robot-4"] = { tint = tints.golden_yellow },
	["bob-logistic-robot-5"] = { tint = tints.vermilion },
}

for name, params in pairs(logistic_robots) do
	RobotLogisticGraphicsPack:configure(params):try_apply_to_entity(data.raw["logistic-robot"][name])
end

local RoboportGraphicsPack = require("graphics-packs.base.roboport-graphics-pack")
local roboports = {
	["roboport"] = { tint = tints.cobalt_blue, antenna_variant = 0, door_variant = 0 },
	["bob-roboport-2"] = { tint = tints.cerulean, antenna_variant = 1, door_variant = 1 },
	["bob-roboport-3"] = { tint = tints.lime_green, antenna_variant = 2, door_variant = 2 },
	["bob-roboport-4"] = { tint = tints.golden_yellow, antenna_variant = 3, door_variant = 3 },
}

for name, params in pairs(roboports) do
	RoboportGraphicsPack:configure(params):try_apply_to_entity(data.raw["roboport"][name])
end

local InserterGraphicsPack = require("graphics-packs.base.inserter-graphics-pack")
local inserters = {
	["inserter"] = { tint = tints.gray, variant = "inserter" },
	["bob-red-inserter"] = { tint = tints.cobalt_blue, variant = "inserter-long" },
	["long-handed-inserter"] = { tint = tints.cerulean, variant = "inserter-filter" },
	["fast-inserter"] = { tint = tints.lime_green, variant = "inserter-filter" },
	["bob-turbo-inserter"] = { tint = tints.golden_yellow, variant = "inserter-filter-long" },
	["bob-express-inserter"] = { tint = tints.vermilion, variant = "inserter-filter-long" },

	["bob-red-bulk-inserter"] = { tint = tints.cobalt_blue, variant = "inserter-bulk" },
	["bulk-inserter"] = { tint = tints.cerulean, variant = "inserter-bulk" },
	["bob-turbo-bulk-inserter"] = { tints = tints.lime_green, variant = "inserter-bulk-filter" },
	["bob-express-bulk-inserter"] = { tints = tints.golden_yellow, variant = "inserter-bulk-filter" },
}

for name, params in pairs(inserters) do
	InserterGraphicsPack:configure(params):try_apply_to_entity(data.raw["inserter"][name])
end

local InserterPresetGraphicsPack = require("graphics-packs.base.inserter-preset-graphics-pack")
local inserter_presets = {
	["burner-inserter"] = { preset = "inserter-express-filter", is_long = true },
}

for name, params in pairs(inserter_presets) do
	InserterPresetGraphicsPack:configure(params):try_apply_to_entity(data.raw["inserter"][name])
end
