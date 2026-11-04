---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")
local Assignment = require("api.assignment")

---Applies a `set` of type `land_mine_sprite_set` to `prototype`.
---@param prototype LandMinePrototype
---@param set LandMineSpriteSet
local function apply_sprite_set_to_land_mine(prototype, set)
	prototype.picture_safe = util.copy(set.picture_safe)
	prototype.picture_set = util.copy(set.picture_set)
	prototype.picture_set_enemy = util.copy(set.picture_set_enemy)

	Assignment.safe_assign(prototype, set, { "circuit_connector" })
end

---@type LandMineSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.land_mine_sprite_set,
	apply_to = apply_sprite_set_to_land_mine,
}

---Defines the sprite data of a `SpriteSetDefinition` of type `land_mine_sprite_set`.
---@class (exact) LandMineSpriteSet : EntityWithHealthSpriteSet
---The sprite of the landmine before it is armed (just after placing).
---
---See [LandMinePrototype::picture_safe](https://lua-api.factorio.com/latest/prototypes/LandMinePrototype.html#picture_safe).
---@field picture_safe Sprite
---The sprite of the landmine of a friendly force when it is armed.
---
---See [LandMinePrototype::picture_set](https://lua-api.factorio.com/latest/prototypes/LandMinePrototype.html#picture_set).
---@field picture_set Sprite
---The sprite of the landmine of an enemy force when it is armed.
---
---See [LandMinePrototype::picture_set_enemy](https://lua-api.factorio.com/latest/prototypes/LandMinePrototype.html#picture_set_enemy).
---@field picture_set_enemy? Sprite
---When `nil`, the circuit connector of the prototype is not modified.
---@field circuit_connector? CircuitConnectorDefinition

---Applies the `LandMineSpriteSet` to `LandMinePrototype` instances.
---@class (exact) LandMineSpriteSetApplicator : SpriteSetApplicator<LandMinePrototype, LandMineSpriteSet>
