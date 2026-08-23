---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Defines

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")

---Applies an `electric_pole_sprite_set`-shaped `set` to `prototype`.
---@param prototype ElectricPolePrototype
---@param set ElectricPoleSpriteSet
local function apply_sprite_set_to_electric_pole(prototype, set)
	prototype.pictures = util.copy(set.pictures)
end

---@param explosion ExplosionPrototype
---@param set ElectricPoleSpriteSet
local function apply_sprite_set_to_explosion(explosion, set)
	error("Not implemented")
end

---@type ElectricPoleSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.electric_pole_sprite_set,
	apply_to = apply_sprite_set_to_electric_pole,
	apply_to_explosion = apply_sprite_set_to_explosion,
}

---The sprite data an `electric_pole_sprite_set`-tagged `SpriteSetDefinition` carries.
---@class (exact) ElectricPoleSpriteSet : EntityWithHealthSpriteSet
---The prototype's `pictures`.
---@field pictures RotatedSprite

---The applicator for electric poles.
---@class (exact) ElectricPoleSpriteSetApplicator : SpriteSetApplicator<ElectricPolePrototype, ElectricPoleSpriteSet>
