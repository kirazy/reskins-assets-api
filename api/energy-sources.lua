---@using data

---@namespace Reskins.Assets

local V = require("__reskins-sprite-utils__.validation")

---Provides methods for modifying the energy sources of a prototype.
---
---#### Examples
---```lua
---local EnergySources = require("__reskins-assets-api__.api.energy-sources")
---```
---@class EnergySources
local _energy_sources = {}

-- The types of energy source that have a `light_flicker`. An energy source with no `type` is a burner energy source.
local light_flicker_types = {
	["burner"] = true,
	["fluid"] = true,
}

---A validator that checks that a value is a burner or fluid energy source.
local light_flicker_energy_source = V.custom("BurnerEnergySource|FluidEnergySource", function(value)
	return type(value) == "table" and (value.type == nil or light_flicker_types[value.type] == true)
end, "a burner or fluid energy source")

---Gets a `LightFlickeringDefinition` that shows no light.
---
---Each call creates a new table.
---@return LightFlickeringDefinition
---@nodiscard
function _energy_sources.get_zeroed_light_flicker()
	return {
		color = { 0, 0, 0 },
		minimum_light_size = 0,
		light_intensity_to_size_coefficient = 0,
	}
end

local check_zero_out_light_flicker = V.signature("zero_out_light_flicker", {
	{ "energy_source", light_flicker_energy_source },
})

---Sets the `light_flicker` of the given `energy_source` to a `LightFlickeringDefinition` that shows no light, in place.
---@param energy_source EnergySource
---@throws When `energy_source` is not a burner or fluid energy source.
function _energy_sources.zero_out_light_flicker(energy_source)
	check_zero_out_light_flicker(energy_source)
	---@cast energy_source -ElectricEnergySource, -HeatEnergySource, -VoidEnergySource

	energy_source.light_flicker = _energy_sources.get_zeroed_light_flicker()
end

return _energy_sources
