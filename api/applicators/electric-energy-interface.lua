---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")

---Applies a `set` of type `electric_energy_interface_sprite_set` to `prototype`.
---@param prototype ElectricEnergyInterfacePrototype
---@param set ElectricEnergyInterfaceSpriteSet
local function apply_sprite_set_to_electric_energy_interface(prototype, set)
	prototype.picture = util.copy(set.picture)
	prototype.pictures = util.copy(set.pictures)
	prototype.animation = util.copy(set.animation)
	prototype.animations = util.copy(set.animations)
	prototype.light = util.copy(set.light)
end

---@type ElectricEnergyInterfaceSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.electric_energy_interface_sprite_set,
	apply_to = apply_sprite_set_to_electric_energy_interface,
}

---Defines the sprite data in a `SpriteSetDefinition` of type `electric_energy_interface_sprite_set`.
---@class (exact) ElectricEnergyInterfaceSpriteSet : EntityWithHealthSpriteSet
---The prototype's `picture`.
---@field picture? Sprite
---The prototype's `pictures`.
---@field pictures? Sprite4Way
---The prototype's `animation`.
---@field animation? Animation
---The prototype's `animations`.
---@field animations? Animation4Way
---When `nil`, the light of the prototype is removed.
---@field light? LightDefinition

---Applies the `ElectricEnergyInterfaceSpriteSet` to `ElectricEnergyInterfacePrototype` instances.
---@class (exact) ElectricEnergyInterfaceSpriteSetApplicator : SpriteSetApplicator<ElectricEnergyInterfacePrototype, ElectricEnergyInterfaceSpriteSet>
