---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")
local Assignment = require("api.assignment")

---Applies a `set` of type `inserter_sprite_set` to `prototype`.
---@param prototype InserterPrototype
---@param set InserterSpriteSet
local function apply_sprite_set_to_inserter(prototype, set)
	prototype.hand_base_picture = util.copy(set.hand_base_picture)
	prototype.hand_base_shadow = util.copy(set.hand_base_shadow)
	prototype.hand_open_picture = util.copy(set.hand_open_picture)
	prototype.hand_closed_picture = util.copy(set.hand_closed_picture)
	prototype.hand_open_shadow = util.copy(set.hand_open_shadow)
	prototype.hand_closed_shadow = util.copy(set.hand_closed_shadow)
	prototype.platform_picture = util.copy(set.platform_picture)

	Assignment.safe_assign(prototype, set, {
		"hand_base_frozen",
		"hand_closed_frozen",
		"hand_open_frozen",
		"platform_frozen",
		"circuit_connector",
	})
end

---@type InserterSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.inserter_sprite_set,
	apply_to = apply_sprite_set_to_inserter,
}

---Defines the sprite data of a `SpriteSetDefinition` of type `inserter_sprite_set`.
---@class (exact) InserterSpriteSet : EntityWithHealthSpriteSet
---The prototype's `hand_base_picture`.
---@field hand_base_picture Sprite
---The prototype's `hand_base_shadow`.
---@field hand_base_shadow Sprite
---The prototype's `hand_open_picture`.
---@field hand_open_picture Sprite
---The prototype's `hand_closed_picture`.
---@field hand_closed_picture Sprite
---The prototype's `hand_open_shadow`.
---@field hand_open_shadow Sprite
---The prototype's `hand_closed_shadow`.
---@field hand_closed_shadow Sprite
---The prototype's `platform_picture`.
---@field platform_picture Sprite4Way
---When `nil`, the `hand_base_frozen` of the prototype is not modified.
---@field hand_base_frozen? Sprite
---When `nil`, the `hand_closed_frozen` of the prototype is not modified.
---@field hand_closed_frozen? Sprite
---When `nil`, the `hand_open_frozen` of the prototype is not modified.
---@field hand_open_frozen? Sprite
---When `nil`, the `platform_frozen` of the prototype is not modified.
---@field platform_frozen? Sprite4Way
---When `nil`, the circuit connector of the prototype is not modified.
---@field circuit_connector? [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]

---Applies the `InserterSpriteSet` to `InserterPrototype` instances.
---@class (exact) InserterSpriteSetApplicator : SpriteSetApplicator<InserterPrototype, InserterSpriteSet>
