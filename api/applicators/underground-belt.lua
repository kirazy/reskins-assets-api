---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")

---Applies a `set` of type `underground_belt_sprite_set` to `prototype`.
---@param prototype UndergroundBeltPrototype
---@param set UndergroundBeltSpriteSet
local function apply_sprite_set_to_underground_belt(prototype, set)
	prototype.belt_animation_set = util.copy(set.belt_animation_set)
	prototype.structure = util.copy(set.structure)
end

---@type UndergroundBeltSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.underground_belt_sprite_set,
	apply_to = apply_sprite_set_to_underground_belt,
}

---Defines the sprite data in a `SpriteSetDefinition` of type `underground_belt_sprite_set`.
---@class (exact) UndergroundBeltSpriteSet : TransportBeltConnectableSpriteSet
---@field structure UndergroundBeltStructure

---Applies the `UndergroundBeltSpriteSet` to `UndergroundBeltPrototype` instances.
---@class (exact) UndergroundBeltSpriteSetApplicator : SpriteSetApplicator<UndergroundBeltPrototype, UndergroundBeltSpriteSet>
