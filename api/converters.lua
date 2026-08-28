-- The converter registry every caller shares: one built from api.converter-registry, populated with
-- every known sprite-set conversion, and returned. api.applicator-registry requires this file rather
-- than api.converter-registry directly, so the registry is always fully populated for anyone applying
-- a sprite set.
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
