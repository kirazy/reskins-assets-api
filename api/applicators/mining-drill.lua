---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")
local Assignment = require("api.assignment")

---Applies a `set` of type `mining_drill_sprite_set` to `prototype`.
---@param prototype MiningDrillPrototype
---@param set MiningDrillSpriteSet
local function apply_sprite_set_to_mining_drill(prototype, set)
	prototype.graphics_set = util.copy(set.graphics_set)
	prototype.wet_mining_graphics_set = util.copy(set.wet_mining_graphics_set)

	Assignment.safe_assign(prototype, set, { "circuit_connector", "circuit_connector_flipped" })

	-- Flipped graphics sets exist in Factorio 2.1 and later.
	if helpers.compare_versions(mods["base"], "2.1.0") >= 0 then
		---@diagnostic disable-next-line: inject-field
		prototype.graphics_set_flipped = util.copy(set.graphics_set_flipped)
		---@diagnostic disable-next-line: inject-field
		prototype.wet_mining_graphics_set_flipped = util.copy(set.wet_mining_graphics_set_flipped)
	end
end

---@type MiningDrillSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.mining_drill_sprite_set,
	apply_to = apply_sprite_set_to_mining_drill,
}

---Defines the sprite data of a `SpriteSetDefinition` of type `mining_drill_sprite_set`.
---@class (exact) MiningDrillSpriteSet : EntityWithHealthSpriteSet
---The prototype's `graphics_set`.
---@field graphics_set? MiningDrillGraphicsSet
---The prototype's `graphics_set_flipped`, in Factorio 2.1 and later.
---@field graphics_set_flipped? MiningDrillGraphicsSet
---The prototype's `wet_mining_graphics_set`.
---@field wet_mining_graphics_set? MiningDrillGraphicsSet
---The prototype's `wet_mining_graphics_set_flipped`, in Factorio 2.1 and later.
---@field wet_mining_graphics_set_flipped? MiningDrillGraphicsSet
---When `nil`, the circuit connector of the prototype is not modified.
---@field circuit_connector? [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
---When `nil`, the flipped circuit connector of the prototype is not modified.
---@field circuit_connector_flipped? [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]

---Applies the `MiningDrillSpriteSet` to `MiningDrillPrototype` instances.
---@class (exact) MiningDrillSpriteSetApplicator : SpriteSetApplicator<MiningDrillPrototype, MiningDrillSpriteSet>
