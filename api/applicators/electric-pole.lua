---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")

---Applies a `set` of type `electric_pole_sprite_set` to `prototype`.
---@param prototype ElectricPolePrototype
---@param set ElectricPoleSpriteSet
local function apply_sprite_set_to_electric_pole(prototype, set)
	prototype.pictures = util.copy(set.pictures)
end

---@type ElectricPoleSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.electric_pole_sprite_set,
	apply_to = apply_sprite_set_to_electric_pole,
}

---Defines the sprite data in a `SpriteSetDefinition` of type `electric_pole_sprite_set`.
---@class (exact) ElectricPoleSpriteSet : EntityWithHealthSpriteSet
---The prototype's `pictures`.
---@field pictures RotatedSprite

---Applies the `ElectricPoleSpriteSet` to `ElectricPolePrototype` instances.
---@class (exact) ElectricPoleSpriteSetApplicator : SpriteSetApplicator<ElectricPolePrototype, ElectricPoleSpriteSet>
