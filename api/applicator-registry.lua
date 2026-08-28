---@using data

---@namespace Reskins.Assets

local _converters = require("api.converters")
local _defines = require("api.defines")
local PrototypeScaler = require("api.prototype-scaler")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local AssetsCommon = require("api.validation")

---The registry of prototype type names to the corresponding `SpriteSetType` that handles it. Which
---of these have an applicator is a property of the registry being applied through, not of this
---mapping: applying to a prototype whose `SpriteSetType` has none raises an exception.
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

---Creates applicator registries: registries of the applicator that paints each `SpriteSetType`,
---with routing from a prototype's own type to the one that handles it.
---
---### Examples
---```lua
---local ApplicatorRegistry = require("__reskins-assets-api__.api.applicator-registry")
---```
---@class ApplicatorRegistryFactory
local _factory = {}

local check_register = V.signature("register", {
	{
		"applicator",
		V.shape({
			set_type = AssetsCommon.sprite_set_type,
			apply_to = AssetsCommon.applicator_function,
		}):describe_as("a SpriteSetApplicator"),
	},
})

---Creates an empty applicator registry.
---
---Registries share nothing, so one made here is a place to register applicators without disturbing
---the applicators anything else relies on.
---
---### Examples
---```lua
---local ApplicatorRegistry = require("__reskins-assets-api__.api.applicator-registry")
---
---local registry = ApplicatorRegistry.new()
---registry.register(require("__reskins-assets-api__.api.applicators.accumulator"))
---```
---
---### Returns
---@return ApplicatorRegistry # A registry with no applicators registered in it.
---@nodiscard
function _factory.new()
	---Applies sprite sets to prototypes, routing each to the applicator that paints its type.
	---
	---Each registry owns its applicators. The one every caller shares is `api.applicators`, populated with
	---the applicators the mod ships; a registry made by `new` starts empty, and nothing registered in it
	---is visible to any other.
	---
	---### Examples
	---```lua
	---local Applicators = require("__reskins-assets-api__.api.applicators")
	---
	---local entity = data.raw["assembling-machine"]["assembling-machine-1"]
	---Applicators.apply_sprite_set(entity, sprite_set)
	---
	----- The same sprite set paints the entity's remnants, applied to the corpse itself.
	---local corpse = data.raw["corpse"]["assembling-machine-1-remnants"]
	---Applicators.apply_sprite_set(corpse, sprite_set)
	---```
	---@class ApplicatorRegistry
	local registry = {}

	---The applicators registered here, keyed by `SpriteSetType`.
	---@type table<SpriteSetType, AnySpriteSetApplicator>
	local applicators = {}

	---The applicator registry, keyed by `SpriteSetType`. Exposed for advanced use cases — calling an
	---applicator's `apply_to` directly skips translation between prototype shape and sprite set shapes,
	---automatic reconciliation of sprite scaling, and does not handle application of the standard
	---low-level entity sprites such as water reflections and integration.
	---
	---In general, prefer to use `apply_sprite_set` directly with a sprite set imported from the
	---`assets` namespace and appropriately configured.
	registry.applicators = applicators

	---Registers `applicator` as the one that paints the `SpriteSetType` it names.
	---
	---An applicator carries the `SpriteSetType` it consumes, so it is keyed by that rather than by a
	---separately given name, and the two cannot disagree.
	---
	---### Parameters
	---@param applicator AnySpriteSetApplicator # The applicator to register.
	---
	---### Exceptions
	---*@throws* `string` — Thrown when `applicator` does not carry a `SpriteSetType` and an `apply_to`.
	function registry.register(applicator)
		check_register(applicator)

		applicators[applicator.set_type] = applicator
	end

	---@generic T extends AnySpriteSetDefinition
	---@param definition T
	---@param prototype EntityWithHealthPrototype|CorpsePrototype
	---@param params ApplySpriteSetParams
	---@return T
	---@nodiscard
	local function rescale_sprite_set_for_prototype(definition, prototype, params)
		local scaler = PrototypeScaler.for_prototype(prototype, {
			nominal_width = definition.set.nominal_width,
			nominal_height = definition.set.nominal_height,
			scale = params.scale,
			scale_factor = params.scale_factor,
		})

		local scaled_set = util.copy(definition.set)
		scaler:rescale(scaled_set)

		return {
			set_type = definition.set_type,
			set = scaled_set,
			converters = definition.converters,
		}
	end

	---@param corpse_prototype CorpsePrototype
	---@param definition SpriteSetDefinition<EntityWithHealthSpriteSet>
	---@param params ApplySpriteSetParams
	local function apply_sprite_set_to_corpse(corpse_prototype, definition, params)
		local rescaled_definition = rescale_sprite_set_for_prototype(definition, corpse_prototype, params)

		local corpse_set = rescaled_definition.set.corpse
		if not corpse_set then
			return
		end

		for key, value in pairs(corpse_set) do
			corpse_prototype[key] = value
		end
	end

	---@param prototype EntityWithHealthPrototype
	---@param sprite_set EntityWithHealthSpriteSet
	local function apply_common_fields(prototype, sprite_set)
		prototype.integration_patch = sprite_set.integration_patch
		prototype.integration_patch_render_layer = sprite_set.integration_patch_render_layer
		prototype.water_reflection = sprite_set.water_reflection
	end

	---@param prototype EntityWithHealthPrototype
	---@param definition AnySpriteSetDefinition
	---@param params ApplySpriteSetParams
	local function apply_sprite_set_to_entity(prototype, definition, params)
		local set_type = set_type_by_prototype_type[prototype.type]
		local applicator = applicators[set_type]
		local scaled_source = rescale_sprite_set_for_prototype(definition, prototype, params)
		local resolved_set = _converters.resolve(scaled_source, applicator.set_type)

		apply_common_fields(prototype, scaled_source.set)
		applicator.apply_to(prototype, resolved_set)
	end

	---Indicates whether `apply_sprite_set` can route `prototype`: a corpse, or an entity whose type
	---takes a `SpriteSetType` with an applicator registered here.
	---@param prototype EntityWithHealthPrototype|CorpsePrototype # The prototype to route.
	---@return boolean # Whether the prototype can be routed.
	---@return string? # What was wanted, when it cannot.
	local function is_routable(prototype)
		if prototype.type == "corpse" then
			return true
		end

		local set_type = set_type_by_prototype_type[prototype.type]
		if not set_type then
			return false,
				string.format("must be a prototype whose type takes a known sprite set type, got '%s'", prototype.type)
		end

		if not applicators[set_type] then
			return false,
				string.format(
					"must be a prototype whose type has an implemented applicator; '%s' takes '%s', which has not been implemented",
					prototype.type,
					set_type
				)
		end

		return true
	end

	-- Built per registry, since the rule reaching `is_routable` reads this registry's own applicators.
	local check_apply_sprite_set = V.signature("apply_sprite_set", {
		{ "prototype", AssetsCommon.prototype },
		{ "definition", AssetsCommon.sprite_set_definition },
		{
			"params",
			V.shape({
				scale = Common.positive_number:optional(),
				scale_factor = Common.positive_number:optional(),
			})
				:strict()
				:describe_as("an ApplySpriteSetParams")
				:optional(),
		},
	}, {
		{ parameter = "prototype", arguments = { "prototype" }, check = is_routable },
	})

	---Applies `definition` to `prototype`.
	---
	---Routed by `prototype.type`: a corpse prototype gets `definition.set.corpse`'s fields copied directly
	---onto it (every `CorpseSpriteSet` field shares its name with the `CorpsePrototype` field it's
	---meant for); any other `EntityWithHealthPrototype` gets routed to the applicator registered for
	---its own type.
	---
	---`definition` need not already be in the target shape, and need not already be at the target
	---scale — both are handled automatically:
	---- If `definition.set_type` doesn't match the target applicator's shape, it's resolved via
	---  `api.converters`, which checks `definition.converters` before its own registered conversions.
	---- The sprite data is scaled for `prototype` via `PrototypeScaler`, automatically from
	---  `definition.set.nominal_width`/`nominal_height` vs. `prototype.selection_box`, unless overridden by
	---  `params.scale` or `params.scale_factor`.
	---
	---`definition` is not mutated, so the same `SpriteSetDefinition` may be reused across multiple calls
	---(e.g. applying it to both an entity and its corpse).
	---
	---### Parameters
	---@param prototype EntityWithHealthPrototype|CorpsePrototype # The prototype to apply `definition` to.
	---@param definition AnySpriteSetDefinition # The sprite set definition to apply.
	---@param params ApplySpriteSetParams? # Escape hatches for scaling.
	---
	---### Exceptions
	---*@throws* `string` — Thrown when `prototype` is not a prototype.\
	---*@throws* `string` — Thrown when `definition` is not a `SpriteSetDefinition`.\
	---*@throws* `string` — Thrown when `definition.set.corpse` carries a field no `CorpsePrototype` has.\
	---*@throws* `string` — Thrown when `params` carries an unrecognized field, or a `scale` or `scale_factor` that is not a positive number.\
	---*@throws* `string` — Thrown when `prototype.type` has no known `SpriteSetType`.\
	---*@throws* `string` — Thrown when `prototype.type`'s `SpriteSetType` has no applicator registered here.\
	---*@throws* `string` — Thrown when `definition.set_type` doesn't match the target shape and neither `definition.converters` nor a registered conversion connects them.
	function registry.apply_sprite_set(prototype, definition, params)
		check_apply_sprite_set(prototype, definition, params)

		params = params or {}

		if prototype.type == "corpse" then
			apply_sprite_set_to_corpse(prototype --[[@as CorpsePrototype]], definition, params)
		else
			apply_sprite_set_to_entity(prototype --[[@as EntityWithHealthPrototype]], definition, params)
		end
	end

	return registry
end

return _factory
