---@using data

---@namespace Reskins.Assets

local _converters = require("api.converters")
local _defines = require("api.defines")
local PrototypeScaler = require("api.prototype-scaler")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local AssetsCommon = require("api.validation")

---The `SpriteSetType` for each prototype type name. Applying a sprite set raises an error when the `SpriteSetType` of
---the prototype has no registered applicator.
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
	["lab"] = _defines.sprite_set_type.lab_sprite_set,
}

---Provides methods for creating applicator registries, which apply sprite sets to prototypes.
---
---#### Examples
---```lua
---local ApplicatorRegistry = require("__reskins-assets-api__.api.applicator-registry")
---```
---@class ApplicatorRegistryFactory
local _factory = {}

local check_register = V.signature("register", {
	{
		"applicator",
		V.struct({
			set_type = AssetsCommon.sprite_set_type,
			apply_to = AssetsCommon.applicator_function,
		}):describe_as("a SpriteSetApplicator"),
	},
})

---Creates an empty applicator registry.
---
---#### Examples
---```lua
----- Create a registry with only the accumulator applicator.
---local ApplicatorRegistry = require("__reskins-assets-api__.api.applicator-registry")
---
---local registry = ApplicatorRegistry.new()
---registry.register(require("__reskins-assets-api__.api.applicators.accumulator"))
---```
---@return ApplicatorRegistry
---@nodiscard
function _factory.new()
	---Represents a registry that applies sprite sets to prototypes, using the applicator registered for the type of
	---each prototype.
	---
	---`api.applicators` returns the shared registry, which has every applicator of this mod registered.
	---
	---#### Examples
	---```lua
	---local Applicators = require("__reskins-assets-api__.api.applicators")
	---```
	---@class ApplicatorRegistry
	local registry = {}

	---The registered applicators, by `SpriteSetType`.
	---@type table<SpriteSetType, AnySpriteSetApplicator>
	local applicators = {}

	---The applicators, by `SpriteSetType`. Calling `apply_to` on an applicator directly does not convert the sprite
	---set, scale it, or apply the fields common to every applicator; `apply_sprite_set` does all of these.
	registry.applicators = applicators

	---Registers the given `applicator` for the `SpriteSetType` it declares.
	---@param applicator AnySpriteSetApplicator The applicator to register.
	---@throws When `applicator` is not a `SpriteSetApplicator`.
	function registry.register(applicator)
		check_register(applicator)

		applicators[applicator.set_type] = applicator
	end

	---Creates a copy of the given `definition` with its sprite set scaled for the given `prototype`.
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

	---Applies the given `definition` to the given `corpse_prototype`.
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

	---Applies the fields common to every applicator from the given `sprite_set` to the given `prototype`.
	---@param prototype EntityWithHealthPrototype
	---@param sprite_set EntityWithHealthSpriteSet
	local function apply_common_fields(prototype, sprite_set)
		prototype.integration_patch = sprite_set.integration_patch
		prototype.integration_patch_render_layer = sprite_set.integration_patch_render_layer
		prototype.water_reflection = sprite_set.water_reflection
	end

	---Applies the given `definition` to the given entity `prototype`.
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

	---Indicates whether a sprite set can be applied to the given `prototype`. A sprite set can be applied to a corpse,
	---or to an entity with a type that maps to a `SpriteSetType` with a registered applicator.
	---@param prototype EntityWithHealthPrototype|CorpsePrototype The prototype to which a sprite set is applied.
	---@return boolean # `true` when a sprite set can be applied to the prototype; otherwise, `false`.
	---@return string? # A description of the fault, when a sprite set cannot be applied.
	local function is_routable(prototype)
		if prototype.type == "corpse" then
			return true
		end

		local set_type = set_type_by_prototype_type[prototype.type]
		if not set_type then
			return false, string.format("no sprite set type available for type '%s'", prototype.type)
		end

		if not applicators[set_type] then
			return false,
				string.format("no registered applicator supports type '%s' with sprite set type '%s'", prototype.type, set_type)
		end

		return true
	end

	---Indicates whether the sprite set of the given `definition` can be scaled for the given `prototype` with the given
	---`params`.
	---@param prototype EntityWithHealthPrototype|CorpsePrototype
	---@param definition AnySpriteSetDefinition
	---@param params? ApplySpriteSetParams
	---@return boolean
	---@return string?
	local function can_scale(prototype, definition, params)
		params = params or {}

		return PrototypeScaler.can_resolve(prototype, {
			nominal_width = definition.set.nominal_width,
			nominal_height = definition.set.nominal_height,
			scale = params.scale,
			scale_factor = params.scale_factor,
		})
	end

	-- Create the signature for each registry, because `is_routable` reads the applicators of the registry.
	local check_apply_sprite_set = V.signature("apply_sprite_set", {
		{ "prototype", AssetsCommon.prototype },
		{ "definition", AssetsCommon.sprite_set_definition },
		{
			"params",
			V.struct({
				scale = Common.positive_number:optional(),
				scale_factor = Common.positive_number:optional(),
			})
				:strict()
				:where(function(value)
					return value.scale == nil or value.scale_factor == nil
				end, "sets both 'scale' and 'scale_factor'")
				:describe_as("an ApplySpriteSetParams")
				:optional(),
		},
	}, {
		{ parameter = "prototype", arguments = { "prototype" }, check = is_routable },
		{ parameter = "prototype", arguments = { "prototype", "definition", "params" }, check = can_scale },
	})

	---Applies the given `definition` to the given `prototype`.
	---
	---The sprite set type of `definition` may differ from the sprite set type of `prototype`. The sprite set is then
	---converted to the sprite set type of `prototype`, when a conversion between the two types exists.
	---
	---The sprite set is scaled to the scale that `params` sets, if any. Otherwise, it is scaled when the size of
	---`prototype` differs from the nominal size of the sprite set.
	---
	---#### Parameters
	---@param prototype EntityWithHealthPrototype|CorpsePrototype The prototype to which `definition` is applied.
	---@param definition AnySpriteSetDefinition The sprite set definition to apply.
	---@param params? ApplySpriteSetParams Scaling options.
	---
	---#### Examples
	---```lua
	----- Apply a sprite set to the assembling machine and to its remnants.
	---local Applicators = require("__reskins-assets-api__.api.applicators")
	---
	---Applicators.apply_sprite_set(data.raw["assembling-machine"]["assembling-machine-1"], sprite_set)
	---Applicators.apply_sprite_set(data.raw["corpse"]["assembling-machine-1-remnants"], sprite_set)
	----- The corpse takes the fields of sprite_set.set.corpse.
	---```
	---@throws When `prototype` is not a prototype.
	---@throws When `definition` is not a `SpriteSetDefinition`.
	---@throws When `definition.set.corpse` defines a field that a `CorpsePrototype` does not have.
	---@throws When `params` defines an unrecognized field, or a `scale` or `scale_factor` that is not a positive number.
	---@throws When `params` sets both `scale` and `scale_factor`.
	---@throws When neither `params.scale` nor `params.scale_factor` is given, and `prototype` has no `selection_box` with a positive width and height.
	---@throws When `prototype.type` has no known `SpriteSetType`.
	---@throws When no applicator is registered for the `SpriteSetType` of `prototype.type`.
	---@throws When `definition.set_type` does not match the sprite set type of the applicator and neither `definition.converters` nor a registered conversion connects them.
	---@see ConverterRegistry.resolve
	---@see PrototypeScaler.for_prototype
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
