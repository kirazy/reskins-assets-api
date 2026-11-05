---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Bobs.Items

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")

local icons = IconBuilderFactory:create({ folder = _defines.assets_source.bobs_assets .. "/graphics/icons" })

---Provides methods for getting the icons at the root of the icon folder, such as `vehicle-engine.png`.
---
---#### Examples
---```lua
---local Icons = require("__reskins-assets-api__.assets.bobs.items.icons")
---```
---@class Icons
local M = {}

---Gets the icon for the advanced greenhouse cycle as an `IconComposition`.
M.get_advanced_greenhouse_cycle_icon_composition =
	icons:flat("advanced-greenhouse-cycle"):build_composition("get_advanced_greenhouse_cycle_icon_composition")

---Gets the icon for alumina as an `IconComposition`.
M.get_alumina_icon_composition = icons:flat("alumina"):build_composition("get_alumina_icon_composition")

---Gets the icon for the basic greenhouse cycle as an `IconComposition`.
M.get_basic_greenhouse_cycle_icon_composition =
	icons:flat("basic-greenhouse-cycle"):build_composition("get_basic_greenhouse_cycle_icon_composition")

---Gets the icon for the Bobingabout enrichment process as an `IconComposition`.
M.get_bobingabout_enrichment_process_icon_composition =
	icons:flat("bobingabout-enrichment-process"):build_composition("get_bobingabout_enrichment_process_icon_composition")

---Gets the icon for the bullet casing as an `IconComposition`.
M.get_bullet_casing_icon_composition =
	icons:flat("bullet-casing"):build_composition("get_bullet_casing_icon_composition")

---Gets the icon for calcium chloride as an `IconComposition`.
M.get_calcium_chloride_icon_composition =
	icons:flat("calcium-chloride"):build_composition("get_calcium_chloride_icon_composition")

---Gets the icon for carbon as an `IconComposition`.
M.get_carbon_icon_composition = icons:flat("carbon"):build_composition("get_carbon_icon_composition")

---Gets the icon for coal cracking as an `IconComposition`.
M.get_coal_cracking_icon_composition =
	icons:flat("coal-cracking"):build_composition("get_coal_cracking_icon_composition")

---Gets the icon for cobalt oxide as an `IconComposition`.
M.get_cobalt_oxide_icon_composition = icons:flat("cobalt-oxide"):build_composition("get_cobalt_oxide_icon_composition")

---Gets the icon for cobalt oxide from copper as an `IconComposition`.
M.get_cobalt_oxide_from_copper_icon_composition =
	icons:flat("cobalt-oxide-from-copper"):build_composition("get_cobalt_oxide_from_copper_icon_composition")

---Gets the icon for cordite as an `IconComposition`.
M.get_cordite_icon_composition = icons:flat("cordite"):build_composition("get_cordite_icon_composition")

---Gets the icon for the alternate deuterium fuel reprocessing as an `IconComposition`, with blue deuterium.
M.get_deuterium_fuel_reprocessing_alternate_blue_icon_composition = icons
	:flat("deuterium-fuel-reprocessing-alternate-blue")
	:build_composition("get_deuterium_fuel_reprocessing_alternate_blue_icon_composition")

---Gets the icon for the alternate deuterium fuel reprocessing as an `IconComposition`, with pink deuterium.
M.get_deuterium_fuel_reprocessing_alternate_pink_icon_composition = icons
	:flat("deuterium-fuel-reprocessing-alternate-pink")
	:build_composition("get_deuterium_fuel_reprocessing_alternate_pink_icon_composition")

---Gets the icon for deuterium fuel reprocessing as an `IconComposition`, with blue deuterium.
M.get_deuterium_fuel_reprocessing_blue_icon_composition = icons
	:flat("deuterium-fuel-reprocessing-blue")
	:build_composition("get_deuterium_fuel_reprocessing_blue_icon_composition")

---Gets the icon for deuterium fuel reprocessing as an `IconComposition`, with pink deuterium.
M.get_deuterium_fuel_reprocessing_pink_icon_composition = icons
	:flat("deuterium-fuel-reprocessing-pink")
	:build_composition("get_deuterium_fuel_reprocessing_pink_icon_composition")

---Gets the icon for enriched fuel as an `IconComposition`.
M.get_enriched_fuel_icon_composition =
	icons:flat("enriched-fuel"):build_composition("get_enriched_fuel_icon_composition")

---Gets the icon for enriched fuel from hydrazine as an `IconComposition`.
M.get_enriched_fuel_from_hydrazine_icon_composition =
	icons:flat("enriched-fuel-from-hydrazine"):build_composition("get_enriched_fuel_from_hydrazine_icon_composition")

---Gets the icon for enriched fuel from light oil as an `IconComposition`.
M.get_enriched_fuel_from_light_oil_icon_composition =
	icons:flat("enriched-fuel-from-light-oil"):build_composition("get_enriched_fuel_from_light_oil_icon_composition")

---Gets the icon for fertiliser as an `IconComposition`.
M.get_fertiliser_icon_composition = icons:flat("fertiliser"):build_composition("get_fertiliser_icon_composition")

---Gets the icon for glass as an `IconComposition`.
M.get_glass_icon_composition = icons:flat("glass"):build_composition("get_glass_icon_composition")

---Gets the icon for the grinding wheel as an `IconComposition`.
M.get_grinding_wheel_icon_composition =
	icons:flat("grinding-wheel"):build_composition("get_grinding_wheel_icon_composition")

---Gets the icon for the heat shield tile as an `IconComposition`.
M.get_heat_shield_tile_icon_composition =
	icons:flat("heat-shield-tile"):build_composition("get_heat_shield_tile_icon_composition")

---Gets the icon for the laser rifle as an `IconComposition`.
M.get_laser_rifle_icon_composition = icons:flat("laser-rifle"):build_composition("get_laser_rifle_icon_composition")

---Gets the icon for the laser rifle battery case as an `IconComposition`.
M.get_laser_rifle_battery_case_icon_composition =
	icons:flat("laser-rifle-battery-case"):build_composition("get_laser_rifle_battery_case_icon_composition")

---Gets the icon for the laser robot as an `IconComposition`.
M.get_laser_robot_icon_composition = icons:flat("laser-robot"):build_composition("get_laser_robot_icon_composition")

---Gets the icon for lead oxide as an `IconComposition`.
M.get_lead_oxide_icon_composition = icons:flat("lead-oxide"):build_composition("get_lead_oxide_icon_composition")

---Gets the icon for liquid air as an `IconComposition`.
M.get_liquid_air_icon_composition = icons:flat("liquid-air"):build_composition("get_liquid_air_icon_composition")

---Gets the icon for lithium chloride as an `IconComposition`.
M.get_lithium_chloride_icon_composition =
	icons:flat("lithium-chloride"):build_composition("get_lithium_chloride_icon_composition")

---Gets the icon for lithium cobalt oxide as an `IconComposition`.
M.get_lithium_cobalt_oxide_icon_composition =
	icons:flat("lithium-cobalt-oxide"):build_composition("get_lithium_cobalt_oxide_icon_composition")

---Gets the icon for lithium perchlorate as an `IconComposition`.
M.get_lithium_perchlorate_icon_composition =
	icons:flat("lithium-perchlorate"):build_composition("get_lithium_perchlorate_icon_composition")

---Gets the icon for the mech armor plate as an `IconComposition`.
M.get_mech_armor_plate_icon_composition =
	icons:flat("mech-armor-plate"):build_composition("get_mech_armor_plate_icon_composition")

---Gets the icon for the mech brain as an `IconComposition`.
M.get_mech_brain_icon_composition = icons:flat("mech-brain"):build_composition("get_mech_brain_icon_composition")

---Gets the icon for the mech foot as an `IconComposition`.
M.get_mech_foot_icon_composition = icons:flat("mech-foot"):build_composition("get_mech_foot_icon_composition")

---Gets the icon for the mech frame as an `IconComposition`.
M.get_mech_frame_icon_composition = icons:flat("mech-frame"):build_composition("get_mech_frame_icon_composition")

---Gets the icon for the mech hip as an `IconComposition`.
M.get_mech_hip_icon_composition = icons:flat("mech-hip"):build_composition("get_mech_hip_icon_composition")

---Gets the icon for the mech knee as an `IconComposition`.
M.get_mech_knee_icon_composition = icons:flat("mech-knee"):build_composition("get_mech_knee_icon_composition")

---Gets the icon for the mech leg as an `IconComposition`.
M.get_mech_leg_icon_composition = icons:flat("mech-leg"):build_composition("get_mech_leg_icon_composition")

---Gets the icon for the mech leg segment as an `IconComposition`.
M.get_mech_leg_segment_icon_composition =
	icons:flat("mech-leg-segment"):build_composition("get_mech_leg_segment_icon_composition")

---Gets the icon for nuclear fuel reprocessing as an `IconComposition`.
M.get_nuclear_fuel_reprocessing_icon_composition =
	icons:flat("nuclear-fuel-reprocessing"):build_composition("get_nuclear_fuel_reprocessing_icon_composition")

---Gets the icon for petroleum gas cracking as an `IconComposition`.
M.get_petroleum_gas_cracking_icon_composition =
	icons:flat("petroleum-gas-cracking"):build_composition("get_petroleum_gas_cracking_icon_composition")

---Gets the icon for petroleum jelly as an `IconComposition`.
M.get_petroleum_jelly_icon_composition =
	icons:flat("petroleum-jelly"):build_composition("get_petroleum_jelly_icon_composition")

---Gets the icon for the polishing compound as an `IconComposition`.
M.get_polishing_compound_icon_composition =
	icons:flat("polishing-compound"):build_composition("get_polishing_compound_icon_composition")

---Gets the icon for the polishing wheel as an `IconComposition`.
M.get_polishing_wheel_icon_composition =
	icons:flat("polishing-wheel"):build_composition("get_polishing_wheel_icon_composition")

---Gets the icon for powdered tungsten as an `IconComposition`.
M.get_powdered_tungsten_icon_composition =
	icons:flat("powdered-tungsten"):build_composition("get_powdered_tungsten_icon_composition")

---Gets the icon for resin as an `IconComposition`.
M.get_resin_icon_composition = icons:flat("resin"):build_composition("get_resin_icon_composition")

---Gets the icon for resin from oil as an `IconComposition`.
M.get_resin_oil_icon_composition = icons:flat("resin-oil"):build_composition("get_resin_oil_icon_composition")

---Gets the icon for resin from wood as an `IconComposition`.
M.get_resin_wood_icon_composition = icons:flat("resin-wood"):build_composition("get_resin_wood_icon_composition")

---Gets the icon for the rifle as an `IconComposition`.
M.get_rifle_icon_composition = icons:flat("rifle"):build_composition("get_rifle_icon_composition")

---Gets the icon for the robot drone frame as an `IconComposition`.
M.get_robot_drone_frame_icon_composition =
	icons:flat("robot-drone-frame"):build_composition("get_robot_drone_frame_icon_composition")

---Gets the icon for the large robot drone frame as an `IconComposition`.
M.get_robot_drone_frame_large_icon_composition =
	icons:flat("robot-drone-frame-large"):build_composition("get_robot_drone_frame_large_icon_composition")

---Gets the icon for the rocket engine as an `IconComposition`.
M.get_rocket_engine_icon_composition =
	icons:flat("rocket-engine"):build_composition("get_rocket_engine_icon_composition")

---Gets the icon for rubber as an `IconComposition`.
M.get_rubber_icon_composition = icons:flat("rubber"):build_composition("get_rubber_icon_composition")

---Gets the icon for salt as an `IconComposition`.
M.get_salt_icon_composition = icons:flat("salt"):build_composition("get_salt_icon_composition")

---Gets the icon for the scatter cannon shell as an `IconComposition`.
M.get_scatter_cannon_shell_icon_composition =
	icons:flat("scatter-cannon-shell"):build_composition("get_scatter_cannon_shell_icon_composition")

---Gets the icon for the advanced logistic science pack as an `IconComposition`.
M.get_science_pack_advanced_logistic_icon_composition =
	icons:flat("science-pack-advanced-logistic"):build_composition("get_science_pack_advanced_logistic_icon_composition")

---Gets the icon for the gold science pack as an `IconComposition`.
M.get_science_pack_gold_icon_composition =
	icons:flat("science-pack-gold"):build_composition("get_science_pack_gold_icon_composition")

---Gets the icon for the seedling as an `IconComposition`.
M.get_seedling_icon_composition = icons:flat("seedling"):build_composition("get_seedling_icon_composition")

---Gets the icon for the shotgun shell casing as an `IconComposition`.
M.get_shotgun_shell_casing_icon_composition =
	icons:flat("shotgun-shell-casing"):build_composition("get_shotgun_shell_casing_icon_composition")

---Gets the icon for silicon as an `IconComposition`.
M.get_silicon_icon_composition = icons:flat("silicon"):build_composition("get_silicon_icon_composition")

---Gets the icon for silicon carbide as an `IconComposition`.
M.get_silicon_carbide_icon_composition =
	icons:flat("silicon-carbide"):build_composition("get_silicon_carbide_icon_composition")

---Gets the icon for silicon nitride as an `IconComposition`.
M.get_silicon_nitride_icon_composition =
	icons:flat("silicon-nitride"):build_composition("get_silicon_nitride_icon_composition")

---Gets the icon for silicon powder as an `IconComposition`.
M.get_silicon_powder_icon_composition =
	icons:flat("silicon-powder"):build_composition("get_silicon_powder_icon_composition")

---Gets the icon for the silicon wafer as an `IconComposition`.
M.get_silicon_wafer_icon_composition =
	icons:flat("silicon-wafer"):build_composition("get_silicon_wafer_icon_composition")

---Gets the icon for silver from lead as an `IconComposition`.
M.get_silver_from_lead_icon_composition =
	icons:flat("silver-from-lead"):build_composition("get_silver_from_lead_icon_composition")

---Gets the icon for silver nitrate as an `IconComposition`.
M.get_silver_nitrate_icon_composition =
	icons:flat("silver-nitrate"):build_composition("get_silver_nitrate_icon_composition")

---Gets the icon for silver oxide as an `IconComposition`.
M.get_silver_oxide_icon_composition = icons:flat("silver-oxide"):build_composition("get_silver_oxide_icon_composition")

---Gets the icon for the sniper rifle as an `IconComposition`.
M.get_sniper_rifle_icon_composition = icons:flat("sniper-rifle"):build_composition("get_sniper_rifle_icon_composition")

---Gets the icon for sodium hydroxide as an `IconComposition`.
M.get_sodium_hydroxide_icon_composition =
	icons:flat("sodium-hydroxide"):build_composition("get_sodium_hydroxide_icon_composition")

---Gets the icon for solder as an `IconComposition`.
M.get_solder_icon_composition = icons:flat("solder"):build_composition("get_solder_icon_composition")

---Gets the icon for solid fuel from hydrogen as an `IconComposition`.
M.get_solid_fuel_from_hydrogen_icon_composition =
	icons:flat("solid-fuel-from-hydrogen"):build_composition("get_solid_fuel_from_hydrogen_icon_composition")

---Gets the icon for solid fuel from sour gas as an `IconComposition`.
M.get_solid_fuel_from_sour_gas_icon_composition =
	icons:flat("solid-fuel-from-sour-gas"):build_composition("get_solid_fuel_from_sour_gas_icon_composition")

---Gets the icon for the spidertron cannon as an `IconComposition`.
M.get_spidertron_cannon_icon_composition =
	icons:flat("spidertron-cannon"):build_composition("get_spidertron_cannon_icon_composition")

---Gets the icon for the spidertron gatling gun as an `IconComposition`.
M.get_spidertron_gatling_gun_icon_composition =
	icons:flat("spidertron-gatling-gun"):build_composition("get_spidertron_gatling_gun_icon_composition")

---Gets the icon for synthetic wood as an `IconComposition`.
M.get_synthetic_wood_icon_composition =
	icons:flat("synthetic-wood"):build_composition("get_synthetic_wood_icon_composition")

---Gets the icon for thorium fuel reprocessing as an `IconComposition`.
M.get_thorium_fuel_reprocessing_icon_composition =
	icons:flat("thorium-fuel-reprocessing"):build_composition("get_thorium_fuel_reprocessing_icon_composition")

---Gets the icon for the alternate thorium fuel reprocessing as an `IconComposition`.
M.get_thorium_fuel_reprocessing_alternate_icon_composition = icons
	:flat("thorium-fuel-reprocessing-alternate")
	:build_composition("get_thorium_fuel_reprocessing_alternate_icon_composition")

---Gets the icon for thorium processing as an `IconComposition`.
M.get_thorium_processing_icon_composition =
	icons:flat("thorium-processing"):build_composition("get_thorium_processing_icon_composition")

---Gets the icon for tungsten oxide as an `IconComposition`.
M.get_tungsten_oxide_icon_composition =
	icons:flat("tungsten-oxide"):build_composition("get_tungsten_oxide_icon_composition")

---Gets the icon for the vehicle engine equipment as an `IconComposition`.
M.get_vehicle_engine_icon_composition =
	icons:flat("vehicle-engine"):build_composition("get_vehicle_engine_icon_composition")

---Gets the icon for the vehicle motor equipment as an `IconComposition`.
M.get_vehicle_motor_icon_composition =
	icons:flat("vehicle-motor"):build_composition("get_vehicle_motor_icon_composition")

---Gets the icon for wood pellets as an `IconComposition`.
M.get_wood_pellets_icon_composition = icons:flat("wood-pellets"):build_composition("get_wood_pellets_icon_composition")

return M
