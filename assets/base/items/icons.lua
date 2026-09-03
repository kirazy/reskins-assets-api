---@using Reskins.SpriteUtils
---@using Reskins.Assets

---@namespace Reskins.Assets.Base

local _defines = require("api.defines")
local _pipes = require("assets.base.entities.pipe-pictures")
local IconCatalog = require("api.icon-catalog")

local icons = IconCatalog:create({ folder = _defines.assets_source.base_assets .. "/graphics/icons" })

---@param pipe_type "pipe"|"pipe-to-ground"
local function get_pipe_icon_fn(pipe_type)
	return IconCatalog.dispatch("material", _defines.pipe_material, "get_pipe_icon", function(pipe_material)
		-- The iron pipe icons come from the base game rather than an assets mod.
		if pipe_material == _defines.pipe_material.iron then
			return IconCatalog:create({ folder = _defines.assets_source.base .. "/graphics/icons" }):flat(pipe_type)
		end

		local material_asset = _pipes.asset_from_material(pipe_material)
		local material_name = _pipes.name_from_material(pipe_material)

		return IconCatalog:create({ folder = material_asset .. "/graphics/icons/" .. pipe_type })
			:flat(material_name .. "-" .. pipe_type)
	end)
end

-- stylua: ignore start
---The icons Artisanal Reskins draws for the base game.
---@class Icons
local _icons = {
	accumulator                   = icons:tinted("accumulator"):build(),
	assembling_machine            = icons:tinted("assembling-machine"):build(),
	battery                       = icons:tinted("battery"):build(),
	beacon                        = icons:tinted("beacon"):build(),
	boiler                        = icons:tinted("boiler"):build(),
	centrifuge                    = icons:tinted("centrifuge"):build(),
	chemical_plant                = icons:tinted("chemical-plant"):build(),
	circuit                       = icons:layers("circuit"):mask():highlights():layer("traces"):build(),
	electric_pole_big             = icons:tinted("electric-pole-big"):build(),
	electric_pole_medium          = icons:tinted("electric-pole-medium"):build(),
	equipment_battery_1           = icons:tinted("equipment-battery-1"):build(),
	equipment_battery_2           = icons:tinted("equipment-battery-2"):build(),
	equipment_energy_shield_1     = icons:tinted("equipment-energy-shield-1"):build(),
	equipment_energy_shield_2     = icons:tinted("equipment-energy-shield-2"):build(),
	equipment_exoskeleton         = icons:tinted("equipment-exoskeleton"):build(),
	equipment_fission_reactor     = icons:tinted("equipment-fission-reactor"):build(),
	equipment_laser_defense       = icons:tinted("equipment-laser-defense"):build(),
	equipment_night_vision        = icons:tinted("equipment-night-vision"):build(),
	equipment_personal_roboport_1 = icons:tinted("equipment-personal-roboport-1"):build(),
	equipment_personal_roboport_2 = icons:tinted("equipment-personal-roboport-2"):build(),
	equipment_solar_panel         = icons:tinted("equipment-solar-panel"):build(),
	flying_robot_frame            = icons:tinted("flying-robot-frame"):build(),
	furnace_electric              = icons:tinted("furnace-electric"):build(),
	furnace_steel                 = icons:tinted("furnace-steel"):build(),
	furnace_stone                 = icons:tinted("furnace-stone"):build(),
	inserter                      = icons:tinted("inserter"):build(),
	mining_drill_electric         = icons:tinted("mining-drill-electric"):build(),
	nuclear_reactor               = icons:tinted("nuclear-reactor"):build(),
	offshore_pump                 = icons:tinted("offshore-pump"):build(),
	oil_refinery                  = icons:tinted("oil-refinery"):build(),
	pipe                          = get_pipe_icon_fn("pipe"),
	pipe_to_ground                = get_pipe_icon_fn("pipe-to-ground"),
	pump                          = icons:tinted("pump"):build(),
	pumpjack                      = icons:tinted("pumpjack"):build(),
	radar                         = icons:tinted("radar"):build(),
	repair_pack                   = icons:tinted("repair-pack"):build(),
	roboport                      = icons:tinted("roboport"):build(),
	robot_construction            = icons:tinted("robot-construction"):build(),
	robot_logistic                = icons:tinted("robot-logistic"):build(),
	science_pack                  = icons:tinted("science-pack"):build(),
	solar_panel                   = icons:tinted("solar-panel"):build(),
	splitter                      = icons:tinted("splitter"):build(),
	steam_engine                  = icons:tinted("steam-engine"):build(),
	steam_turbine                 = icons:tinted("steam-turbine"):build(),
	storage_tank                  = icons:tinted("storage-tank"):build(),
	substation                    = icons:tinted("substation"):build(),
	tank                          = icons:tinted("tank"):build(),
	train_artillery_wagon         = icons:tinted("train-artillery-wagon"):build(),
	train_cargo_wagon             = icons:tinted("train-cargo-wagon"):build(),
	train_fluid_wagon             = icons:tinted("train-fluid-wagon"):build(),
	train_locomotive              = icons:tinted("train-locomotive"):build(),
	transport_belt                = icons:tinted("transport-belt"):build(),
	turret_artillery              = icons:tinted("turret-artillery"):build(),
	turret_gun                    = icons:tinted("turret-gun"):build(),
	turret_laser                  = icons:tinted("turret-laser"):build(),
	underground_belt              = icons:tinted("underground-belt"):build(),
}
-- stylua: ignore end

return _icons
