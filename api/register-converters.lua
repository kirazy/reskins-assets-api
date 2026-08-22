-- Populates the converter registry (api.converters) with every known sprite-set conversion, and
-- returns it. api.apply requires this file rather than api.converters directly, so the registry
-- is always fully populated for anyone calling apply().
--
-- Register a converter here when adding a corresponding converter definition under api/converters/.

local _defines = require("api.defines")

local ConverterRegistry = require("api.converters")

ConverterRegistry.register(
	_defines.sprite_set_type.boiler_sprite_set,
	_defines.sprite_set_type.crafting_machine_sprite_set,
	require("converters.boiler-picture-set-to-crafting-machine-graphics-set")
)

return ConverterRegistry
