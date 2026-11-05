---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Technologies

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local technologies = IconBuilderFactory:create({
	folder = _defines.assets_source.bobs_assets .. "/graphics/technology",
	defaults_type = "technology",
})

---Provides methods for getting the technology icons at the root of the technology folder, such as
---`vehicle-engine-equipment.png`.
---
---#### Examples
---```lua
---local Icons = require("__reskins-assets-api__.assets.bobs.technologies.icons")
---```
---@class Icons
local M = {}

local advanced_material_processing = technologies:flat("advanced-material-processing"):size(128)

---Gets the technology icon for advanced material processing.
M.get_advanced_material_processing_icon = advanced_material_processing:build("get_advanced_material_processing_icon")

---Gets the technology icon for advanced material processing as an `IconComposition`.
M.get_advanced_material_processing_icon_composition =
	advanced_material_processing:build_composition("get_advanced_material_processing_icon_composition")

local advanced_processing_unit = technologies:flat("advanced-processing-unit")

---Gets the technology icon for the advanced processing unit.
M.get_advanced_processing_unit_icon = advanced_processing_unit:build("get_advanced_processing_unit_icon")

---Gets the technology icon for the advanced processing unit as an `IconComposition`.
M.get_advanced_processing_unit_icon_composition =
	advanced_processing_unit:build_composition("get_advanced_processing_unit_icon_composition")

local advanced_processing_unit_legacy = technologies:flat("advanced-processing-unit-legacy")

---Gets the legacy technology icon for the advanced processing unit.
M.get_advanced_processing_unit_legacy_icon =
	advanced_processing_unit_legacy:build("get_advanced_processing_unit_legacy_icon")

---Gets the legacy technology icon for the advanced processing unit as an `IconComposition`.
M.get_advanced_processing_unit_legacy_icon_composition =
	advanced_processing_unit_legacy:build_composition("get_advanced_processing_unit_legacy_icon_composition")

local advanced_research = technologies:flat("advanced-research")

---Gets the technology icon for advanced research.
M.get_advanced_research_icon = advanced_research:build("get_advanced_research_icon")

---Gets the technology icon for advanced research as an `IconComposition`.
M.get_advanced_research_icon_composition = advanced_research:build_composition("get_advanced_research_icon_composition")

local alien_research = technologies:flat("alien-research")

---Gets the technology icon for alien research.
M.get_alien_research_icon = alien_research:build("get_alien_research_icon")

---Gets the technology icon for alien research as an `IconComposition`.
M.get_alien_research_icon_composition = alien_research:build_composition("get_alien_research_icon_composition")

local alloy_processing = technologies:flat("alloy-processing")

---Gets the technology icon for alloy processing.
M.get_alloy_processing_icon = alloy_processing:build("get_alloy_processing_icon")

---Gets the technology icon for alloy processing as an `IconComposition`.
M.get_alloy_processing_icon_composition = alloy_processing:build_composition("get_alloy_processing_icon_composition")

local aluminium_processing = technologies:flat("aluminium-processing")

---Gets the technology icon for aluminium processing.
M.get_aluminium_processing_icon = aluminium_processing:build("get_aluminium_processing_icon")

---Gets the technology icon for aluminium processing as an `IconComposition`.
M.get_aluminium_processing_icon_composition =
	aluminium_processing:build_composition("get_aluminium_processing_icon_composition")

local bobingabout_enrichment_process = technologies:flat("bobingabout-enrichment-process")

---Gets the technology icon for the Bobingabout enrichment process.
M.get_bobingabout_enrichment_process_icon =
	bobingabout_enrichment_process:build("get_bobingabout_enrichment_process_icon")

---Gets the technology icon for the Bobingabout enrichment process as an `IconComposition`.
M.get_bobingabout_enrichment_process_icon_composition =
	bobingabout_enrichment_process:build_composition("get_bobingabout_enrichment_process_icon_composition")

local bulk_inserter = technologies:flat("bulk-inserter")

---Gets the technology icon for bulk inserters.
M.get_bulk_inserter_icon = bulk_inserter:build("get_bulk_inserter_icon")

---Gets the technology icon for bulk inserters as an `IconComposition`.
M.get_bulk_inserter_icon_composition = bulk_inserter:build_composition("get_bulk_inserter_icon_composition")

local bulk_inserter_2 = technologies:flat("bulk-inserter-2")

---Gets the technology icon for bulk inserters 2.
M.get_bulk_inserter_2_icon = bulk_inserter_2:build("get_bulk_inserter_2_icon")

---Gets the technology icon for bulk inserters 2 as an `IconComposition`.
M.get_bulk_inserter_2_icon_composition = bulk_inserter_2:build_composition("get_bulk_inserter_2_icon_composition")

local ceramics = technologies:flat("ceramics")

---Gets the technology icon for ceramics.
M.get_ceramics_icon = ceramics:build("get_ceramics_icon")

---Gets the technology icon for ceramics as an `IconComposition`.
M.get_ceramics_icon_composition = ceramics:build_composition("get_ceramics_icon_composition")

local chemical_processing_1 = technologies:flat("chemical-processing-1"):size(128)

---Gets the technology icon for chemical processing 1.
M.get_chemical_processing_1_icon = chemical_processing_1:build("get_chemical_processing_1_icon")

---Gets the technology icon for chemical processing 1 as an `IconComposition`.
M.get_chemical_processing_1_icon_composition =
	chemical_processing_1:build_composition("get_chemical_processing_1_icon_composition")

local chemical_processing_2 = technologies:flat("chemical-processing-2")

---Gets the technology icon for chemical processing 2.
M.get_chemical_processing_2_icon = chemical_processing_2:build("get_chemical_processing_2_icon")

---Gets the technology icon for chemical processing 2 as an `IconComposition`.
M.get_chemical_processing_2_icon_composition =
	chemical_processing_2:build_composition("get_chemical_processing_2_icon_composition")

local cobalt_processing = technologies:flat("cobalt-processing")

---Gets the technology icon for cobalt processing.
M.get_cobalt_processing_icon = cobalt_processing:build("get_cobalt_processing_icon")

---Gets the technology icon for cobalt processing as an `IconComposition`.
M.get_cobalt_processing_icon_composition = cobalt_processing:build_composition("get_cobalt_processing_icon_composition")

local cordite_processing = technologies:flat("cordite-processing")

---Gets the technology icon for cordite processing.
M.get_cordite_processing_icon = cordite_processing:build("get_cordite_processing_icon")

---Gets the technology icon for cordite processing as an `IconComposition`.
M.get_cordite_processing_icon_composition =
	cordite_processing:build_composition("get_cordite_processing_icon_composition")

local deuterium_fuel_cell_2 = technologies:flat("deuterium-fuel-cell-2"):size(128)

---Gets the technology icon for the deuterium fuel cell 2.
M.get_deuterium_fuel_cell_2_icon = deuterium_fuel_cell_2:build("get_deuterium_fuel_cell_2_icon")

---Gets the technology icon for the deuterium fuel cell 2 as an `IconComposition`.
M.get_deuterium_fuel_cell_2_icon_composition =
	deuterium_fuel_cell_2:build_composition("get_deuterium_fuel_cell_2_icon_composition")

local deuterium_fuel_reprocessing_blue = technologies:flat("deuterium-fuel-reprocessing-blue"):size(128)

---Gets the technology icon for deuterium fuel reprocessing, with blue deuterium.
M.get_deuterium_fuel_reprocessing_blue_icon =
	deuterium_fuel_reprocessing_blue:build("get_deuterium_fuel_reprocessing_blue_icon")

---Gets the technology icon for deuterium fuel reprocessing as an `IconComposition`, with blue deuterium.
M.get_deuterium_fuel_reprocessing_blue_icon_composition =
	deuterium_fuel_reprocessing_blue:build_composition("get_deuterium_fuel_reprocessing_blue_icon_composition")

local deuterium_fuel_reprocessing_pink = technologies:flat("deuterium-fuel-reprocessing-pink"):size(128)

---Gets the technology icon for deuterium fuel reprocessing, with pink deuterium.
M.get_deuterium_fuel_reprocessing_pink_icon =
	deuterium_fuel_reprocessing_pink:build("get_deuterium_fuel_reprocessing_pink_icon")

---Gets the technology icon for deuterium fuel reprocessing as an `IconComposition`, with pink deuterium.
M.get_deuterium_fuel_reprocessing_pink_icon_composition =
	deuterium_fuel_reprocessing_pink:build_composition("get_deuterium_fuel_reprocessing_pink_icon_composition")

local electrolysis = technologies:flat("electrolysis")

---Gets the technology icon for electrolysis.
M.get_electrolysis_icon = electrolysis:build("get_electrolysis_icon")

---Gets the technology icon for electrolysis as an `IconComposition`.
M.get_electrolysis_icon_composition = electrolysis:build_composition("get_electrolysis_icon_composition")

local express_inserter = technologies:flat("express-inserter")

---Gets the technology icon for express inserters.
M.get_express_inserter_icon = express_inserter:build("get_express_inserter_icon")

---Gets the technology icon for express inserters as an `IconComposition`.
M.get_express_inserter_icon_composition = express_inserter:build_composition("get_express_inserter_icon_composition")

local fertiliser = technologies:flat("fertiliser")

---Gets the technology icon for fertiliser.
M.get_fertiliser_icon = fertiliser:build("get_fertiliser_icon")

---Gets the technology icon for fertiliser as an `IconComposition`.
M.get_fertiliser_icon_composition = fertiliser:build_composition("get_fertiliser_icon_composition")

local fluid_chemical_furnace = technologies:flat("fluid-chemical-furnace"):size(128)

---Gets the technology icon for the fluid chemical furnace.
M.get_fluid_chemical_furnace_icon = fluid_chemical_furnace:build("get_fluid_chemical_furnace_icon")

---Gets the technology icon for the fluid chemical furnace as an `IconComposition`.
M.get_fluid_chemical_furnace_icon_composition =
	fluid_chemical_furnace:build_composition("get_fluid_chemical_furnace_icon_composition")

local fluid_mixing_furnace = technologies:flat("fluid-mixing-furnace"):size(128)

---Gets the technology icon for the fluid mixing furnace.
M.get_fluid_mixing_furnace_icon = fluid_mixing_furnace:build("get_fluid_mixing_furnace_icon")

---Gets the technology icon for the fluid mixing furnace as an `IconComposition`.
M.get_fluid_mixing_furnace_icon_composition =
	fluid_mixing_furnace:build_composition("get_fluid_mixing_furnace_icon_composition")

local gas_canisters = technologies:flat("gas-canisters")

---Gets the technology icon for gas canisters.
M.get_gas_canisters_icon = gas_canisters:build("get_gas_canisters_icon")

---Gets the technology icon for gas canisters as an `IconComposition`.
M.get_gas_canisters_icon_composition = gas_canisters:build_composition("get_gas_canisters_icon_composition")

local gem_processing_1 = technologies:flat("gem-processing-1")

---Gets the technology icon for gem processing 1.
M.get_gem_processing_1_icon = gem_processing_1:build("get_gem_processing_1_icon")

---Gets the technology icon for gem processing 1 as an `IconComposition`.
M.get_gem_processing_1_icon_composition = gem_processing_1:build_composition("get_gem_processing_1_icon_composition")

local gem_processing_2 = technologies:flat("gem-processing-2")

---Gets the technology icon for gem processing 2.
M.get_gem_processing_2_icon = gem_processing_2:build("get_gem_processing_2_icon")

---Gets the technology icon for gem processing 2 as an `IconComposition`.
M.get_gem_processing_2_icon_composition = gem_processing_2:build_composition("get_gem_processing_2_icon_composition")

local gem_processing_3 = technologies:flat("gem-processing-3")

---Gets the technology icon for gem processing 3.
M.get_gem_processing_3_icon = gem_processing_3:build("get_gem_processing_3_icon")

---Gets the technology icon for gem processing 3 as an `IconComposition`.
M.get_gem_processing_3_icon_composition = gem_processing_3:build_composition("get_gem_processing_3_icon_composition")

local gold_processing = technologies:flat("gold-processing")

---Gets the technology icon for gold processing.
M.get_gold_processing_icon = gold_processing:build("get_gold_processing_icon")

---Gets the technology icon for gold processing as an `IconComposition`.
M.get_gold_processing_icon_composition = gold_processing:build_composition("get_gold_processing_icon_composition")

local greenhouse = technologies:flat("greenhouse")

---Gets the technology icon for the greenhouse.
M.get_greenhouse_icon = greenhouse:build("get_greenhouse_icon")

---Gets the technology icon for the greenhouse as an `IconComposition`.
M.get_greenhouse_icon_composition = greenhouse:build_composition("get_greenhouse_icon_composition")

local grinding = technologies:flat("grinding")

---Gets the technology icon for grinding.
M.get_grinding_icon = grinding:build("get_grinding_icon")

---Gets the technology icon for grinding as an `IconComposition`.
M.get_grinding_icon_composition = grinding:build_composition("get_grinding_icon_composition")

local heat_shield = technologies:flat("heat-shield")

---Gets the technology icon for the heat shield.
M.get_heat_shield_icon = heat_shield:build("get_heat_shield_icon")

---Gets the technology icon for the heat shield as an `IconComposition`.
M.get_heat_shield_icon_composition = heat_shield:build_composition("get_heat_shield_icon_composition")

local invar_processing = technologies:flat("invar-processing")

---Gets the technology icon for invar processing.
M.get_invar_processing_icon = invar_processing:build("get_invar_processing_icon")

---Gets the technology icon for invar processing as an `IconComposition`.
M.get_invar_processing_icon_composition = invar_processing:build_composition("get_invar_processing_icon_composition")

local lab = technologies:flat("lab")

---Gets the technology icon for the lab.
M.get_lab_icon = lab:build("get_lab_icon")

---Gets the technology icon for the lab as an `IconComposition`.
M.get_lab_icon_composition = lab:build_composition("get_lab_icon_composition")

local laser_rifle = technologies:flat("laser-rifle")

---Gets the technology icon for the laser rifle.
M.get_laser_rifle_icon = laser_rifle:build("get_laser_rifle_icon")

---Gets the technology icon for the laser rifle as an `IconComposition`.
M.get_laser_rifle_icon_composition = laser_rifle:build_composition("get_laser_rifle_icon_composition")

local laser_robot = technologies:flat("laser-robot")

---Gets the technology icon for the laser robot.
M.get_laser_robot_icon = laser_robot:build("get_laser_robot_icon")

---Gets the technology icon for the laser robot as an `IconComposition`.
M.get_laser_robot_icon_composition = laser_robot:build_composition("get_laser_robot_icon_composition")

local lead_processing = technologies:flat("lead-processing")

---Gets the technology icon for lead processing.
M.get_lead_processing_icon = lead_processing:build("get_lead_processing_icon")

---Gets the technology icon for lead processing as an `IconComposition`.
M.get_lead_processing_icon_composition = lead_processing:build_composition("get_lead_processing_icon_composition")

local lithium_processing = technologies:flat("lithium-processing")

---Gets the technology icon for lithium processing.
M.get_lithium_processing_icon = lithium_processing:build("get_lithium_processing_icon")

---Gets the technology icon for lithium processing as an `IconComposition`.
M.get_lithium_processing_icon_composition =
	lithium_processing:build_composition("get_lithium_processing_icon_composition")

local long_inserters_1 = technologies:flat("long-inserters-1")

---Gets the technology icon for long inserters 1.
M.get_long_inserters_1_icon = long_inserters_1:build("get_long_inserters_1_icon")

---Gets the technology icon for long inserters 1 as an `IconComposition`.
M.get_long_inserters_1_icon_composition = long_inserters_1:build_composition("get_long_inserters_1_icon_composition")

local nickel_processing = technologies:flat("nickel-processing")

---Gets the technology icon for nickel processing.
M.get_nickel_processing_icon = nickel_processing:build("get_nickel_processing_icon")

---Gets the technology icon for nickel processing as an `IconComposition`.
M.get_nickel_processing_icon_composition = nickel_processing:build_composition("get_nickel_processing_icon_composition")

local nitinol_processing = technologies:flat("nitinol-processing")

---Gets the technology icon for nitinol processing.
M.get_nitinol_processing_icon = nitinol_processing:build("get_nitinol_processing_icon")

---Gets the technology icon for nitinol processing as an `IconComposition`.
M.get_nitinol_processing_icon_composition =
	nitinol_processing:build_composition("get_nitinol_processing_icon_composition")

local nuclear_fuel_reprocessing = technologies:flat("nuclear-fuel-reprocessing"):size(128)

---Gets the technology icon for nuclear fuel reprocessing.
M.get_nuclear_fuel_reprocessing_icon = nuclear_fuel_reprocessing:build("get_nuclear_fuel_reprocessing_icon")

---Gets the technology icon for nuclear fuel reprocessing as an `IconComposition`.
M.get_nuclear_fuel_reprocessing_icon_composition =
	nuclear_fuel_reprocessing:build_composition("get_nuclear_fuel_reprocessing_icon_composition")

local plutonium_fuel_cell = technologies:flat("plutonium-fuel-cell"):size(128)

---Gets the technology icon for the plutonium fuel cell.
M.get_plutonium_fuel_cell_icon = plutonium_fuel_cell:build("get_plutonium_fuel_cell_icon")

---Gets the technology icon for the plutonium fuel cell as an `IconComposition`.
M.get_plutonium_fuel_cell_icon_composition =
	plutonium_fuel_cell:build_composition("get_plutonium_fuel_cell_icon_composition")

local polishing = technologies:flat("polishing")

---Gets the technology icon for polishing.
M.get_polishing_icon = polishing:build("get_polishing_icon")

---Gets the technology icon for polishing as an `IconComposition`.
M.get_polishing_icon_composition = polishing:build_composition("get_polishing_icon_composition")

local reinforced_wall = technologies:flat("reinforced-wall")

---Gets the technology icon for the reinforced wall.
M.get_reinforced_wall_icon = reinforced_wall:build("get_reinforced_wall_icon")

---Gets the technology icon for the reinforced wall as an `IconComposition`.
M.get_reinforced_wall_icon_composition = reinforced_wall:build_composition("get_reinforced_wall_icon_composition")

local scatter_cannon_shells = technologies:flat("scatter-cannon-shells")

---Gets the technology icon for scatter cannon shells.
M.get_scatter_cannon_shells_icon = scatter_cannon_shells:build("get_scatter_cannon_shells_icon")

---Gets the technology icon for scatter cannon shells as an `IconComposition`.
M.get_scatter_cannon_shells_icon_composition =
	scatter_cannon_shells:build_composition("get_scatter_cannon_shells_icon_composition")

local silicon_processing = technologies:flat("silicon-processing")

---Gets the technology icon for silicon processing.
M.get_silicon_processing_icon = silicon_processing:build("get_silicon_processing_icon")

---Gets the technology icon for silicon processing as an `IconComposition`.
M.get_silicon_processing_icon_composition =
	silicon_processing:build_composition("get_silicon_processing_icon_composition")

local steel_chemical_furnace = technologies:flat("steel-chemical-furnace"):size(128)

---Gets the technology icon for the steel chemical furnace.
M.get_steel_chemical_furnace_icon = steel_chemical_furnace:build("get_steel_chemical_furnace_icon")

---Gets the technology icon for the steel chemical furnace as an `IconComposition`.
M.get_steel_chemical_furnace_icon_composition =
	steel_chemical_furnace:build_composition("get_steel_chemical_furnace_icon_composition")

local steel_mixing_furnace = technologies:flat("steel-mixing-furnace"):size(128)

---Gets the technology icon for the steel mixing furnace.
M.get_steel_mixing_furnace_icon = steel_mixing_furnace:build("get_steel_mixing_furnace_icon")

---Gets the technology icon for the steel mixing furnace as an `IconComposition`.
M.get_steel_mixing_furnace_icon_composition =
	steel_mixing_furnace:build_composition("get_steel_mixing_furnace_icon_composition")

local thorium_fuel_reprocessing = technologies:flat("thorium-fuel-reprocessing"):size(128)

---Gets the technology icon for thorium fuel reprocessing.
M.get_thorium_fuel_reprocessing_icon = thorium_fuel_reprocessing:build("get_thorium_fuel_reprocessing_icon")

---Gets the technology icon for thorium fuel reprocessing as an `IconComposition`.
M.get_thorium_fuel_reprocessing_icon_composition =
	thorium_fuel_reprocessing:build_composition("get_thorium_fuel_reprocessing_icon_composition")

local thorium_plutonium_fuel_cell = technologies:flat("thorium-plutonium-fuel-cell"):size(128)

---Gets the technology icon for the thorium plutonium fuel cell.
M.get_thorium_plutonium_fuel_cell_icon = thorium_plutonium_fuel_cell:build("get_thorium_plutonium_fuel_cell_icon")

---Gets the technology icon for the thorium plutonium fuel cell as an `IconComposition`.
M.get_thorium_plutonium_fuel_cell_icon_composition =
	thorium_plutonium_fuel_cell:build_composition("get_thorium_plutonium_fuel_cell_icon_composition")

local void_fluid = technologies:flat("void-fluid")

---Gets the technology icon for gas venting.
M.get_void_fluid_icon = void_fluid:build("get_void_fluid_icon")

---Gets the technology icon for gas venting as an `IconComposition`.
M.get_void_fluid_icon_composition = void_fluid:build_composition("get_void_fluid_icon_composition")

local zinc_processing = technologies:flat("zinc-processing")

---Gets the technology icon for zinc processing.
M.get_zinc_processing_icon = zinc_processing:build("get_zinc_processing_icon")

---Gets the technology icon for zinc processing as an `IconComposition`.
M.get_zinc_processing_icon_composition = zinc_processing:build_composition("get_zinc_processing_icon_composition")

local vehicle_belt_immunity_equipment = technologies:flat("vehicle-belt-immunity-equipment")

---Gets the technology icon for the vehicle belt immunity equipment.
M.get_vehicle_belt_immunity_equipment_icon =
	vehicle_belt_immunity_equipment:build("get_vehicle_belt_immunity_equipment_icon")

---Gets the technology icon for the vehicle belt immunity equipment as an `IconComposition`.
M.get_vehicle_belt_immunity_equipment_icon_composition =
	vehicle_belt_immunity_equipment:build_composition("get_vehicle_belt_immunity_equipment_icon_composition")

local vehicle_engine_equipment = technologies:flat("vehicle-engine-equipment")

---Gets the technology icon for the vehicle engine equipment.
M.get_vehicle_engine_equipment_icon = vehicle_engine_equipment:build("get_vehicle_engine_equipment_icon")

---Gets the technology icon for the vehicle engine equipment as an `IconComposition`.
M.get_vehicle_engine_equipment_icon_composition =
	vehicle_engine_equipment:build_composition("get_vehicle_engine_equipment_icon_composition")

local vehicle_motor_equipment = technologies:flat("vehicle-motor-equipment")

---Gets the technology icon for the vehicle motor equipment.
M.get_vehicle_motor_equipment_icon = vehicle_motor_equipment:build("get_vehicle_motor_equipment_icon")

---Gets the technology icon for the vehicle motor equipment as an `IconComposition`.
M.get_vehicle_motor_equipment_icon_composition =
	vehicle_motor_equipment:build_composition("get_vehicle_motor_equipment_icon_composition")

return M
