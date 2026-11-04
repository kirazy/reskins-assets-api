---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")

---Applies a `set` of type `entity_with_health_sprite_set` to `prototype`. The set defines no artwork of the entity, so
---`prototype` is not modified. `ApplicatorRegistry.apply_sprite_set` creates the dying explosion and the corpse of the
---entity from the set.
---@param prototype EntityWithHealthPrototype
---@param set EntityWithHealthSpriteSet
local function apply_sprite_set_to_entity_with_health(prototype, set) end

---@type EntityWithHealthSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.entity_with_health_sprite_set,
	apply_to = apply_sprite_set_to_entity_with_health,
}

---Applies the `EntityWithHealthSpriteSet` to `LocomotivePrototype`, `CargoWagonPrototype`, `FluidWagonPrototype`,
---`ArtilleryWagonPrototype`, and `CarPrototype` instances.
---@class (exact) EntityWithHealthSpriteSetApplicator : SpriteSetApplicator<EntityWithHealthPrototype, EntityWithHealthSpriteSet>
