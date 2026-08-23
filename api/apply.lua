---@using data

---@namespace Reskins.Assets

---The type name of an [EntityWithHealthPrototype](https://lua-api.factorio.com/latest/prototypes/EntityWithHealthPrototype.html).
---@alias PrototypeType string

local _defines = require("api.defines")

---One applicator per `SpriteSetType`. Grown on demand alongside new target kinds.
---@type table<SpriteSetType, AnySpriteSetApplicator>
local applicators = {
	[_defines.sprite_set_type.crafting_machine_sprite_set] = require("applicators.crafting-machine"),
	[_defines.sprite_set_type.boiler_sprite_set] = require("applicators.boiler"),
	[_defines.sprite_set_type.accumulator_sprite_set] = require("applicators.accumulator"),
	[_defines.sprite_set_type.electric_pole_sprite_set] = require("applicators.electric-pole"),
	[_defines.sprite_set_type.inserter_sprite_set] = require("applicators.inserter"),
	[_defines.sprite_set_type.reactor_sprite_set] = require("applicators.reactor"),
	[_defines.sprite_set_type.pipe_sprite_set] = require("applicators.pipe"),
	[_defines.sprite_set_type.pipe_to_ground_sprite_set] = require("applicators.pipe-to-ground"),
	[_defines.sprite_set_type.pump_sprite_set] = require("applicators.pump"),
	[_defines.sprite_set_type.radar_sprite_set] = require("applicators.radar"),
	[_defines.sprite_set_type.roboport_sprite_set] = require("applicators.roboport"),
	[_defines.sprite_set_type.construction_robot_sprite_set] = require("applicators.robot-construction"),
	[_defines.sprite_set_type.logistic_robot_sprite_set] = require("applicators.robot-logistic"),
	[_defines.sprite_set_type.beacon_sprite_set] = require("applicators.beacon"),
	[_defines.sprite_set_type.generator_sprite_set] = require("applicators.generator"),
	[_defines.sprite_set_type.transport_belt_sprite_set] = require("applicators.transport-belt"),
	[_defines.sprite_set_type.solar_panel_sprite_set] = require("applicators.solar-panel"),
	[_defines.sprite_set_type.storage_tank_sprite_set] = require("applicators.storage-tank"),
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
	["artillery-turret"] = _defines.sprite_set_type.artillery_turret_sprite_set,
	["mining-drill"] = _defines.sprite_set_type.mining_drill_sprite_set,
	["offshore-pump"] = _defines.sprite_set_type.offshore_pump_sprite_set,
	["beacon"] = _defines.sprite_set_type.beacon_sprite_set,
	["transport-belt"] = _defines.sprite_set_type.transport_belt_sprite_set,
	["underground-belt"] = _defines.sprite_set_type.transport_belt_sprite_set,
	["linked-belt"] = _defines.sprite_set_type.transport_belt_sprite_set,
	["splitter"] = _defines.sprite_set_type.transport_belt_sprite_set,
	["electric-pole"] = _defines.sprite_set_type.electric_pole_sprite_set,
	["pipe"] = _defines.sprite_set_type.pipe_sprite_set,
	["pipe-to-ground"] = _defines.sprite_set_type.pipe_to_ground_sprite_set,
	["heat-pipe"] = _defines.sprite_set_type.heat_pipe_sprite_set,
	["construction-robot"] = _defines.sprite_set_type.construction_robot_sprite_set,
	["logistic-robot"] = _defines.sprite_set_type.logistic_robot_sprite_set,
	["combat-robot"] = _defines.sprite_set_type.flying_robot_sprite_set,
	["accumulator"] = _defines.sprite_set_type.accumulator_sprite_set,
	["inserter"] = _defines.sprite_set_type.inserter_sprite_set,
	["reactor"] = _defines.sprite_set_type.reactor_sprite_set,
	["pump"] = _defines.sprite_set_type.pump_sprite_set,
	["radar"] = _defines.sprite_set_type.radar_sprite_set,
	["roboport"] = _defines.sprite_set_type.roboport_sprite_set,
	["solar-panel"] = _defines.sprite_set_type.solar_panel_sprite_set,
	["storage-tank"] = _defines.sprite_set_type.storage_tank_sprite_set,
}

---Applies sprite data built by a sprite-producing function onto an entity prototype. `source` must
---already be in the shape the target applicator expects — resolve it with `api.converters` first if
---it isn't.
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
---applicator's `apply_to` directly skips the `set_type` match check `apply`/`apply_as` do.
_apply.applicators = applicators

---Copies `EntityWithHealthSpriteSet`'s prototype-level fields (`integration_patch`,
---`integration_patch_render_layer`, `water_reflection`) from `set` onto `prototype`. Reads from the
---original, pre-conversion `set` rather than a converted value, so these apply consistently
---regardless of whether a conversion happened.
---
---Neither `dying_explosion` nor `corpse` are applied here: both reference separate prototypes
---rather than holding sprite data directly. `corpse` has its own `apply_corpse`; explosion
---application isn't implemented yet.
---@param prototype EntityWithHealthPrototype
---@param set EntityWithHealthSpriteSet
local function apply_common_fields(prototype, set)
	prototype.integration_patch = set.integration_patch
	prototype.integration_patch_render_layer = set.integration_patch_render_layer
	prototype.water_reflection = set.water_reflection
end

---Applies `source` via `applicator`, then applies the common `EntityWithHealthSpriteSet` fields.
---
---Does not resolve `source` to `applicator.set_type` — that's `api.converters`' job, done by the
---caller before reaching here. `source.set_type` must already match `applicator.set_type`.
---@param applicator AnySpriteSetApplicator
---@param prototype EntityWithHealthPrototype
---@param source AnySpriteSetDefinition
local function apply_with(applicator, prototype, source)
	assert(
		source.set_type == applicator.set_type,
		string.format(
			"source's set_type ('%s') doesn't match the applicator's set_type ('%s'); resolve it first with api.converters.",
			tostring(source.set_type),
			tostring(applicator.set_type)
		)
	)

	applicator.apply_to(prototype, source.set)
	apply_common_fields(prototype, source.set)
end

---Applies `source` to `prototype`, routing to the applicator for `prototype`'s own type.
---
---Does not resolve `source` to that applicator's shape — resolve it with `api.converters` first if
---`source.set_type` doesn't already match. Does not scale `prototype`; scaling is a separate,
---subsequent step (see `graphics-packs.abstractions.prototype-scaler`).
---
---### Parameters
---@param prototype EntityWithHealthPrototype # The prototype to apply `source` to.
---@param source AnySpriteSetDefinition # The sprite data to apply.
---
---### Exceptions
---*@throws* `string` — Thrown when `prototype.type` has no known `SpriteSetType`.\
---*@throws* `string` — Thrown when `prototype.type`'s `SpriteSetType` has no applicator implemented yet.\
---*@throws* `string` — Thrown when `source.set_type` doesn't match the applicator's `set_type`.
function _apply.apply(prototype, source)
	local set_type = set_type_by_prototype_type[prototype.type]
	assert(set_type, string.format("No sprite set type known for prototype type '%s'.", tostring(prototype.type)))

	local applicator = applicators[set_type]
	assert(applicator, string.format("No applicator implemented yet for sprite set type '%s'.", tostring(set_type)))

	apply_with(applicator, prototype, source)
end

---Applies `source.set.corpse`'s fields directly onto `corpse` — every `CorpseSpriteSet` field
---shares its name with the `CorpsePrototype` field it's meant for. Does nothing if
---`source.set.corpse` is unset.
---
---Call this explicitly, alongside `apply`/`apply_as`, once `corpse` exists — orchestration code
---typically creates the corpse prototype itself (see e.g. `_lib.create_remnant` in
---reskins-nullius) rather than relying on it already existing under some name.
---### Parameters
---@param corpse CorpsePrototype # The corpse prototype to apply `source.set.corpse` to.
---@param source AnySpriteSetDefinition # The sprite data whose `set.corpse` to apply.
function _apply.apply_corpse(corpse, source)
	local set = source.set.corpse
	if not set then
		return
	end

	for key, value in pairs(set) do
		corpse[key] = value
	end
end

---Applies `set_definition` to `prototype` via the applicator registered for `set_type`, ignoring
---`prototype.type`. Use this to apply sprite data to a differently-shaped prototype than it was
---built for, or to route a prototype type not yet in the standard routing table.
---
---Does not resolve `set_definition` to `set_type` — resolve it with `api.converters` first if
---`set_definition.set_type` doesn't already match.
---
---### Parameters
---@param set_type SpriteSetType # The `applicators` entry to apply through.
---@param prototype EntityWithHealthPrototype # The prototype to apply `set_definition` to.
---@param set_definition AnySpriteSetDefinition # The sprite data to apply.
---
---### Exceptions
---*@throws* `string` — Thrown when `set_type` has no registered applicator.\
---*@throws* `string` — Thrown when `set_definition.set_type` doesn't match `set_type`.
function _apply.apply_as(set_type, prototype, set_definition)
	local applicator = applicators[set_type]
	assert(applicator, string.format("No applicator registered for set type '%s'.", tostring(set_type)))

	apply_with(applicator, prototype, set_definition)
end

return _apply
