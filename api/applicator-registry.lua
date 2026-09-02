---@using data

---@namespace Reskins.Assets

local _converters = require("api.converters")
local _defines = require("api.defines")
local PrototypeScaler = require("api.prototype-scaler")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local AssetsCommon = require("api.validation")

---The `SpriteSetType` for each prototype type name. Applying a sprite set to a prototype whose
---`SpriteSetType` has no registered applicator raises an error.
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

---Provides applicator registries, which map each `SpriteSetType` to the applicator that applies it,
---and each prototype type to its `SpriteSetType`.
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
		V.shape({
			set_type = AssetsCommon.sprite_set_type,
			apply_to = AssetsCommon.applicator_function,
		}):describe_as("a SpriteSetApplicator"),
	},
})

---Creates an empty applicator registry.
---
---Registries are independent; applicators registered in one are not visible to another.
---@return ApplicatorRegistry # A registry with no applicators registered in it.
---
---#### Examples
---```lua
---local ApplicatorRegistry = require("__reskins-assets-api__.api.applicator-registry")
---
---local registry = ApplicatorRegistry.new()
---registry.register(require("__reskins-assets-api__.api.applicators.accumulator"))
---```
---@nodiscard
function _factory.new()
	---Applies sprite sets to prototypes, using the applicator registered for the type of each prototype.
	---
	---The shared registry is `api.applicators`, populated with the applicators provided by this mod. A
	---registry created by `new` is empty and independent.
	---
	---#### Examples
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

	---The applicators, keyed by `SpriteSetType`. Calling `apply_to` on an applicator directly does not
	---convert the sprite set, scale it, or apply the common entity sprites such as water reflections and
	---the integration patch; use `apply_sprite_set` instead.
	registry.applicators = applicators

	---Registers the given `applicator` for the `SpriteSetType` it declares.
	---@param applicator AnySpriteSetApplicator The applicator to register.
	---@throws Thrown when `applicator` does not carry a `SpriteSetType` and an `apply_to`.
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

	---Indicates whether a sprite set can be applied to the given `prototype`: a corpse, or an entity
	---whose type maps to a `SpriteSetType` with a registered applicator.
	---@param prototype EntityWithHealthPrototype|CorpsePrototype The prototype to route.
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

	---Applies the given `definition` to the given `prototype`.
	---
	---- For a corpse prototype, the fields of `definition.set.corpse` are copied onto it. For any other
	---  `EntityWithHealthPrototype`, the applicator registered for its type is used.
	---- If `definition.set_type` is not the `SpriteSetType` of the applicator, the sprite set is
	---  converted with `api.converters`, which checks `definition.converters` first.
	---- The sprite set is scaled for `prototype` with `PrototypeScaler`, from the nominal dimensions of
	---  the sprite set and the `selection_box` of the prototype, unless `params.scale` or
	---  `params.scale_factor` is given.
	---- `definition` is not modified.
	---
	---#### Parameters
	---@param prototype EntityWithHealthPrototype|CorpsePrototype The prototype to apply `definition` to.
	---@param definition AnySpriteSetDefinition The sprite set definition to apply.
	---@param params ApplySpriteSetParams? Scaling options.
	---@throws Thrown when `prototype` is not a prototype.
	---@throws Thrown when `definition` is not a `SpriteSetDefinition`.
	---@throws Thrown when `definition.set.corpse` carries a field no `CorpsePrototype` has.
	---@throws Thrown when `params` carries an unrecognized field, or a `scale` or `scale_factor` that is not a positive number.
	---@throws Thrown when `prototype.type` has no known `SpriteSetType`.
	---@throws Thrown when `prototype.type`'s `SpriteSetType` has no applicator registered here.
	---@throws Thrown when `definition.set_type` doesn't match the target shape and neither `definition.converters` nor a registered conversion connects them.
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
