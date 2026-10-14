-- Provides the shared converter registry with all conversions pre-registered.
--
-- Register a converter here when adding a corresponding converter definition under api/converters/.

---@namespace Reskins.Assets

local _defines = require("api.defines")

local ConverterRegistry = require("api.converter-registry")

---@type ConverterRegistry
local registry = ConverterRegistry.new()

registry.register(
	_defines.sprite_set_type.boiler_sprite_set,
	_defines.sprite_set_type.crafting_machine_sprite_set,
	require("converters.boiler-to-crafting-machine-sprite-set-transformer")
)

return registry
