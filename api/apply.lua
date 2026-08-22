---@using data

---@namespace Reskins.Assets

---The type name of an [EntityWithHealthPrototype](https://lua-api.factorio.com/latest/prototypes/EntityWithHealthPrototype.html).
---@alias PrototypeType string

local _defines = require("api.defines")

-- Requires the registration module rather than api.converters directly, so the registry is always
-- fully populated for anyone using apply().
local converters = require("api.register-converters")

---One applicator per `SpriteSetType`. Grown on demand alongside new target kinds.
---@type table<SpriteSetType, AnySpriteSetApplicator>
local applicators = {
	[_defines.sprite_set_type.crafting_machine_sprite_set] = require("applicators.crafting-machine"),
	[_defines.sprite_set_type.boiler_sprite_set] = require("applicators.boiler"),
}

---Maps a prototype to the `SpriteSetType` it takes. Not every `SpriteSetType`
---listed here has an applicator registered in `applicators` yet — see `apply`'s exceptions.
---@type table<PrototypeType, SpriteSetType>
local set_type_by_prototype_type = {
	["assembling-machine"] = _defines.sprite_set_type.crafting_machine_sprite_set,
	["furnace"] = _defines.sprite_set_type.crafting_machine_sprite_set,
	["boiler"] = _defines.sprite_set_type.boiler_sprite_set,
	["generator"] = _defines.sprite_set_type.generator_sprite_set,
	["ammo-turret"] = _defines.sprite_set_type.turret_sprite_set,
	["electric-turret"] = _defines.sprite_set_type.turret_sprite_set,
	["fluid-turret"] = _defines.sprite_set_type.turret_sprite_set,
	["mining-drill"] = _defines.sprite_set_type.mining_drill_sprite_set,
	["offshore-pump"] = _defines.sprite_set_type.offshore_pump_sprite_set,
	["beacon"] = _defines.sprite_set_type.beacon_sprite_set,
	["transport-belt"] = _defines.sprite_set_type.transport_belt_sprite_set,
	["underground-belt"] = _defines.sprite_set_type.transport_belt_sprite_set,
	["linked-belt"] = _defines.sprite_set_type.transport_belt_sprite_set,
	["splitter"] = _defines.sprite_set_type.transport_belt_sprite_set,
	["electric-pole"] = _defines.sprite_set_type.electric_pole_sprite_sprite,
	["pipe"] = _defines.sprite_set_type.pipe_sprite_set,
	["pipe-to-ground"] = _defines.sprite_set_type.pipe_to_ground_sprite_set,
	["heat-pipe"] = _defines.sprite_set_type.heat_pipe_sprite_set,
	["construction-robot"] = _defines.sprite_set_type.flying_robot_sprite_set,
	["logistic-robot"] = _defines.sprite_set_type.flying_robot_sprite_set,
	["combat-robot"] = _defines.sprite_set_type.flying_robot_sprite_set,
}

---Applies sprite data built by a sprite-producing function onto an entity prototype, converting it
---to whatever shape the prototype's own applicator expects.
---
---### Examples
---```lua
---local apply = require("__reskins-assets-api__.api.apply")
---
---apply.apply(data.raw["assembling-machine"]["assembling-machine-1"], sprites)
---```
---@class Applicator
local _apply = {}

---The applicator registry, keyed by `SpriteSetType`. Exposed for advanced use — calling an
---applicator's `apply_to` directly skips shape resolution for a value already in its `set_type`.
_apply.applicators = applicators

---Copies `EntityWithHealthSpriteSet`'s prototype-level fields (`integration_patch`,
---`integration_patch_render_layer`, `water_reflection`) from `set` onto `prototype`. Reads from the
---original, pre-conversion `set` rather than a converted value, so these apply consistently
---regardless of whether a conversion happened.
---
---`dying_explosion` and `corpse` are not applied here: Factorio's `EntityWithHealthPrototype`
---fields of those names reference separate prototypes rather than holding sprite data directly.
---@param prototype EntityWithHealthPrototype
---@param set EntityWithHealthSpriteSet
local function apply_common_fields(prototype, set)
	prototype.integration_patch = set.integration_patch
	prototype.integration_patch_render_layer = set.integration_patch_render_layer
	prototype.water_reflection = set.water_reflection
end

---Resolves `source` to `applicator.set_type`, applies it, then applies the common
---`EntityWithHealthSpriteSet` fields.
---@param applicator AnySpriteSetApplicator
---@param prototype EntityWithHealthPrototype
---@param source AnySpriteSetDefinition
local function apply_with(applicator, prototype, source)
	applicator.apply_to(prototype, converters.resolve(source, applicator.set_type))
	apply_common_fields(prototype, source.set)
end

---Applies `source` to `prototype`, routing to the applicator for `prototype`'s own type and
---converting `source` to that applicator's expected shape if needed.
---
---Does not scale `prototype`; scaling is a separate, subsequent step (see
---`graphics-packs.abstractions.prototype-scaler`).
---
---### Parameters
---@param prototype EntityWithHealthPrototype # The prototype to apply `source` to.
---@param source AnySpriteSetDefinition # The sprite data to apply.
---
---### Exceptions
---*@throws* `string` — Thrown when `prototype.type` has no known `SpriteSetType`.\
---*@throws* `string` — Thrown when `prototype.type`'s `SpriteSetType` has no applicator implemented yet.\
---*@throws* `string` — Thrown when no registered conversion connects `source.set_type` to the applicator's `set_type`.
function _apply.apply(prototype, source)
	local set_type = set_type_by_prototype_type[prototype.type]
	assert(set_type, string.format("No sprite set type known for prototype type '%s'.", tostring(prototype.type)))

	local applicator = applicators[set_type]
	assert(applicator, string.format("No applicator implemented yet for sprite set type '%s'.", tostring(set_type)))

	apply_with(applicator, prototype, source)
end

---Applies `set_definition` to `prototype` via the applicator registered for `set_type`, ignoring
---`prototype.type`. Use this to apply sprite data to a differently-shaped prototype than it was
---built for, or to route a prototype type not yet in the standard routing table.
---
---### Parameters
---@param set_type SpriteSetType # The `applicators` entry to apply through.
---@param prototype EntityWithHealthPrototype # The prototype to apply `set_definition` to.
---@param set_definition AnySpriteSetDefinition # The sprite data to apply.
---
---### Exceptions
---*@throws* `string` — Thrown when `set_type` has no registered applicator.\
---*@throws* `string` — Thrown when no registered conversion connects `set_definition.set_type` to that applicator's `set_type`.
function _apply.apply_as(set_type, prototype, set_definition)
	local applicator = applicators[set_type]
	assert(applicator, string.format("No applicator registered for set type '%s'.", tostring(set_type)))

	apply_with(applicator, prototype, set_definition)
end

return _apply
