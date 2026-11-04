---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")

---Applies a `set` of type `valve_sprite_set` to `prototype`.
---@param prototype ValvePrototype
---@param set ValveSpriteSet
local function apply_sprite_set_to_valve(prototype, set)
	prototype.animations = util.copy(set.animations)
	prototype.frozen_patch = util.copy(set.frozen_patch)
end

---@type ValveSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.valve_sprite_set,
	apply_to = apply_sprite_set_to_valve,
}

---Defines the sprite data of a `SpriteSetDefinition` of type `valve_sprite_set`.
---@class (exact) ValveSpriteSet : EntityWithHealthSpriteSet
---See [ValvePrototype::animations](https://lua-api.factorio.com/latest/prototypes/ValvePrototype.html#animations).
---@field animations Animation4Way
---When `nil`, the frozen patch of the prototype is removed.
---@field frozen_patch? Sprite4Way

---Applies the `ValveSpriteSet` to `ValvePrototype` instances.
---@class (exact) ValveSpriteSetApplicator : SpriteSetApplicator<ValvePrototype, ValveSpriteSet>
