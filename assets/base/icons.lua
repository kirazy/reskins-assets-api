-- THIS MODULE IS EXTREMELY WIP AND SUBJECT TO CHANGE.
-- The require path, function names and signatures are not stable.

local helpers = require("prototypes.icon-helpers")
local icon_utils = require("__reskins-sprite-utils__.icons")

local folder = "__reskins-assets-base__/graphics/icons"

-- stylua: ignore start
local _icons = {
	accumulator = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "accumulator" }),
	assembling_machine = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "assembling-machine" }),
	battery = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "battery" }),
	beacon = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "beacon" }),
	boiler = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "boiler" }),
	centrifuge = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "centrifuge" }),
	chemical_plant = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "chemical-plant" }),
	circuit = helpers.make_tinted_circuit_icon_creator_fn({ folder = folder, icon_name = "circuit" }),
	electric_pole_big = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "electric-pole-big" }),
	electric_pole_medium = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "electric-pole-medium" }),
	equipment_battery_1 = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "equipment-battery-1" }),
	equipment_battery_2 = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "equipment-battery-2" }),
	equipment_energy_shield_1 = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "equipment-energy-shield-1" }),
	equipment_energy_shield_2 = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "equipment-energy-shield-2" }),
	equipment_exoskeleton = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "equipment-exoskeleton" }),
	equipment_fission_reactor = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "equipment-fission-reactor" }),
	equipment_laser_defense = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "equipment-laser-defense" }),
	equipment_night_vision = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "equipment-night-vision" }),
	equipment_personal_roboport_1 = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "equipment-personal-roboport-1" }),
	equipment_personal_roboport_2 = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "equipment-personal-roboport-2" }),
	equipment_solar_panel = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "equipment-solar-panel" }),
	flying_robot_frame = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "flying-robot-frame" }),
	furnace_electric = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "furnace-electric" }),
	furnace_steel = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "furnace-steel" }),
	furnace_stone = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "furnace-stone" }),
	inserter = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "inserter" }),
	mining_drill_electric = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "mining-drill-electric" }),
	-- modules = icon_utils.make_tinted_icon_creator_fn({ folder = folder, icon_name = "modules" }),
	nuclear_reactor = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "nuclear-reactor" }),
	offshore_pump = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "offshore-pump" }),
	oil_refinery = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "oil-refinery" }),
	pump = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "pump" }),
	pumpjack = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "pumpjack" }),
	radar = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "radar" }),
	repair_pack = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "repair-pack" }),
	roboport = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "roboport" }),
	robot_construction = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "robot-construction" }),
	robot_logistic = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "robot-logistic" }),
	science_pack = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "science-pack" }),
	solar_panel = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "solar-panel" }),
	splitter = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "splitter" }),
	steam_engine = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "steam-engine" }),
	steam_turbine = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "steam-turbine" }),
	storage_tank = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "storage-tank" }),
	substation = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "substation" }),
	tank = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "tank" }),
	train_artillery_wagon = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "train-artillery-wagon" }),
	train_cargo_wagon = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "train-cargo-wagon" }),
	train_fluid_wagon = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "train-fluid-wagon" }),
	train_locomotive = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "train-locomotive" }),
	transport_belt = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "transport-belt" }),
	turret_artillery = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "turret-artillery" }),
	turret_gun = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "turret-gun" }),
	turret_laser = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "turret-laser" }),
	underground_belt = helpers.make_tinted_three_layer_icon_creator_fn({ folder = folder, icon_name = "underground-belt" }),
}
-- stylua: ignore end

return _icons
